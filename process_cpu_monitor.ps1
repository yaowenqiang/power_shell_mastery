# pick demo processes that actually exist on each platform
$processes = if ($IsWindows) { @('notepad', 'calc') } else { @('Finder', 'WindowServer') }

$checkInterval = 5

$cpuThreshold = 10

do {
    foreach ($process in $processes) {
        $processInfo = Get-Process -Name $process -ErrorAction SilentlyContinue
        if ($processInfo) {
            # total CPU seconds used by all instances (fixed: was undefined $processName)
            # [double] turns $null (system process, access denied) into 0
            $startCPU = [double](Get-Process -Name $process | Measure-Object -Property CPU -Sum).Sum

            Start-Sleep -Seconds 1
            $endCPU = [double](Get-Process -Name $process | Measure-Object -Property CPU -Sum).Sum

            # % of one core during the 1 second sample window
            $cpuPercentage = ($endCPU - $startCPU) * 100

            if ($cpuPercentage -gt $cpuThreshold) {
                Write-Host "$process is using $cpuPercentage% CPU - Above Threshold" -ForegroundColor Red
            }
            else {
                Write-Host "$process is using $cpuPercentage% CPU" -ForegroundColor Green
            }

        }
        else {
            Write-Host "$process is not running" -ForegroundColor Yellow
        }
    }
    Start-Sleep -Seconds $checkInterval
} while ($true)
