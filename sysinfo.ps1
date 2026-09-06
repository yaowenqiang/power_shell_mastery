Write-Host "What System Information would you like to see"
Write-Host "1. Operating System"
Write-Host "2. CPU"
Write-Host "3. Memory"
Write-Host "4. Current User"

$choice = Read-Host "Enter your choice (1-4)"

switch ($choice) {
    1 {
        if ($IsMacOS) {
            Write-Host "Operating System: $(sw_vers -productName)"
            Write-Host "Version: $(sw_vers -productVersion)"
        }
        elseif ($IsLinux) {
            $osRelease = Get-Content /etc/os-release | Where-Object { $_ -like 'PRETTY_NAME=*' }
            Write-Host "Operating System: $($osRelease -replace 'PRETTY_NAME=|\"', '')"
        }
        else {
            $os = Get-CimInstance -ClassName Win32_OperatingSystem
            Write-Host "Operating System: $($os.Caption)"
            Write-Host "Version: $($os.Version)"
        }
    }
    2 {
        if ($IsMacOS) {
            Write-Host "CPU: $(sysctl -n machdep.cpu.brand_string)"
            Write-Host "Cores: $(sysctl -n hw.physicalcpu) physical / $(sysctl -n hw.ncpu) logical"
        }
        elseif ($IsLinux) {
            $modelName = (Get-Content /proc/cpuinfo | Where-Object { $_ -like 'model name*' } |
                Select-Object -First 1) -replace '^model name\s*:\s*', ''
            $cores = (Get-Content /proc/cpuinfo | Where-Object { $_ -like 'processor*' }).Count
            Write-Host "CPU: $modelName"
            Write-Host "Cores: $cores"
        }
        else {
            $cpu = Get-CimInstance -ClassName Win32_Processor
            Write-Host "CPU: $($cpu.Name)"
            Write-Host "Cores: $($cpu.NumberOfCores)"
            Write-Host "Speed: $($cpu.MaxClockSpeed / 1000) GHz"
        }
    }
    3 {
        if ($IsMacOS) {
            $memoryBytes = [long](sysctl -n hw.memsize)
        }
        elseif ($IsLinux) {
            $memLine = Get-Content /proc/meminfo | Where-Object { $_ -like 'MemTotal*' }
            $memoryBytes = [long]($memLine -replace '\D', '') * 1KB
        }
        else {
            $memoryBytes = (Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory
        }
        $totalMemoryGB = [math]::Round($memoryBytes / 1GB, 2)
        Write-Host "Total Physical Memory: $totalMemoryGB GB"
    }
    4 {
        # works on Windows, macOS and Linux
        Write-Host "Current User: $([System.Environment]::UserName)"
    }
    default {
        Write-Host "Invalid choice"
    }
}
