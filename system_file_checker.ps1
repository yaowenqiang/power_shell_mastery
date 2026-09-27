$logFile = $(Get-Date -Format "yyyy-MM-dd") + "_system_file_checker.log"

Write-Host "Running System File Checker, this may take some time..."

sfc /scannow

$interpretation = switch ($LASTEXITCODE) {
    0 { "No integrity errors found.No futher action required." }
    1 { "SFC could not perform the required operations. Please check the log for details." }
    2 { "SFC performed repairs. It's recommaned to reboot the system." }
    4 { "SFC could not perform the requested operation, A reboot is required." }
    default { "unexpected error code: " + $LASTEXITCODE, "Please review the log file." }

}

$report = @"
SFC Scan Report
Date: $(Get-Date)
Exit Code: $LASTEXITCODE
Interpretation: $interpretation
"@
$report | Tee-Object -FilePath $logFile

Write-Host "`nDetailed report save to $logFile" -ForegroundColor Cyan

