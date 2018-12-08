<#
    .SYNOPSIS
    Gets a badge.

    .DESCRIPTION
    Gets all badges or a single badge if a badge id or badgekey is specified.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE
    Get-Badge

    BadgeID       BadgeKey      PersonID      Status        Activate               Deactivate             BadgeTypeID
    -------       --------      --------      ------        --------               ----------             -----------
    1039236244    2             2             1             01/08/2017 00:00:00    01/08/2022 00:00:00    1

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-Badge
{
    [CmdletBinding()]
    param
    (
        [Parameter(
            Position=0,
            Mandatory=$false,
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The name of the server where the DataConduIT service is running or localhost.')]
        [string]
        $Server = $Script:Server,

        [Parameter(
            Position=1,
            Mandatory=$false,
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The credentials used to authenticate the user to the DataConduIT service.')]
        [PSCredential]
        $Credential = $Script:Credential,

        [Parameter(
            Mandatory=$false,
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The badge id parameter.')]
        [long]
        $BadgeID,

        [Parameter(
            Mandatory=$false,
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The badge key parameter.')]
        [int]
        $BadgeKey,

        [Parameter(
            Mandatory=$false,
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The person id parameter.')]
        [int]
        $PersonID
    )

    process {
        $query = "SELECT * FROM Lnl_Badge WHERE __CLASS='Lnl_Badge'"

        if($BadgeID) {
            $query += " AND ID=$BadgeID"
        }

        if($BadgeKey) {
            $query += " AND BADGEKEY=$BadgeKey"
        }

        if($PersonID) {
            $query += " AND PersonID=$PersonID"
        }

        LogQuery $query

        $parameters = @{
            ComputerName=$Server;
            Namespace=$Script:OnGuardNamespace;
            Query=$query
        }

        if($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        Get-WmiObject @parameters | ForEach-Object { New-Object PSObject -Property @{
                Class=$_.__CLASS;
                SuperClass=$_.__SUPERCLASS;
                Server=$_.__SERVER;
                ComputerName=$_.__SERVER;
                Path=$_.__PATH;
                Credential=$Credential;
                BadgeKey=$_.BADGEKEY;
                BadgeID=$_.ID;
                PersonID=$_.PERSONID;
                BadgeTypeID=$_.TYPE;
                Status=$_.STATUS;
                Activate=ToDateTime($_.ACTIVATE);
                Deactivate=ToDateTime($_.DEACTIVATE);
                APBExempt=$_.APBEXEMPT;
                DestinationExempt=($_.DEST_EXEMPT -eq 1);
                DeadBoltOverride=$_.DEADBOLT_OVERRIDE;
                ExtendedStrikeHeld=$_.EXTEND_STRIKE_HELD;
                PassageMode=$_.PASSAGE_MODE;
                UseLimit=$_.USELIMIT;
                TwoManType=$_.TWO_MAN_TYPE;
                LastChanged=ToDateTime($_.LASTCHANGED);
                LastPrint=ToDateTime($_.LASTPRINT);
            } | Add-ObjectType -TypeName "DataConduIT.LnlBadge"
        }
    }
}