<#
    .SYNOPSIS
    Gets an access level assignment.

    .DESCRIPTION
    Gets all access level assignments.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE
    Get-AccessLevelAssignment

    .EXAMPLE
    Get-AccessLevelAssignment -BadgeKey 1

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT

    .EXTERNALHELP PSDataConduIT-help.xml
#>
function Get-AccessLevelAssignment {
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
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the access level id of the access level assignment(s) to get.')]
        [int]
        $AccessLevelID = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the badge key of the access level assignment(s) to get.')]
        [int]
        $BadgeKey = $null
    )

    process {
        $query = "SELECT * FROM Lnl_AccessLevelAssignment WHERE __CLASS='Lnl_AccessLevelAssignment'"

        if ($AccessLevelID) {
            $query += " AND ACCESSLEVELID=$AccessLevelID"
        }

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

        Get-WmiObject @parameters | ForEach-Object { New-Object PSObject -Property @{
                Class         = $_.__CLASS;
                SuperClass    = $_.__SUPERCLASS;
                Server        = $_.__SERVER;
                ComputerName  = $_.__SERVER;
                Path          = $_.__PATH;
                Credential    = $Credential;
                AccessLevelID = $_.ACCESSLEVELID;
                BadgeKey      = $_.BADGEKEY;
                Activate      = ToDateTime $_.ACTIVATE;
                Deactivate    = ToDateTime $_.DEACTIVATE;
            } | Add-ObjectType -TypeName "DataConduIT.LnlAccessLevelAssignment"
        }
    }
}