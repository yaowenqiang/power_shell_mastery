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

function Check_Service_Status {
    # param(
    #     [Parameter(Position = 0, Mandatory = $true)]
    #     $serviceName, 
    #     [Parameter(Position = 1, Mandatory = $true)]
    #     $action
    # )
    param(
        [Parameter(Position = 0, Mandatory = $true)]
        [string]$serviceName, 

        [Parameter(Position = 1)]
        [ValidateSet('start', 'stop', "None")]
        [string]$action = "None"
    )
    $service = Get-Service -Name $serviceName
    if ($service.Status -eq "Stopped") {
        write-host "Service $serviceName is not running."
        if ($action -eq "start") {
            Write-Host "Starting $serviceName service..."
            Start-Service -Name $serviceName
        }
    }
    else {
        write-host "Service $serviceName is current running."
        if ($action -eq "stop") {
            Write-Host "Stopping $serviceName service..."
            Stop-Service -Name $serviceName
        }
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

# Check_Service_Status -serviceName "wuauserv" -action "start"
# Check_Service_Status -serviceName "windefend" -action "stop"

# Check_Service_Status "wuauserv" "start"
# Check_Service_Status "windefend" "stop"

Check_Service_Status "wuauserv" -action "start"
Check_Service_Status "windefend" "stop"
Check_Service_Status "spooler" "start"