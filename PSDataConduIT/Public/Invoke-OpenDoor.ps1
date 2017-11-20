<#
    .SYNOPSIS
    Opens a door.

    .DESCRIPTION   
    Opens a door .If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Invoke-OpenDoor
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

        [switch]$PassThru
    )

    process {
        $parameters = @{
            Server=$Server;
        }

        if($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        if(($reader = Get-Reader @parameters -PanelID $PanelID -ReaderID $ReaderID) -eq $null) {
            Write-Error -Message ("Reader id '$($ReaderID)' on panel id '$($PanelID)' not found")
            return
        }

		$reader.OpenDoor.Invoke()

        Write-Verbose -Message ("Door reader '$($reader.Name)' opened")

        if($PassThru) {
            Write-Output $reader
        }
    }
}