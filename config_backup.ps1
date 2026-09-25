$ErrorActionPreference = "Stop"

$configPath = "c:\ImportantApp\settings.txt"
$backupFolder = "c:\Backups"
$errorLogPath = “c:\Logs\backup_error_log.txt"

if (!(Test-Path $errorLogPath)) {
    Write-Host "Creating Error Log file..."
    New-Item -ItemType File -Path $errorLogPath
}
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
    $errorMessage = "$(Get-Date) - Error during initial checks: $($Error[0])"
    Add-Content -Path $errorLogPath -Value $errorMessage
    Write-Error "Error during initial checks: $($Error[0])"
    Exit 1
}
try {
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $configObject = Get-ChildItem $configPath
    # $($expr) evaluates an expression; ${name} would look for a variable literally named that
    $backupPath = "$backupFolder\$($configObject.BaseName)_$timestamp$($configObject.Extension)"
    Copy-Item -Path $configPath -Destination $backupPath 
    Write-Host "Backup created successfully: $backupPath"

}
catch {
    # Write-Warning "Failed to backup using Copy-Item， Attempting alternative method"
    # $content = Get-Content -Path $configPath -Raw
    # $content | Set-Content -Path $backupPath
    # Write-Host "Backup created successfully using alternative method at: $backupPath"
    $errorMessage = "$(Get-Date) - Failed to create backup using Copy-Item: $($Error[0])"
    Add-Content -Path $errorLogPath -Value $errorMessage
    Write-Warning "Failed to backup using Copy-Item， Attempting alternative method"
}
finally {
    try {
        Write-Warning "Failed to backup using Copy-Item， Attempting alternative method"
        $content = Get-Content -Path $configPath -Raw
        $content | Set-Content -Path $backupPath
        Write-Host "Backup created successfully using alternative method at: $backupPath"
    }
    catch {
        $errorMessage = "$(Get-Date) - All backup attempts failed $($Error[0])"
        Add-Content -Path $errorLogPath -Value $errorMessage
        Write-Error "All backup attempts failed, Error: $($Error[0])"
        Exit 1
    }
}
finally {
    Write-Host "Backup operation completed, Exiting script."
}


