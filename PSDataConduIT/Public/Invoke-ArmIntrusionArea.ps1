<#
    .SYNOPSIS
    Arms the intrusion area.

    .DESCRIPTION   
    Arms the intrusion area.
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Invoke-ArmIntrusionArea
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-ArmIntrusionArea
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
        [int]$IntrusionAreaID = $null,

        [Parameter(
            Mandatory=$true, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The intrusion arm method parameter')]
        [ArmState]$Method = $null
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
            $intrusionArea.Arm.Invoke($Method) | Out-Null
        }
    }
}