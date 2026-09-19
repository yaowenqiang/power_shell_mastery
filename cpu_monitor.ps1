$threshold = 80

# log to the user profile on mac/Linux, keep the original Windows path
$logFile = if ($IsWindows) { "C:\Users\Public\cpu_monitor.log" } else { Join-Path $HOME "cpu_monitor.log" }

while ($true) {
    if ($IsMacOS) {
        # top reports how much was idle, usage is the rest
        $topLine = (top -l 1 | Select-String 'CPU usage').ToString()
        $idle = [double]([regex]::Match($topLine, '(\d+\.?\d*)% idle').Groups[1].Value)
        $cpu = [math]::Round(100 - $idle, 1)
    }
    elseif ($IsLinux) {
        $topLine = (top -bn1 | Select-String 'Cpu').ToString()
        $idle = [double]([regex]::Match($topLine, '(\d+\.?\d*)\s*id').Groups[1].Value)
        $cpu = [math]::Round(100 - $idle, 1)
    }
    else {
        $cpu = (Get-CimInstance Win32_Processor).LoadPercentage
    }

    if ($cpu -gt $threshold) {
        Write-Host "Warning: CPU usage is at $cpu%" -ForegroundColor Red
        "$(Get-Date) - CPU Usage: $cpu%" | Out-File -FilePath $logFile -Append
    }
    else {
        Write-Host "CPU usage is at $cpu%" -ForegroundColor Green
    }
    Start-Sleep -Seconds 10
}
