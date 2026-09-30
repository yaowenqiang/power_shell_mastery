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

> New-Item -ItemType SymbolicLink -Path ./e -Target a

> no change SymbolicLink method directly, you should remove the old one and create the new one

> if the target was renamed or deleted,the symlink will broken

> 在 Linux 系统中，符号链接（symlink）的嵌套层数是40

> 在 Windows 上，这个限制通常是 63 层

> new-item -path originalfile.txt -ItemType file -value "this is original file"

> new-item -path hardlink.txt -ItemType HardLink   -Target ./originalfile.txt

> get-content file1,file2

> get-content filename -TotalCount 3

> get-content filename -Tail 3

> set-content filepath -value "hello,newcontent"

> add-content filepath -value "hello,newcontent"

> get-date -format 'yyyy-MM-dd'

> add-content a -value "hi, $(Get-Date -Format 'yyyy-MM-dd')"

> Move-Item -path a  -Destination aaa

> copy-Item -path aaa  -Destination aaaa

> copy-Item aaa aaaa

> Rename-Item -Path ./aaa  -NewName bb

> Rename-Item bb cc

> Remove-Item -Path aaaa

> Remove-Item d

> Remove-Item d  -recurse

> Remove-Item d  -force

> 1..100000 | ForEach-Object {"this is line $_ of a large , compressible file. It contains repetitive text to ensure good compression."} | out-file -FilePath big_file.txt

> Compress-Archive -Path ./big_file.txt -DestinationPath smaller_file.zip

> Compress-Archive -Path file1,file2,file3 -DestinationPath smaller_file.zip

> Compress-Archive -Path file1,file2,file3 -DestinationPath smaller_file.zip -Update

> expand-Archive -Path smaller_file.zip

> expand-Archive -Path smaller_file.zip  -destination new_path

> only support zip format

> get-process | get-member

> get-childitem ./hello | get-member

> (get-childitem ./hello).lastAccessTime

> (get-childitem ./hello).CreationTime

> stat -x filename # mac

> eza -l --icons NOTES.md

> (Get-Process).StartTime

> (Get-Process).cpu

> (Get-Process).WorkingSet(memory bytes)

> (Get-Process).workingset / 1024 / 1024 / 1024

> (Get-Process).workingset / 1MB

> (Get-ChildItem file).LastWriteTime = '01/01/2026'

> (Get-ChildItem hi).LastWriteTime = [datetime]"01/01/2026"

> (Get-ChildItem hi).LastWriteTime = [datetime]"2026-01-11"

> (Get-ChildItem hi).LastWriteTime = [datetime]::ParseExact("01/01/2025", "MM/dd/yyyy", $null)

> https://learn.microsoft.com/en-us/dotnet/api/system.datetime.parseexact?view=net-10.0

> (Get-ChildItem hi).CreationTime = [datetime]"01/01/2026"

> (Get-ChildItem hi).CreationTime = [datetime]::ParseExact("01/01/2026 09:30:00", "MM/dd/yyyy HH:mm:ss", $null)

> (get-process notepad).kill()

> (get-childItem hi).CopyTo('/hello')

> (get-childItem hi).Delete()

> (get-childItem hi)| Get-Member -MemberType method

> stop-process -name notepad

> get-process -name notepad | stop-process

> Get-ChildItem | Measure-Object

> Get-ChildItem | Measure-Object -Property Length -sum

> Get-ChildItem | Measure-Object -Property Length -Average -Maximum -Minimum

> Get-Process | Sort-Object cpu -Descending

> Get-Process | Sort-Object CPU -Descending | Select-Object -first 5

> Get-Process | Sort-Object WorkingSet -Descending

> Get-Process | Sort-Object StartTime -Descending | Select-Object -first 5 Name,CPU, StartTime

> Get-Process | Format-Table Name,Id,cpu

> Get-Process | Format-list

> get-process | Format-Wide

> get-process | Format-Wide -column 2

> get-service | Format-Wide name, status, starttype

> get-process chrome | format-list *

> get-childitem | format-wide name -column 3

> get-process | sort-object cpu -Descending | Select-Object -first 5 | format-table name, id,cpu

> always put your formatting commandlets at the end of your pipeline

> get-service | sort-object status | Select-Object -first 10 | format-list name,status,starttype

> get-service | sort-object status | Select-Object -first 10 | format-list name,status,starttype

> get-service | sort-object status | Select-Object -first 10 | format-table name,status,starttype

> get-service | sort-object status | Select-Object -first 10 | format-table name,status,starttype -autosize

> get-process | sort-object cpu -Descending | Select-Object -first 10 | out-gridview

> get-process | sort-object cpu -Descending | Select-Object -first 10 | out-file process.txt

> get-process | Tee-object -Filepath "process.txt" | out-gridview

> get-service | sort-object status | select-object -first 10 | Tee-object -Filepath "service.txt" | out-gridview

> get-process | sort-object WorkingSet -Descending | select-object -first 20 | ConvertTo-html

> Get-ChildItem | Group-Object Extension

> Get-ChildItem | Group-Object Extension | sort-object name

> get-process | Measure-Object WorkingSet -sum -Average -Maximum -Minimum

> get-process | Measure-Object WorkingSet -sum -Average -Maximum -Minimum

> get-process | Group-Object ProcessName | Measure-Object Count -Average

> Get-ChildItem desktop -File -Recurse  | Measure-Object length -sum -Average -Maximum -Minimum

> Get-ChildItem  -File -Recurse  | Measure-Object length -sum -Average -Maximum -Minimum | Select-Object Count, @{Name="Sum(MB)";Expression={[math]::Round($_.sum / 1MB, 2)}}

> Get-ChildItem desktop -File -Recurse  | Measure-Object length -sum -Average -Maximum -Minimum | Select-Object Count, @{Name="Sum (MB)";Expression={[math]::Round($_.sum / 1MB, 2)}}, @{Name="Average (MB)";Expression={[math]::Round($_.Average / 1MB, 2)}}

> Get-ChildItem  -File -Recurse  | Measure-Object length -sum -Average -Maximum -Minimum | Select-Object Count, @{Name="Sum(MB)";Expression={[math]::Round($_.sum / 1MB, 2)}},@{Name="`Average (MB)";Expression={[math]::Round($_.Average / 1MB, 2)}},@{Name="`Maximum(MB)";Expression={[math]::Round($_.Maximum / 1MB, 2)}}, @{Name="`Minimum(MB)";Expression={[math]::Round($_.Minimum / 1MB, 2)}}

> get-childitem Desktop -File -Recurse | Group-Object Extension | select-object name, Count | Sort-Object count -Descending

> get-childitem / -File -Recurse | Group-Object Extension | select-object name, Count, @{name="TotalSize(MB)";Expression={($_.Group | Measure-Object Length -sum).Sum / 1MB -as [int]}}

> get-childitem / -File -Recurse | Group-Object Extension | select-object name, Count, @{name="TotalSize(MB)";Expression={($_.Group | Measure-Object Length -sum).Sum / 1MB -as [int]}} | Sort-Object "TotalSize(MB)"

> pwsh hello.ps1

> $PSVersionTable

> $PWD

> $HOME

```ps1
    $server = "192.168.1.1"
    Test-Connection -ComputerName $server -Count 1
    Invoke-Command -ComputerName $server -ScriptBlock {Get-Process}
    Restart-Computer -ComputerName $server  -Force
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    #$myfile = "Desktop\myawesomefile.txt"
    $myfile = "Desktop\myawesomefile_$timestamp.txt"
    new-item -Path $myfile -ItemType File
    add-content -Path $myfile -Value "PowerShell, so cool `nVariables make life easy `nScripting is my jam"
```

```ps1
$appName = Read-Host "Enter the name of the application"
#$appName = "myAwesomeApp"
$appDataDir = "${appName}_Data"

New-item $appDataDir -ItemType "Directory"

New-Item -Path "$appDataDir\config.txt" -ItemType "File"

Add-Content -Path "$appDataDir\config.txt" -Value "Hello, this is a configuration file for the $appName app."

Get-ChildItem $appDataDir

Get-Content -Path "$appDataDir\config.txt"
```

```ps1

($Error[0]).Exception.GetType().Fullname
($Error[0]).Exception.Message

($Error[0]).InvocationInfo | Get-Member
$Error[0].InvocationInfo
$Error[0].CategoryInfo
$Error[0].Exception
$Error[0].Exception.Message
$Error[0].Exception.GetType().FullName
$Error[0].Exception.StackTrace
$Error[0].Exception.TargetSite
$Error[0].Exception.Source
$Error[0].Exception.Data
$Error[0].Exception.HelpLink
$Error[0].Exception.HResult
$Error[0].Exception.InnerException
$Error[0].Exception.Data
$Error[0].Exception.Data.Keys
$Error[0].Exception.Data.Values
$Error[0].Exception.Data.Count


```

> $error[0].Exception.InnerException.getType().FullName


> Get-Process | Foreach-Object { $PSItem.name }

> Get-Process | Foreach-Object { $_.name }

> "wuauserv", "winDefend" ,"spooler" , "BITS" | ForEach-Object { Restart-Service -Name $_  -WhatIF }

> Get-ChildItem Desktop -Recurse -File | ForEach-Object { $_.IsReadOnly = $true}

> Get-ChildItem Desktop -Recurse -File  -Filter *.txt| ForEach-Object { $_.IsReadOnly = $true}

> Get-ChildItem Desktop\*.txt| ForEach-Object { $_.LastWriteTime = (Get-Date)}

> Get-ChildItem Desktop\*.txt| ForEach-Object { $_.LastWriteTime = (Get-Date "2023-06-15 09:00:00")}

> Get-ChildItem Desktop\*.txt| ForEach-Object { $_.LastWriteTime = (Get-Date).AddDays(-7)}

> Get-ChildItem Desktop\*.txt | Select-Object Name, LastWriteTime

> Get-Process | Where-Object { $_.CPU -gt 10000 }

> Get-ChildItem Desktop | Where-Object { $_.length -gt 1MB -and $_.Extension -eq ".txt" }


> Get-ChildItem -Path Desktop -Recurse | Where-Object {$_.LastWriteTime -lt (Get-Date).AddDays(-30)} | ForEach-Object {Remove-Item $_.FullName -WhatIf}

> Get-ChildItem -Path Desktop -Recurse | Where-Object {$_.LastWriteTime -gt (Get-Date).AddHours(-24)} | Select-Object name, LastWriteTime, Length

> Get-ChildItem -Path Desktop -Recurse | Where-Object {$_.LastWriteTime -gt (Get-Date).AddHours(-24) -and $_.length -gt 1MB} | Select-Object name, LastWriteTime, Length

> Get-ChildItem -File | Select-Object name, LastWriteTime,Length


> Get-ChildItem -File | Where-Object {$_.length -gt 1MB}

> "Desktop" | Get-Item

> "Desktop" | Get-Member

> Get-Help Get-ChildItem -Full

> Get-Process -Name notepad | Stop-Process -WhatIf

> Get-Process | Where-Object {$_.CPU -gt 10 }| Select-Object Name, ID | Sort-Object Name

> $users =  @([PSCustomObject]@{Name = "Jone Doe"; Description = "desc"}, [PSCustomObject]@{"Name"="aaa";"Description" = "desc"})

> $users | New-LocalUser -NoPassword -WhatIf

> $users | Get-Member

```ps1
$Services = @([PSCustomObject]@{Name = "Spooler",StartupType = "Automatic"},[PSCustomObject]@{Name = "WinRM", StartupType = "Automatic"}) | Set-Service -WhatIf

$Services = @([PSCustomObject]@{Name = "Spooler",StartupType = "Automatic", DisplayName="Print Spooler"},[PSCustomObject]@{Name = "WinRM", StartupType = "Automatic", DisplayName="Windows Remote Management (WS-Management)"}) | Set-Service -WhatIf
Get-Help Set-Service -Full

```

```ps1
1..5 | ForEach-Object -Begin {$sum=0} -Process {$sum +=  $_} -End {$sum}

 Get-Process | ForEach-Object -Begin {$total = 0} -Process {$total += $_.WorkingSet} -End {"Total Memory Usage: $($total /1MB) MB"}


Get-ChildItem ./Desktop/ | ForEach-Object -Begin {$totalSize = 0; $filecount=0} -Process {$totalSize += $_.Length;$fileCount++} -End {Write-Host ("Processed {0} files with a total size of {1:N2}  Megabytes." -f $fileCount, ($totalSize /1MB))}


Get-ChildItem -Path (Read-Host "Enter th directory path") -Filter (Read-Host "Enter a pattern to filter by (e.g., *.txt)") | ForEach-Object -Begin {$count=0} -Process {$count++} -End {Write-Host ("Number of $extension file count is {0}" -f $count)}


$filter = Read-Host "Enter a pattern to filter by (e.g., *.txt)"
$path   = Read-Host "Enter the directory path"

$count = (Get-ChildItem -Path $path -Filter $filter).Count
Write-Host ("Number of '$filter' files: $count")

```

```ps1
Get-ChildItem | Select-Object Name, @{Name="SizeMB";Expression={$_.length / 1MB}}

Get-ChildItem | Select-Object Name, @{Name="SizeMB";Expression={"{0:N2}" -f ($_.length / 1MB)}}


Get-Process | Select-Object Name,Id, @{Name="Age";Expression={(Get-Date) - $_.StartTime}}

Get-ChildItem | Select-Object Name, @{Name="DaysSinceModified";Expression={((Get-Date) - $_.LastWriteTime).Days}}

Get-ChildItem | Select-Object Name, @{Name="LastModified";Expression={$days = ((Get-Date) - $_.LastWriteTime).Days; if ($days -eq 0 ) { "Today" } elseif ($days -eq 1) { "Yesterday" } else { "$days days ago" } }}

Get-ChildItem | Select-Object Name, @{Name="LastModified";Expression={$days = ((Get-Date) - $_.LastWriteTime).Days; if ($days -eq 0 ) { "Today" } elseif ($days -eq 1) { "Yesterday" } else { "$days days ago" } }} | Sort-Object {$_.LastModified -replace "Today", "0" -replace "Yesterday", "1" -replace "Days ago", ""}

```
