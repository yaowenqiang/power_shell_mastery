function Check-ServiceStatus {
    param($serviceName)
    $service = Get-Service -Name $serviceName
    if ($service.Status -eq "Stopped") {
        Write-Host "Windows Update Service is stopped, Attempting to start..."
        Start-Service -Name $serviceName
    }
    else {
        Write-Host "$serviceName service is running, No action needed."
    }
    
}

Check-ServiceStatus -serviceName "wuauserv"
Check-ServiceStatus -serviceName "windefend"