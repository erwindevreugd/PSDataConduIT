<#
    .SYNOPSIS
    Gets the panel hardware status.

    .DESCRIPTION   
    Gets the panel hardware status for all panels or the hardware status for a single panel if an panel id is specified. If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Get-PanelHardwareStatus
    
    Online
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-PanelHardwareStatus
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
            HelpMessage='The panel id parameter')]
        [int]$PanelID    
    )

    process {
        $parameters = @{
            Server=$Server;
            PanelID=$PanelID
        }

        if($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        $panel = Get-Panel @parameters
		$panel.UpdateHardwareStatus.Invoke()
		
		Write-Verbose -Message "Getting hardware status for panel '$($panel.Name)'"

        $status = $panel.GetHardwareStatus.Invoke().Status

		$panelStatus = [Enum]::GetValues([PanelStatus]) | where { $_ -band [int]$status }

		Write-Output $panelStatus
    }
}