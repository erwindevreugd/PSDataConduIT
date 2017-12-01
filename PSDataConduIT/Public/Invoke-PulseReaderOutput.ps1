<#
    .SYNOPSIS
    Pulses a reader output.

    .DESCRIPTION   
    Pulses a raeder output. 
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Invoke-PulseReaderOutput
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
        [int]$ReaderID,

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

        if(($readerOutputs = Get-ReaderOutput @parameters -PanelID $PanelID -ReaderID $ReaderID -ReaderOutputID $ReaderOutputID) -eq $null) {
            Write-Verbose -Message ("No reader outputs found")
            return
        }

        foreach($readerOutput in $readerOutputs) {
            $readerOutput.Pulse.Invoke() | Out-Null
            
            Write-Verbose -Message ("Reader output '$($readerOutput.Name)' pulsed")
    
            if($PassThru) {
                Write-Output $$readerOutput
            }
        }
    }
}