function Get-PanelHardwareStatus
{
    [CmdletBinding()]
    param
    (
        [Parameter(Position=0, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]$Server = $Script:Server,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [PSCredential]$Credential = $Script:Credential,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
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