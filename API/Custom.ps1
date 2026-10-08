# Custom.ps1 - HTTP client for a custom OpenAI-compatible endpoint
# Endpoint: https://slop.storo.cloud/v1 (OpenAI-compatible chat completions)
# Default model: deepseek-v4.1-flash

$Script:CustomBaseURL = "https://slop.storo.cloud/v1"

function Invoke-CustomChat {
    param(
        [Parameter(Mandatory)][string]$Model,
        [Parameter(Mandatory)][array]$Messages,
        [Parameter()][array]$Tools = @(),
        [int]$MaxTokens = 4096,
        [double]$Temperature = 0.7,
        [string]$ApiKey
    )
    if (-not $ApiKey) { $ApiKey = Get-CustomApiKey }
    if (-not $ApiKey) {
        Write-ErrorPS "API Key not found. Use '/config apiKey <your-key>' or set `$env:SLOP_API_KEY"
        return $null
    }

    $headers = @{
        "Authorization" = "Bearer $ApiKey"
        "Content-Type" = "application/json"
    }
    $body = Build-ChatBody -Model $Model -Messages $Messages -Tools $Tools -MaxTokens $MaxTokens -Temperature $Temperature
    return Invoke-APIChat -Uri "$Script:CustomBaseURL/chat/completions" -Headers $headers -Body $body -ProviderName "Custom"
}

function Get-CustomModelsList {
    return @(
        "--- CUSTOM (slop.storo.cloud) ---"
        "deepseek-v4.1-flash"
    )
}
