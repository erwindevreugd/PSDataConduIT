<#
    .SYNOPSIS
    Copies access level assignments from one badge to another badge.

    .DESCRIPTION
    Copies access level assignments from one badge to another badge.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE
    Copy-AccessLevelAssignment

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT

    .EXTERNALHELP PSDataConduIT-help.xml
#>
function Copy-AccessLevelAssignment {
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
            HelpMessage = 'Specifies the badge key of the badge to copy the access level assignments to.')]
        [int]
        $DestinationBadgeKey,

        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the badge key of the badge to copy the access level assignments from.')]
        [int]
        $SourceBadgeKey
    )

    process {
        if (($sourceBadge = Get-Badge -Server $Server -Credential $Credential -BadgeKey $SourceBadgeKey) -eq $null) {
            Write-Error -Message ("Source badge with badge key '$($SourceBadgeKey)' not found")
            return
        }

        if (($destinationBadge = Get-Badge -Server $Server -Credential $Credential -BadgeKey $DestinationBadgeKey) -eq $null) {
            Write-Error -Message ("Destination badge with badge key '$($DestinationBadgeKey)' not found")
            return
        }

        if (($sourceAccessLevelAssignments = Get-AccessLevelAssignment -Server $Server -Credential $Credential -BadgeKey $SourceBadgeKey) -eq $null) {
            Write-Error -Message ("Source badge with badge key '$($DestinationBadgeKey)' has no access level assignments")
            return
        }

        $sourceAccessLevelAssignments | ForEach-Object {
            $_ | Add-AccessLevelAssignment -BadgeKey $DestinationBadgeKey
        }
    }
}