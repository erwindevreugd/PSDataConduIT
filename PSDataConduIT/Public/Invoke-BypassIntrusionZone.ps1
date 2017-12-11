<#
    .SYNOPSIS
    Bypasses an intrusion zone.

    .DESCRIPTION   
    Bypasses an intrusion zone.
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Invoke-BypassIntrusionZone
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Invoke-BypassIntrusionZone
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
        [int]$IntrusionZoneID,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$false,
            HelpMessage='Returns an object that represents the intrusion zone. By default, this cmdlet does not generate any output.')]
        [switch]$PassThru
    )

    process { 
        $parameters = @{
            Server=$Server;
        }

        if($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        if(($intrusionZones = Get-IntrusionZone @parameters -IntrusionZoneID $IntrusionZoneID) -eq $null) {
            Write-Verbose -Message ("No intrusion zones found")
            return
        }

        foreach($intrusionZone in $intrusionZones) {
            $intrusionZone.Bypass.Invoke() | Out-Null
    
            Write-Verbose -Message ("Intrusion zone '$($intrusionZone.Name)' bypassed")
    
            if($PassThru) {
                Write-Output $intrusionZone
            }
        }
    }
}