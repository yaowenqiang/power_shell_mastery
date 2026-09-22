do {
    # $input = Read-Host "Enter a number between 1 and 10"
    $input = (Read-Host "Enter a number between 1 and 10") -as [int]
    if ($input -eq $null) {
        Write-Host "That's not a number. Please try again."
    }
    elseif ($input -lt 1 -or $input -gt 10) {
        Write-Host "That number is out of range. Please try again."
    }
} until ( $input -ge 1 -and $input -le 10 )

Write-Host "Good Job! You entered a valid number: $input"
