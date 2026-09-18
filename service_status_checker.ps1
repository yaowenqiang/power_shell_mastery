param (
    [string]$status = "all"
)

$services = Get-Service

$runningServices = 0

$stoppedServices = 0

foreach ($service in $services) {
    # count every service first, independent of the display filter
    if ($service.Status -eq "Running") {
        $runningServices++
    }
    elseif ($service.Status -eq "Stopped") {
        $stoppedServices++
    }

    if ($status -eq 'all' -or $service.Status -eq $status) {
        Write-Host "Service Name: $($service.Name), Status: $($service.Status)"
    }
}

Write-Host "Total Running services: $runningServices"
Write-Host "Total Stopped services: $stoppedServices"