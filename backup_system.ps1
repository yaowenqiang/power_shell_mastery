New-Item -Path "C:\users\YourName\Desktop\Backup" -ItemType Directory
New-Item -Path "C:\users\YourName\Desktop\Backup\File1.txt" -ItemType File -Value "This is File 1"
New-Item -Path "C:\users\YourName\Desktop\Backup\File2.txt" -ItemType File -Value "This is File 2"
New-Item -Path "C:\users\YourName\Desktop\Backup\File3.txt" -ItemType File -Value "This is File 3"

New-Item -Path "C:\users\YourName\Desktop\Backup\File3.txt" -ItemType File -Value "This is File 3"

New-Item -Path Path1, Path2,path3 -ItemType File -Value value1,value2,value3

Get-ChildItem -Path "C:\users\YourName\Desktop\Backup\"

