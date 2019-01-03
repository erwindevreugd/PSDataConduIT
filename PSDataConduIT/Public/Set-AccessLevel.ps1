<#
    .SYNOPSIS
    Updates an access level.

    .DESCRIPTION
    Updates an access level.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT

    .EXTERNALHELP PSDataConduIT-help.xml
#>
function Set-AccessLevel {
    [CmdletBinding()]
    param
    (
        [Parameter(
            Position = 0,
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The name of the server where the DataConduIT service is running or localhost')]
        [string]
        $Server = $Script:Server,

        [Parameter(
            Position = 1,
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The credentials used to authenticate the user to the DataConduIT service')]
        [PSCredential]
        $Credential = $Script:Credential,

        [ValidateRange(1, 2147483647)]
        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies id of the access level to update.')]
        [int]
        $AccessLevelID,

        [ValidateLength(1, 255)]
        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the new name of the access level.')]
        [string]
        $Name,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies wheter the access level has command authority.')]
        [bool]
        $HasCommandAuthority,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies wheter the access level will be downloaded to intelligent readers.')]
        [bool]
        $DownloadToIntelligentReaders,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies wheter the access level has first card unlock.')]
        [bool]
        $FirstCardUnlock
    )

    process {
        $query = "SELECT * FROM Lnl_AccessLevel WHERE __CLASS='Lnl_AccessLevel'"

        if ($AccessLevelID) {
            $query += " AND ID=$AccessLevelID"
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

        if (($accessLevel = Get-WmiObject @parameters) -eq $null) {
            Write-Error -Message ("Access level id '$($AccessLevelID)' not found")
            return
        }

        $updateSet = @{}

        if ($Name -and $Name -ne $accessLevel.Name) {
            Write-Verbose -Message ("Updating name '$($accessLevel.Name)' to '$($Name)' on access level id '$($accessLevel.ID)'")
            $updateSet.Add("Name", $Name)
        }

        if ($HasCommandAuthority -and $HasCommandAuthority -ne $badge.HasCommandAuthority) {
            Write-Verbose -Message ("Updating has command authority '$($badge.HasCommandAuthority)' to '$($DeadBoltOverride)' access level id '$($accessLevel.ID)'")
            $updateSet.Add("HasCommandAuthority", $HasCommandAuthority)
        }

        if ($DownloadToIntelligentReaders -and $DownloadToIntelligentReaders -ne $badge.DownloadToIntelligentReaders) {
            Write-Verbose -Message ("Updating download to intelligent readers '$($badge.DownloadToIntelligentReaders)' to '$($DownloadToIntelligentReaders)' access level id '$($accessLevel.ID)'")
            $updateSet.Add("DownloadToIntelligentReaders", $DownloadToIntelligentReaders)
        }

        if ($FirstCardUnlock -and $FirstCardUnlock -ne $badge.FirstCardUnlock) {
            Write-Verbose -Message ("Updating has command authority '$($badge.FirstCardUnlock)' to '$($FirstCardUnlock)' access level id '$($accessLevel.ID)'")
            $updateSet.Add("FirstCardUnlock", $FirstCardUnlock)
        }

        $accessLevel | Set-WmiInstance -Arguments $updateSet |
            Select-Object *, @{L = 'AccessLevelID'; E = {$_.ID}} |
            Get-AccessLevel
    }
}