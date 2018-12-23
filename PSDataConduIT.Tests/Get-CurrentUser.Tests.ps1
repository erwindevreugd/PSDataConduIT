Import-Module $PSScriptRoot\..\PSDataConduIT -Force

Describe 'Get-CurrentUser' {

    It 'Result contains expected type name' {
        Mock -ModuleName PSDataConduIT -CommandName Invoke-WmiMethod -Verifiable -MockWith {
            return @{ReturnValue = "Account, System (10)"}
        }

        $expectedTypeName = "DataConduIT.LnlCurrentUser"
        $actual = Get-CurrentUser

        $actual | ForEach-Object {
            $_.pstypenames.contains($expectedTypeName) | Should Be $true
        }

        Assert-VerifiableMock
    }

    It 'Account name with multi-digit id maps correctly' {

        Mock -ModuleName PSDataConduIT -CommandName Invoke-WmiMethod -Verifiable -MockWith {
            return @{ReturnValue = "Account, System (100)"}
        }

        $actual = Get-CurrentUser

        $actual | ForEach-Object {
            $_ | Should Not BeNullOrEmpty
            $_.User | Should Not BeNullOrEmpty
            $_.User | Should Be "Account, System (100)"
            $_.UserID | Should Not BeNullOrEmpty
            $_.UserID | Should Be 100
        }

        Assert-VerifiableMock
    }

    It 'Account name with single digit id maps correctly' {

        Mock -ModuleName PSDataConduIT -CommandName Invoke-WmiMethod -Verifiable -MockWith {
            return @{ReturnValue = "Account, System (1)"}
        }

        $actual = Get-CurrentUser

        $actual | ForEach-Object {
            $_ | Should Not BeNullOrEmpty
            $_.User | Should Not BeNullOrEmpty
            $_.User | Should Be "Account, System (1)"
            $_.UserID | Should Not BeNullOrEmpty
            $_.UserID | Should Be 1
        }

        Assert-VerifiableMock
    }
}