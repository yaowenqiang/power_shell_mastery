# Script: Automated File Archiver and Cleaner

# Define paths
$ErrorActionPreference = "Stop"
$sourceFolder = "Desktop"
$archiveFolder = "Desktop/Archives"

$alternateArchiveFolder = "Archives2"

function Log-Error {
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



if (!(Test-Path $alternateArchiveFolder)) {
    try {
        New-Item -ItemType Directory -Path $alternateArchiveFolder -ErrorAction Stop
        Write-Host "Created alternate archive folder: $alternateArchiveFolder"
    }
    catch {
        $errorMessage = "Error: Failed to create alternate archive folder: $alternateArchiveFolder"

        Write-Error $errorMessage
        Log-Error $errorMessage
        exit 1
    }
}
# Check if source folder exists

if (!(Test-Path $sourceFolder)) {
    Write-Host "Error: Source folder does not exist: $sourceFolder"
    exit
}

# Ensure archive folder exists

if (!(Test-Path $archiveFolder)) {
    New-Item -ItemType Directory -Path $archiveFolder -ErrorAction Stop
    Write-Host "Created archive folder: $archiveFolder"
}

# Get files older than 30 days

$oldFiles = [System.Collections.ArrayList]::new()

$cutoffDate = (Get-Date).AddDays(-30)

foreach ($file in Get-ChildItem -Path $sourceFolder -File -ErrorAction SilentlyContinue) {
    if ($file.LastWriteTime -lt $cutoffDate) {
        [void]$oldFiles.Add($file)
    }
}

# Process each file

foreach ($file in $oldFiles) {
    # Join-Path uses the correct separator on every platform ("\" would break on mac/Linux)
    # Compress-Archive -Path $file.FullName -DestinationPath (Join-Path $archiveFolder "$($file.BaseName).zip") -WhatIf -ErrorAction Stop

    # Write-Host "Compressed file: $($file.Name)"

    try {
        Compress-Archive -Path $file.FullName -DestinationPath (Join-Path $archiveFolder "$($file.BaseName).zip") -ErrorAction Stop

        Write-Host "Compressed file: $($file.Name)"
    }
    catch [System.UnauthorizedAccessException] {
        Write-Host "Access denied to primary archive folder, attempting to copy to alternate location."
        try {

            Compress-Archive -Path $file.FullName -DestinationPath (Join-Path $alternateArchiveFolder "$($file.BaseName).zip") -ErrorAction Stop
            Write-Host "Compressed file to alternate archive folder: $($file.Name)"
        }
        catch {
            $errorMessage = "Error: Failed to compress file to alternate location: $($file.Name), Error: $($_.Exception.Message)"
            Write-Error $errorMessage
            Log-Error $errorMessage
        }
        # Copy-Item -Path $file.FullName -Destination $archiveFolder
        # Write-Host "Copied file to the archive folder: $($file.Name)"

        # Write-Error "Failed to compress file: $($file.Name), Attempting to copy to the archive folder instead"
        # Copy-Item -Path $file.FullName -Destination $archiveFolder
        # Write-Host "Copied file to the archive folder: $($file.Name)"
    }
    catch {
        $errorMessage = "Error: Failed to compress file: $($file.Name), Error: $($_.Exception.Message), attempting to copy to the archive folder instead"
        Write-Error $errorMessage
        Log-Error $errorMessage
        try {
            Copy-Item -Path $file.FullName -Destination $archiveFolder -ErrorAction Stop
            Write-Host "Copied file to the archive folder: $($file.Name)"
        }
        catch [System.UnauthorizedAccessException] {
            $errorMessage = "Access denied to primary archive folder, attempting to copy to alternate location."
            Write-Error $errorMessage
            Log-Error $errorMessage
            try {
                Copy-Item -Path $file.FullName -Destination $alternateArchiveFolder -ErrorAction Stop
                Write-Host "Copied file to alternate archive folder: $($file.Name)"
            }
            catch {
                $errorMessage = "Error: Failed to copy file to alternate location: $($file.Name), Error: $($_.Exception.Message)"
                Write-Error $errorMessage
                Log-Error $errorMessage
            }
        }
        catch {
            $errorMessage = "Error: Failed to copy file: $($file.Name), Error: $($_.Exception.Message)"
            Write-Error $errorMessage
            Log-Error $errorMessage
        }
    }
    finally {
        try {
            # Delete the original (optionally)
            Remove-Item -Path $file.FullName -ErrorAction stop
            Write-Host "Deleted original file: $($file.Name)"
        }
        catch [System.UnauthorizedAccessException] {
            $errorMessage = "Access denied when trying to delete original file: $($file.Name) "
            Write-Error $errorMessage
            Log-Error $errorMessage
        }
        catch {
            $errorMessage = "Error: Failed to delete original file: $($file.Name), Error: $($_.Exception.Message)"
            Write-Error $errorMessage
            Log-Error $errorMessage
        }
    }
}

# Clean up old archive files (older than 1 year) 

$oldArchivesCount = 0
$cutoffDate = (Get-Date).AddYears(-1)
$allFiles = Get-ChildItem -Path $archiveFolder -File -ErrorAction SilentlyContinue

foreach ($file in $allFiles) {
    if ($file.LastWriteTime -lt $cutoffDate) {
        try {
            Remove-Item -Path $file.FullName -ErrorAction Stop
            $oldArchivesCount++
            Write-Host "Removed old archive: $file"
        }
        catch [System.UnauthorizedAccessException] {
            $errorMessage = "Access denied when trying to delete old archive file: $($file.Name)"
            Write-Error $errorMessage
            Log-Error $errorMessage
        }
        catch {
            $errorMessage = "Failed to delete old archive file: $($file.Name), Error: $($_.Exception.Message)"
            Write-Error $errorMessage
            Log-Error $errorMessage
        }
    }
}


# Generate and display summary

$summary = "File Archiving and Cleaning Summary:`n"
$summary += "----------------------------------`n"
$summary += "Files moved to archive: {0}`n" -f $oldFiles.Count
$summary += "Old archives removed: {0}`n" -f $oldArchivesCount

Write-Host $summary

# Prompt user for file list viewing if we processed any files

if ($oldFiles.Count -gt 0 -or $oldArchivesCount -gt 0) {

    if (Read-Host "Do you want to view the list of processed files? (Y/N)" -eq "Y") {
        $oldFiles | Select-Object Name, LastWriteTime
    }
}