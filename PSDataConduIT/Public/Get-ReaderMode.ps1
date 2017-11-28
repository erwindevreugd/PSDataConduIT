<#
    .SYNOPSIS
    Gets reader mode.

    .DESCRIPTION   
    Gets the reader mode for all readers or the reader mode for a single reader if a panel id and reader id is specified. 
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Get-ReaderMode
    
    PanelID       ReaderID      Name                 Mode
    -------       --------      ----                 ----
    1             1             Reader 1             CardOnly
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-ReaderMode 
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

        [Parameter(
            Mandatory=$true, 
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

        if(($panel = Get-Panel @parameters -PanelID $PanelID) -eq $null) {
            Write-Error -Message ("Panel id '$($PanelID)' was not found")
            return
        }

        # Update panel hardware status so we can get the current reader mode
        $panel | Invoke-UpdateHardwareStatus

        if(($reader = Get-Reader @parameters -PanelID $PanelID -ReaderID $ReaderID) -eq $null) {
            Write-Error -Message ("Reader id '$($ReaderID)' on panel id '$($PanelID)' was not found")
            return
        }

		$mode = MapEnum ([ReaderMode].AsType()) $reader.GetReaderMode.Invoke().Mode

        Write-Verbose -Message ("Reader '$($reader.Name)' on Panel '$($panel.Name)' reader mode is '$($mode)'")

        New-Object PSObject -Property @{
            PanelID=$PanelID;
            ReaderID=$ReaderID;
            Name=$reader.Name;
            Mode=$mode;
        } | Add-ObjectType -TypeName "DataConduIT.LnlReaderMode"
	}
}