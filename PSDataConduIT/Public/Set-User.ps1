<#
    .SYNOPSIS
    Updates a user.

    .DESCRIPTION
    Updates a user.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT

    .EXTERNALHELP PSDataConduIT-help.xml
#>
function Set-User {
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
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the id of the user to update.')]
        [int]
        $UserID,

        [ValidateLength(0, 64)]
        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the new first name of the user.')]
        [string]
        $Firstname,

        [ValidateLength(0, 64)]
        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the new last name of the user.')]
        [string]
        $Lastname,

        [ValidateLength(1, 64)]
        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the new internal username of the user.')]
        [string]
        $LogonID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the new system permission group id of the user.')]
        [nullable[int]]
        $SystemPermissionGroupID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the new monitoring permission group id of the user.')]
        [nullable[int]]
        $MonitoringPermissionGroupID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the new card permission group id of the user.')]
        [nullable[int]]
        $CardPermissionGroupID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the new field permission id of the user.')]
        [nullable[int]]
        $FieldPermissionID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the new report permission group id of the user.')]
        [nullable[int]]
        $ReportPermissionGroupID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the new monitoring zone id of the user.')]
        [nullable[int]]
        $MonitoringZoneID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the new primary segment id of the user.')]
        [nullable[int]]
        $SegmentID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Determines wheter the new user is enabled or disabled.')]
        [nullable[bool]]
        $Enabled = $true,

        [ValidateLength(0, 250)]
        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the new note field for the user.')]
        [string]
        $Notes
    )

    begin {
        $currentUser = Get-CurrentUser -Server $Server -Credential $Credential
    }

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

        if (($user = Get-WmiObject @parameters) -eq $null) {
            Write-Error -Message ("User id '$($UserID)' not found")
            return
        }

        if ($currentUser.UserID -eq $user.ID) {
            Write-Error -Message ("Cannot change the user account of the current user account '$($CurrentUser)'")
            return
        }

        $updateSet = @{}

        if ($Firstname -and $Firstname -ne $user.FirstName) {
            Write-Verbose -Message ("Updating firstname '$($user.FirstName)' to '$($Firstname)' on user '$($user.ID)'")
            $updateSet.Add("FirstName", $Firstname)
        }

        if ($Lastname -and $Lastname -ne $user.LastName) {
            Write-Verbose -Message ("Updating lastname '$($user.LastName)' to '$($Lastname)' on user '$($user.ID)'")
            $updateSet.Add("LastName", $Lastname)
        }

        if ($LogonID -and $LogonID -ne $user.LogonID) {
            Write-Verbose -Message ("Updating internal user name '$($user.LogonID)' to '$($LogonID)' on user '$($user.ID)'")
            $updateSet.Add("LogonID", $LogonID)
        }

        if ($SystemPermissionGroupID -and $SystemPermissionGroupID -ne $user.SystemPermissionGroupID) {
            Write-Verbose -Message ("Updating system permission group '$($user.SystemPermissionGroupID)' to '$($SystemPermissionGroupID)' on user '$($user.ID)'")
            $updateSet.Add("SystemPermissionGroupID", $SystemPermissionGroupID)
        }

        if ($MonitoringPermissionGroupID -and $MonitoringPermissionGroupID -ne $user.MonitoringPermissionGroupID) {
            Write-Verbose -Message ("Updating monitor permission group '$($user.MonitoringPermissionGroupID)' to '$($MonitoringPermissionGroupID)' on user '$($user.ID)'")
            $updateSet.Add("MonitoringPermissionGroupID", $MonitoringPermissionGroupID)
        }

        if ($CardPermissionGroupID -and $CardPermissionGroupID -ne $user.CardPermissionGroupID) {
            Write-Verbose -Message ("Updating card permission group '$($user.CardPermissionGroupID)' to '$($CardPermissionGroupID)' on user '$($user.ID)'")
            $updateSet.Add("CardPermissionGroupID", $CardPermissionGroupID)
        }

        if ($FieldPermissionID -and $FieldPermissionID -ne $user.FieldPermissionID) {
            Write-Verbose -Message ("Updating field permission '$($user.FieldPermissionID)' to '$($FieldPermissionID)' on user '$($user.ID)'")
            $updateSet.Add("FieldPermissionID", $FieldPermissionID)
        }

        if ($ReportPermissionGroupID -and $ReportPermissionGroupID -ne $user.ReportPermissionGroupID) {
            Write-Verbose -Message ("Updating report permission group '$($user.ReportPermissionGroupID)' to '$($ReportPermissionGroupID)' on user '$($user.ID)'")
            $updateSet.Add("ReportPermissionGroupID", $ReportPermissionGroupID)
        }

        if ($MonitoringZoneID -and $MonitoringZoneID -ne $user.MonitoringZoneID) {
            Write-Verbose -Message ("Updating monitoring zone '$($user.MonitoringZoneID)' to '$($MonitoringZoneID)' on user '$($user.ID)'")
            $updateSet.Add("MonitoringZoneID", $MonitoringZoneID)
        }

        if ($SegmentID -and $SegmentID -ne $user.PrimarySegmentID) {
            Write-Verbose -Message ("Updating primary segment '$($user.PrimarySegmentID)' to '$($SegmentID)' on user '$($user.ID)'")
            $updateSet.Add("PrimarySegmentID", $SegmentID)
        }

        if ($Enabled -and $Enabled -ne $user.Enabled) {
            Write-Verbose -Message ("Updating enabled state '$($user.Enabled)' to '$($Enabled)' on user '$($user.ID)'")
            $updateSet.Add("Enabled", $Enabled)
        }

        if ($Notes -and $Notes -ne $user.Notes) {
            Write-Verbose -Message ("Updating notes '$($user.Notes)' to '$($Notes)' on user '$($user.ID)'")
            $updateSet.Add("Notes", $Notes)
        }

        $user | Set-WmiInstance -Arguments $updateSet -PutType UpdateOnly |
            Select-Object -Property ID, @{L = 'UserID'; E = {$_.ID}} |
            Get-User
    }
}