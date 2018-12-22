Import-Module $PSScriptRoot\..\PSDataConduIT -Force

$Global:TestItems =
[PSObject][ordered]@{
    __CLASS       = "Lnl_AccessLevelAssignment";
    __SUPERCLASS  = "Lnl_Element";
    __SERVER      = "localhost";
    __PATH        = "\\localhost\root\onguard:Lnl_AccessLevelAssignment.AccessLevelID=1,BadgeKey=1"
    AccessLevelID = 1;
    BadgeKey      = 1;
    Activate      = "20181116000000.000000+060";
    Deactivate    = "20231116000000.000000+060";
},
[PSObject][ordered]@{
    __CLASS       = "Lnl_AccessLevelAssignment";
    __SUPERCLASS  = "Lnl_Element";
    __SERVER      = "localhost";
    __PATH        = "\\localhost\root\onguard:Lnl_AccessLevelAssignment.AccessLevelID=2,BadgeKey=1"
    AccessLevelID = 2;
    BadgeKey      = 1;
    Activate      = "20181116000000.000000+060";
    Deactivate    = "20231116000000.000000+060";
}

Describe 'Get-AccessLevelAssignment' {

    It 'Result contains expected type name' {
        Mock -ModuleName PSDataConduIT -CommandName Get-WmiObject -Verifiable -MockWith {
            return $Global:TestItems
        }

        $expectedTypeName = "DataConduIT.LnlAccessLevelAssignment"
        $actual = Get-AccessLevelAssignment

        $actual | ForEach-Object {
            $_.pstypenames.contains($expectedTypeName) | Should Be $true
        }

        Assert-VerifiableMock
    }

    It 'Properties are mapped to the expected fields' {

        Mock -ModuleName PSDataConduIT -CommandName Get-WmiObject -ParameterFilter { $Query -eq "SELECT * FROM Lnl_AccessLevelAssignment WHERE __CLASS='Lnl_AccessLevelAssignment'" } -Verifiable -MockWith {
            return $Global:TestItems
        }

        $actual = Get-AccessLevelAssignment

        $actual | ForEach-Object {
            $_ | Should Not BeNullOrEmpty
            $_.AccessLevelID | Should Not BeNullOrEmpty
            $_.BadgeKey | Should Not BeNullOrEmpty
            $_.Activate | Should Not BeNullOrEmpty
            $_.Deactivate | Should Not BeNullOrEmpty
        }

        Assert-VerifiableMock
    }

    It 'Given no parameters executes expected query and returns all access level assignments' {
        Mock -ModuleName PSDataConduIT -CommandName Get-WmiObject -ParameterFilter { $Query -eq "SELECT * FROM Lnl_AccessLevelAssignment WHERE __CLASS='Lnl_AccessLevelAssignment'" } -Verifiable -MockWith {
            return $Global:TestItems
        }

        $actual = Get-AccessLevelAssignment

        $actual | Should Not BeNullOrEmpty
        $actual | Measure-Object | Select-Object -Expand Count | Should Be 2

        Assert-VerifiableMock
    }

    It 'Given an AccessLevelID and BadgeKey parameter executes expected query and returns a single access level assignment' {

        Mock -ModuleName PSDataConduIT -CommandName Get-WmiObject -ParameterFilter { $Query -eq "SELECT * FROM Lnl_AccessLevelAssignment WHERE __CLASS='Lnl_AccessLevelAssignment' AND AccessLevelID=1 AND BadgeKey=1" } -Verifiable -MockWith {
            return $Global:TestItems | Where-Object { $_.AccessLevelID -eq 1 -and $_.BadgeKey -eq 1 }
        }

        $actual = Get-AccessLevelAssignment -AccessLevelID 1 -BadgeKey 1

        $actual | Should Not BeNullOrEmpty
        $actual | Measure-Object | Select-Object -Expand Count | Should Be 1

        Assert-VerifiableMock
    }
}