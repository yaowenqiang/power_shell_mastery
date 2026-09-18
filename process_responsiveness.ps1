$unresponsiveProcesses = [System.Collections.ArrayList]::new()



foreach ($process in Get-Process) {
    if (!$process.Responding) {
        [void]$unresponsiveProcesses.Add($process)
    }
}

if ($unresponsiveProcesses.Count -gt 0) {
    Write-Host "Found $($unresponsiveProcesses.Count) unresponsive processes:"
    foreach ($process in $unresponsiveProcesses) {
        Write-Host "Attempting to close and restart: $($process.Name)"
        # $process.CloseMainWindow()
        # $process.WaitForExit()
        # Start-Process $process.Name
    }
}
else {
    Write-Host "All processes are responding. All clear!"
}

# $unresponsiveProcesses.Remove($unresponsiveProcesses[0])
# $unresponsiveProcesses.Insert(0, $someProcess)
# $unresponsiveProcesses.Clear()