<#
    .SYNOPSIS
    Sets a reader to the specified reader mode.

    .DESCRIPTION   
    Sets a reader to the specified reader mode. If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Set-ReaderMode 
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
        [int]$ReaderID,

		[Parameter(
            Mandatory=$true,
            HelpMessage='The reader mode parameter')]
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

        if($reader -eq $null) {
            Write-Debug -Message "Reader id '$ReaderID' on panel id '$PanelID' does not exist"
            return
        }
        
		$reader.SetReaderMode.Invoke($Mode)

        Write-Verbose -Message ("Reader '{0}' mode set to '{1}'" -f $reader.Name, $Mode)
	}
}