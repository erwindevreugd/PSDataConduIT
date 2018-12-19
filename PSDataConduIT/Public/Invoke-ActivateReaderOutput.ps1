<#
    .SYNOPSIS
    Activates a reader output.

    .DESCRIPTION
    Activates a reader output.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT

    .EXTERNALHELP PSDataConduIT-help.xml
#>
function Invoke-ActivateReaderOutput {
    [CmdletBinding()]
    param
    (
        [Parameter(
            Position = 0,
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The name of the server where the DataConduIT service is running or localhost.')]
        [string]
        $Server = $Script:Server,

        [Parameter(
            Position = 1,
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The credentials used to authenticate the user to the DataConduIT service.')]
        [PSCredential]
        $Credential = $Script:Credential,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the panel id of the reader output(s) to activate.')]
        [int]
        $PanelID = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the reader id of the reader output(s) to activate.')]
        [int]
        $ReaderID = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the reader output id of the reader output(s) to activate.')]
        [ValidateSet(0, 1, 2)]
        [int]
        $ReaderOutputID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $false,
            HelpMessage = 'Returns an object that represents the reader output. By default, this cmdlet does not generate any output.')]
        [switch]
        $PassThru
    )

    process {
        $parameters = @{
            Server = $Server;
        }

        if ($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        if (($readerOutputs = Get-ReaderOutput @parameters -PanelID $PanelID -ReaderID $ReaderID -ReaderOutputID $ReaderOutputID) -eq $null) {
            Write-Verbose -Message ("No reader outputs found")
            return
        }

        foreach ($readerOutput in $readerOutputs) {
            $readerOutput.Activate.Invoke() | Out-Null

            Write-Verbose -Message ("Reader output '$($readerOutput.Name)' activated")

            if ($PassThru) {
                Write-Output $$readerOutput
            }
        }
    }
}