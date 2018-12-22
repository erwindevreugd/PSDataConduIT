Import-Module $PSScriptRoot\..\PSDataConduIT -Force

$Global:TestItems =
[PSObject][ordered]@{
    __CLASS      = "Lnl_Account";
    __SUPERCLASS = "Lnl_Element";
    __SERVER     = "localhost";
    __PATH       = "\\localhost\root\onguard:Lnl_Account.ID=1"
    ID           = 1;
    AccountID    = "S-1-5-21-0000000000-0000000000-000000000-0001";
    DirectoryID  = 1;
    PersonID     = 1;
},
[PSObject][ordered]@{
    __CLASS      = "Lnl_Account";
    __SUPERCLASS = "Lnl_Element";
    __SERVER     = "localhost";
    __PATH       = "\\localhost\root\onguard:Lnl_Account.ID=2"
    ID           = 2;
    AccountID    = "S-1-5-21-0000000000-0000000000-000000000-0002";
    DirectoryID  = 2;
    PersonID     = 2;
}
Describe 'Get-Account' {

    It 'Result contains expected type name' {
        Mock -ModuleName PSDataConduIT -CommandName Get-WmiObject -Verifiable -MockWith {
            return $Global:TestItems
        }

        $expectedTypeName = "DataConduIT.LnlAccount"
        $actual = Get-Account

        $actual | ForEach-Object {
            $_.pstypenames.contains($expectedTypeName) | Should Be $true
        }

        Assert-VerifiableMock
    }

    It 'Properties are mapped to the expected fields' {

        Mock -ModuleName PSDataConduIT -CommandName Get-WmiObject -ParameterFilter { $Query -eq "SELECT * FROM Lnl_Account WHERE __CLASS='Lnl_Account'" } -Verifiable -MockWith {
            return $Global:TestItems
        }

        $actual = Get-Account

        $actual | ForEach-Object {
            $_ | Should Not BeNullOrEmpty
            $_.AccountID | Should Not BeNullOrEmpty
            $_.ExternalAccountID | Should Not BeNullOrEmpty
            $_.DirectoryID | Should Not BeNullOrEmpty
            $_.PersonID | Should Not BeNullOrEmpty
        }

        Assert-VerifiableMock
    }

    It 'Given no parameters executes expected query and returns all accounts' {
        Mock -ModuleName PSDataConduIT -CommandName Get-WmiObject -ParameterFilter { $Query -eq "SELECT * FROM Lnl_Account WHERE __CLASS='Lnl_Account'" } -Verifiable -MockWith {
            return $Global:TestItems
        }

        $actual = Get-Account

        $actual | Should Not BeNullOrEmpty
        $actual | Measure-Object | Select-Object -Expand Count | Should Be 2

        Assert-VerifiableMock
    }

    It 'Given an AccountID parameter executes expected query and returns a single account' {

        Mock -ModuleName PSDataConduIT -CommandName Get-WmiObject -ParameterFilter { $Query -eq "SELECT * FROM Lnl_Account WHERE __CLASS='Lnl_Account' AND ID=1" } -Verifiable -MockWith {
            return $Global:TestItems | Where-Object { $_.ID -eq 1 }
        }

        $actual = Get-Account -AccountID 1

        $actual | Should Not BeNullOrEmpty
        $actual | Measure-Object | Select-Object -Expand Count | Should Be 1

        Assert-VerifiableMock
    }

    It 'Given an ExternalAccountID parameter executes expected query and returns expected account(s)' {

        Mock -ModuleName PSDataConduIT -CommandName Get-WmiObject -ParameterFilter { $Query -eq "SELECT * FROM Lnl_Account WHERE __CLASS='Lnl_Account' AND AccountID='S-1-5-21-0000000000-0000000000-000000000-0001'" } -Verifiable -MockWith {
            return $Global:TestItems | Where-Object { $_.AccountID -eq "S-1-5-21-0000000000-0000000000-000000000-0001" }
        }

        $actual = Get-Account -ExternalAccountID "S-1-5-21-0000000000-0000000000-000000000-0001"

        $actual | Should Not BeNullOrEmpty
        $actual | Measure-Object | Select-Object -Expand Count | Should Be 1

        Assert-VerifiableMock
    }

    It 'Given a DirectoryID parameter executes expected query and returns a single account' {

        Mock -ModuleName PSDataConduIT -CommandName Get-WmiObject -ParameterFilter { $Query -eq "SELECT * FROM Lnl_Account WHERE __CLASS='Lnl_Account' AND DirectoryID=1" } -Verifiable -MockWith {
            return $Global:TestItems | Where-Object { $_.DirectoryID -eq 1 }
        }

        $actual = Get-Account -DirectoryID 1

        $actual | Should Not BeNullOrEmpty
        $actual | Measure-Object | Select-Object -Expand Count | Should Be 1

        Assert-VerifiableMock
    }

    It 'Given a PersonID parameter executes expected query and returns a single account' {

        Mock -ModuleName PSDataConduIT -CommandName Get-WmiObject -ParameterFilter { $Query -eq "SELECT * FROM Lnl_Account WHERE __CLASS='Lnl_Account' AND PersonID=1" } -Verifiable -MockWith {
            return $Global:TestItems | Where-Object { $_.PersonID -eq 1 }
        }

        $actual = Get-Account -PersonID 1

        $actual | Should Not BeNullOrEmpty
        $actual | Measure-Object | Select-Object -Expand Count | Should Be 1

        Assert-VerifiableMock
    }
}