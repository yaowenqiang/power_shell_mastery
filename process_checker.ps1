function check_process_status {
    param (
        $processName
    )
    $process = Get-Process -Name $processName -ErrorAction SilentlyContinue
    if ($process) {
        Write-Host "Process $processName is already running."
    }
    else {
        Write-Host "Process $processName is not running, 
        Attempting to start ..."
        Start-Process $processName
        Start-Sleep -Seconds 2

        if (Get-Process -Name $processName -ErrorAction SilentlyContinue) {
            Write-Host "Process $processName started successfully."
        }
        else {
            Write-Host "Failed to start process $processName."
        }
    }
}

check_process_status -processName "notepad"

check_process_status -processName "calc"

