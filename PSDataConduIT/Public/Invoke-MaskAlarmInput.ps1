<#
    .SYNOPSIS
    Masks an alarm input.

    .DESCRIPTION
    Masks an alarm input.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Invoke-MaskAlarmInput {
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
            HelpMessage = 'Specifies the panel id of the alarm input(s) to mask.')]
        [int]
        $PanelID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the alarm panel id of the alarm input(s) to mask.')]
        [int]
        $AlarmPanelID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the input id of the alarm input(s) to mask.')]
        [int]
        $InputID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the alarm input id of the alarm input to mask.')]
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
            $alarmInput.Mask.Invoke() | Out-Null

            Write-Verbose -Message ("Alarm input '$($alarmInput.Name)' masked")

            if ($PassThru) {
                Write-Output $$alarmInput
            }
        }
    }
}