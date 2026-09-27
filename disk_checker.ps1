param(
    [parameter(Mandatory = $true)]
    [string]$driveLetter
)
$logFile = $(Get-Date).ToString("yyyyMMdd_HHmmss") + "_chkdsk.log"

Write-Host "Running chkdsk on $driveLetter, This may take some time..."
chkdsk $driveLetter /scan

$interpretation = switch ($LASTEXITCODE) {
    0 { "No errors found. Your disk is in good health." }
    1 { "Errors were found and fixed, it's recommended to run another scan to confirm." }
    2 { "Disk cleanup performed, Some old or unnecessary files may have been removed." }
    3 { "An error occurred during the scan, Please check the system logs for more details." }
    4 { "Errors were found but not all were fixed. Manual intervention may be required." }
    Default { "unexpected exit code: $LASTEXITCODE, Please review the system logs for more information." }
}
$report = @"
CHDSK Scan Report
Date: $(Get-Date)
Drive Scanned: $driveLetter
Exit Code: $LASTEXITCODE
Interpretation: $interpretation
"@
$report | Tee-Object -FilePath $logFile
Write-Host "`nDetailed report saved to $logFile" -ForegroundColor Cyan
