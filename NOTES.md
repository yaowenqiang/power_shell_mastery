> Get-Process | Sort-Object CPU -Descending | Select-Object -first 5


> Get-Host

> Get-Date

> Get-Command

> Set-Date

> Get-Service

> Get-Content

> Get-History (h)


## parameters

> Get-Process -name firefox

> Get-Process -name chrome -FileVersionInfo

> Get-Process -N chrome -FileVersionInfo

> Get-Process -Id 123 -FileVersionInfo

> Start-Process -FilePath c:\windows\System32\notepad.exe

> Test-Connection -ComputerName google.com

> Test-Connection -ComputerName google.com -Quiet

> Test-Connection -ComputerName google.com -count 1

> Stop-Process -Id 1234

> Stop-Process -Name msedge

> Remove-Item Env:http_proxy

> get-help get-process

> get-help get-help

> get-help -examples

> get-help -online

> get-help -detailed

> Update-Help -UICulture en-US

> get-connection -?

> get-command

> get-help get-random

> get-help get-random -examples

> get-help convert-string

> get-help convert-string -detailed

> get-help test-path
> get-help test-path -online

> get-help get-process -full

> get-alias
> get-command gcm

> set-alias tc test-connection

> remove-item alias:tc

> set-alias apps get-process

> set-alias test-net test-connection

> function explain { get-help @args -Full }

> Get-ChildItem

> set-location 

> push-location

> pop-location

> new-item -path desk/new_file.txt -itemType "file"

> new-item -path desk/new_file.txt 
> new-item hello` world

> new-item "hello world"

> New-Item -Path '.\test '' " file.txt' -ItemType File

> New-Item -Path "./test`n`t'`" file.txt" -ItemType File

> touch "./test`n`t'`" file.txt"

