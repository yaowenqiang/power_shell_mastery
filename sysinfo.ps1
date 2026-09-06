Write-Host "What System Information whould you like to see"
Write-Host "1. Operation system"
Write-Host "2. CPU"
Write-Host "3. Memory"
Write-Host "4. Current User"

$choice = Read-Host "Enter your choice (1-5)"

switch ($choice) {
    1 {
        $os = Get-CimInstance -ClassName Win32_OperatingSystem 
        $os_name = $os.Caption
        $os_version = $os.Version
        Write-Host "Operating System: $os_name"
        Write-Host "Version: $os_version"
    }
    2 {
        $cpu = Get-CimInstance -ClassName Win32_Processor
        $cpu_name = $cpu.Name
        $cpu_cores = $cpu.NumberOfCores
        $cpu_speed = $cpu.MaxClockSpeed
        Write-Host "CPU: $cpu_name"
        Write-Host "Cores: $cpu_cores"
        Write-Host "Speed: $($cpu_speed / 1000) GHz"
    }
    3 {
        $totalMemroyGB = [math]::Round((Get-CimInstance Win32_computerSystem).totalPhysicalMemory / 1GB, 2)
        write-host "Total Physical Memory: $totalMemroyGB GB"
    }
    4 {
        $currentUser = $Env:USERNAME
        Write-Host "Current User: $currentUser"
    }
    default {
        Write-Host "Invalid choice"
    }
}   