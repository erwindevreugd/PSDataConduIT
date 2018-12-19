<#
    .SYNOPSIS
    Gets a segment group.

    .DESCRIPTION
    Gets all segment groups or a single segment group if a segment group id is specified.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE
    Get-SegmentGroup

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT

    .EXTERNALHELP PSDataConduIT-help.xml
#>
function Get-SegmentGroup {
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
            HelpMessage = 'Specifies the id of the segment group to get.')]
        [int]
        $SegmentGroupID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the name of the segment group to get. Wildcards are permitted.')]
        [string]
        $Name
    )

    process {
        $query = "SELECT * FROM Lnl_SegmentGroup"

        if ($SegmentGroupID) {
            $query += " WHERE ID=$SegmentGroupID"
        }

        if ($Name) {
            $query += " AND NAME like '$(ToWmiWildcard $Name)'"
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
                Class          = $_.__CLASS;
                SuperClass     = $_.__SUPERCLASS;
                Server         = $_.__SERVER;
                ComputerName   = $_.__SERVER;
                Path           = $_.__PATH;
                Credential     = $Credential;
                SegmentGroupID = $_.ID;
                Name           = $_.NAME
            } | Add-ObjectType -TypeName "DataConduIT.LnlSegmentGroup"
        }
    }
}