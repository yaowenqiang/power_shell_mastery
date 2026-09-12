
param(
    [Parameter(Mandatory = $true)]
    [string]$process_name,
    [Parameter(Mandatory = $true)]
    [ValidateSet("Start", "Stop", "Restart", "Info")]
    [string]$action
)

switch ($action) {
    "Start" {
        if (Get-Process -Name $process_name) {
            Write-Host "Process $process_name is already running"
        }
        else {
            Start-Process $process_name
            Write-Host "Started process $process_name"
        }
    }
    "Stop" {
        if (Get-Process -Name $process_name) {
            Stop-Process -Name $process_name
            write-host "Stopped process $process_name"
        }
        else {
            write-host "process $process_name is not running."
        }
    }
    "Restart" {
        if (Get-Process -Name $process_name) {
            Stop-Process -Name $process_name
            Start-Process $process_name
            Write-Host "Restarted process $process_name"
        }
        else {
            Start-Process $process_name
            Write-Host "Process $process_name is not running, started it."
        }
    }
    "Info" {
        $process = Get-Process -Name $process_name
        if ($process) {
            Write-Host "Process Name: $($process.Name)"
            Write-Host "Process ID: $($process.Id)"
            Write-Host "CPU Usage: $($process.CPU)"
            Write-Host "Memory Usage: $($process.WorkingSet64) / 1Mb) MB"
        }
        else {
            Write-Host "Process $process_name is not running."
        }
    }
}