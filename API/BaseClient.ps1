# BaseClient.ps1 - Shared HTTP client logic for API providers
# Uses Invoke-RestMethod (a cmdlet) instead of .NET HTTP classes, so it works in
# both FullLanguage and ConstrainedLanguage mode.
# Retry logic: exponential backoff with Retry-After support.

$Script:MaxRetries = 5
$Script:InitialBackoffMs = 1000
$Script:MaxBackoffMs = 16000
$Script:RequestTimeoutSec = 600

function Invoke-APIChat {
    param(
        [Parameter(Mandatory)][string]$Uri,
        [Parameter(Mandatory)][hashtable]$Headers,
        [Parameter(Mandatory)][hashtable]$Body,
        [Parameter(Mandatory)][string]$ProviderName
    )

    $jsonBody = $Body | ConvertTo-Json -Depth 20
    Write-PSCoderLog -Level "DEBUG" -Message "Calling $ProviderName API" -Source "BaseClient"

    $retryCount = 0
    $backoffMs = $Script:InitialBackoffMs

    while ($true) {
        try {
            $response = Invoke-RestMethod -Uri $Uri -Method Post -Headers $Headers `
                -Body $jsonBody -ContentType "application/json; charset=utf-8" `
                -TimeoutSec $Script:RequestTimeoutSec
            Write-PSCoderLog -Level "DEBUG" -Message "$ProviderName API call successful" -Source "BaseClient"
            return $response
        }
        catch {
            $errorMsg = $_.Exception.Message
            $statusCode = 0
            $retryAfterSec = 0

            # Status code: parse from the message (reading Exception.Response is not
            # available in ConstrainedLanguage mode).
            if ($errorMsg -match '\b(4\d\d|5\d\d)\b') { $statusCode = [int]$Matches[1] }

            # Prefer the API's own error message when present.
            try {
                if ($_.ErrorDetails -and $_.ErrorDetails.Message) {
                    $errorJson = $_.ErrorDetails.Message | ConvertFrom-Json
                    if ($errorJson.error.message) { $errorMsg = $errorJson.error.message }
                    elseif ($errorJson.message) { $errorMsg = $errorJson.message }
                }
            } catch {}

            # Determine if retryable
            $isRetryable = $false
            if ($statusCode -eq 429 -or $statusCode -eq 500 -or $statusCode -eq 502 -or $statusCode -eq 503 -or $statusCode -eq 504) {
                $isRetryable = $true
            }
            if ($errorMsg -match "timeout|tiempo de espera|connection reset") {
                $isRetryable = $true
            }

            if ($isRetryable -and $retryCount -lt $Script:MaxRetries) {
                $retryCount++

                # Exponential backoff (Retry-After header is not read in CLM).
                $waitMs = $backoffMs
                $backoffMs = $backoffMs * 2
                if ($backoffMs -gt $Script:MaxBackoffMs) { $backoffMs = $Script:MaxBackoffMs }

                $waitSec = [int]($waitMs / 1000)
                Write-PSCoderLog -Level "WARN" -Message "$ProviderName retry $retryCount/$Script:MaxRetries after ${waitSec}s (status: $statusCode)" -Source "BaseClient"
                Write-InfoPS "$ProviderName rate limited/error. Retrying in ${waitSec}s (attempt $retryCount/$Script:MaxRetries)..."
                Start-Sleep -Milliseconds $waitMs
                continue
            }

            Write-PSCoderLog -Level "ERROR" -Message "$ProviderName API error: $errorMsg (status: $statusCode, retries: $retryCount)" -Source "BaseClient"
            Write-ErrorPS "$ProviderName`n API: $errorMsg"
            return $null
        }
    }
}

function Build-ChatBody {
    param(
        [Parameter(Mandatory)][string]$Model,
        [Parameter(Mandatory)][array]$Messages,
        [array]$Tools = @(),
        [int]$MaxTokens = 4096,
        [double]$Temperature = 0.7,
        [string]$MaxTokensKey = "max_tokens",
        [hashtable]$ExtraParams = @{}
    )

    $body = @{
        model = $Model
        messages = $Messages
        $MaxTokensKey = $MaxTokens
        temperature = $Temperature
    }

    if ($Tools.Count -gt 0) { $body.tools = $Tools }

    foreach ($key in $ExtraParams.Keys) {
        $body[$key] = $ExtraParams[$key]
    }

    return $body
}
