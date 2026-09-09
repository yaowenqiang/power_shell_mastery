$currentDay = (Get-Date).DayOfWeek
$currentHour = (Get-Date).Hour

# if ($currentDay -eq "Saturday" -and $currentDay -eq "Sunday") {
#     $isWeekday = $true
# } else {
#     $isWeekday = $false
# }

# if ($isWeekday -eq $true) {
#     if ($currentHour -ge 9 -and $currentHour -lt 17) {
#         $isOpen = $true
#     }
#     else {
#         $isOpen = $false
#     }
# }
# else {
#     $isOpen = $false
# }

$isWeekday = ($currentDay -ge 1) -and ($currentDay -le 5)

$isBusinessours = ($currentHour -ge 9) -and ($currentHour -lt 17)

if ($currentDay -eq "wendsday" -and $currentHour -ge 14 -and $currentHour -lt 15) {
    Write-Host "team meeting time"
}
elseif ($isWeekday -and $isBusinessours ) {
    Write-Host "Business hours"
}
else {
    Write-Host "Off hours"
}


