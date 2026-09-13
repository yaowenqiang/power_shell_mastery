Write-Host "Welcome to the process checker!"

$runningCount = 0

$notRunningCount = 0

function check_process_status() {
    param(
        [Parameter(Mandatory = $true)]
        [string]$processName
    )

    $process = get-process -name $processName -ErrorAction SilentlyContinue

    if ($process) {
        $script:runningCount++
        return $true
    }
    else {
        $script:notRunningCount++
        return $false
    }
}

if (check_process_status("explorer")) {
    Write-Host "Windows Explorer is running." 
}
else {
    Write-Host "Windows Explorer is not running. This is unusual and may indicate a problem." 
}

if (check_process_status("Taskmgr")) {
    Write-Host "Task Manager is running." 
}
else {
    Write-Host "Task Manager Explorer is not running. This is is normal if it hasn't been started." 
}


if (check_process_status("SecurityHealthSystray")) {
    Write-Host "Windows Security is running." 
}
else {
    Write-Host "Windows Security does not appear to be running. This might be a security concern." 
}

if (check_process_status("SearchApp")) {
    Write-Host "Windows Search is running." 
}
else {
    Write-Host "Windows Search is not running. This might effect system search functionality." 
}


Write-Host "`nProcess Check Summary:"
Write-Host "total Processes checked: $($runningCount + $notRunningCount)"
Write-Host "Processes Running: $runningCount"
Write-Host "Processes Not Running: $notRunningCount"

$global:lastRunTime = Get-Date
Write-Host "This script was last run at $global:lastRunTime"

$local:localVariable = "I exists only withing the current scope(which in this case is the current script)"

