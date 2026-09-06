Write-Host "Simple Network Troubleshooter"
Write-Host "1. Check Internet Connection"
Write-Host "2. View IP Configuration"
Write-Host "3. Flush DNS"
Write-Host "4. Port Scan"
Write-Host "5. Exit"

$choice = Read-Host "Enter your choice"

switch ($choice) {
    1 {
        Write-Host "Checking Internet Connection..."
        $testREsult = Test-Connection -ComputerName baidu.com -Count 1 -Quiet
        if ($testREsult -eq "True") {
            Write-Host "Internet connection is working."
        }
        else {
            Write-Host "Unable to connect to the internet. Please check your network settings."
        }
    }
    2 {
        Write-Host "Viewing IP Configuration..."
        $ipAddress = (Get-NetIPConfiguration).IPv4Address.IPAddress
        $defaultGateway = (Get-NetIPConfiguration).IPv4DefaultGateway.NextHop
        Write-Host "IP Address: $ipAddress"
        Write-Host "Default Gateway: $defaultGateway"
    }
    3 {
        Clear-DnsClientCache
        Write-Host "DNS cache has been flushed."

    }
    4 {
        Write-Host "Performing Port Scan..."
        $ip = Read-Host "Enter the IP address to scan"
        $port = Read-Host "Enter the port number to scan"
        Test-Connection -ComputerName $ip -Port $port
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