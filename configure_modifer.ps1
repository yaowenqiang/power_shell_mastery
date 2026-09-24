$ErrorActionPreference = "Stop" # continue,slientContinue,inquire,stop,ignore

$configFile = "~/Desktop/configuration.txt"
$newContent = "This is a configuration file for the my_awsome_App app"

Write-Host "Backing up existing configuration..."
Copy-Item -Path $configFile -Destination "~/Desktop/configuration_backup.txt"

Write-Host "Modifying configuration file..."
Set-Content -Path $configFile -Value $newcontent

Write-Host "Done"


