Write-Host "Welcome to the Creation date file Renamer!"

$fileName = Read-Host "Enter the name of the file you want to rename (including extension)"

if (Test-Path $fileName) {
    $fileInfo = Get-Item $fileName
    $creationDate = $fileInfo.CreationTime
    Write-Host "File was created on : $($creationDate.ToString("dd/MM/yyyy"))"
    Write-Host "File was created on : $((Get-Date $creationDate -format "yyyy-MM-dd"))"


    $newFileName = "$($creationDate.ToString("yyyyMMdd"))_$($fileInfo.BaseName)$($fileInfo.Extension)"

    Rename-Item $fileName $newFileName
    Write-Host "File successfully renamed from $($fileInfo.Name) to $newFileName"
}
else {
    Write-Host "Error! the file $fileName does not exist in the current directory."
    exit
}

#(get-item a).CreationTime| Get-Member
