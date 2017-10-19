function Get-ReaderHardwareStatus
{
    [CmdletBinding()]
    param
    (
        [Parameter(Position=0, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]$Server = $Script:Server,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [PSCredential]$Credential = $Script:Credential,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int]$PanelID,
		
		[Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int]$ReaderID   
    )

    process {
        $parameters = @{
            Server=$Server;
        }

        if($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        $panel = Get-Panel @parameters -PanelID $PanelID
		$panel.UpdateHardwareStatus.Invoke()

		$reader = Get-Reader @parameters -PanelID $PanelID -ReaderID $ReaderID

        Write-Verbose -Message "Getting hardware status for reader '$($reader.Name)'"

        $status = $reader.GetHardwareStatus.Invoke().Status

		$readerStatus = [Enum]::GetValues([ReaderStatus]) | where { $_ -band [int]$status } 	

		Write-Output $readerStatus
    }
}