# $extensitions = @('.txt', '.docx', '.pdf', '.jpg', '.png')

# $directory = '/Users/yaojack/Downloads/'
param(
    [string]$directory = "/Users/yaojack/Downloads/",
    [string[]]$extensitions = @('.txt', '.docx', '.pdf', '.jpg', '.png')
)

$totalFile = 0
$totalSize = 0



foreach ($ext in $extensitions) {
    # $count = (Get-ChildItem -Path $directory -Recurse -Filter "*$ext" | Measure-Object).Count
    # $totalFile += $count
    # Write-Host "Number of $ext files: $count"
    $files = Get-ChildItem -Path $directory -Filter "*$ext"
    $size = ($files | Measure-Object -Property Length -Sum).sum / 1MB
    $count = $files.Count
    $totalSize += $size
    $totalFile += $count

    Write-Host "Number of $ext files: $count, Total size : $($size.ToString("N2")) MB"
}
Write-Host "Total size of files: $($totalSize.ToString("N2")) MB"
Write-Host "Total number of files: $totalFile"