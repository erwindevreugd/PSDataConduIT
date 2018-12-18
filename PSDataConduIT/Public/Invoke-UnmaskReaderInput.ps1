<#
    .SYNOPSIS
    Unmasks a reader input.

    .DESCRIPTION
    Unmasks a raeder input.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Invoke-UnmaskReaderInput {
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
            HelpMessage = 'Specifies the panel id of the reader input(s) to unmask.')]
        [int]
        $PanelID = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the reader id of the reader input(s) to unmask.')]
        [int]
        $ReaderID = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the reader input id of the reader input(s) to unmask.')]
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
            $readerInput.Unmask.Invoke() | Out-Null

            Write-Verbose -Message ("Reader input '$($readerInput.Name)' unmasked")

            if ($PassThru) {
                Write-Output $$readerInput
            }
        }
    }
}