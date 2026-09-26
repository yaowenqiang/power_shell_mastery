$errorLogPath = "file_organizer_error_log.txt"
if (!(Test-path $errorLogPath)) {
    Write-Host "Creating error log file at $errorLogPath"
    [void](New-Item -Path $errorLogPath -ItemType File -ErrorAction Stop)
}
Add-Content -Path $errorLogPath -Value "$(Get-Date) - File Organization started!"
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
    Category: $($ErrorRecord.CategoryInfo.Category)
    Target Object: $($ErrorRecord.TargetObject)
"@
    Add-Content -Path $errorLogPath -Value $ErrorDetails
    Write-Host "Error logged, See $errorLogPath for details"
}
$categoryMap = @{
    ".txt"  = "Documents"
    ".doc"  = "Documents"
    ".docx" = "Documents"
    ".pdf"  = "Documents"
    ".jpg"  = "Images"
    ".png"  = "Images"
    ".gif"  = "Images"
    ".mp3"  = "Audio"
    ".wav"  = "Audio"
    ".mp4"  = "Videos"
    ".avi"  = "Videos"
    ".zip"  = "Archives"
    ".rar"  = "Archives"
}

$unknownExtensions = @{

}

# Write-Host $categoryMap['.txt']

function Move-FileToCategory($file, $category) {
    try {
        $destinationFolder = "$PWD/$category" 

        if (!(Test-path $destinationFolder)) {
            [void](New-Item -Path $destinationFolder -ItemType Directory -ErrorAction Stop)
        }
        # use .Name: "$file" would interpolate the full path into the destination
        $destinationPath = "$destinationFolder/$($file.Name)"
        Move-Item -Path $file.FullName -Destination $destinationPath  -ErrorAction Stop

        Write-Host "Moved :$($File.Name) to $Category"

    }
    catch {
        LogError -ErrorRecord $_ -CustomMessage "Error moving file $($file.Name) to $category"
        $errorMessage = "$(Get-Date) - Error moving file $($file.Name) to $category : $_"
        Add-Content -Path $errorLogPath -Value $errorMessage
        Write-Warning "Failed to move $($file.Name). check error log for details."
    }

}

$categorizedCount = 0
# exclude the log file itself, otherwise the organizer moves it into Documents
foreach ($file in (Get-ChildItem -Exclude $errorLogPath -ErrorAction SilentlyContinue)) {
    try {
        $extension = $file.Extension.ToLower()
        if ($categoryMap.ContainsKey($extension)) {
            Move-FileToCategory $file $categoryMap[$extension]
            $categorizedCount++
        }
        else {
            Move-FileToCategory $file 'Miscellaneous'
            if ($unknownExtensions.ContainsKey($extension)) {
                $unknownExtensions[$extension]++
            }
            else {
                $unknownExtensions[$extension] = 1
            }
        }

    }
    catch {
        LogError -ErrorRecord $_ -CustomMessage "Error processing file $($file.Name)"
        $errorMessage = "$(Get-Date) - Error processing file $($file.Name) : $_"
        Add-Content -Path $errorLogPath -Value $errorMessage
        Write-Warning "Failed to process $($file.Name). check error log for details."
    }
}

Write-Host "`nCategorized $categorizedCount file(s)."

Write-Host "`nUnknown file types encountered:"

foreach ($extension in $unknownExtensions.Keys) {
    Write-Host "$extension : $($unknownExtensions[$extension]) file(s)"
}

if (Test-Path $errorLogPath) {
    # count only error lines; the log also holds the start/completed markers
    $errorCount = (Get-Content $errorLogPath | Where-Object { $_ -match ' - Error ' }).Count
    if ($errorCount -gt 0) { 
        Write-Host "`nEncountered $errorCount error(s). Check $ErrorLogPath for details."
    }
    else {
        Write-Host "`nNo errors encountered during file organization."
    }
}
else {
    Write-Host "`nNo error log encountered.File organization completed without any logged errors."
}

Add-Content -Path $errorLogPath -Value "$(Get-Date) - File Organization completed!"