New-Item -Path "c:\windows\system32\new_file.txt" -ItemType File
$file = New-Item -Path "Desktop\locked_file.txt" -ItemType File
$stream = $file.OpenWrite()
Remove-Item -Path $file.FullName -Force
$stream.Close()

Get-Content Non-Exists.txt

Invoke-WebRequest -Uri "http://www.non-exist-website12343.com"

UndefinedVariable.SomeMethod()

Get-Process -Name "ThisProcessDoesNOtExist"


[int]"Not a Number"
