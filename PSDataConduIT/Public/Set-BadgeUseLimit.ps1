<#
    .SYNOPSIS
    Sets the use limit for a given badge.

    .DESCRIPTION
    Sets the use limit for a given badge.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Set-BadgeUseLimit {
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
            HelpMessage = 'The badge key parameter.')]
        [int]
        $BadgeKey,

        [Parameter(
            Mandatory = $true,
            HelpMessage = 'The use limit for the badge.')]
        [int]
        $UseLimit
    )

    process {
        $query = "SELECT * FROM Lnl_Badge WHERE __CLASS='Lnl_Badge'"

        if ($BadgeKey) {
            $query += " AND BADGEKEY=$BadgeKey"
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

        if (($badge = Get-WmiObject @parameters) -eq $null) {
            Write-Error -Message ("Badge key '$($BadgeKey)' not found")
            return
        }

        $updateSet = @{}

        if ($UseLimit -and $UseLimit -ne $badge.USELIMIT) {
            Write-Verbose -Message ("Updating use limit '$($badge.USELIMIT)' to '$($UseLimit)' on badge key '$($badge.BADGEKEY)'")
            $updateSet.Add("USELIMIT", $UseLimit)
        }

        $badge | Set-WmiInstance -Arguments $updateSet |
            Get-Badge
    }
}