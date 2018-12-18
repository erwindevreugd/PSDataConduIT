<#
    .SYNOPSIS
    Gets a reader.

    .DESCRIPTION
    Gets all reader or a single reader if a panel id and a reader id are specified.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE
    Get-Reader

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-Reader {
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
            HelpMessage = 'Specifies the panel id of the reader(s) to get. To get a specific reader specify both PanelID and ReaderID parameters.')]
        [int]
        $PanelID = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the reader id of the reader(s) to get. To get a specific reader specify both PanelID and ReaderID parameters.')]
        [int]
        $ReaderID = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the name of the reader(s) to get. Wildcards are permitted.')]
        [string]
        $Name,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the host name of the reader(s) to get. Wildcards are permitted.')]
        [string]
        $HostName
    )

    process {
        $query = "SELECT * FROM Lnl_Reader WHERE __CLASS='Lnl_Reader'"

        if ($PanelID) {
            $query += " AND PanelID=$PanelID"
        }

        if ($ReaderID) {
            $query += " AND ReaderID=$ReaderID"
        }

        if ($Name) {
            $query += " AND Name like '$(ToWmiWildcard $Name)'"
        }

        if ($HostName) {
            $query += " AND HostName like '$(ToWmiWildcard $HostName)'"
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
                Class                  = $_.__CLASS;
                SuperClass             = $_.__SUPERCLASS;
                Server                 = $_.__SERVER;
                ComputerName           = $_.__SERVER;
                Path                   = $_.__PATH;
                Credential             = $Credential;
                Name                   = $_.Name;
                HostName               = $_.HostName;
                PanelID                = $_.PanelID;
                ReaderID               = $_.ReaderID;
                ControlType            = $_.ControlType;
                TimeAttendanceType     = MapEnum ([TimeAttandanceType]) $_.TimeAttendanceType;
                OpenDoor               = $_.OpenDoor;
                SetReaderMode          = $_.SetMode;
                GetReaderMode          = $_.GetMode;
                SetFirstCardUnlockMode = $_.SetFirstCardUnlockMode;
                DownloadFirmware       = $_.DownloadFirmware;
                GetHardwareStatus      = $_.GetHardwareStatus
            } | Add-ObjectType -TypeName "DataConduIT.LnlReader"
        }
    }
}