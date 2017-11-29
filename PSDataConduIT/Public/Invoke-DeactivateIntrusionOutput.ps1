<#
    .SYNOPSIS
    Deactivates an intrusion output.

    .DESCRIPTION   
    Deactivates an intrusion output. 
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Invoke-DeactivateIntrusionOutput
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Invoke-DeactivateIntrusionOutput
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
            HelpMessage='The intrusion output id parameter')]
        [int]$IntrusionOutputID = $null
    )

    process { 
        $parameters = @{
            Server=$Server;
        }

        if($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        if(($intrusionOutput = Get-IntrusionOutput @parameters -IntrusionOutputID $IntrusionOutputID) -eq $null) {
            Write-Error -Message ("Intrusion output id '$($IntrusionOutputID)' not found")
            return
        }

        $intrusionOutput.Deactivate.Invoke() | Out-Null

        Write-Verbose -Message ("Intrusion output '$($intrusionOutput.Name)' deactivated")

        if($PassThru) {
            Write-Output $intrusionOutput
        }
    }
}