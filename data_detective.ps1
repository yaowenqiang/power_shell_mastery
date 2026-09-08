$userInput = Read-Host "Enter a number"

if ($userInput -as [int] ) {
    write-host "$($userInput -as [int]) "
    write-host "Good job! you entered a vaild number." 
}
else {
    write-host "try again! you didn't enter a number."
}

if ($userInput -match "^\d+$") {
    write-host "Good job! you entered a vaild number."
}
else {
    write-host "try again! you didn't enter a number."  
}
$userInput = 42

if ($userInput -is [int]) {
    write-host "Good job! you entered a vaild number."
}
else {
    write-host "try again! you didn't enter a number."  
}

$userInput = "42"

if ($userInput -is [int]) {
    write-host "Good job! you entered a vaild number."
}
else {
    write-host "try again! you didn't enter a number."  
}

$fileName = Read-Host "Enter a file name"

if ($fileName -like "report*.xlsx") {
    write-host "Valid report filename"
}
else {
    write-host "Invalid report filename, It should be in the format report_yyyy_MM_DD.xlsx"
}


$fileName = Read-Host "Enter the name of a document"

if ($fileName -notlike "*.txt") {
    write-host "the document is not a text file."
}
else {
    write-host "the document is a text file."
}
