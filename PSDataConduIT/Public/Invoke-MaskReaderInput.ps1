<#
    .SYNOPSIS
    Masks a reader input.

    .DESCRIPTION   
    Masks a raeder input. If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Invoke-MaskReaderInput
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
        [int]$PanelID = $null,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The reader id parameter')]
        [int]$ReaderID = $null,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The reader input id parameter')]
        [ValidateSet(0,1,2)]
        [int]$ReaderInputID,

        [switch]$PassThru
    )

    process {
        $parameters = @{
            Server=$Server;
        }

        if($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        if(($readerInput = Get-ReaderInput @parameters -PanelID $PanelID -ReaderID $ReaderID -ReaderInputID $ReaderInputID) -eq $null) {
            Write-Error -Message ("Reader input id '$($ReaderOutputID)' on reader id '$($ReaderID)' on panel id '$($PanelID)' not found")
            return
        }

		$readerInput.Mask.Invoke()

        Write-Verbose -Message ("Reader input '$($readerInput.Name)' masked")

        if($PassThru) {
            Write-Output $$readerInput
        }
    }
}