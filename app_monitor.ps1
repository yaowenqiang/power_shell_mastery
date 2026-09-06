$process_name = read-host "Enter the process name to monitor"

$process = Get-Process -Name $process_name -ErrorAction SilentlyContinue

if (-not $process) {
    Write-Host "Process '$process_name' not found."
    exit
}
elseif ($process.Responding) {
    Write-Host "Process '$process_name' is working correctly."
}
else {
    Write-Host "Process '$process_name' is not responding."
    $process.Kill()
}
