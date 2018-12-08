<#
    .SYNOPSIS
    Gets a badge.

    .DESCRIPTION
    Gets all badges for a given visitor.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE
    Get-VisitorBadge

    BadgeID       BadgeKey      PersonID      Status        Activate               Deactivate             BadgeTypeID
    -------       --------      --------      ------        --------               ----------             -----------
    123456        6             1             1             19/10/2017 00:00:00    19/10/2022 00:00:00    1

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-VisitorBadge {
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
            HelpMessage = 'The visitor id parameter.')]
        [int]
        $VisitorID
    )

    process {
        $query = "SELECT * FROM Lnl_Badge WHERE __CLASS='Lnl_Badge' AND ID<>0"

        if ($VisitorID) {
            $query += " AND PERSONID=$VisitorID"
        }

        if (($visitorBadgeTypes = @(Get-BadgeType | Where-Object { $_.TypeClass -eq [BadgeTypeClass]::Visitor})) -eq $null) {
            Write-Verbose -Message "No visitor badge types are defined."
            return
        }
        for ($i = 0; $i -lt $visitorBadgeTypes.Count; $i++) {
            if ($i -eq 0) {
                $query += " AND (Type=$($visitorBadgeTypes[$i].BadgeTypeID))"
            }
            else {
                $query += " OR (Type=$($visitorBadgeTypes[$i].BadgeTypeID))"
            }
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

        Get-WmiObject @parameters | ForEach-Object {
            Get-Badge -Server $Server -Credential $Credential -BadgeKey $_.BADGEKEY
        }
    }
}