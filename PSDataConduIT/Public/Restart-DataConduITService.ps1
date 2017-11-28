<#
    .SYNOPSIS
    Restarts the DataConduIT service.

    .DESCRIPTION   
    Restarts the DataConduIT service. 
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Restart-DataConduITService
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Restart-DataConduITService
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

        [switch]$PassThru
    )

    process {   
        if(($service = Get-DataConduITService -Server $Server -Credential $Credential) -eq $null) {
            Write-Error -Message ("DataConduIT service not found on server '$($Server)'")
            return
        }

        $service | Stop-DataConduITService -PassThru | Start-DataConduITService

        if($PassThru) {
            Get-DataConduITService -Server $Server -Credential $Credential
        }
    }
}