Describe "Logging" {
  BeforeAll {
    . .\src\private\Start-Logging.ps1
    Mock -CommandName Start-Transcript -MockWith {}
  }

  It "Should start transcript" {
    Start-Logging
    Should -Invoke -CommandName Start-Transcript -Times 1 -Exactly
  }

}