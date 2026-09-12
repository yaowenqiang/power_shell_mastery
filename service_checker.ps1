function Check-ServiceStatus {
    param($serviceName)
    $service = Get-Service -Name $serviceName
    if ($service.Status -eq "Stopped") {
        return $false
    }
    else {
        return $true
    }
}

if (Check-ServiceStatus -serviceName "wuauserv") {
    Write-Host "Windows Update Service is running."
}
else {
    Write-Host "Windows Update Service is stopped,Attempting to start ..."
    Start-Service -Name "wuauserv"
}
if (Check-ServiceStatus -serviceName "windefend") {
    Write-Host "Windows Defender Service is running, Attempting to stop ..."
    #Stop-Service -Name "windefend"
}
else {
    Write-Host "Windows Defender Service is stopped."
}