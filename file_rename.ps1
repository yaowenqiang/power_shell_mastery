Write-Host "Welcome to the file Renamer!"

$fileName = Read-Host "Enter the name of the file you want to rename (including extension)"

if (Test-Path $fileName) {
    Write-Host "File found! Preparing to rename..."
    $fileInfo = Get-Item $fileName

    # $newFileName = $fileInfo.BaseName + "_" + $(Get-Date -Format "yyyyMMdd") + $fileInfo.Extension

    $newFileName = "$($fileInfo.BaseName)_$(Get-Date -Format "yyyyMMdd")$($fileInfo.Extension)"

    Rename-Item $fileName $newFileName
    Write-Host "File successfully renamed from $($fileInfo.Name) to $newFileName"
}
else {
    Write-Host "Error! the file $fileName does not exist in the current directory."
    exit
}