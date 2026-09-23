$attempts = 0
do {
    $password = Read-Host "Enter a password(at least 8 characters with at least one number)"
    $validPassword = $false
    if ($password.Length -ge 8) {
        if ($password -like "*[0-9]*") {
            $validPassword = $true
            write-host "Congratulations! You've entered a valid password"
        }
        else {
            Write-Host "Password must contain at least one number"
        }
    }
    else {
        Write-Host "Password is too short. It must be at least 8 characters"     
    }
    $attempts++
} until ($validPassword -eq $true -or $attempts -eq 3)