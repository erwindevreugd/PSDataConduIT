<#
    .SYNOPSIS
    Gets reader hardware status.

    .DESCRIPTION   
    Gets reader hardware status for all readers or the reader hardware status for a single reader if a panel id and reader id are specified. If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Get-ReaderHardwareStatus
    
    Online
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-ReaderHardwareStatus
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
        [int]$PanelID,
		
		[Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The reader id parameter')]
        [int]$ReaderID   
    )

    process {
        $parameters = @{
            Server=$Server;
        }

        if($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        if(($panels = Get-Panel @parameters -PanelID $PanelID) -eq $null) {
            return
        }

        if(($readers = Get-Reader @parameters -PanelID $PanelID -ReaderID $ReaderID) -eq $null) {
            return
        }

        foreach($panel in $panels) {
            try {
                Write-Verbose -Message "Updating hardware status for panel '$($panel.Name)'"
                $panel.UpdateHardwareStatus.Invoke() | Out-Null
            }
            catch {
                Write-Warning -Message ("Failed to update hardware status for panel '$($panel.Name)'")
            }
        }	

        foreach($reader in $readers) {
            try {
                $status = $reader.GetHardwareStatus.Invoke().Status
                $readerStatus = [Enum]::GetValues([ReaderStatus]) | Where-Object { $_ -band [int]$status } 	

                Write-Verbose -Message ("Reader '$($reader.Name)' status is '$($readerStatus)'")
            } 
            catch {
            }

            New-Object PSObject -Property @{
                Name=$reader.Name;
                Status=$readerStatus;
            } | Add-ObjectType -TypeName "DataConduIT.LnlReaderHardwareStatus"
        }
    }
}