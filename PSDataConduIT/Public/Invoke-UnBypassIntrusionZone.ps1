<#
    .SYNOPSIS
    Unbypasses an intrusion zone.

    .DESCRIPTION   
    Unbypasses an intrusion zone.
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Invoke-UnBypassIntrusionZone
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Invoke-UnBypassIntrusionZone
{
    [CmdletBinding()]
    param
    (
        [Parameter(
            Position=0, 
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The name of the server where the DataConduIT service is running or localhost')]
        [string]$Server = $Script:Server,
        
        [Parameter(
            Position=1,
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The credentials used to authenticate the user to the DataConduIT service')]
        [PSCredential]$Credential = $Script:Credential,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The intrusion zone id parameter')]
        [int]$IntrusionZoneID
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
            $intrusionZone.UnBypass.Invoke() | Out-Null
            
            Write-Verbose -Message ("Intrusion zone '$($intrusionZone.Name)' unbypassed")
    
            if($PassThru) {
                Write-Output $intrusionZone
            }
        }
    }
}