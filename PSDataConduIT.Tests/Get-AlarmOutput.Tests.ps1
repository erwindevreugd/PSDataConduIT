Import-Module $PSScriptRoot\..\PSDataConduIT -Force

$Global:TestItems =
[PSObject][ordered]@{
    __CLASS      = "Lnl_AlarmOutput";
    __SUPERCLASS = "Lnl_Element";
    __SERVER     = "localhost";
    __PATH       = "\\localhost\root\onguard:Lnl_AlarmOutput.ID=1"
    ID           = 1;
    PanelID      = 1;
    AlarmPanelID = 66;
    OutputID     = 1;
    Name         = "Alarm Output 1";
    HostName     = "Host1";
},
[PSObject][ordered]@{
    __CLASS      = "Lnl_AlarmOutput";
    __SUPERCLASS = "Lnl_Element";
    __SERVER     = "localhost";
    __PATH       = "\\localhost\root\onguard:Lnl_AlarmOutput.ID=2"
    ID           = 2;
    PanelID      = 2;
    AlarmPanelID = 67;
    OutputID     = 2;
    Name         = "Alarm Output 2";
    HostName     = "Host2";
}
Describe 'Get-AlarmOutput' {

    It 'Result contains expected type name' {
        Mock -ModuleName PSDataConduIT -CommandName Get-WmiObject -Verifiable -MockWith {
            return $Global:TestItems
        }

        $expectedTypeName = "DataConduIT.LnlAlarmOutput"
        $actual = Get-AlarmOutput

        $actual | ForEach-Object {
            $_.pstypenames.contains($expectedTypeName) | Should Be $true
        }

        Assert-VerifiableMock
    }

    It 'Properties are mapped to the expected fields' {

        Mock -ModuleName PSDataConduIT -CommandName Get-WmiObject -ParameterFilter { $Query -eq "SELECT * FROM Lnl_AlarmOutput WHERE __CLASS='Lnl_AlarmOutput'" } -Verifiable -MockWith {
            return $Global:TestItems
        }

        $actual = Get-AlarmOutput

        $actual | ForEach-Object {
            $_ | Should Not BeNullOrEmpty
            $_.AlarmOutputID | Should Not BeNullOrEmpty
            $_.PanelID | Should Not BeNullOrEmpty
            $_.AlarmPanelID | Should Not BeNullOrEmpty
            $_.OutputID | Should Not BeNullOrEmpty
        }

        Assert-VerifiableMock
    }

    It 'Given no parameters executes expected query and returns all alarm outputs' {
        Mock -ModuleName PSDataConduIT -CommandName Get-WmiObject -ParameterFilter { $Query -eq "SELECT * FROM Lnl_AlarmOutput WHERE __CLASS='Lnl_AlarmOutput'" } -Verifiable -MockWith {
            return $Global:TestItems
        }

        $actual = Get-AlarmOutput

        $actual | Should Not BeNullOrEmpty
        $actual | Measure-Object | Select-Object -Expand Count | Should Be 2

        Assert-VerifiableMock
    }

    It 'Given an AlarmOutputID parameter executes expected query and returns a single alarm output' {

        Mock -ModuleName PSDataConduIT -CommandName Get-WmiObject -ParameterFilter { $Query -eq "SELECT * FROM Lnl_AlarmOutput WHERE __CLASS='Lnl_AlarmOutput' AND ID=1" } -Verifiable -MockWith {
            return $Global:TestItems | Where-Object { $_.ID -eq 1 }
        }

        $actual = Get-AlarmOutput -AlarmOutputID 1

        $actual | Should Not BeNullOrEmpty
        $actual | Measure-Object | Select-Object -Expand Count | Should Be 1

        Assert-VerifiableMock
    }

    It 'Given a PanelID parameter executes expected query and returns expected alarm output(s)' {

        Mock -ModuleName PSDataConduIT -CommandName Get-WmiObject -ParameterFilter { $Query -eq "SELECT * FROM Lnl_AlarmOutput WHERE __CLASS='Lnl_AlarmOutput' AND PanelID=1" } -Verifiable -MockWith {
            return $Global:TestItems | Where-Object { $_.PanelID -eq 1 }
        }

        $actual = Get-AlarmOutput -PanelID 1

        $actual | Should Not BeNullOrEmpty
        $actual | Measure-Object | Select-Object -Expand Count | Should Be 1

        Assert-VerifiableMock
    }

    It 'Given an AlarmPanelID parameter executes expected query and returns expected alarm output(s)' {

        Mock -ModuleName PSDataConduIT -CommandName Get-WmiObject -ParameterFilter { $Query -eq "SELECT * FROM Lnl_AlarmOutput WHERE __CLASS='Lnl_AlarmOutput' AND AlarmPanelID=66" } -Verifiable -MockWith {
            return $Global:TestItems | Where-Object { $_.AlarmPanelID -eq 66 }
        }

        $actual = Get-AlarmOutput -AlarmPanelID 66

        $actual | Should Not BeNullOrEmpty
        $actual | Measure-Object | Select-Object -Expand Count | Should Be 1

        Assert-VerifiableMock
    }

    It 'Given an OutputID parameter executes expected query and returns expected alarm output(s)' {

        Mock -ModuleName PSDataConduIT -CommandName Get-WmiObject -ParameterFilter { $Query -eq "SELECT * FROM Lnl_AlarmOutput WHERE __CLASS='Lnl_AlarmOutput' AND OutputID=1" } -Verifiable -MockWith {
            return $Global:TestItems | Where-Object { $_.OutputID -eq 1 }
        }

        $actual = Get-AlarmOutput -OutputID 1

        $actual | Should Not BeNullOrEmpty
        $actual | Measure-Object | Select-Object -Expand Count | Should Be 1

        Assert-VerifiableMock
    }
}