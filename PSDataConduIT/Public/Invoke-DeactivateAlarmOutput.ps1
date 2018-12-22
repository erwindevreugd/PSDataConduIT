<#
    .SYNOPSIS
    Deactivates an alarm output.

    .DESCRIPTION
    Deactivates an alarm output.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT

    .EXTERNALHELP PSDataConduIT-help.xml
#>
function Invoke-DeactivateAlarmOutput {
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
            HelpMessage = 'Specifies the panel id of the alarm output(s) to deactivate.')]
        [int]
        $PanelID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the alarm panel id of the alarm output(s) to deactivate.')]
        [int]
        $AlarmPanelID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the output id of the alarm output(s) to deactivate.')]
        [int]
        $OutputID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'TSpecifies the alarm output id of the alarm output(s) to deactivate.')]
        [int]
        $AlarmOutputID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $false,
            HelpMessage = 'Returns an object that represents the alarm output. By default, this cmdlet does not generate any output.')]
        [switch]$PassThru
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
            $alarmOutput.Deactivate.Invoke() | Out-Null

            Write-Verbose -Message ("Alarm output '$($alarmOutput.Name)' deactivated")

            if ($PassThru) {
                Write-Output $$alarmOutput
            }
        }
    }
}