<#
    .SYNOPSIS
    Sets the panel clock.

    .DESCRIPTION   
    Sets the panel clock. 
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Invoke-SetClock
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
            HelpMessage='The panel id parameter')]
        [int]$PanelID,

        [switch]$PassThru
    )

    process {
        $parameters = @{
            Server=$Server;
            PanelID=$PanelID;
        }

        if($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        if(($panel = Get-Panel @parameters) -eq $null) {
            Write-Error -Message ("Panel id '$($PanelID)' not found")
            return
        }
        
		$panel.SetClock.Invoke() | Out-Null

        Write-Verbose -Message ("Set clock on panel '$($panel.Name)'")

        if($PassThru) {
            Write-Output $panel
        }
    }
}