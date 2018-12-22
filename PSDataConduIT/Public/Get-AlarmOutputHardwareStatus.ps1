<#
    .SYNOPSIS
    Gets the alarm output hardware status.

    .DESCRIPTION
    Gets the alarm output hardware status for all alarm output or the hardware status for a single alarm output if an alarm panel id is specified.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE
    Get-AlarmOutputHardwareStatus

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT

    .EXTERNALHELP PSDataConduIT-help.xml
#>
function Get-AlarmOutputHardwareStatus {
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
            HelpMessage = 'Specifies the panel id of the alarm output(s) for which to get the hardware status.')]
        [int]
        $PanelID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the alarm panel id of the alarm output(s) for which to get the hardware status.')]
        [int]
        $AlarmPanelID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the output id of the alarm output(s) for which to get the hardware status.')]
        [int]
        $OutputID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the alarm output id of the alarm output for which to get the hardware status.')]
        [int]
        $AlarmOutputID
    )

    process {
        $parameters = @{
            Server = $Server;
        }

        if ($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        if (($alarmOutputs = Get-AlarmOutput @parameters -PanelID $PanelID -AlarmPanelID $AlarmPanelID -OutputID $OutputID -AlarmOutputID $AlarmOutputID) -eq $null) {
            return
        }

        foreach ($alarmOutput in $alarmOutputs) {
            if (($panel = Get-Panel @parameters -PanelID ($alarmOutput.PanelID)) -eq $null) {
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
                $s = [int]($alarmOutput.GetHardwareStatus.Invoke().Status)
                $status = MapEnum ([OutputStatus].AsType()) $s

                Write-Verbose -Message ("Alarm Panel '$($alarmOutput.Name)' status is '$($status)'")
            }
            catch {
                Write-Warning -Message ("Failed to get hardware status for alarm output '$($alarmOutput.Name)'")
            }

            New-Object PSObject -Property @{
                Name   = $alarmOutput.Name;
                Status = $status;
                Panel  = $panel.Name;
            } | Add-ObjectType -TypeName "DataConduIT.LnlAlarmOutputHardwareStatus"
        }
    }
}