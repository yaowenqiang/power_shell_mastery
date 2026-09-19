$serviceName = "spooler" 

$maxAttempts = 5
$serviceStarted = $false

for ($i = 1; $i -le $maxAttempts; $i++) {
    $service = Get-Service -Name $serviceName
    if ($service.Status -eq "Running") {
        Write-Host "Service $serviceName is already running." -ForegroundColor Green
        $serviceStarted = $true
        break
    }
    elseif ($service.Status -eq "Stopped") {
        Write-Host "Attempt $i: Trying to start service $serviceName..."
        Start-Service -Name $serviceName
        Start-Sleep -Seconds 5
        $service = Get-Service -Name $serviceName
        if ($service.Status -eq "Running") {
            Write-Host "Success! Service $serviceName started on attempt $i." -ForegroundColor Green
            $serviceStarted = $true
            break
        }
        else {
            Write-Host "Attempt $i failed,Service $serviceName is still stopped." -ForegroundColor Yellow
            Start-Sleep -Seconds 5
        }
    }
    if ($i -lt $maxAttempts) {
        $waitTime = $i * 10
        Write-Host "Waiting $waitTime seconds before next attempt..." -ForegroundColor Yellow
        Start-Sleep -Seconds $waitTime
    }
}

if (-not $serviceStarted) {
    Write-Host "Failed to start service $serviceName after $maxAttempts attempts."  -ForegroundColor Red
}