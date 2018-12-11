<#
    .SYNOPSIS
    Gets a segment unit.

    .DESCRIPTION
    Gets all segment units or a single segment unit if a segment unit id is specified.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE
    Get-SegmentUnit

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-SegmentUnit {
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
            HelpMessage = 'The segment unit id parameter.')]
        [int]
        $SegmentUnitID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The segment unit name parameter.')]
        [string]
        $Name
    )

    process {
        $query = "SELECT * FROM Lnl_SegmentUnit"

        if ($SegmentID) {
            $query += " WHERE ID=$SegmentUnitID"
        }

        if ($Name) {
            $query += " AND NAME='$Name'"
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
                SegmentUnitID = $_.ID;
                Name          = $_.NAME
            } | Add-ObjectType -TypeName "DataConduIT.LnlSegmentUnit"
        }
    }
}