<#
    .SYNOPSIS
    Gets a badge type.

    .DESCRIPTION
    Gets all badge types or a single badge type if a badge type id is specified.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE
    Get-BadgeType

    BadgeTypeID   Name
    -----------   ----
    1             Employee
    2             Visitor
    3             Temporary

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-BadgeType {
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
            HelpMessage = 'The badge type id parameter.')]
        [int]
        $BadgeTypeID = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The badge type name parameter.')]
        [string]
        $Name
    )

    process {
        $query = "SELECT * FROM Lnl_BadgeType WHERE __CLASS='Lnl_BadgeType' AND ID!=0"

        if ($BadgeTypeID) {
            $query += " AND ID=$BadgeTypeID"
        }

        if ($Name) {
            $query += " AND NAME like '$(ToWmiWildcard $Name)'"
        }

        LogQuery $query

        $parameters = @{
            ComputerName = $Server;
            Namespace    = $Script:OnGuardNamespace;
            Query        = $query;
        }

        if ($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        Get-WmiObject @parameters | ForEach-Object { New-Object PSObject -Property @{
                Class              = $_.__CLASS;
                SuperClass         = $_.__SUPERCLASS;
                Server             = $_.__SERVER;
                ComputerName       = $_.__SERVER;
                Path               = $_.__PATH;
                Credential         = $Credential;
                BadgeTypeID        = $_.ID;
                Name               = $_.NAME;
                TypeClass          = MapEnum ([BadgeTypeClass].AsType()) $_.BADGETYPECLASS;
                DefaultAccessGroup = $_.DEFAULTACCESSGROUP;
                IsDisposable       = $_.ISDISPOSABLE;
                SegmentID          = $_.SEGMENTID;
            } | Add-ObjectType -TypeName "DataConduIT.LnlBadgeType"
        }
    }
}