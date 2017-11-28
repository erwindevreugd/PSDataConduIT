<#
    .SYNOPSIS
    Opens an intrusion door.

    .DESCRIPTION   
    Opens an intrusion door. 
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Invoke-OpenIntrusionDoor
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
            Mandatory=$true, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The intrusion door id parameter')]
        [int]$IntrusionDoorID = $null,

        [switch]$PassThru
    )

    process {
        $parameters = @{
            Server=$Server;
        }

        if($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        if(($intrusionDoor = Get-IntrusionDoor @parameters -IntrusionDoorID $IntrusionDoorID) -eq $null) {
            Write-Error -Message ("Intrusion door id '$($IntrusionDoorID)' not found")
            return
        }

		$intrusionDoor.Open.Invoke()

        Write-Verbose -Message ("Intrusion door '$($intrusionDoor.Name)' opened")

        if($PassThru) {
            Write-Output $intrusionDoor
        }
    }
}