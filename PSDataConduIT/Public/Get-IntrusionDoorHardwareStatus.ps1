<#
    .SYNOPSIS
    Gets the intrusion door hardware status.

    .DESCRIPTION
    Gets the intrusion door hardware status for all intrusion doors or the hardware status for a single intrusion door if an intrusion door id is specified.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE
    Get-IntrusionDoorHardwareStatus

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT

    .EXTERNALHELP PSDataConduIT-help.xml
#>
function Get-IntrusionDoorHardwareStatus {
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
            HelpMessage = 'Specifies the id of the intrusion door for which to get the hardware status.')]
        [int]
        $IntrusionDoorID = $null
    )

    process {
        $parameters = @{
            Server = $Server;
        }

        if ($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        if (($intrusionDoors = Get-IntrusionDoor @parameters -IntrusionDoorID $IntrusionDoorID) -eq $null) {
            return
        }

        foreach ($intrusionDoor in $intrusionDoors) {
            if (($panel = Get-Panel @parameters -PanelID ($intrusionDoor.PanelID)) -eq $null) {
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
                $s = [int]($intrusionDoor.GetHardwareStatus.Invoke().Status)
                $status = MapEnum ([DeviceStatus].AsType()) $s;

                Write-Verbose -Message ("Intrusion door '$($intrusionDoor.Name)' status is '$($status)'")
            }
            catch {
                Write-Warning -Message ("Failed to get hardware status for intrusion door '$($intrusionDoor.Name)'")
            }

            New-Object PSObject -Property @{
                Name   = $intrusionDoor.Name;
                Status = $status;
                Panel  = $panel.Name;
            } | Add-ObjectType -TypeName "DataConduIT.LnlIntrusionDoorHardwareStatus"
        }
    }
}