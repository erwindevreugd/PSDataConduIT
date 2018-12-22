Import-Module $PSScriptRoot\..\PSDataConduIT -Force

$Global:TestItems =
[PSObject][ordered]@{
    __CLASS      = "Lnl_AlarmInput";
    __SUPERCLASS = "Lnl_Element";
    __SERVER     = "localhost";
    __PATH       = "\\localhost\root\onguard:Lnl_AlarmInput.ID=1"
    ID           = 1;
    PanelID      = 1;
    AlarmPanelID = 66;
    InputID      = 1;
    Name         = "Alarm Input 1";
    HostName     = "Host1";
},
[PSObject][ordered]@{
    __CLASS      = "Lnl_AlarmInput";
    __SUPERCLASS = "Lnl_Element";
    __SERVER     = "localhost";
    __PATH       = "\\localhost\root\onguard:Lnl_AlarmInput.ID=2"
    ID           = 2;
    PanelID      = 2;
    AlarmPanelID = 67;
    InputID      = 2;
    Name         = "Alarm Input 2";
    HostName     = "Host2";
}
Describe 'Get-AlarmInput' {

    It 'Result contains expected type name' {
        Mock -ModuleName PSDataConduIT -CommandName Get-WmiObject -Verifiable -MockWith {
            return $Global:TestItems
        }

        $expectedTypeName = "DataConduIT.LnlAlarmInput"
        $actual = Get-AlarmInput

        $actual | ForEach-Object {
            $_.pstypenames.contains($expectedTypeName) | Should Be $true
        }

        Assert-VerifiableMock
    }

    It 'Properties are mapped to the expected fields' {

        Mock -ModuleName PSDataConduIT -CommandName Get-WmiObject -ParameterFilter { $Query -eq "SELECT * FROM Lnl_AlarmInput WHERE __CLASS='Lnl_AlarmInput'" } -Verifiable -MockWith {
            return $Global:TestItems
        }

        $actual = Get-AlarmInput

        $actual | ForEach-Object {
            $_ | Should Not BeNullOrEmpty
            $_.AlarmInputID | Should Not BeNullOrEmpty
            $_.PanelID | Should Not BeNullOrEmpty
            $_.AlarmPanelID | Should Not BeNullOrEmpty
            $_.InputID | Should Not BeNullOrEmpty
        }

        Assert-VerifiableMock
    }

    It 'Given no parameters executes expected query and returns all alarm inputs' {
        Mock -ModuleName PSDataConduIT -CommandName Get-WmiObject -ParameterFilter { $Query -eq "SELECT * FROM Lnl_AlarmInput WHERE __CLASS='Lnl_AlarmInput'" } -Verifiable -MockWith {
            return $Global:TestItems
        }

        $actual = Get-AlarmInput

        $actual | Should Not BeNullOrEmpty
        $actual | Measure-Object | Select-Object -Expand Count | Should Be 2

        Assert-VerifiableMock
    }

    It 'Given an AlarmInputID parameter executes expected query and returns a single alarm input' {

        Mock -ModuleName PSDataConduIT -CommandName Get-WmiObject -ParameterFilter { $Query -eq "SELECT * FROM Lnl_AlarmInput WHERE __CLASS='Lnl_AlarmInput' AND ID=1" } -Verifiable -MockWith {
            return $Global:TestItems | Where-Object { $_.ID -eq 1 }
        }

        $actual = Get-AlarmInput -AlarmInputID 1

        $actual | Should Not BeNullOrEmpty
        $actual | Measure-Object | Select-Object -Expand Count | Should Be 1

        Assert-VerifiableMock
    }

    It 'Given a PanelID parameter executes expected query and returns expected alarm input(s)' {

        Mock -ModuleName PSDataConduIT -CommandName Get-WmiObject -ParameterFilter { $Query -eq "SELECT * FROM Lnl_AlarmInput WHERE __CLASS='Lnl_AlarmInput' AND PanelID=1" } -Verifiable -MockWith {
            return $Global:TestItems | Where-Object { $_.PanelID -eq 1 }
        }

        $actual = Get-AlarmInput -PanelID 1

        $actual | Should Not BeNullOrEmpty
        $actual | Measure-Object | Select-Object -Expand Count | Should Be 1

        Assert-VerifiableMock
    }

    It 'Given an AlarmPanelID parameter executes expected query and returns expected alarm input(s)' {

        Mock -ModuleName PSDataConduIT -CommandName Get-WmiObject -ParameterFilter { $Query -eq "SELECT * FROM Lnl_AlarmInput WHERE __CLASS='Lnl_AlarmInput' AND AlarmPanelID=66" } -Verifiable -MockWith {
            return $Global:TestItems | Where-Object { $_.AlarmPanelID -eq 66 }
        }

        $actual = Get-AlarmInput -AlarmPanelID 66

        $actual | Should Not BeNullOrEmpty
        $actual | Measure-Object | Select-Object -Expand Count | Should Be 1

        Assert-VerifiableMock
    }

    It 'Given an InputID parameter executes expected query and returns expected alarm input(s)' {

        Mock -ModuleName PSDataConduIT -CommandName Get-WmiObject -ParameterFilter { $Query -eq "SELECT * FROM Lnl_AlarmInput WHERE __CLASS='Lnl_AlarmInput' AND InputID=1" } -Verifiable -MockWith {
            return $Global:TestItems | Where-Object { $_.InputID -eq 1 }
        }

        $actual = Get-AlarmInput -InputID 1

        $actual | Should Not BeNullOrEmpty
        $actual | Measure-Object | Select-Object -Expand Count | Should Be 1

        Assert-VerifiableMock
    }
}