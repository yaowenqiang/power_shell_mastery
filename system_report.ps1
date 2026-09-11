# works on all platforms ($env:COMPUTERNAME is Windows-only)
$computerName = [System.Environment]::MachineName

# --- OS info ---
if ($IsMacOS) {
    $osName = sw_vers -productName
    $osVersion = sw_vers -productVersion
}
elseif ($IsLinux) {
    $osName = (Get-Content /etc/os-release | Where-Object { $_ -like 'PRETTY_NAME=*' }) -replace 'PRETTY_NAME=|\"', ''
    $osVersion = (Get-Content /etc/os-release | Where-Object { $_ -like 'VERSION_ID=*' }) -replace 'VERSION_ID=|\"', ''
}
else {
    $osInfo = Get-CimInstance Win32_OperatingSystem
    $osName = $osInfo.Caption
    $osVersion = $osInfo.Version
}

# --- CPU usage ---
if ($IsMacOS) {
    # top reports how much was idle, usage is the rest
    $topLine = (top -l 1 | Select-String 'CPU usage').ToString()
    $idle = [double]([regex]::Match($topLine, '(\d+\.?\d*)% idle').Groups[1].Value)
    $cpu = [math]::Round(100 - $idle, 1)
}
elseif ($IsLinux) {
    $topLine = (top -bn1 | Select-String 'Cpu').ToString()
    $idle = [double]([regex]::Match($topLine, '(\d+\.?\d*)\s*id').Groups[1].Value)
    $cpu = [math]::Round(100 - $idle, 1)
}
else {
    $cpu = (Get-CimInstance Win32_Processor).LoadPercentage
}

# --- Memory (physical, KB -> GB means / 1MB) ---
if ($IsMacOS) {
    # hw.memsize is bytes, / 1GB converts to GB
    $totalMemory = [long](sysctl -n hw.memsize) / 1GB
    # vm_stat reports free memory in pages, page size varies (16KB on Apple Silicon)
    $vmStat = vm_stat
    $pageSize = [long]([regex]::Match($vmStat[0], 'page size of (\d+) bytes').Groups[1].Value)
    $freePages = [long]((([regex]::Match(($vmStat | Select-String 'Pages free'), '([\d,]+)').Groups[1].Value)) -replace ',', '')
    $freeMemory = $freePages * $pageSize / 1GB
}
elseif ($IsLinux) {
    $totalMemory = [long]((Get-Content /proc/meminfo | Where-Object { $_ -like 'MemTotal*' }) -replace '\D', '') / 1MB
    $freeMemory = [long]((Get-Content /proc/meminfo | Where-Object { $_ -like 'MemAvailable*' }) -replace '\D', '') / 1MB
}
else {
    # TotalVisibleMemorySize (physical) instead of TotalVirtualMemorySize so the % math is consistent
    $osInfo = Get-CimInstance Win32_OperatingSystem
    $totalMemory = $osInfo.TotalVisibleMemorySize / 1MB
    $freeMemory = $osInfo.FreePhysicalMemory / 1MB
}

# --- Disk (Get-PSDrive works everywhere, only the drive name differs) ---
if ($IsWindows) {
    $drive = Get-PSDrive C
    $diskLabel = "Disk C:"
}
else {
    $drive = Get-PSDrive /
    $diskLabel = "Disk /"
}
$totalSpace = ($drive.Used + $drive.Free) / 1GB
$freeSpace = $drive.Free / 1GB

$report = "System Health Report `n"
$report += "---------------------`n"
$report += "Generated On {0:yyyy-MM-dd HH:mm:ss} `n`n" -f (Get-Date)
$report += "Computer Name: {0} `n" -f $computerName
$report += "OS Name: {0} `n" -f $osName
$report += "OS Version: {0} `n" -f $osVersion
$report += "CPU Usage: {0}% `n" -f $cpu
$report += "Memory: {0:N2} GB free of {1:N2} GB `n" -f $freeMemory, $totalMemory
$report += "$diskLabel {0:N2} GB free of {1:N2} GB `n" -f $freeSpace, $totalSpace

$memoryUsagePercent = 100 - (($freeMemory / $totalMemory) * 100)

$diskUsagePercent = 100 - (($freeSpace / $totalSpace) * 100)

$report += "`nUsage Percentages:`n"
$report += "Memory: {0:N2}% `n" -f $memoryUsagePercent
$report += "$diskLabel {0:N2}% `n" -f $diskUsagePercent

Write-Host $report

$reportPath = if ($IsWindows) { "C:\SystemReport.txt" } else { Join-Path $HOME "SystemReport.txt" }
$report | Out-File -FilePath $reportPath -Encoding UTF8

Write-Host "Report generated at $reportPath"

# https://ss64.com/ps/syntax-f-operator.html
