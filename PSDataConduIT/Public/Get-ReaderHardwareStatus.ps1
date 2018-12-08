<#
    .SYNOPSIS
    Gets reader hardware status.

    .DESCRIPTION
    Gets reader hardware status for all readers or the reader hardware status for a single reader if a panel id and reader id are specified.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE
    Get-ReaderHardwareStatus

    Name                 Status               Panel
    ----                 ------               -----
    Reader 1             Online               AccessPanel 1
    Reader 2             Online               AccessPanel 1

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-ReaderHardwareStatus {
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
        $PanelID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The reader id parameter.')]
        [int]
        $ReaderID
    )

    process {
        $parameters = @{
            Server = $Server;
        }

        if ($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        if (($readers = Get-Reader @parameters -PanelID $PanelID -ReaderID $ReaderID) -eq $null) {
            return
        }

        foreach ($reader in $readers) {
            if (($panel = Get-Panel @parameters -PanelID ($reader.PanelID)) -eq $null) {
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
                $status = $reader.GetHardwareStatus.Invoke().Status
                $readerStatus = [Enum]::GetValues([ReaderStatus]) | Where-Object { $_ -band [int]$status }

                Write-Verbose -Message ("Reader '$($reader.Name)' status is '$($readerStatus)'")
            }
            catch {
                Write-Warning -Message ("Failed to get hardware status for reader '$($reader.Name)'")
            }

            New-Object PSObject -Property @{
                Name   = $reader.Name;
                Status = $readerStatus;
                Panel  = $panel.Name;
            } | Add-ObjectType -TypeName "DataConduIT.LnlReaderHardwareStatus"
        }
    }
}