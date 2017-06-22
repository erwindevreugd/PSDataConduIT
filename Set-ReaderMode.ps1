function Set-ReaderMode 
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
        [int]$ReaderID,

		[Parameter(Mandatory=$true)]
		[ReaderMode]$Mode
	)

	process {
		$parameters = @{
            Server=$Server;
        }

        if($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        $reader = Get-Reader @parameters -PanelID $PanelID -ReaderID $ReaderID
		$reader.SetReaderMode.Invoke($Mode)

        Write-Verbose -Message ("Reader '{0}' mode set to '{1}'" -f $reader.Name, $Mode)
	}
}