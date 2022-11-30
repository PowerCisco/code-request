function Get-AnvilSanityCheckDetails {
    <#
    .SYNOPSIS
        PowerShell function to get details related to the Change Request to merge PRs.
    .DESCRIPTION
        This private PowerShell function receives a CSV file as input with the details
        related to a CRQ to merge a PR. 
    .EXAMPLE
        Get-AnvilSanityCheckDetails -FilePath "c:\CsvFileWithDetails.csv"
        
        This example gets the list of urls from a .csv file as input and produces the corresponding output.
    .INPUTS
        A CSV file containg the following headers:
        CRQ          
        DateAndTime
        Details     
        DoneBy      
        DownTime    
        InstanceName

        If more than one row of values are found, only the first row (After the header) will be used.
    .OUTPUTS
        System.Collections.Hashtable
    .NOTES
        General notes
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $CsvFile
    )
    
    begin {


        if (!(Test-Path $CsvFile) -or $CsvFile.Count -eq 0) {
            Write-Error "Could not find file $CsvFile or it is empty." -ErrorAction Stop
                
        }
        $SanityCheckDetailsCsv = Import-Csv -Path $CsvFile -ErrorAction Stop
        



        $SanityCheckDetails = @{
            CRQ          = $SanityCheckDetailsCsv[0].CRQ
            DateAndTime  = (Get-Date -Format "MM-dd-yy_hhmm")
            Details      = $SanityCheckDetailsCsv[0].Details
            DoneBy       = $SanityCheckDetailsCsv[0].DoneBy
            DownTime     = $SanityCheckDetailsCsv[0].Downtime
            InstanceName = $SanityCheckDetailsCsv[0].InstanceName
        }

    }
    
    process {
        
        Write-Output $SanityCheckDetails
        
    }
    
    end {
        
    }
}