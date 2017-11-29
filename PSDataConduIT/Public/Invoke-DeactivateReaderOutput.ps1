<#
    .SYNOPSIS
    Deactivates a reader output.

    .DESCRIPTION   
    Deactivates a raeder output. 
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Invoke-DeactivateReaderOutput
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
            HelpMessage='The reader output id parameter')]
        [ValidateSet(0,1,2)]
        [int]$ReaderOutputID,

        [switch]$PassThru
    )

    process {
        $parameters = @{
            Server=$Server;
        }

        if($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        if(($readerOutput = Get-ReaderOutput @parameters -PanelID $PanelID -ReaderID $ReaderID -ReaderOutputID $ReaderOutputID) -eq $null) {
            Write-Error -Message ("Reader output id '$($ReaderOutputID)' on reader id '$($ReaderID)' on panel id '$($PanelID)' not found")
            return
        }

        $readerOutput.Deactivate.Invoke() | Out-Null

        Write-Verbose -Message ("Reader output '$($readerOutput.Name)' deactivated")

        if($PassThru) {
            Write-Output $$readerOutput
        }
    }
}