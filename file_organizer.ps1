$errorLogPath = "C:\Logs\file_organizer_error_log.txt"
if (!(Test-path $errorLogPath)) {
    Write-Host "Creating error log file at $errorLogPath"
    [void](New-Item -Path $errorLogPath -ItemType File -WhatIf -ErrorAction Stop)
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
            [void](New-Item -Path $destinationFolder -ItemType Directory -WhatIf -ErrorAction Stop)
        }
        # use .Name: "$file" would interpolate the full path into the destination
        $destinationPath = "$destinationFolder/$($file.Name)"
        Move-Item -Path $file.FullName -Destination $destinationPath  -ErrorAction Stop

        Write-Host "Moved :$($File.Name) to $Category"

    }
    catch {
        $errorMessage = "$(Get-Date) - Error moving file $($file.Name) to $category : $_"
        Add-Content -Path $errorLogPath -Value $errorMessage
        Write-Warning "Failed to move $($file.Name). check error log for details."
    }

}

$categorizedCount = 0
foreach ($file in Get-ChildItem -ErrorAction SilentlyContinue) {
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
    $errorCount = (Get-Content $errorLogPath).Count
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