<#
    .SYNOPSIS
    Disarms the intrusion area.

    .DESCRIPTION   
    Disarms the intrusion area.
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Invoke-DisarmIntrusionArea
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-DisarmIntrusionArea
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
            HelpMessage='The intrusion area id parameter')]
        [int]$IntrusionAreaID = $null
    )

    process {
        $parameters = @{
            Server=$Server;
        }

        if($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        if(($intrusionAreas = Get-IntrusionArea @parameters -IntrusionAreaID $IntrusionAreaID) -eq $null) {
            return
        }

        foreach($intrusionArea in $intrusionAreas) {
            $intrusionArea.Disarm.Invoke() | Out-Null
        }
    }
}