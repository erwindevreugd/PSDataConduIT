<#
    .SYNOPSIS
    Gets the intrusion zone hardware status.

    .DESCRIPTION   
    Gets the intrusion zone hardware status for all intrusion zone or the hardware status for a single intrusion zone if an intrusion zone id is specified. 
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Get-IntrusionZoneHardwareStatus
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-IntrusionZoneHardwareStatus
{
    [CmdletBinding()]
    param
    (
        [Parameter(
            Position=0, 
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The name of the server where the DataConduIT service is running or localhost.')]
        [string]$Server = $Script:Server,
        
        [Parameter(
            Position=1,
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The credentials used to authenticate the user to the DataConduIT service.')]
        [PSCredential]$Credential = $Script:Credential,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The intrusion zone id parameter.')]
        [int]$IntrusionZoneID = $null
    )

    process {
        $parameters = @{
            Server=$Server;
        }

        if($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        if(($intrusionZones = Get-IntrusionZone @parameters -IntrusionZoneID $IntrusionZoneID) -eq $null) {
            return
        }

        foreach($intrusionZone in $intrusionZones) {
            if(($panel = Get-Panel @parameters -PanelID ($intrusionZone.PanelID)) -eq $null) {
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
                $s = [int]($intrusionZone.GetHardwareStatus.Invoke().Status)
                $status = MapEnum ([DeviceStatus].AsType()) $s;
    
                Write-Verbose -Message ("Intrusion zone '$($intrusionZone.Name)' status is '$($status)'")
            }
            catch {
                Write-Warning -Message ("Failed to get hardware status for intrusion zone '$($intrusionZone.Name)'")
            }
            
            New-Object PSObject -Property @{
                Name=$intrusionZone.Name;
                Status=$status;
                Panel=$panel.Name;
            } | Add-ObjectType -TypeName "DataConduIT.LnlIntrusionZoneHardwareStatus"
        }
    }
}