<#
    .SYNOPSIS
    Disables an user.

    .DESCRIPTION   
    Disables an user. 
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Disable-User
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Disable-User {
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = "High"
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
            Mandatory = $false, 
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The user id parameter.')]
        [int]
        $UserID,

        [switch]
        $PassThru,

        [Parameter(
            Mandatory = $false, 
            ValueFromPipelineByPropertyName = $false,
            HelpMessage = 'Forces the user to be disabled with out displaying a should process.')]
        [switch]
        $Force
    )

    process {
        $query = "SELECT * FROM Lnl_User WHERE __CLASS='Lnl_User'"

        if ($UserID) {
            $query += " AND ID=$UserID"
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

        $users = Get-WmiObject @parameters

        foreach ($user in $users) {
            if ($Force -or $PSCmdlet.ShouldProcess("$Server", "Disable user '$($user.LastName)'")) {
                $user | Set-WmiInstance -Arguments @{ Enabled = $false }
            }
        }

        if ($PassThru) {
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
                    FieldPermissionGroupID      = $_.FieldPermissionGroupID;
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
}