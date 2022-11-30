function Get-AnvilUrlHealth {
    <#
    .SYNOPSIS
        PowerShell function to get health status of various Anvil Services
    .DESCRIPTION
        This private PowerShell function gets the content of multiple health check websites
        for Anvil services and parses them to identify if the service is healthy or not.
        It requires a csv file with a list of urls separated by lines (one per line) and will output a PSCustom Object with the following properties:
        Url, Status and DateLastCheck.
    .EXAMPLE
        Get-AnvilUrlHealth -FilePath "c:\listOfUrls.csv"
        
        This example gets the list of urls from a .csv file as input and produces the corresponding output.
    .INPUTS
        Any list of commma separated values that contain the following: urls separated by a line. urls must contain the protocol (http or https)
    .OUTPUTS
        System.Management.Automation.PSCustomObject
    .NOTES
        General notes
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $FilePath
    )
    
    begin {
        $data = @(
            foreach ($item in (Import-Csv $FilePath)) {
                [pscustomobject]@{Url = $item.url; Type = $item.type ; Status = '' }
            }
        )
    }
    
    process {
        for ($i = 0; $i -lt $data.Count; $i++) {
            if ($data[$i].type -like "WebService") {
                $data[$i].Status = If ($(Invoke-WebRequest $data[$i].Url).Content -eq "Healthy") { "Healthy" } Else { "NOT Healthy" } 
            }
            elseif ($data[$i].type -like "Dashboard") {
                $data[$i].Status = If ($(Invoke-WebRequest $data[$i].Url).StatusCode -eq 200) { "Good" } Else { "NOT good" } 
            }
        }
        Write-Output $data
    }
    end {}
}

