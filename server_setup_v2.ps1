$appName = Read-Host "Enter the application name"
$customMessage = Read-Host "Enter a custom message for the configuration file"

$timestemp = Get-Date -format "yyyy-MM-dd HH-mm-ss"

$appDataDir = "${appName}_data"


New-Item -Path $appDataDir -ItemType Directory -Force

New-Item -Path "$appDataDir/config.txt" -ItemType File -Force

Add-Content -Path "$appDataDir/config.txt" -Value "Configuration for $appName `ncustomem message: $customMessage `nCreated on: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"

Get-ChildItem -Path $appDataDir
Get-Content -Path "$appDataDir/config.txt"

