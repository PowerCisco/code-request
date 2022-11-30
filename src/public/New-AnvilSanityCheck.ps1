function New-AnvilSanityCheck {
    <#
    .SYNOPSIS
        PowerShell function to run a full sanity check of various Anvil Services after a PR has been merged.
    .DESCRIPTION
        This PowerShell function runs a full sanity check on the Anvil web services
        and creates a file with the results and sends it automatically to the Anvil Support distro.
        
        The optional switch parameter NoEmail runs the function (Creating the SanityCheckFile) without sending the email.
        
        It requires a csv file with a list of urls separated by lines (one per line).
    .EXAMPLE
        Get-AnvilUrlHealth -FilePath "c:\listOfUrls.txt"
        
        This example gets the list of urls from a .txt file as input and produces the corresponding output.
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
        [string] $WebServicesFile,
        # Parameter help description
        [switch]
        $NoEmail
        
    )
    
    begin {

        try {
            Start-Logging
            $ChangeDetails = (Get-AnvilSanityCheckDetails)
            $UrlChecks = (Get-AnvilUrlHealth -FilePath $WebServicesFile)
        }
        catch {
            Write-Host "An error was encountered while running a private function"
            Stop-Transcript | Out-Null
        }
        

        $CRQ = $ChangeDetails.CRQ
        $DateAndTime = $ChangeDetails.DateAndTime
        $Details = $ChangeDetails.Details
        $DoneBy = $ChangeDetails.DoneBy
        $Downtime = $ChangeDetails.Downtime
        $InstanceName = $ChangeDetails.InstanceName
        $body = @"

<h1>Sanity Check</h1>

<p>Hi Team,</p>
<p>Please find below the Sanity Check details:</p>
<br>

<table id="Table">
    <tr>
        <th>Change Request Number</th>
        <th id="CRQ">$CRQ</th>
    </tr>

    <tr>
        <td>Date and Time</td>
        <td id="DateAndTime">$DateAndTime</td>
    </tr>

    <tr>
        <td>Change Details</td>
        <td id="Details">$Details</td>
    </tr>

    <tr>
        <td>PSS Check Done By</td>
        <td id="DoneBy">$DoneBy</td>
    </tr>

    <tr>
        <td>Downtime</td>
        <td id="Downtime">$Downtime</td>
    </tr>

    <tr>
        <td>Instance Name</td>
        <td id="Instance">$InstanceName</td>
    </tr>

</table>

<br>
<br>

"@

        $head = @"

    <title>Sanity Check</title>
    <style>
        Table {
            font-family: Arial, Helvetica, sans-serif;
            border-collapse: collapse;
            width: 100%;
        }

        Table td,
        Table th {
            border: 1px solid #ddd;
            padding: 8px;
        }

        Table tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        Table tr:hover {
            background-color: #ddd;
        }

        Table th {
            padding-top: 12px;
            padding-bottom: 12px;
            text-align: left;
            background-color: #04AA6D;
            color: white;
        }
    </style>
"@

        $footer = @"
<br>
<br>

<h3>Anvil Support | L3 Team</h4>
<h4>Anvil-Support@ACME.com</h3>
"@

   
    }
    
    process {
        $UrlChecks | ConvertTo-Html -Head $head -Body $body -PostContent $footer | out-file SanityCheckTemplate.html
        
        if ($NoEmail) {

        }
        else {
            if ((Test-NetConnection mailhost.ACME.com -Port 25).TcpTestSucceeded) {
                Send-AnvilEmailReport 
            }
            else {
                Write-Warning "mailhost.ACME.com:25 is unreachable.
                `nFile has been created in ${PSScriptRoot}\SanityCheckTemplate but email will not be sent."
            }
        }
    }
    end {
        
    }
}