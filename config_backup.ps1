$ErrorActionPreference = "Stop"

$configPath = "c:\ImportantApp\settings.txt"
$backupFolder = "c:\Backups"

# if (-not (Test-Path $configPath)) {
#     Write-Host "Config file not found at $configPath, Exiting..."
#     exit 1
# }

try {
    if (-not (Test-Path $configPath)) {
        throw "Config file not found at $configPath"
    }
    if (-not (Test-Path $backupFolder)) {
        New-Item -ItemType Directory -Path $backupFolder
    } 
}
catch {
    Write-Error "Error during initial checks"
    Exit 1
}
try {
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $configObject = Get-ChildItem $configPath
    $backupPath = "$backupFolder\${$configObject.BaseName}_$timestamp$($configObject.Extension)"
    Copy-Item -Path $configPath -Destination $backupPath 
    Write-Host "Backup created successfully: $backupPath"

}
catch {
    # Write-Warning "Failed to backup using Copy-Item， Attempting alternative method"
    # $content = Get-Content -Path $configPath -Raw
    # $content | Set-Content -Path $backupPath
    # Write-Host "Backup created successfully using alternative method at: $backupPath"
    try {
        Write-Warning "Failed to backup using Copy-Item， Attempting alternative method"
        $content = Get-Content -Path $configPath -Raw
        $content | Set-Content -Path $backupPath
        Write-Host "Backup created successfully using alternative method at: $backupPath"
    }
    catch {
        Write-Error "All backup attempts failed, Error"
        Exit 1
    }
}
finally {
    Write-Host "Backup operation completed, Exiting script."
}


