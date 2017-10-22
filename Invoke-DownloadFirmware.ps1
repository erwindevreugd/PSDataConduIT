<#
    .SYNOPSIS
    Downloads firmware to the specified panel.

    .DESCRIPTION   
    Downloads firmware to the specified panel. If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Invoke-DownloadFirmware
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
        [int]$PanelID    
    )

    process {
        $parameters = @{
            Server=$Server;
            PanelID=$PanelID;
        }

        if($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        $panel = Get-Panel @parameters

        if($panel -eq $null) {
            Write-Debug -Message "Panel id '$PanelID' does not exist"
            return
        }
        
		$panel.DownloadFirmware.Invoke()

        Write-Verbose -Message "Downloaded firmware to panel '$($panel.Name)'"
    }
}