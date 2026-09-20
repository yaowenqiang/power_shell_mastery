$processName = "zoomit"
$memoryThreshold = 5MB

$Process = Get-Process $processName -ErrorAction SilentlyContinue
while ($process -and $process.WorkingSet -lt $memoryThreshold) {
    $memoryUsage = $process.WorkingSet
    Write-Host "$processName is using $($memoryUsage / 1MB) MB of memory"
    Start-Sleep -Seconds 5
    $process = Get-Process $processName -ErrorAction SilentlyContinue
}

do {
    $process = Get-Process $processName -ErrorAction SilentlyContinue
    if ($process) {
        $memoryUsage = $process.WorkingSet
        Write-Host "$processName is using $($memoryUsage / 1MB) MB of memory"
        Start-Sleep -Seconds 5
    }
} while ($process -and $memoryUsage -lt $memoryThreshold)

if ($Process) {
    Write-Host "$processName has exceeded the memory threshold of $($memoryThreshold / 1MB) MB"
}
else {
    Write-Host "$processName is not running"
}