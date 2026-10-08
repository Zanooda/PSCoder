#Requires -Version 5.1
# PSCoder.psm1 - Main module for PSCoder

# Detect the PowerShell language mode. Under an application control policy
# (WDAC / AppLocker) PowerShell runs in ConstrainedLanguage mode, where most
# .NET types (System.Net, System.IO, System.Math, Add-Type, COM, ...) are not
# available. PSCoder is written to work in both modes: everything uses cmdlets
# and ConstrainedLanguage-allowed types. A few optional features (speech, OCR)
# degrade gracefully when .NET is unavailable.
$Script:PSCoderLanguageMode = $ExecutionContext.SessionState.LanguageMode
$Script:PSCoderConstrained = ($Script:PSCoderLanguageMode -ne 'FullLanguage')

if ($Script:PSCoderConstrained) {
    Write-Warning "PSCoder: PowerShell is in $($Script:PSCoderLanguageMode) mode (application control policy). Running with cmdlet-only features; speech and OCR are disabled."
}

# Configure UTF-8 encoding for special characters (skipped in ConstrainedLanguage mode)
try { chcp 65001 | Out-Null } catch {}
if (-not $Script:PSCoderConstrained) {
    try {
        [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
        [Console]::InputEncoding = [System.Text.Encoding]::UTF8
        $OutputEncoding = [System.Text.Encoding]::UTF8
    } catch {}
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor [Net.SecurityProtocolType]::Tls13
    } catch {}
}
$PSDefaultParameterValues['*:Encoding'] = 'utf8'

$PSScriptRoot_ = Split-Path $MyInvocation.MyCommand.Path -Parent

# Load modules in dependency order
$modulesToLoad = @(
    "Config/Config.ps1"
    "Tools/Cache.ps1"
    "UI/Formatter.ps1"
    "API/BaseClient.ps1"
    "API/Custom.ps1"
    "API/Groq.ps1"
    "API/OrcaRouter.ps1"
    "Tools/WebSearch.ps1"
    "Tools/WebFetch.ps1"
    "Tools/OcrImage.ps1"
    "Tools/ToolRegistry.ps1"
    "Tools/ExecutePowerShell.ps1"
    "Tools/ReadFile.ps1"
    "Tools/WriteFile.ps1"
    "Tools/EditFile.ps1"
    "Tools/SearchFiles.ps1"
    "Tools/GlobFiles.ps1"
    "Tools/ListDirectory.ps1"
    "Core/Logger.ps1"
    "Core/Hooks.ps1"
    "Core/ContextBuilder.ps1"
    "Core/AutoImprove.ps1"
    "Core/AutoHealing.ps1"
    "Core/AgentNarration.ps1"
    "Memory/Memory.ps1"
    "Core/Init.ps1"
    "Core/ReasoningEngine.ps1"
    "Core/MemoryDecision.ps1"
    "Tools/SkillManager.ps1"
    "Tools/Invoke-Tool.ps1"
    "History/History.ps1"
    "Commands/SlashCommands.ps1"
    "Core/SystemPrompt.ps1"
    "Core/Permissions.ps1"
    "Core/InterruptHandler.ps1"
    "Core/Main-Loop.ps1"
)

$failedModules = @()
foreach ($module in $modulesToLoad) {
    $modulePath = Join-Path $PSScriptRoot_ $module
    if (Test-Path $modulePath) {
        try {
            . $modulePath
        } catch {
            $failedModules += "$module : $($_.Exception.Message)"
        }
    } else {
        $failedModules += "$module : file not found"
    }
}

if ($failedModules.Count -gt 0) {
    Write-Warning "PSCoder: Failed to load $($failedModules.Count) module(s):"
    foreach ($f in $failedModules) {
        Write-Warning "  - $f"
    }
}

# Initialize configuration and subsystems
Initialize-PSCoderConfig
Initialize-PSCoderSubsystems
Initialize-Hooks
Initialize-Permissions

# Export all module members
Export-ModuleMember -Function *
