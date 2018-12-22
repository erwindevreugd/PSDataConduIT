<#
    .SYNOPSIS
    Gets the intrusion area hardware status.

    .DESCRIPTION
    Gets the intrusion area hardware status for all intrusion areas or the hardware status for a single intrusion area if an intrusion area id is specified.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE
    Get-IntrusionAreaHardwareStatus

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT

    .EXTERNALHELP PSDataConduIT-help.xml
#>
function Get-IntrusionAreaHardwareStatus {
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
            HelpMessage = 'Specifiest the id of the intrusion area for which to get the hardware status.')]
        [int]
        $IntrusionAreaID = $null
    )

    process {
        $parameters = @{
            Server = $Server;
        }

        if ($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        if (($intrusionAreas = Get-IntrusionArea @parameters -IntrusionAreaID $IntrusionAreaID) -eq $null) {
            return
        }

        foreach ($intrusionArea in $intrusionAreas) {
            if (($panel = Get-Panel @parameters -PanelID ($intrusionArea.PanelID)) -eq $null) {
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
                $s = [int]($intrusionArea.GetHardwareStatus.Invoke().Status)
                $status = MapEnum ([DeviceStatus].AsType()) $s;

                Write-Verbose -Message ("Intrusion area '$($intrusionArea.Name)' status is '$($status)'")
            }
            catch {
                Write-Warning -Message ("Failed to get hardware status for intrusion area '$($intrusionArea.Name)'")
            }

            New-Object PSObject -Property @{
                Name   = $intrusionArea.Name;
                Status = $status;
                Panel  = $panel.Name;
            } | Add-ObjectType -TypeName "DataConduIT.LnlIntrusionAreaHardwareStatus"
        }
    }
}