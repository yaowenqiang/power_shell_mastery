$ErrorActionPreference = "Stop"

$configPath = "c:\ImportantApp\settings.txt"
$backupFolder = "c:\Backups"

if (-not (Test-Path $configPath)) {
    Write-Host "Config file not found at $configPath, Exiting..."
    exit 1
}

if (-not (Test-Path $backupFolder)) {
    New-Item -ItemType Directory -Path $backupFolder
}

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$configObject = Get-ChildItem $configPath
$backupPath = "$backupFolder\${$configObject.BaseName}_$timestamp$($configObject.Extension)"

Copy-Item -Path $configPath -Destination $backupPath 

Write-Host "Backup created successfully: $backupPath"
