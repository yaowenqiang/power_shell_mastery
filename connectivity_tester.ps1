for ($i = 1; $i -le 10; $i++) {
    write-Host "$i"
}
$ErrorActionPreference = "ignore"
$server = "www.google.com"

$maxAttempts = 5

$successfulPing = $false

for ($i = 1; $i -le $maxAttempts; $i++) {
    $timeout = $i * 1
    Write-Host "attempt $i with timeout $timeout s"
    # no -Quiet here so we get the full response object with its Latency
    $response = Test-Connection -TargetName $server -Count 1 -TimeoutSeconds $timeout -ErrorAction SilentlyContinue
    if ($response -and $response.Status -eq "Success") {
        $successfulPing = $true
        Write-Host "Success! $([math]::Round($response.Latency)) ms" -ForegroundColor Green
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