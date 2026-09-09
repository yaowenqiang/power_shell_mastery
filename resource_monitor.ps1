$cpu = (Get-CimInstance Win32_Processor).LoadPercentage

$memory = (Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1MB

Write-Host "Current CPU Usage: $cpu%"
Write-Host "Current Memory Usage: $memory GB"

if (($cpu -gt 90) -and ($memory -lt 2)) {
    Write-Host "critical! High CPU usage and low memory! consider closing some applications "
}
elseif (($cpu -gt 90) -or ($memory -lt 2)) {
    Write-Host "Warning! System resources are strained!.checking running processes."
}
elseif (($cpu -lt 20) -and ($memory -gt 8)) {
    Write-Host "System resources are optimal. Good time for system updates."
}
else {
    Write-Host "System resources are normal."
}
