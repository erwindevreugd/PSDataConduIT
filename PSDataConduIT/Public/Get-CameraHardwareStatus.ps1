<#
    .SYNOPSIS
    Gets the camera hardware status.

    .DESCRIPTION
    Gets the camera hardware status for all cameras or the hardware status for a single camera if a camera id is specified.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE
    Get-CameraHardwareStatus

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT

    .EXTERNALHELP PSDataConduIT-help.xml
#>
function Get-CameraHardwareStatus {
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
        $CameraID = $null
    )

    process {
        $parameters = @{
            Server = $Server;
        }

        if ($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        if (($cameras = Get-Camera @parameters -CameraID $CameraID) -eq $null) {
            return
        }

        foreach ($camera in $cameras) {
            if (($panel = Get-Panel @parameters -PanelID ($camera.PanelID)) -eq $null) {
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
                $s = [int]($camera.GetHardwareStatus.Invoke().Status)
                $status = MapEnum ([DeviceStatus].AsType()) $s;

                Write-Verbose -Message ("Camera '$($camera.Name)' status is '$($status)'")
            }
            catch {
                Write-Warning -Message ("Failed to get hardware status for camera '$($camera.Name)'")
            }

            New-Object PSObject -Property @{
                Name   = $camera.Name;
                Status = $status;
                Panel  = $panel.Name;
            } | Add-ObjectType -TypeName "DataConduIT.LnlCameraHardwareStatus"
        }
    }
}