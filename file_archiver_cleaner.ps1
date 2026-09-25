# Script: Automated File Archiver and Cleaner

# Define paths
$ErrorActionPreference = "Stop"
$sourceFolder = "Desktop"
$archiveFolder = "Desktop/Archives"

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
    catch {
        Write-Error "Failed to compress file: $($file.Name), Attempting to copy to the archive folder instead"
        Copy-Item -Path $file.FullName -Destination $archiveFolder
        Write-Host "Copied file to the archive folder: $($file.Name)"
    }
    finally {
        # Delete the original (optionally)
        Remove-Item -Path $file.FullName -WhatIf -ErrorAction SilentlyContinue
        Write-Host "Attempted to delete original file: $($file.Name)"
    }
}

# Clean up old archive files (older than 1 year) 

$oldArchivesCount = 0
$cutoffDate = (Get-Date).AddYears(-1)
$allFiles = Get-ChildItem -Path $archiveFolder -File -ErrorAction SilentlyContinue

foreach ($file in $allFiles) {
    if ($file.LastWriteTime -lt $cutoffDate) {
        $oldArchivesCount++
        Remove-Item -Path $file.FullName -WhatIf -ErrorAction SilentlyContinue
        Write-Host "Removed old archive: $file"
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