Import-Module $PSScriptRoot\..\PSDataConduIT -Force

$Global:TestItems =
[PSObject][ordered]@{
    __CLASS       = "Lnl_AccessLevelReaderAssignment";
    __SUPERCLASS  = "Lnl_Element";
    __SERVER      = "localhost";
    __PATH        = "\\localhost\root\onguard:Lnl_AccessLevelReaderAssignment.AccessLevelID=1,PanelID=1,ReaderID=1"
    AccessLevelID = 1;
    PanelID       = 1;
    ReaderID      = 1;
    TimezoneID    = 1;
},
[PSObject][ordered]@{
    __CLASS       = "Lnl_AccessLevelReaderAssignment";
    __SUPERCLASS  = "Lnl_Element";
    __SERVER      = "localhost";
    __PATH        = "\\localhost\root\onguard:Lnl_AccessLevelReaderAssignment.AccessLevelID=2,PanelID=1,ReaderID=1"
    AccessLevelID = 2;
    PanelID       = 1;
    ReaderID      = 2;
    TimezoneID    = 1;
}

Describe 'Get-AccessLevelReaderAssignment' {

    It 'Result contains expected type name' {
        Mock -ModuleName PSDataConduIT -CommandName Get-WmiObject -Verifiable -MockWith {
            return $Global:TestItems
        }

        $expectedTypeName = "DataConduIT.LnlAccessLevelReaderAssignment"
        $actual = Get-AccessLevelReaderAssignment

        $actual | ForEach-Object {
            $_.pstypenames.contains($expectedTypeName) | Should Be $true
        }

        Assert-VerifiableMock
    }

    It 'Properties are mapped to the expected fields' {

        Mock -ModuleName PSDataConduIT -CommandName Get-WmiObject -ParameterFilter { $Query -eq "SELECT * FROM Lnl_AccessLevelReaderAssignment WHERE __CLASS='Lnl_AccessLevelReaderAssignment'" } -Verifiable -MockWith {
            return $Global:TestItems
        }

        $actual = Get-AccessLevelReaderAssignment

        $actual | ForEach-Object {
            $_ | Should Not BeNullOrEmpty
            $_.AccessLevelID | Should Not BeNullOrEmpty
            $_.PanelID | Should Not BeNullOrEmpty
            $_.ReaderID | Should Not BeNullOrEmpty
            $_.TimezoneID | Should Not BeNullOrEmpty
        }

        Assert-VerifiableMock
    }

    It 'Given no parameters executes expected query and returns all access level reader assignments' {
        Mock -ModuleName PSDataConduIT -CommandName Get-WmiObject -ParameterFilter { $Query -eq "SELECT * FROM Lnl_AccessLevelReaderAssignment WHERE __CLASS='Lnl_AccessLevelReaderAssignment'" } -Verifiable -MockWith {
            return $Global:TestItems
        }

        $actual = Get-AccessLevelReaderAssignment

        $actual | Should Not BeNullOrEmpty
        $actual | Measure-Object | Select-Object -Expand Count | Should Be 2

        Assert-VerifiableMock
    }

    It 'Given an AccessLevelID, PanelID and ReaderID parameter executes expected query and returns a single access level reader assignment' {

        Mock -ModuleName PSDataConduIT -CommandName Get-WmiObject -ParameterFilter { $Query -eq "SELECT * FROM Lnl_AccessLevelReaderAssignment WHERE __CLASS='Lnl_AccessLevelReaderAssignment' AND AccessLevelID=1 AND PanelID=1 AND ReaderID=1" } -Verifiable -MockWith {
            return $Global:TestItems | Where-Object { $_.AccessLevelID -eq 1 -and $_.PanelID -eq 1 -and $_.ReaderID -eq 1 }
        }

        $actual = Get-AccessLevelReaderAssignment -AccessLevelID 1 -PanelID 1 -ReaderID 1

        $actual | Should Not BeNullOrEmpty
        $actual | Measure-Object | Select-Object -Expand Count | Should Be 1

        Assert-VerifiableMock
    }
}