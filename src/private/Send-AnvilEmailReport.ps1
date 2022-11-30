function Send-AnvilEmailReport {
    <#
    .SYNOPSIS
        PowerShell function to send Sanity Check report via email.
    .DESCRIPTION
        This PowerShell function uses an internal smtp server
        to send an email when called.
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
        
    begin {


        $currentDate = (Get-Date -Format "MM/dd/yyyy_HH:mm").ToString()

        $sendMailParameters = @{
            To          = 'Anvil-Support@ACME.com'
            #Cc         = 'francisco.castillo@ACME.com'
            Subject     = "ACME - Sanity Check - ${currentDate}"
            Attachments = 'SanityCheckTemplate.html'
            Body        = "Please find attached the results of the sanity checks. `nThis is an automated email."
            From        = "Anvil-Support@ACME.com"
            SmtpServer  = "smtp.ACME.com" 
            Port        = 25
        }
    }
    
    process {

        try {
            Send-MailMessage  @sendMailParameters
        }
        catch {
            Write-Debug "Send-MailMessage failed"
        }
    }
    end {   }
}