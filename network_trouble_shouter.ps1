Write-Host "Simple Network Troubleshooter"
Write-Host "1. Check Internet Connection"
Write-Host "2. View IP Configuration"
Write-Host "3. Flush DNS"
Write-Host "4. Port Scan"
Write-Host "5. Exit"

$choice = Read-Host "Enter your choice (1-5)"

switch ($choice) {
    1 {
        Write-Host "Checking Internet Connection..."
        # -TargetName + -Quiet work on all platforms (pwsh 6+)
        $testResult = Test-Connection -TargetName baidu.com -Count 1 -Quiet
        if ($testResult) {
            Write-Host "Internet connection is working."
        }
        else {
            Write-Host "Unable to connect to the internet. Please check your network settings."
        }
    }
    2 {
        Write-Host "Viewing IP Configuration..."
        if ($IsMacOS) {
            # find the interface used by the default route, then ask for its IP
            $routeInfo = route -n get default
            $interface = [regex]::Match($routeInfo, 'interface:\s+(\S+)').Groups[1].Value
            $ipAddress = ipconfig getifaddr $interface
            $defaultGateway = [regex]::Match($routeInfo, 'gateway:\s+(\S+)').Groups[1].Value
        }
        elseif ($IsLinux) {
            $ipAddress = (hostname -I).Trim().Split(' ')[0]
            $defaultGateway = [regex]::Match((ip route show default), 'via\s+(\S+)').Groups[1].Value
        }
        else {
            $netConfig = Get-NetIPConfiguration
            $ipAddress = $netConfig.IPv4Address.IPAddress
            $defaultGateway = $netConfig.IPv4DefaultGateway.NextHop
        }
        Write-Host "IP Address: $ipAddress"
        Write-Host "Default Gateway: $defaultGateway"
    }
    3 {
        if ($IsMacOS) {
            # macOS flushes DNS via the mDNSResponder daemon, requires admin password
            sudo dscacheutil -flushcache
            sudo killall -HUP mDNSResponder
        }
        elseif ($IsLinux) {
            resolvectl flush-caches 2>$null
            if ($LASTEXITCODE -ne 0) { systemd-resolve --flush-caches }
        }
        else {
            Clear-DnsClientCache
        }
        Write-Host "DNS cache has been flushed."
    }
    4 {
        Write-Host "Performing Port Scan..."
        $ip = Read-Host "Enter the IP address or host to scan"
        $port = Read-Host "Enter the port number to scan"
        if (Test-Connection -TargetName $ip -TcpPort $port -Quiet) {
            Write-Host "Port $port on $ip is open."
        }
        else {
            Write-Host "Port $port on $ip is closed or unreachable."
        }
    }
    5 {
        Write-Host "Exiting..."
        exit
    }
    default {
        Write-Host "Invalid choice. Please try again."
    }
}

$filename = "document.docs"

switch -Wildcard ($filename) {
    "*.docx" { Write-Host "This is a Word document." }
    "*.xlsx" { Write-Host "This is an Excel document." }
    "*.pptx" { Write-Host "This is a PowerPoint document." }
    "*.txt" { Write-Host "This is a text file." }
    "*.pdf" { Write-Host "This is a PDF file." }
    "*.jpg" { Write-Host "This is a JPEG image." }
    "*.png" { Write-Host "This is a PNG image." }
    "*.gif" { Write-Host "This is a GIF image." }
    default { Write-Host "Unknown file type." }
}
