# 1, Crate a new directory named "MyAwsomeAppData"
New-Item MyAwsomeAppData -ItemType directory
New-Item -path MyAwsomeAppData/config.txt -ItemType "File"
Add-Content -Path "MyAwsomeAppData/config.txt" -Value "Hello, This is a configuration file"

Get-ChildItem MyAwsomeAppData
Get-Content "MyAwsomeAppData/config.txt"

