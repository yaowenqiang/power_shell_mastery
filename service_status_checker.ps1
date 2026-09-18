param (
    [string]$status = "all"
)

$service = Get-Service

$runningServices = 0

$stoppedServices = 0

foreach ($service in $service) {
    if ($status -eq 'all' -or $service.Status -eq $service) {
        Write-Host "Service Name: $($service.Name), Status: $($service.Status)"
        $runningServices++
    }
    elseif ($service.Status -eq "Stopped") {
        $stoppedServices++
    }
}

Write-Host "Total Running services: $runningServices"
Write-Host "Total Stopped services: $stoppedServices"