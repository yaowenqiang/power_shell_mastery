$freeSpace = (GetCimInstance -ClassName Win32_LogicalDisk | Where-Object DeviceID -eq 'C:').FreeSpace / 1GB
$freeSpace = [math]::Round($freeSpace, 2)

Write-Host " You have $freeSpace GB free on C Drive."

if ($freeSpace -gt 50) {
    Write-Host " Plenty of space available! You have $freeSpace GB free."
}
elseif ($freeSpace -gt 20) {
    Write-Host "You're doing Okay, but you should consider cleaning up some space soon."
}
elseif ($freeSpace -gt 5) {
    Write-Host "Warning: You're running low on space."
}
else {
    Write-Host "Critical: Almost full! time to delte some files!"
}