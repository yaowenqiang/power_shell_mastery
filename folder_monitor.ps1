$folderPath = "Desktop"

$fileCount = (Get-ChildItem $folderPath).Count

Write-Host "Monitoring filder: $folderPath, initial file count: $fileCount"

While ($true) {
    Start-Sleep -Seconds 5
    $newCount = (Get-ChildItem $folderPath).Count
    if ($newCount -ne $fileCount) {
        Write-Host "File count changed, new count: $newCount"
        $fileCount = $newCount
    }
}
