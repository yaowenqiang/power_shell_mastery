$count = 1
while ($count -lt 5) {
    Write-Host "Iteration $count"
    $count++
}

while ($true) { 
    Write-Host "Press any key to continue..."
    Sleep -Seconds 1
}