function Invoke-UpdateHardwareStatus
{
    [CmdletBinding()]
    param
    (
        [Parameter(Position=0, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]$Server = $Script:Server,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [PSCredential]$Credential = $Script:Credential,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
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

		$panel.UpdateHardwareStatus.Invoke()

        Write-Verbose -Message "Updated hardware status for panel '$($panel.Name)'"
    }
}