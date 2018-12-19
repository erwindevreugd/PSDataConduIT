<#
    .SYNOPSIS
    Creates a new user.

    .DESCRIPTION
    Creates a new user.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT

    .EXTERNALHELP PSDataConduIT-help.xml
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
            HelpMessage = 'Specifies the first name of the new user.')]
        [string]
        $Firstname,

        [ValidateLength(1, 255)]
        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the lastn name of the new user.')]
        [string]
        $Lastname,

        [ValidateLength(1, 255)]
        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the internal username of the new user.')]
        [string]
        $LogonID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the password for the new user.')]
        [string]
        $Password,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the system permission group id to assign to the new user.')]
        [int]
        $SystemPermissionGroupID = -1,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the monitoring permission group id to assign to the new user.')]
        [int]
        $MonitoringPermissionGroupID = -1,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the card permission group id to assign to the new user.')]
        [int]
        $CardPermissionGroupID = -1,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the field permission id to assign to the user.')]
        [int]
        $FieldPermissionID = -1,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the report permission group id to assign to the new user.')]
        [int]
        $ReportPermissionGroupID = -1,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the monitoring zone id to assign to the new user.')]
        [int]
        $MonitoringZoneID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the primary segment id of the new user.')]
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
            HelpMessage = 'Specifies the note field for the new user.')]
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