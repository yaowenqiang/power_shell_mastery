$processes = @('notepad', 'calc')

$checkInterval = 5

$cpuThreshold = 10

do {
    foreach ($process in $processes) {
        $processInfo = Get-Process -Name $process -ErrorAction SilentlyContinue
        if ($processInfo) {
            $startCPU = (Get-Process -Name $processName | Measure-Object -Property CPU -Sum).Sum
            
            Start-Sleep -Seconds 1
            $endCPU = (Get-Process -Name $processName | Measure-Object -Property CPU -Sum).Sum

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
} while ($true)
