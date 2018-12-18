<#
    .SYNOPSIS
    Unmasks an alarm input.

    .DESCRIPTION
    Unmasks an alarm input.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Invoke-UnmaskAlarmInput {
    [CmdletBinding()]
    param
    (
        [Parameter(
            Position = 0,
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The name of the server where the DataConduIT service is running or localhost.')]
        [string]
        $Server = $Script:Server,

        [Parameter(
            Position = 1,
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The credentials used to authenticate the user to the DataConduIT service.')]
        [PSCredential]
        $Credential = $Script:Credential,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the panel id of the alarm input(s) to unmask.')]
        [int]
        $PanelID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the alarm panel id of the alarm input(s) to unmask.')]
        [int]
        $AlarmPanelID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the input id of the alarm input(s) to unmask.')]
        [int]
        $InputID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the alarm input id of the alarm input(s) to unmask.')]
        [int]
        $AlarmInputID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $false,
            HelpMessage = 'Returns an object that represents the alarm input. By default, this cmdlet does not generate any output.')]
        [switch]
        $PassThru
    )

    process {
        $parameters = @{
            Server = $Server;
        }

        if ($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        if (($alarmInputs = Get-AlarmInput @parameters -PanelID $PanelID -AlarmPanelID $AlarmPanelID -InputID $InputID -AlarmInputID $AlarmInputID) -eq $null) {
            Write-Verbose -Message ("No alarm inputs found")
            return
        }

        foreach ($alarmInput in $alarmInputs) {
            $alarmInput.Unmask.Invoke() | Out-Null

            Write-Verbose -Message ("Alarm input '$($alarmInput.Name)' unmasked")

            if ($PassThru) {
                Write-Output $$alarmInput
            }
        }
    }
}