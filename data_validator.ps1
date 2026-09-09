$userDate = Read-Host "Enter a date in the format yyyy-MM-DD "

if ($userDate -as [string]) {
    Write-Host "Good start! You entered a string."
    if ($userDate -like "????-??-??") {
        Write-Host "Fantastic! That's the correct format."
    }
    else {
        Write-Host "Nice try, but that's not quite the right format. Remember, we need  yyyy-MM-DD."
    }
}
else {
    Write-Host "Opps! That's not event a string. Try again."
}

