$categoryMap = @{
    ".txt"  = "Documents"
    ".doc"  = "Documents"
    ".docx" = "Documents"
    ".pdf"  = "Documents"
    ".jpg"  = "Images"
    ".png"  = "Documents"
    ".gif"  = "Documents"
    ".mp3"  = "Audio"
    ".wav"  = "Documents"
    ".mp4"  = "Videos"
    ".avi"  = "Videos"
    ".zip"  = "Archives"
    ".rar"  = "Archives"
}

# Write-Host $categoryMap['.txt']

function Move-FileToCategory($file, $category) {
    $destinationFolder = "$PWD/$category" 
    if (!(Test-path $destinationFolder)) {
        [void](New-Item -Path $destinationFolder -ItemType Directory -WhatIf)
    }
    $destinationPath = "$destinationFolder/$file"
    Move-Item -Path $file.FullName -Destination $destinationPath -WhatIf

    Write-Host "Moved :$($File.Name) to $Category"

}

$categorizedCount = 0
foreach ($file in Get-ChildItem) {
    $extension = $file.Extension.ToLower()
    if ($categoryMap.ContainsKey($extension)) {
        Move-FileToCategory $file $categoryMap[$extension]
        $categorizedCount++
    }
}

Write-Host "`nCategorized $categorizedCount file(s)."

