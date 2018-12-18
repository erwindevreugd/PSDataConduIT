<#
    .SYNOPSIS
    Gets an user.

    .DESCRIPTION
    Gets all users or a single user if an user id is specified.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE
    Get-User

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
            HelpMessage = 'Specifies the id of the user to get.')]
        [int]
        $UserID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the first name of the user(s) to get. Wildcards are permitted.')]
        [string]
        $Firstname,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the last name of the user(s) to get. Wildcards are permitted.')]
        [string]
        $Lastname,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the internal user account of the user(s) to get. Wildcards are permitted.')]
        [string]
        $LogonID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'When set only enabled users are returned.')]
        [switch]
        $Enabled,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'When set only disabled users are returned.')]
        [switch]
        $Disabled,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the segment id of the user(s) to get.')]
        [int]
        $SegmentID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the system permission group id of the user(s) to get. When given all users that have that system permission group assigned are returned.')]
        [Nullable[int]]
        $SystemPermissionGroupID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the monitoring permission group id of the user(s) to get. When given all users that have that monitoring permission group assigned are returned.')]
        [Nullable[int]]
        $MonitoringPermissionGroupID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the card permission group id of the user(s) to get. When given all users that have that card permission group assigned are returned.')]
        [Nullable[int]]
        $CardPermissionGroupID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the field permission id of the user(s) to get. When given all users that have that field permission assigned are returned.')]
        [Nullable[int]]
        $FieldPermissionID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the report permission group id of the user(s) to get. When given all users that have that report permission group assigned are returned.')]
        [Nullable[int]]
        $ReportPermissionGroupID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the monitoring zone id of the user(s) to get. When given all users that have that monitoring zone assigned are returned.')]
        [Nullable[int]]
        $MonitoringZoneID
    )

    process {
        $query = "SELECT * FROM Lnl_User WHERE __CLASS='Lnl_User'"

        if ($UserID) {
            $query += " AND ID=$UserID"
        }

        if ($Firstname) {
            $query += " AND FirstName like '$(ToWmiWildcard $Firstname)'"
        }

        if ($Lastname) {
            $query += " AND LastName like '$(ToWmiWildcard $Lastname)'"
        }

        if ($LogonID) {
            $query += " AND LogonID like '$(ToWmiWildcard $LogonID)'"
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