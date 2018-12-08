<#
    .SYNOPSIS
    Gets a reader input.

    .DESCRIPTION
    Gets all reader inputs or a single reader input if a reader input id is specified.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE
    Get-ReaderInput

    PanelID       ReaderID      ReaderInputID  Name
    -------       --------      -------------  ----
    1             1             1
    1             2             1

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-ReaderInput {
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
        $ReaderInputID
    )

    process {
        $query = "SELECT * FROM Lnl_ReaderInput1 WHERE __CLASS='Lnl_ReaderInput1' OR __CLASS='Lnl_ReaderInput2'"

        if ($ReaderInputID -eq 1) {
            $query = "SELECT * FROM Lnl_ReaderInput1 WHERE __CLASS='Lnl_ReaderInput1'"
        }

        if ($ReaderInputID -eq 2) {
            $query = "SELECT * FROM Lnl_ReaderInput2 WHERE __CLASS='Lnl_ReaderInput2'"
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
                ReaderInputID     = if ($_.__CLASS -eq "Lnl_ReaderInput1") { 1 } else { 2 };
                Name              = $_.NAME;
                GetHardwareStatus = $_.GetHardwareStatus;
                Mask              = $_.MASK;
                Unmask            = $_.UNMASK;
            } | Add-ObjectType -TypeName "DataConduIT.LnlReaderInput"
        }
    }
}