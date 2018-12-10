<#
    .SYNOPSIS
    Gets an user.

    .DESCRIPTION
    Gets all users or a single user if an user id is specified.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE
    Get-User

    UserID        Lastname             Firstname            LogonID
    ------        --------             ---------            -------
    -1            System Account       System Account       SA
    1             Administrator        Administrator        ADMIN
    2             Badge Operator       Badge Operator       BADGE
    3             User                 User                 USER

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-User {
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
            HelpMessage = 'The user id parameter.')]
        [int]
        $UserID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The user firstname parameter.')]
        [string]
        $Firstname,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The user lastname parameter.')]
        [string]
        $Lastname,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The user internal user name parameter.')]
        [string]
        $LogonID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Returns only enabled users.')]
        [switch]
        $Enabled,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Returns only disabled users.')]
        [switch]
        $Disabled,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The segment id parameter.')]
        [int]
        $SegmentID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The system permission group id parameter.')]
        [int]
        $SystemPermissionGroupID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The monitoring permission group id parameter.')]
        [int]
        $MonitoringPermissionGroupID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The card permission group id parameter.')]
        [int]
        $CardPermissionGroupID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The field permission id parameter.')]
        [int]
        $FieldPermissionID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The report permission group id parameter.')]
        [int]
        $ReportPermissionGroupID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The monitoring zone id parameter.')]
        [int]
        $MonitoringZoneID
    )

    process {
        $query = "SELECT * FROM Lnl_User WHERE __CLASS='Lnl_User'"

        if ($UserID) {
            $query += " AND ID=$UserID"
        }

        if ($Firstname) {
            $query += " AND FirstName='$Firstname'"
        }

        if ($Lastname) {
            $query += " AND LastName='$Lastname'"
        }

        if ($LogonID) {
            $query += " AND LogonID='$LogonID'"
        }

        if ($Enabled) {
            $query += " AND Enabled=1"
        }

        if ($Disabled) {
            $query += " AND Enabled=0"
        }

        if ($SegmentID) {
            $query += " AND PrimarySegmentID=$SegmentID"
        }

        if ($SystemPermissionGroupID) {
            $query += " AND SystemPermissionGroupID=$SystemPermissionGroupID"
        }

        if ($MonitorPermissionGroupID) {
            $query += " AND MonitorPermissionGroupID=$MonitorPermissionGroupID"
        }

        if ($CardPermissionGroupID) {
            $query += " AND CardPermissionGroupID=$CardPermissionGroupID"
        }

        if ($FieldPermissionID) {
            $query += " AND FieldPermissionID=$FieldPermissionID"
        }

        if ($ReportPermissionGroupID) {
            $query += " AND ReportPermissionGroupID=$ReportPermissionGroupID"
        }

        if ($MonitoringZoneID) {
            $query += " AND MonitoringZoneID=$MonitoringZoneID"
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
                Class                       = $_.__CLASS;
                SuperClass                  = $_.__SUPERCLASS;
                Server                      = $_.__SERVER;
                ComputerName                = $_.__SERVER;
                Path                        = $_.__PATH;
                Credential                  = $Credential;
                UserID                      = $_.ID;
                LogonID                     = $_.LogonID;
                Password                    = $_.Password;
                Firstname                   = $_.FirstName;
                Lastname                    = $_.LastName;
                AllowManualLogon            = $_.AllowManualLogon;
                AllowUnifiedLogon           = $_.AllowUnifiedLogon;
                Enabled                     = $_.Enabled;
                SystemPermissionGroupID     = $_.SystemPermissionGroupID;
                MonitoringPermissionGroupID = $_.MonitoringPermissionGroupID;
                CardPermissionGroupID       = $_.CardPermissionGroupID;
                FieldPermissionID           = $_.FieldPermissionID;
                ReportPermissionGroupID     = $_.ReportPermissionGroupID;
                SegmentID                   = $_.PrimarySegmentID;
                MonitoringZoneID            = $_.MonitoringZoneID;
                Created                     = ToDateTime $_.Created;
                LastChanged                 = ToDateTime $_.LastChanged;
                Notes                       = $_.Notes;
                AutomaticallyCreated        = $_.AutomaticallyCreated;
                DatabaseID                  = $_.DatabaseID;
            } | Add-ObjectType -TypeName "DataConduIT.LnlUser"
        }
    }
}