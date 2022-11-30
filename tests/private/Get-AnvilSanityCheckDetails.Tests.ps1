Describe "Get-AnvilSanityCheckDetails" {
  BeforeAll {
    . .\src\private\Get-AnvilSanityCheckDetails.ps1

    $SampleData = @{
      CRQ          = "Mocked CRQ"
      DateAndTime  = "Mocked DateAndTime"
      Details      = "Mocked Details"
      DoneBy       = "Mocked DoneBy"
      DownTime     = "Mocked DownTime"
      InstanceName = "Mocked InstanceName"
    }
    #$SampleData | Export-Csv -Path TestDrive:\Get-AnvilSanityCheckDetails.csv
    Mock Get-AnvilSanityCheckDetails { $SampleData }
    Mock Import-Csv { $SampleData }
  }

  
  Context 'Given CsvFile parameter' {    
   
    It 'Should give a valid file path' {

      { Get-AnvilSanityCheckDetails -CsvFile TestDrive:\Get-AnvilSanityCheckDetails.csv } | Should -Not -Throw
    }
    It "Should output CRQ details hash" {
        
      Get-AnvilSanityCheckDetails -CsvFile TestDrive:\Get-AnvilSanityCheckDetails.csv | Should -Be $SampleData 
    }
    It 'Should given an invalid file path then throw a terminating error' {
      { Get-AnvilSanityCheckDetails -CsvFile $Null -ErrorAction Stop } | Should -Throw
    }
  }
 
  
}