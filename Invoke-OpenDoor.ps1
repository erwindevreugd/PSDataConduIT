function Invoke-OpenDoor
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

        $reader = Get-Reader @parameters -PanelID $PanelID -ReaderID $ReaderID

        if($reader -eq $null) {
            Write-Debug -Message "Reader id '$ReaderID' on panel id '$PanelID' does not exist"
            return
        }

		$reader.OpenDoor.Invoke()

        Write-Verbose -Message ("Door opened '{0}'" -f $reader.Name)
    }
}