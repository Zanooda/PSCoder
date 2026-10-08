# Formatter.ps1 - Clean CLI output for PSCoder
# Uses only ASCII-safe characters that render correctly in all Windows consoles

$Script:Colors = @{
    User = "Cyan"; Assistant = "Green"; Tool = "Yellow"; Error = "Red"
    Info = "Gray"; Header = "Magenta"; Prompt = "Blue"; Success = "DarkGreen"
    Accent = "Cyan"; Dim = "DarkGray"; Bright = "White"
    Border = "DarkGray"; Spinner = "Cyan"; StatusBar = "DarkGray"
    Thinking = "DarkGray"; ToolCall = "Yellow"; ToolResult = "Green"
}

function Write-PSCoderBanner {
    Write-Host ""
    Write-Host "  _____   _____  ____   ____" -ForegroundColor $Script:Colors.Accent
    Write-Host " |  _ \ / ____/ ___| / ___|  ___ _ __" -ForegroundColor $Script:Colors.Accent
    Write-Host " | |_) | (___| |     \___ \ / _ \  __|" -ForegroundColor $Script:Colors.Accent
    Write-Host " |  __/ \___ \ |___   ___) |  __/ |" -ForegroundColor $Script:Colors.Accent
    Write-Host " |_|    |____/\____| |____/ \___|_|" -ForegroundColor $Script:Colors.Accent
    Write-Host ""
    Write-Host "  AI Assistant for PowerShell" -ForegroundColor $Script:Colors.Bright
    Write-Host "  Custom OpenAI-compatible API (slop.storo.cloud)" -ForegroundColor $Script:Colors.Dim
    Write-Host ""
}

function Write-PSCoderPrompt {
    param([string]$Model, [string]$CurrentDir)
    Write-Host ""
    $shortDir = Split-Path $CurrentDir -Leaf
    Write-Host " [$shortDir] [$Model] > " -NoNewline -ForegroundColor $Script:Colors.Accent
}

function Write-ThinkingStart {
    Write-Host ""
    Write-Host " [Thinking] " -NoNewline -ForegroundColor $Script:Colors.Thinking
    Write-Host "..." -ForegroundColor $Script:Colors.Thinking
}

function Write-AssistantMessage {
    param([string]$Message)
    Write-Host ""
    Write-Host $Message -ForegroundColor $Script:Colors.Bright
}

function Write-ToolCall {
    param([string]$ToolName, [string]$Summary)
    $text = if ($Summary) { $Summary } else { "" }
    $text = ($text -replace "\s+", " ").Trim()
    if ($text.Length -gt 150) { $text = $text.Substring(0, 150) + "..." }
    Write-Host ""
    Write-Host " > " -NoNewline -ForegroundColor $Script:Colors.ToolCall
    Write-Host $ToolName -NoNewline -ForegroundColor $Script:Colors.ToolCall
    if ($text) { Write-Host ": $text" -ForegroundColor $Script:Colors.Dim } else { Write-Host "" }
}

function Write-ToolResult {
    param([string]$ToolName, [string]$Result, [bool]$Success = $true)
    if (-not $Result) { return }
    $color = if ($Success) { $Script:Colors.ToolResult } else { $Script:Colors.Error }
    $lines = @($Result -split "`r?`n")
    $max = 8
    for ($i = 0; $i -lt $lines.Count -and $i -lt $max; $i++) {
        Write-Host "   $($lines[$i])" -ForegroundColor $color
    }
    if ($lines.Count -gt $max) {
        Write-Host "   ... (+$($lines.Count - $max) more lines)" -ForegroundColor $Script:Colors.Dim
    }
}

function Write-StatusBar {
    param(
        [string]$Model = "",
        [int]$Tokens = 0,
        [int]$Turn = 0,
        [string]$Provider = "",
        [double]$Cost = 0.0
    )
    try {
        $width = $Host.UI.RawUI.WindowSize.Width
        if ($width -le 0) { $width = 80 }
    } catch {
        $width = 80  # Fallback for non-interactive hosts
    }

    $costStr = if ($Cost -gt 0) { " | Cost: `${0:N4}" -f $Cost } else { "" }
    $statusText = " Model: $Model | Provider: $Provider | Tokens: $Tokens | Turn: $Turn$costStr "
    $padding = $width - $statusText.Length - 2
    if ($padding -lt 0) { $padding = 0 }

    Write-Host ""
    Write-Host " $('-' * ($width - 2))" -ForegroundColor $Script:Colors.StatusBar
    Write-Host " $statusText".PadRight($width - 1) -ForegroundColor $Script:Colors.StatusBar
    Write-Host " $('-' * ($width - 2))" -ForegroundColor $Script:Colors.StatusBar
}

function Write-ConfirmDialog {
    param([string]$Message)
    $width = Get-MaxInt ($Message.Length + 10) 50

    Write-Host ""
    Write-Host " $('-' * ($width - 2))" -ForegroundColor $Script:Colors.Border
    Write-Host " WARNING: Confirmation".PadRight($width - 1) -ForegroundColor $Script:Colors.ToolCall
    Write-Host " $('-' * ($width - 2))" -ForegroundColor $Script:Colors.Border
    Write-Host " $Message".PadRight($width - 1) -ForegroundColor $Script:Colors.Info
    Write-Host ""
    Write-Host " [Y] Yes  [N] No  [A] Always".PadRight($width - 1) -ForegroundColor $Script:Colors.Info
    Write-Host " $('-' * ($width - 2))" -ForegroundColor $Script:Colors.Border
}

function Write-ErrorPS {
    param([string]$Message)
    Write-Host ""
    Write-Host " --- Error --------------------------------------------" -ForegroundColor $Script:Colors.Error
    Write-Host " $Message" -ForegroundColor $Script:Colors.Error
    Write-Host " ------------------------------------------------------" -ForegroundColor $Script:Colors.Error
}

function Write-InfoPS {
    param([string]$Message)
    Write-Host ""
    Write-Host " [Info] $Message" -ForegroundColor $Script:Colors.Info
}

function Write-HeaderPS {
    param([string]$Message)
    Write-Host ""
    Write-Host " === $Message ===" -ForegroundColor $Script:Colors.Header
}

function Write-WarningPS {
    param([string]$Message)
    Write-Host ""
    Write-Host " [Warning] $Message" -ForegroundColor $Script:Colors.Tool
}

function Confirm-Action {
    param([string]$Message)
    Write-ConfirmDialog -Message $Message
    Write-Host ""
    Write-Host " Response: " -NoNewline -ForegroundColor $Script:Colors.Dim
    $response = Read-Host
    switch ($response.ToLower()) {
        "y" { return "yes" } "yes" { return "yes" }
        "a" { return "always" } "always" { return "always" }
        default { return "no" }
    }
}
