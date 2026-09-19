param(
    [string]$SearchProcess
)

$memoryHungryProcesses = [System.Collections.ArrayList]::new()

# Get all processes
$processes = Get-Process

# Iterate through each process
foreach ($process in $processes) {
    # Check if the process is memory hungry
    if ($process.WorkingSet / 1MB -gt 100) {
        # Add the process to the list of memory hungry processes
        [void]$memoryHungryProcesses.Add($process)
    }
}
if ($SearchProcess) {
    Write-Output "`nSearching for process: $SearchProcess   "
    $found = $false
    foreach ($process in $sortedProcesses) {
        if ($process.Name -eq $SearchProcess) {
            $memoryUsageMB = [math]::Round($process.WorkingSet / 1MB, 2)
            Write-Output "$($process.Name) is using  $($memoryUsageMB) MB of memory"
            $found = $true
            exit
        }
    }
    if (-not $found) {
        Write-Output "$SearchProcess is not in the list of memory intensive processes"
        exit
    }

}

Write-Output "Memory Intensive Processes Report"
Write-Output "---------------------------------"
Write-Output "Total Memory Intensive Processes: $($memoryHungryProcesses.Count)"

$sortedProcesses = $memoryHungryProcesses | Sort-Object -Property WorkingSet -Descending
# Iterate through each memory hungry process
foreach ($process in $sortedProcesses) {
    $memoryUsageMB = [math]::Round($process.WorkingSet / 1MB, 2)
    Write-Output "$($process.Name) is using  $($memoryUsageMB) MB of memory"
}

$totalMemoryUsage = ($memoryHungryProcesses | Measure-Object -Property WorkingSet -Sum).Sum / 1GB
$totalMemoryUsage = [math]::Round($totalMemoryUsage, 2)

Write-Output "`nTotal Memory Usage of Intensive Processes: $($totalMemoryUsage) GB"
Write-Output "---------------------------------"
Write-Output "---------------------------------"