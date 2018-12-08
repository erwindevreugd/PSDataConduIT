<#
    .SYNOPSIS
    Pulses an alarm output.

    .DESCRIPTION
    Pulses an alarm output.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Invoke-PulseAlarmOutput {
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
            HelpMessage = 'The panel id parameter.')]
        [int]
        $PanelID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The alarm panel id parameter.')]
        [int]
        $AlarmPanelID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The output id parameter.')]
        [int]
        $OutputID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The alarm output id parameter.')]
        [int]
        $AlarmOutputID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $false,
            HelpMessage = 'Returns an object that represents the alarm output. By default, this cmdlet does not generate any output.')]
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

        if (($alarmOutputs = Get-AlarmOutput @parameters -PanelID $PanelID -AlarmPanelID $AlarmPanelID -OutputID $OutputID -AlarmOutputID $AlarmOutputID) -eq $null) {
            Write-Verbose -Message ("No alarm outputs found")
            return
        }

        foreach ($alarmOutput in $alarmOutputs) {
            $alarmOutput.Pulse.Invoke() | Out-Null

            Write-Verbose -Message ("Alarm output '$($alarmOutput.Name)' pulsed")

            if ($PassThru) {
                Write-Output $$alarmOutput
            }
        }
    }
}