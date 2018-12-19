<#
    .SYNOPSIS
    Gets an user permission groups.

    .DESCRIPTION
    Gets all user permission groups or a single user permission group if an user permission group id is specified.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE
    Get-UserPermissionGroup

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT

    .EXTERNALHELP PSDataConduIT-help.xml
#>
function Get-UserPermissionGroup {
    [CmdletBinding(
        DefaultParameterSetName = 'UserPermissionGroupsByUserPermissionGroupID'
    )]
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
            ParameterSetName = 'UserPermissionGroupsByUserPermissionGroupID',
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the id of the user permission group to get.')]
        [int]
        $UserPermissionGroupID,

        [Parameter(
            ParameterSetName = 'UserPermissionGroupsByUserID',
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the user id for which to get the assigned permission groups.')]
        [int]
        $UserID
    )

    process {
        $query = "SELECT * FROM Lnl_UserPermissionGroup WHERE __CLASS='Lnl_UserPermissionGroup'"

        if ($UserPermissionGroupID) {
            $query += " AND ID=$UserPermissionGroupID"
        }

        if ($UserID) {
            $user = Get-User -UserID $UserID
            $query += " AND ID=$($user.SystemPermissionGroupID) "
            $query += " OR ID=$($user.MonitoringPermissionGroupID) "
            $query += " OR ID=$($user.CardPermissionGroupID) "
            $query += " OR ID=$($user.FieldPermissionID) "
            $query += " OR ID=$($user.ReportPermissionGroupID) "
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
                Class                 = $_.__CLASS;
                SuperClass            = $_.__SUPERCLASS;
                Server                = $_.__SERVER;
                ComputerName          = $_.__SERVER;
                Path                  = $_.__PATH;
                Credential            = $Credential;
                UserPermissionGroupID = $_.ID;
                Name                  = $_.Name;
                Type                  = MapEnum ([PermissionGroupType]) $_.Type;;
                PTZPriority           = $_.PTZPriority;
                CanLoginToDataConduIT = $_.CanLoginToDataConduIT;
                CanSearchVideo        = $_.CanSearchVideo;
                CanViewLiveVideo      = $_.CanViewLiveVideo;
                CanViewRecordedVideo  = $_.CanViewRecordedVideo;
                DevicesExcluded       = $_.DevicesExcluded;
                SegmentID             = $_.SegmentID;
            } | Add-ObjectType -TypeName "DataConduIT.LnlUserPermissionGroup"
        }
    }
}