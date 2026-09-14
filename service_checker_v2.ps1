function checkServiceStatus {
    param ( $serviceName)
    $service_status = (Get-Service -Name $serviceName).status

    if ($service_status -eq "stopped") {
        return $false
    }
    else {
        return $true
    }
    
}

$services = @("wuauserv", "winDefend", "Spooler", "BITS")

Write-Host $services[0]
$services[0] = "w32time"

$services = $services[0..2]

write-host $services

foreach ($service in $services) {
    if (checkServiceStatus $service) {
        Write-Host "$service is running"
    }
    else {
        Write-Host "$service is stopped, Attempting to start..."
        Start-Service -Name $service
        Write-Host "$service started"
    }
}