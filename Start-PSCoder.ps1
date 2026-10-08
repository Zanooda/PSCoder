# Start-PSCoder.ps1 - Quick start for PSCoder
# Usage: .\Start-PSCoder.ps1 [-Model "deepseek-v4.1-flash"] [-Provider "custom"]

param(
    [string]$Model,
    [string]$Provider
)

# Check minimum PowerShell version
if ($PSVersionTable.PSVersion.Major -lt 5) {
    Write-Host "ERROR: PSCoder requires PowerShell 5.1 or higher." -ForegroundColor Red
    Write-Host "Your version: $($PSVersionTable.PSVersion)" -ForegroundColor Yellow
    exit 1
}

Write-Host "PowerShell $($PSVersionTable.PSVersion) detected" -ForegroundColor Gray

# Load module
$scriptDir = Split-Path $MyInvocation.MyCommand.Path -Parent

# Unblock all PowerShell files in this directory tree, so files copied/downloaded
# from the internet (Zone.Identifier mark) load without being blocked.
if (Get-Command Unblock-File -ErrorAction SilentlyContinue) {
    Get-ChildItem -Path $scriptDir -Recurse -File -Include *.ps1, *.psm1, *.psd1 -ErrorAction SilentlyContinue |
        Unblock-File -ErrorAction SilentlyContinue
}

Import-Module "$scriptDir\PSCoder.psd1" -Force

# Start PSCoder
if ($Model -and $Provider) {
    Start-PSCoder -InitialModel $Model -InitialProvider $Provider
} elseif ($Model) {
    Start-PSCoder -InitialModel $Model
} elseif ($Provider) {
    Start-PSCoder -InitialProvider $Provider
} else {
    Start-PSCoder
}
