function Get-ReaderMode 
{
	[CmdletBinding()]
	param
	(
		[Parameter(Position=0, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]$Server = $Script:Server,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [PSCredential]$Credential = $Script:Credential,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [int]$PanelID,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [int]$ReaderID
	)

	process {
		$parameters = @{
            Server=$Server;
        }

        if($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }
		
		# Update panel hardware status so we can get the current reader mode
		Get-Panel @parameters -PanelID $PanelID | Invoke-UpdateHardwareStatus

        $reader = Get-Reader @parameters -PanelID $PanelID -ReaderID $ReaderID
		$mode = MapEnum ([ReaderMode].AsType()) $reader.GetReaderMode.Invoke().Mode

        Write-Verbose -Message ("Reader '{0}' mode is '{1}'" -f $reader.Name, $mode)

		Write-Output $mode
	}
}