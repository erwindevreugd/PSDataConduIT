<#
    .SYNOPSIS
    Gets the alarm input hardware status.

    .DESCRIPTION
    Gets the alarm input hardware status for all alarm input or the hardware status for a single alarm input if an alarm panel id is specified.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE
    Get-AlarmInputHardwareStatus

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT

    .EXTERNALHELP PSDataConduIT-help.xml
#>
function Get-AlarmInputHardwareStatus {
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
            HelpMessage = 'Specifies the panel id of the alarm input(s) for which to get the hardware status.')]
        [int]
        $PanelID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the alarm panel id of the alarm input(s) for which to get the hardware status.')]
        [int]
        $AlarmPanelID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the input id of the alarm input(s) for which to get the hardware status.')]
        [int]
        $InputID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the alarm input id of the alarm input for which to get the hardware status.')]
        [int]
        $AlarmInputID
    )

    process {
        $parameters = @{
            Server = $Server;
        }

        if ($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        if (($alarmInputs = Get-AlarmInput @parameters -PanelID $PanelID -AlarmPanelID $AlarmPanelID -InputID $InputID -AlarmInputID $AlarmInputID) -eq $null) {
            return
        }

        foreach ($alarmInput in $alarmInputs) {
            if (($panel = Get-Panel @parameters -PanelID ($alarmInput.PanelID)) -eq $null) {
                continue
            }

            try {
                Write-Verbose -Message "Updating hardware status for panel '$($panel.Name)'"
                $panel.UpdateHardwareStatus.Invoke() | Out-Null
            }
            catch {
                Write-Warning -Message ("Failed to update hardware status for panel '$($panel.Name)'")
            }

            try {
                $s = [int]($alarmInput.GetHardwareStatus.Invoke().Status)
                $status = MapEnum ([InputStatus].AsType()) $s

                Write-Verbose -Message ("Alarm input '$($alarmInput.Name)' status is '$($status)'")
            }
            catch {
                Write-Warning -Message ("Failed to get hardware status for alarm input '$($alarmInput.Name)'")
            }

            New-Object PSObject -Property @{
                Name   = $alarmInput.Name;
                Status = $status;
                Panel  = $panel.Name;
            } | Add-ObjectType -TypeName "DataConduIT.LnlAlarmInputHardwareStatus"
        }
    }
}