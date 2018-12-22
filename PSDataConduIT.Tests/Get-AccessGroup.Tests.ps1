Import-Module $PSScriptRoot\..\PSDataConduIT -Force

$Global:TestItems =
[PSObject][ordered]@{
    __CLASS      = "Lnl_AccessGroup";
    __SUPERCLASS = "Lnl_Element";
    __SERVER     = "localhost";
    __PATH       = "\\localhost\root\onguard:Lnl_AccessGroup.ID=1"
    ID           = 1;
    Name         = "Default Access Group 1";
    SegmentID    = 1;
},
[PSObject][ordered]@{
    __CLASS      = "Lnl_AccessGroup";
    __SUPERCLASS = "Lnl_Element";
    __SERVER     = "localhost";
    __PATH       = "\\localhost\root\onguard:Lnl_AccessGroup.ID=2"
    ID           = 2;
    Name         = "Default Access Group 2";
    SegmentID    = 2;
}
Describe 'Get-AccessGroup' {

    It 'Result contains expected type name' {
        Mock -ModuleName PSDataConduIT -CommandName Get-WmiObject -Verifiable -MockWith {
            return $Global:TestItems
        }

        $expectedTypeName = "DataConduIT.LnlAccessGroup"
        $actual = Get-AccessGroup

        $actual | ForEach-Object {
            $_.pstypenames.contains($expectedTypeName) | Should Be $true
        }

        Assert-VerifiableMock
    }

    It 'Properties are mapped to the expected fields' {

        Mock -ModuleName PSDataConduIT -CommandName Get-WmiObject -ParameterFilter { $Query -eq "SELECT * FROM Lnl_AccessGroup WHERE __CLASS='Lnl_AccessGroup'" } -Verifiable -MockWith {
            return $Global:TestItems
        }

        $actual = Get-AccessGroup

        $actual | ForEach-Object {
            $_ | Should Not BeNullOrEmpty
            $_.AccessGroupID | Should Not BeNullOrEmpty
            $_.Name | Should Not BeNullOrEmpty
            $_.SegmentID | Should Not BeNullOrEmpty
        }

        Assert-VerifiableMock
    }

    It 'Given no parameters executes expected query and returns all access groups' {
        Mock -ModuleName PSDataConduIT -CommandName Get-WmiObject -ParameterFilter { $Query -eq "SELECT * FROM Lnl_AccessGroup WHERE __CLASS='Lnl_AccessGroup'" } -Verifiable -MockWith {
            return $Global:TestItems
        }

        $actual = Get-AccessGroup

        $actual | Should Not BeNullOrEmpty
        $actual | Measure-Object | Select-Object -Expand Count | Should Be 2

        Assert-VerifiableMock
    }

    It 'Given an AccessGroupID parameter executes expected query and returns a single access group' {

        Mock -ModuleName PSDataConduIT -CommandName Get-WmiObject -ParameterFilter { $Query -eq "SELECT * FROM Lnl_AccessGroup WHERE __CLASS='Lnl_AccessGroup' AND ID=1" } -Verifiable -MockWith {
            return $Global:TestItems | Where-Object { $_.ID -eq 1 }
        }

        $actual = Get-AccessGroup -AccessGroupID 1

        $actual | Should Not BeNullOrEmpty
        $actual | Measure-Object | Select-Object -Expand Count | Should Be 1

        Assert-VerifiableMock
    }

    It 'Given a Name parameter executes expected query and returns expected access group(s)' {

        Mock -ModuleName PSDataConduIT -CommandName Get-WmiObject -ParameterFilter { $Query -eq "SELECT * FROM Lnl_AccessGroup WHERE __CLASS='Lnl_AccessGroup' AND Name like 'Default Access Group 1'" } -Verifiable -MockWith {
            return $Global:TestItems | Where-Object { $_.Name -eq "Default Access Group 1" }
        }

        $actual = Get-AccessGroup -Name "Default Access Group 1"

        $actual | Should Not BeNullOrEmpty
        $actual | Measure-Object | Select-Object -Expand Count | Should Be 1

        Assert-VerifiableMock
    }

    It 'Given a Name wildcard parameter executes expected query and returns expected access group(s)' {

        Mock -ModuleName PSDataConduIT -CommandName Get-WmiObject -ParameterFilter { $Query -eq "SELECT * FROM Lnl_AccessGroup WHERE __CLASS='Lnl_AccessGroup' AND Name like '%Access Group 1'" } -Verifiable -MockWith {
            return $Global:TestItems | Where-Object { $_.Name -like "*Access Group 1" }
        }

        $actual = Get-AccessGroup -Name "*Access Group 1"

        $actual | Should Not BeNullOrEmpty
        $actual | Measure-Object | Select-Object -Expand Count | Should Be 1

        Assert-VerifiableMock
    }

    It 'Given a SegmentID parameter executes expected query and returns expected access group(s)' {

        Mock -ModuleName PSDataConduIT -CommandName Get-WmiObject -ParameterFilter { $Query -eq "SELECT * FROM Lnl_AccessGroup WHERE __CLASS='Lnl_AccessGroup' AND SegmentID=1" } -Verifiable -MockWith {
            return $Global:TestItems | Where-Object { $_.SegmentID -eq 1 }
        }

        $actual = Get-AccessGroup -SegmentID 1

        $actual | Should Not BeNullOrEmpty
        $actual | Measure-Object | Select-Object -Expand Count | Should Be 1

        Assert-VerifiableMock
    }
}