<#
    .SYNOPSIS
    Gets reader mode.

    .DESCRIPTION
    Gets the reader mode for all readers or the reader mode for a single reader if a panel id and reader id is specified.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE
    Get-ReaderMode

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT

    .EXTERNALHELP PSDataConduIT-help.xml
#>
function Get-ReaderMode {
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

        if (($panels = Get-Panel @parameters -PanelID $PanelID) -eq $null) {
            Write-Verbose -Message ("No panels found")
            return
        }

        foreach ($panel in $panels) {
            # Update panel hardware status so we can get the current reader mode
            $panel | Invoke-UpdateHardwareStatus
        }

        if (($readers = Get-Reader @parameters -PanelID $PanelID -ReaderID $ReaderID) -eq $null) {
            Write-Verbose -Message ("No readers found")
            return
        }

        foreach ($reader in $readers) {
            $mode = MapEnum ([ReaderMode].AsType()) $reader.GetReaderMode.Invoke().Mode

            Write-Verbose -Message ("Reader '$($reader.Name)' on Panel '$($panel.Name)' reader mode is '$($mode)'")

            New-Object PSObject -Property @{
                PanelID  = $reader.PanelID;
                ReaderID = $reader.ReaderID;
                Name     = $reader.Name;
                Mode     = $mode;
            } | Add-ObjectType -TypeName "DataConduIT.LnlReaderMode"
        }
    }
}