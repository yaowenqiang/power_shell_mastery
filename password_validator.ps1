$attempts = 0
do {
    $password = Read-Host "Enter a password(at least 8 characters with at least one number)"
    # $validPassword = $false
    # if ($password.Length -ge 8) {
    #     if ($password -like "*[0-9]*") {
    #         $validPassword = $true
    #         write-host "Congratulations! You've entered a valid password"
    #     }
    #     else {
    #         Write-Host "Password must contain at least one number"
    #     }
    # }
    # else {
    #     Write-Host "Password is too short. It must be at least 8 characters"     
    # }
    # Advanced validation using regex
    # -cmatch (case-sensitive) is required: plain -match is case-insensitive,
    # which makes [a-z] and [A-Z] match ANY letter, breaking the case rules
    # [^a-zA-Z0-9] = at least one character that is not a letter or digit
    if ($password -cmatch "^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^a-zA-Z0-9]).{8,}$") {
        $validPassword = $true
        Write-Host "Congratulations! You've entered a valid password"
    }
    else {
        Write-Host "Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, and one number, and one special character."    
    }
    $attempts++
} until ($validPassword -eq $true -or $attempts -eq 3)

if ($attempts -eq 3 -and -not $validPassword) {
    Write-Host "You have exceeded the maximum number of attempts. Please try again later."
}