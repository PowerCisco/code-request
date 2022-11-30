function Start-Logging {
    $CurrentDate = [datetime]::Now.ToString("yyyy_MM_dd")
    $LogFileName = "$env:APPDATA\AnvilSanityCheckLog_$CurrentDate.txt"
    if (!(test-path $LogFileName)) {
        try {
            New-Item $LogFileName -ItemType File -ErrorAction Stop | Out-Null
        }
        catch {
            Write-Host "Unable to create log file $LogFileName" -ForegroundColor DarkRed
            Write-Host "Press any key to end script execution" ; [System.Console]::ReadKey() | Out-Null 

        } 

    }
    Start-Transcript -Path $LogFileName -Append

}