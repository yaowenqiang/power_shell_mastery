$services = @(
    @("wuauserv", "Windows Update", "TryStart", "Critical: Windows Update Service is vital for receiving updates."),
    @("Windefend", "Windows Defender", "TryStart", "Critical: Windows Defender provides essential protection"),
    @("spooler", "Print Spooler", "AlertOnly", "Non-critical: Print Spooler is for printing services"),
    @("BITS", "Background Intelligent Transfer Services", "Ignore", "Non-critical: BITS handles background file transfers")
)

foreach ($service in $services) {
    $serviceName = $service[0]
    $serviceDisplayName = $service[1]
    $serviceAction = $service[2]
    $serviceDescription = $service[3]

    $serviceStatus = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
    if ($serviceStatus -eq $null) {
        Write-Host "Service $serviceName not found."
        continue
    }

    $serviceState = $serviceStatus.Status
    if ($serviceState -eq "Running") {
        Write-Host "Service $serviceName is running."

    }
    elseif ($serviceState -eq "Stopped") {
        Write-Host "`n$serviceDisplayName ($ServiceName) is stopped, Action: $serviceAction`n"
        if ($serviceAction -eq "TryStart") {
            Write-Host "Attempting to start $serviceName..."
            Start-Service -Name $serviceName
            Write-Host "Service $serviceName has been started."
        }
        elseif ($serviceAction -eq "AlertOnly") {
            Write-Host "`nAlert: $serviceName ($ServiceDisplayName) is not running, but no action will be taken based on policy."
        }
        else {
            Write-Host "`nNo action will be taken for $serviceName($serviceDisplayName)`n"
        }
    }
}