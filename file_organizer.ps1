$categoryMap = @{
    ".txt"  = "Documents"
    ".doc"  = "Documents"
    ".docx" = "Documents"
    ".pdf"  = "Documents"
    ".jpg"  = "Images"
    ".png"  = "Images"
    ".gif"  = "Images"
    ".mp3"  = "Audio"
    ".wav"  = "Audio"
    ".mp4"  = "Videos"
    ".avi"  = "Videos"
    ".zip"  = "Archives"
    ".rar"  = "Archives"
}

$unknownExtensions = @{

}

# Write-Host $categoryMap['.txt']

function Move-FileToCategory($file, $category) {
    $destinationFolder = "$PWD/$category" 
    if (!(Test-path $destinationFolder)) {
        [void](New-Item -Path $destinationFolder -ItemType Directory -WhatIf -ErrorAction Stop)
    }
    # use .Name: "$file" would interpolate the full path into the destination
    $destinationPath = "$destinationFolder/$($file.Name)"
    Move-Item -Path $file.FullName -Destination $destinationPath -WhatIf -ErrorAction Continue

    Write-Host "Moved :$($File.Name) to $Category"

}

$categorizedCount = 0
foreach ($file in Get-ChildItem -ErrorAction SilentlyContinue) {
    $extension = $file.Extension.ToLower()
    if ($categoryMap.ContainsKey($extension)) {
        Move-FileToCategory $file $categoryMap[$extension]
        $categorizedCount++
    }
    else {
        Move-FileToCategory $file 'Miscellaneous'
        if ($unknownExtensions.ContainsKey($extension)) {
            $unknownExtensions[$extension]++
        }
        else {
            $unknownExtensions[$extension] = 1

        }
    }
}

Write-Host "`nCategorized $categorizedCount file(s)."

Write-Host "`nUnknown file types encountered:"

foreach ($extension in $unknownExtensions.Keys) {
    Write-Host "$extension : $($unknownExtensions[$extension]) file(s)"
}