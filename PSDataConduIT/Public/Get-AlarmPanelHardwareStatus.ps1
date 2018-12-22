<#
    .SYNOPSIS
    Gets the alarm panel hardware status.

    .DESCRIPTION
    Gets the alarm panel hardware status for all alarm panels or the hardware status for a single alarm panel if a panel id and an alarm panel id is specified.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE
    Get-AlarmPanelHardwareStatus

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT

    .EXTERNALHELP PSDataConduIT-help.xml
#>
function Get-AlarmPanelHardwareStatus {
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
            HelpMessage = 'Specifies the panel id of the alarm panel(s) for which to get the hardware status.')]
        [int]
        $PanelID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the alarm panel id of the alarm panel(s) for which to get the hardware status.')]
        [int]
        $AlarmPanelID
    )

    process {
        $parameters = @{
            Server = $Server;
        }

        if ($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        if (($alarmPanels = Get-AlarmPanel @parameters -PanelID $PanelID -AlarmPanelID $AlarmPanelID) -eq $null) {
            return
        }

        foreach ($alarmPanel in $alarmPanels) {
            if (($panel = Get-Panel @parameters -PanelID ($alarmPanel.PanelID)) -eq $null) {
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
                $status = $alarmPanel.GetHardwareStatus.Invoke().Status
                $panelStatus = [Enum]::GetValues([PanelStatus]) | Where-Object { $_ -band [int]$status }

                Write-Verbose -Message ("Alarm Panel '$($alarmPanel.Name)' status is '$($panelStatus)'")
            }
            catch {
                Write-Warning -Message ("Failed to get hardware status for alarm panel '$($alarmPanel.Name)'")
            }

            New-Object PSObject -Property @{
                Name   = $alarmPanel.Name;
                Status = $panelStatus;
                Panel  = $panel.Name;
            } | Add-ObjectType -TypeName "DataConduIT.LnlAlarmPanelHardwareStatus"
        }
    }
}