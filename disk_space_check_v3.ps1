# Get-PSDrive works on every platform, no Win32_* CIM classes needed
# only the drive name differs: "C" on Windows, "/" on macOS/Linux
$driveName = if ($IsWindows) { "C" } else { "/" }
$drive = Get-PSDrive $driveName

$totalSpace = [math]::Round(($drive.Used + $drive.Free) / 1GB, 2)
$freeSpace = [math]::Round($drive.Free / 1GB, 2)
$freePercentage = [math]::Round(($freeSpace / $totalSpace) * 100, 2)

Write-Host "You have $freeSpace GB free out of $totalSpace GB total."

if ($freePercentage -gt 25) {
    Write-Host "Plenty of space available! ($freePercentage% free)"
}
else {
    Write-Host "Critical: almost full! Time to delete some files. ($freePercentage% free)"
}
