function Format-FileSize {
    param([long]$bytes)
    # pick the largest unit that keeps the number readable
    if ($bytes -ge 1GB) { return "{0:N2} GB" -f ($bytes / 1GB) }
    elseif ($bytes -ge 1MB) { return "{0:N2} MB" -f ($bytes / 1MB) }
    elseif ($bytes -ge 1KB) { return "{0:N2} KB" -f ($bytes / 1KB) }
    else { return "$bytes B" }
}

$files = Get-ChildItem -Path "/Users/yaojack/Downloads/" -File

$FileInfoArray = @()

foreach ($file in $files) {
    Write-Output "Processing file: $file"
    $FileInfo = @(
        $file.Name,
        $file.Extension,
        $file.Length,
        $file.LastWriteTime
    )
    # the comma operator wraps the array so += nests it instead of flattening
    $FileInfoArray += , $FileInfo
}

$sortedFileInfoArray = $FileInfoArray | Sort-Object -Property { $_[2] } -Descending

foreach ($FileInfo in $sortedFileInfoArray) {
    $fileName = $FileInfo[0]
    $fileExtension = $FileInfo[1]
    $fileSize = $FileInfo[2]
    $fileLastWriteTime = $FileInfo[3]

    Write-Output "File Name: $fileName"
    Write-Output "File Extension: $fileExtension"
    Write-Output "File Size: $(Format-FileSize $fileSize)"
    Write-Output "File Last Write Time: $fileLastWriteTime"
    Write-Output "------------------------"
}