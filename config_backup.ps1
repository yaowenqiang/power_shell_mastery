$ErrorActionPreference = "Stop"

# $configPath = "c:\ImportantApp\settings.txt"
# $backupFolder = "c:\Backups"
# $errorLogPath = “c:\Logs\backup_error_log.txt"

$configPath = "settings.txt"
$backupFolder = "Backups"
$errorLogPath = “backup_error_log.txt"
$alternativeBackupFolder = "Backups_alt"

if (!(Test-Path $errorLogPath)) {
    Write-Host "Creating Error Log file..."
    New-Item -ItemType Directory -Path $errorLogPath -ErrorAction Stop
}

if (!(Test-Path $alternativeBackupFolder)) {
    Write-Host "Creating Error Log file..."
    New-Item -ItemType Directory -Path $alternativeBackupFolder -ErrorAction Stop
}
# if (-not (Test-Path $configPath)) {
#     Write-Host "Config file not found at $configPath, Exiting..."
#     exit 1
# }

function LogError {
    param (
        # must be ErrorRecord: [string] would coerce $_ to its message text, making .Exception null
        [System.Management.Automation.ErrorRecord]$ErrorRecord,
        [string]$CustomMessage
    )
    $ErrorDetails = @"
    Date: $(Get-Date)
    Custom Message: $CustomMessage
    Error Message: $($ErrorRecord.Exception.Message)
    Error Type: $($ErrorRecord.Exception.GetType().FullName)
    Stack Trace: $($ErrorRecord.ScriptStackTrace)
    Script Line: $($ErrorRecord.InvocationInfo.ScriptLineNumber)
    Script Name: $($ErrorRecord.InvocationInfo.ScriptName)
    Invocation Name: $($ErrorRecord.InvocationInfo.InvocationName)
    Position Message: $($ErrorRecord.InvocationInfo.PositionMessage)
    Stack Trace: $($ErrorRecord.ScriptStackTrace)
"@
    Add-Content -Path $errorLogPath -Value $ErrorDetails
    Write-Host "Error logged, See $errorLogPath for details"
}


try {
    if (-not (Test-Path $configPath)) {
        throw "Config file not found at $configPath"
    }
    if (-not (Test-Path $backupFolder)) {
        New-Item -ItemType Directory -Path $backupFolder
    } 
}

catch [System.UnauthorizedAccessException] {
    LogError -ErrorRecord $_ -CustomMessage "Permission Denied."
    Write-Host "Error: Permission Denied.Attempting to the alternate location."
    try {
        Copy-Item -Path $configPath -Destination $alternativeBackupFolder -ErrorAction Stop
        Write-Host "Created backup in alternate location: $alternativeBackupFolder"
    }
    catch {
        LogError -ErrorRecord $_ -CustomMessage "Alternative backup loation also failed."
        Write-Host "Alternative backup loation also failed."
        Exit 1
    }
    Exit 1
}
catch [System.IO.IOException] {
    LogError -ErrorRecord $_ -CustomMessage "IO Error occured."
    Write-Host "IO error occurred.Attempting alternative backup location."
    try {
        $backupPath = "$backupFolder/$($configObject.BaseName)_$timestamp$($configObject.Extension)"
        $configContent = Get-Content -Path $configPath -ErrorAction Stop
        New-Item -Path $backupPath -ItemType File -Value $configContent -ErrorAction Stop
        Write-Host "Backup created successfully using alternative method at: $backupPath"
    }
    catch {
        LogError -ErrorRecord $_ -CustomMessage "Alternative backup method also failed."
        Write-Host "Alternative backup method also failed.$($_.Exception.Message)"
        Exit 1
    }
    Exit 1
}
catch {
    LogError -ErrorRecord $_ -CustomMessage "An unexcepted error occurred."
    Write-Host "An unexcepted error occurred.$($_.Exception.Message)"
    Sent-MailMessage -To "admin@example.com" -From "backup-script@example.com" -Subject "Backup Script Erro4" -Body "An unexcepted error occurred during backup: $($_.Exception.Message)" -SmtpServer "smtp.example.com"
}
finally {
    Write-Host "Backup operation completed, Exiting script."
}
# catch {
#     LogError -ErrorRecord $_ -CustomMessage "Error occurred during initial checks"
#     $errorMessage = "$(Get-Date) - Error during initial checks: $($Error[0])"
#     # Add-Content -Path $errorLogPath -Value $errorMessage
#     Write-Error "Error during initial checks: $($Error[0])"
#     Exit 1
# }
# try {
#     $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
#     $configObject = Get-ChildItem $configPath
#     # forward slash works on Windows and mac/Linux ("\" is not a separator on mac/Linux)
#     $backupPath = "$backupFolder/$($configObject.BaseName)_$timestamp$($configObject.Extension)"
#     Copy-Item -Path $configPath -Destination $backupPath
#     Write-Host "Backup created successfully: $backupPath"
# }
# catch {
#     LogError -ErrorRecord $_ -CustomMessage "Error occurred during backup creation"
#     Write-Warning "Failed to backup using Copy-Item. Attempting alternative method"
#     try {
#         $content = Get-Content -Path $configPath -Raw
#         $content | Set-Content -Path $backupPath
#         Write-Host "Backup created successfully using alternative method at: $backupPath"
#     }
#     catch {
#         LogError -ErrorRecord $_ -CustomMessage "Error occurred during backup creation using alternative method"
#         Write-Error "All backup attempts failed"
#         Exit 1
#     }
# }
# finally {
#     Write-Host "Backup operation completed, Exiting script."
# }


