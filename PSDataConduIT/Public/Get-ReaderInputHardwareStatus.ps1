<#
    .SYNOPSIS
    Get the hardware status for a reader input.

    .DESCRIPTION
    Get the hardware status for a reader input.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE

    Get-ReaderInputHardwareStatus

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT

    .EXTERNALHELP PSDataConduIT-help.xml
#>
function Get-ReaderInputHardwareStatus {
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
            HelpMessage = 'Specifies the panel id of the reader input(s) for which to get the hardware status.')]
        [int]
        $PanelID = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the reader id of the reader input(s) for which to get the hardware status.')]
        [int]
        $ReaderID = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the reader input id of the reader input(s) for which to get the hardware status.')]
        [ValidateSet(0, 1, 2)]
        [int]
        $ReaderInputID
    )

    process {
        $parameters = @{
            Server = $Server;
        }

        if ($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        if (($readerInputs = Get-ReaderInput @parameters -PanelID $PanelID -ReaderID $ReaderID -ReaderInputID $ReaderInputID) -eq $null) {
            Write-Error -Message ("Reader input id '$($ReaderInputID)' on reader id '$($ReaderID)' on panel id '$($PanelID)' not found")
            return
        }

        foreach ($readerInput in $readerInputs) {
            if (($panel = Get-Panel @parameters -PanelID ($readerInput.PanelID)) -eq $null) {
                continue
            }

            try {
                Write-Verbose -Message "Updating hardware status for panel '$($panel.Name)'"
                $panel.UpdateHardwareStatus.Invoke() | Out-Null
            }
            catch {
                Write-Warning -Message ("Failed to update hardware status for panel '$($panel.Name)'")
            }

            try {
                $s = [int]($readerInput.GetHardwareStatus.Invoke().Status)
                $status = MapEnum ([InputStatus].AsType()) $s

                Write-Verbose -Message ("Reader input '$($readerInput.Name)' status is '$($status)'")
            }
            catch {
                Write-Warning -Message ("Failed to get hardware status for reader input '$($readerInput.Name)'")
            }

            New-Object PSObject -Property @{
                Name   = $readerInput.Name;
                Status = $status;
                Panel  = $panel.Name;
            } | Add-ObjectType -TypeName "DataConduIT.LnlReaderInputHardwareStatus"
        }
    }
}