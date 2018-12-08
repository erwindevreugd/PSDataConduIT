<#
    .SYNOPSIS
    Masks a reader input.

    .DESCRIPTION
    Masks a raeder input.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Invoke-MaskReaderInput {
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
            HelpMessage = 'The panel id parameter.')]
        [int]
        $PanelID = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The reader id parameter.')]
        [int]
        $ReaderID = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The reader input id parameter.')]
        [ValidateSet(0, 1, 2)]
        [int]
        $ReaderInputID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $false,
            HelpMessage = 'Returns an object that represents the reader input. By default, this cmdlet does not generate any output.')]
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

        if (($readerInputs = Get-ReaderInput @parameters -PanelID $PanelID -ReaderID $ReaderID -ReaderInputID $ReaderInputID) -eq $null) {
            Write-Verbose -Message ("No reader inputs found")
            return
        }

        foreach ($readerInput in $readerInputs) {
            $readerInput.Mask.Invoke() | Out-Null

            Write-Verbose -Message ("Reader input '$($readerInput.Name)' masked")

            if ($PassThru) {
                Write-Output $$readerInput
            }
        }
    }
}