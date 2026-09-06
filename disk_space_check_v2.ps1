if ($IsWindows) {
    # property name without $ (fixed: was $deviceID, an undefined variable)
    $disk = Get-CimInstance Win32_LogicalDisk | Where-Object DeviceID -eq "C:"
    $totalBytes = $disk.Size
    $freeBytes = $disk.FreeSpace
}
else {
    # macOS/Linux have no Win32_* CIM classes; Get-PSDrive "/" exposes Used and Free in bytes
    $drive = Get-PSDrive /
    $totalBytes = $drive.Used + $drive.Free
    $freeBytes = $drive.Free
}

$totalSpace = [math]::Round($totalBytes / 1GB, 2)
$freeSpace = [math]::Round($freeBytes / 1GB, 2)
$freePercentage = [math]::Round(($freeSpace / $totalSpace) * 100, 2)

Write-Host "You have $freeSpace GB free out of $totalSpace GB total."

if ($freePercentage -gt 25) {
    Write-Host "Plenty of space available! ($freePercentage% free)"
}
else {
    Write-Host "Critical: almost full! Time to delete some files. ($freePercentage% free)"
}
