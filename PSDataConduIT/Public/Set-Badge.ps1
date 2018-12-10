<#
    .SYNOPSIS
    Updates a badge.

    .DESCRIPTION
    Updates a badge in the database.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Set-Badge {
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
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The badge id parameter.')]
        [long]
        $BadgeID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The activation date of the badge.')]
        [nullable[datetime]]
        $Activate,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The deactivation date of the badge.')]
        [nullable[datetime]]
        $Deactivate,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Whether the badge is exempted from anti-passback.')]
        [bool]
        $APBExempt,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Whether the badge is allowed to override deadbolt.')]
        [bool]
        $DeadBoltOverride,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Whether the badge is exempted from destination.')]
        [bool]
        $DestinationExempt,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The embossed value of the badge.')]
        [int]
        $Embossed,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Whether the badge uses extended strike times.')]
        [bool]
        $UseExtendedStrike,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The issue code of the badge.')]
        [int]
        $IssueCode
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

        if ($BadgeID -and $BadgeID -ne $badge.ID) {
            Write-Verbose -Message ("Updating badge id '$($badge.ID)' to '$($BadgeID)' on badge key '$($badge.BADGEKEY)'")
            $updateSet.Add("ID", $BadgeID)
        }

        if ($Activate -and $Activate -ne (ToDateTime $badge.ACTIVATE)) {
            $currentActivationDate = ToDateTime $badge.ACTIVATE;
            Write-Verbose -Message ("Updating activation date '$($currentActivationDate)' to '$($Activate)' on badge key '$($badge.BADGEKEY)'")
            $updateSet.Add("ACTIVATE", (ToWmiDateTime $Activate))
        }

        if ($Deactivate -and $Deactivate -ne (ToDateTime $badge.DEACTIVATE)) {
            $currentDeactivationDate = ToDateTime $badge.DEACTIVATE;
            Write-Verbose -Message ("Updating deactivation date '$($currentDeactivationDate)' to '$($Deactivate)' on badge key '$($badge.BADGEKEY)'")
            $updateSet.Add("DEACTIVATE", (ToWmiDateTime $Deactivate))
        }

        if ($APBExempt -and $APBExempt -ne $badge.APBEXEMPT) {
            Write-Verbose -Message ("Updating apb exempt '$($badge.APBEXEMPT)' to '$($APBExempt)' on badge key '$($badge.BADGEKEY)'")
            $updateSet.Add("APBEXEMPT", $APBExempt)
        }

        if ($DeadBoltOverride -and $DeadBoltOverride -ne $badge.DEADBOLT_OVERRIDE) {
            Write-Verbose -Message ("Updating deadbolt override '$($badge.DEADBOLT_OVERRIDE)' to '$($DeadBoltOverride)' on badge key '$($badge.BADGEKEY)'")
            $updateSet.Add("DEADBOLT_OVERRIDE", $DeadBoltOverride)
        }

        if ($DestinationExempt -and $DestinationExempt -ne $badge.DEST_EXEMPT) {
            Write-Verbose -Message ("Updating destination exempt '$($badge.DEST_EXEMPT)' to '$($DestinationExempt)' on badge key '$($badge.BADGEKEY)'")
            $updateSet.Add("DEST_EXEMPT", $DestinationExempt)
        }

        if ($Embossed -and $Embossed -ne $badge.EMBOSSED) {
            Write-Verbose -Message ("Updating embossed value '$($badge.EMBOSSED)' to '$($Embossed)' on badge key '$($badge.BADGEKEY)'")
            $updateSet.Add("EMBOSSED", $Embossed)
        }

        if ($UseExtendedStrike -and $UseExtendedStrike -ne $badge.EXTEND_STRIKE_HELD) {
            Write-Verbose -Message ("Updating use extended strike '$($badge.EXTEND_STRIKE_HELD)' to '$($UseExtendedStrike)' on badge key '$($badge.BADGEKEY)'")
            $updateSet.Add("EXTEND_STRIKE_HELD", $UseExtendedStrike)
        }

        if ($IssueCode -and $IssueCode -ne $badge.ISSUECODE) {
            Write-Verbose -Message ("Updating issue code '$($badge.ISSUECODE)' to '$($IssueCode)' on badge key '$($badge.BADGEKEY)'")
            $updateSet.Add("ISSUECODE", $IssueCode)
        }

        $badge | Set-WmiInstance -Arguments $updateSet -PutType UpdateOnly |
            Select-Object -Property BadgeKey |
            Get-Badge
    }
}