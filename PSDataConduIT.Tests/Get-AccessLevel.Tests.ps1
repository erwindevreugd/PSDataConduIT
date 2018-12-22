Import-Module $PSScriptRoot\..\PSDataConduIT -Force

$Global:TestItems =
[PSObject][ordered]@{
    __CLASS                      = "Lnl_AccessLevel";
    __SUPERCLASS                 = "Lnl_Element";
    __SERVER                     = "localhost";
    __PATH                       = "\\localhost\root\onguard:Lnl_AccessLevel.ID=1"
    ID                           = 1;
    Name                         = "Default Access Level 1";
    DownloadToIntelligentReaders = $false;
    FirstCardUnlock              = $false;
    HasCommandAuthority          = $false;
    SegmentID                    = 1;
},
[PSObject][ordered]@{
    __CLASS                      = "Lnl_AccessLevel";
    __SUPERCLASS                 = "Lnl_Element";
    __SERVER                     = "localhost";
    __PATH                       = "\\localhost\root\onguard:Lnl_AccessLevel.ID=2"
    ID                           = 2;
    Name                         = "Default Access Level 2";
    DownloadToIntelligentReaders = $false;
    FirstCardUnlock              = $false;
    HasCommandAuthority          = $false;
    SegmentID                    = 2;
}

Describe 'Get-AccessLevel' {

    It 'Result contains expected type name' {
        Mock -ModuleName PSDataConduIT -CommandName Get-WmiObject -Verifiable -MockWith {
            return $Global:TestItems
        }

        $expectedTypeName = "DataConduIT.LnlAccessLevel"
        $actual = Get-AccessLevel

        $actual | ForEach-Object {
            $_.pstypenames.contains($expectedTypeName) | Should Be $true
        }

        Assert-VerifiableMock
    }

    It 'Properties are mapped to the expected fields' {

        Mock -ModuleName PSDataConduIT -CommandName Get-WmiObject -ParameterFilter { $Query -eq "SELECT * FROM Lnl_AccessLevel WHERE __CLASS='Lnl_AccessLevel'" } -Verifiable -MockWith {
            return $Global:TestItems
        }

        $actual = Get-AccessLevel

        $actual | ForEach-Object {
            $_ | Should Not BeNullOrEmpty
            $_.AccessLevelID | Should Not BeNullOrEmpty
            $_.Name | Should Not BeNullOrEmpty
            $_.SegmentID | Should Not BeNullOrEmpty
        }

        Assert-VerifiableMock
    }

    It 'Given no parameters executes expected query and returns all access levels' {
        Mock -ModuleName PSDataConduIT -CommandName Get-WmiObject -ParameterFilter { $Query -eq "SELECT * FROM Lnl_AccessLevel WHERE __CLASS='Lnl_AccessLevel'" } -Verifiable -MockWith {
            return $Global:TestItems
        }

        $actual = Get-AccessLevel

        $actual | Should Not BeNullOrEmpty
        $actual | Measure-Object | Select-Object -Expand Count | Should Be 2

        Assert-VerifiableMock
    }

    It 'Given an AccessLevelID parameter executes expected query and returns a single access level' {

        Mock -ModuleName PSDataConduIT -CommandName Get-WmiObject -ParameterFilter { $Query -eq "SELECT * FROM Lnl_AccessLevel WHERE __CLASS='Lnl_AccessLevel' AND ID=1" } -Verifiable -MockWith {
            return $Global:TestItems | Where-Object { $_.ID -eq 1 }
        }

        $actual = Get-AccessLevel -AccessLevelID 1

        $actual | Should Not BeNullOrEmpty
        $actual | Measure-Object | Select-Object -Expand Count | Should Be 1

        Assert-VerifiableMock
    }

    It 'Given a Name parameter executes expected query and returns expected access level(s)' {

        Mock -ModuleName PSDataConduIT -CommandName Get-WmiObject -ParameterFilter { $Query -eq "SELECT * FROM Lnl_AccessLevel WHERE __CLASS='Lnl_AccessLevel' AND Name like 'Default Access Level 1'" } -Verifiable -MockWith {
            return $Global:TestItems | Where-Object { $_.Name -eq "Default Access Level 1" }
        }

        $actual = Get-AccessLevel -Name "Default Access Level 1"

        $actual | Should Not BeNullOrEmpty
        $actual | Measure-Object | Select-Object -Expand Count | Should Be 1

        Assert-VerifiableMock
    }

    It 'Given a Name wildcard parameter executes expected query and returns expected access level(s)' {

        Mock -ModuleName PSDataConduIT -CommandName Get-WmiObject -ParameterFilter { $Query -eq "SELECT * FROM Lnl_AccessLevel WHERE __CLASS='Lnl_AccessLevel' AND Name like '%Access Level 1'" } -Verifiable -MockWith {
            return $Global:TestItems | Where-Object { $_.Name -like "*Access Level 1" }
        }

        $actual = Get-AccessLevel -Name "*Access Level 1"

        $actual | Should Not BeNullOrEmpty
        $actual | Measure-Object | Select-Object -Expand Count | Should Be 1

        Assert-VerifiableMock
    }

    It 'Given a SegmentID parameter executes expected query and returns expected access level(s)' {

        Mock -ModuleName PSDataConduIT -CommandName Get-WmiObject -ParameterFilter { $Query -eq "SELECT * FROM Lnl_AccessLevel WHERE __CLASS='Lnl_AccessLevel' AND SegmentID=1" } -Verifiable -MockWith {
            return $Global:TestItems | Where-Object { $_.SegmentID -eq 1}
        }

        $actual = Get-AccessLevel -SegmentID 1

        $actual | Should Not BeNullOrEmpty
        $actual | Measure-Object | Select-Object -Expand Count | Should Be 1

        Assert-VerifiableMock
    }
}