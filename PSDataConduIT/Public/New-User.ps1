<#
    .SYNOPSIS
    Adds a new user.

    .DESCRIPTION
    Adds a new user to the database.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function New-User {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        "PSAvoidUsingPlainTextForPassword",
        "",
        Justification="OnGuard requires this to be plain text")]
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

        [ValidateLength(1, 255)]
        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The firsname name of the user.')]
        [string]
        $Firstname,

        [ValidateLength(1, 255)]
        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The firsname name of the user.')]
        [string]
        $Lastname,

        [ValidateLength(1, 255)]
        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The internal username of the user.')]
        [string]
        $LogonID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The password for the user.')]
        [string]
        $Password,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The system permission group id of the user.')]
        [int]
        $SystemPermissionGroupID = -1,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The monitoring permission group id of the user.')]
        [int]
        $MonitoringPermissionGroupID = -1,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The card permission group id of the user.')]
        [int]
        $CardPermissionGroupID = -1,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The field permission id of the user.')]
        [int]
        $FieldPermissionID = -1,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The report permission group id of the user.')]
        [int]
        $ReportPermissionGroupID = -1,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The monitoring zone id of the user.')]
        [int]
        $MonitoringZoneID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The primary segment id of the user.')]
        [int]
        $SegmentID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Determines wheter the new user is enabled or disabled.')]
        [bool]
        $Enabled = $true,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The note field for the user.')]
        [string]
        $Notes
    )

    process {

        $parameters = @{
            ComputerName = $Server;
            Namespace    = $Script:OnGuardNamespace;
            Class        = "Lnl_User";
        }

        if ($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        Set-WmiInstance @parameters -Arguments @{
            FirstName                   = $Firstname;
            LastName                    = $Lastname;
            LogonID                     = $LogonID;
            Password                    = $Password;
            SystemPermissionGroupID     = $SystemPermissionGroupID;
            MonitoringPermissionGroupID = $MonitoringPermissionGroupID;
            CardPermissionGroupID       = $CardPermissionGroupID;
            FieldPermissionID           = $FieldPermissionID;
            ReportPermissionGroupID     = $ReportPermissionGroupID;
            MonitoringZoneID            = $MonitoringZoneID;
            PrimarySegmentID            = $SegmentID;
            Enabled                     = $Enabled;
            Notes                       = $Notes;
        } -PutType CreateOnly |
            Select-Object *, @{L = 'UserID'; E = {$_.ID}} |
            Get-User
    }
}