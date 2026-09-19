for ($i = 1; $i -le 10; $i++) {
    write-Host "$i"
}

$server = "www.google.com"

$maxAttempts = 5

$successfulPing = $false

for ($i = 1; $i -le $maxAttempts; $i++) {
    $timeout = $i * 1
    Write-Host "attempt $attempt with timout $timeout s"
    $result = Test-Connection -ComputerName $server -Count 1 -Quiet -TimeoutSeconds $timeout -ErrorAction SilentlyContinue
    if ($result) {
        $successfulPing = $true
        Write-Host "Success! $($i.latency) ms" -ForegroundColor Green
        break
    }
    else {
        Write-Host "Failed, Increasing timeouts and retrying..." -ForegroundColor yellow
    }
}

if (-Not $successfulPing) {
    Write-Host "All Attempts failed: unable to reach $server." -ForegroundColor Red
}
else {
    Write-Host "Connection successful"
}