<#
    .SYNOPSIS
    Gets a reader output.

    .DESCRIPTION
    Gets all reader output or a single reader output if a panel id, reader id and reader output id are specified.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE
    Get-ReaderOutput

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-ReaderOutput {
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
            HelpMessage = 'Specifies the panel id of the reader output(s) to get.')]
        [int]
        $PanelID = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the reader id of the reader output(s) to get.')]
        [int]
        $ReaderID = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the reader output id of the reader output(s) to get.')]
        [ValidateSet(0, 1, 2)]
        [int]
        $ReaderOutputID
    )

    process {
        $query = "SELECT * FROM Lnl_ReaderOutput WHERE __CLASS='Lnl_ReaderOutput1' OR __CLASS='Lnl_ReaderOutput2'"

        if ($ReaderOutputID -eq 1) {
            $query = "SELECT * FROM Lnl_ReaderOutput1 WHERE __CLASS='Lnl_ReaderOutput1'"
        }

        if ($ReaderOutputID -eq 2) {
            $query = "SELECT * FROM Lnl_ReaderOutput2 WHERE __CLASS='Lnl_ReaderOutput2'"
        }

        if ($PanelID) {
            $query += " AND PANELID=$PanelID"
        }

        if ($ReaderID) {
            $query += " AND READERID=$ReaderID"
        }

        LogQuery $query

        $parameters = @{
            ComputerName = $Server;
            Namespace    = $Script:OnGuardNamespace;
            Query        = $query
        }

        if ($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        Get-WmiObject @parameters | ForEach-Object { New-Object PSObject -Property @{
                Class             = $_.__CLASS;
                SuperClass        = $_.__SUPERCLASS;
                Server            = $_.__SERVER;
                ComputerName      = $_.__SERVER;
                Path              = $_.__PATH;
                Credential        = $Credential;
                PanelID           = $_.PANELID;
                ReaderID          = $_.READERID;
                ReaderOutputID    = if ($_.__CLASS -eq "Lnl_ReaderOutput1") { 1 } else { 2 };
                Name              = $_.NAME;
                GetHardwareStatus = $_.GetHardwareStatus;
                Activate          = $_.ACTIVATE;
                Deactivate        = $_.DEACTIVATE;
                Pulse             = $_.PULSE;
            } | Add-ObjectType -TypeName "DataConduIT.LnlReaderOutput"
        }
    }
}