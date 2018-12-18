<#
    .SYNOPSIS
    Gets a guard tour.

    .DESCRIPTION
    Gets all guard tours or a single guard tour if a guard tour id is specified.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE
    Get-GuardTour

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-GuardTour {
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
            HelpMessage = 'Specifies the id of the guard tour to get.')]
        [int]
        $GuardTourID = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the name of the guard tour to get. Wildcards are permitted.')]
        [string]
        $Name
    )

    process {
        $query = "SELECT * FROM Lnl_GuardTour WHERE __CLASS='Lnl_GuardTour'"

        if ($GuardTourID) {
            $query += " AND ID=$GuardTourID"
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
                Class        = $_.__CLASS;
                SuperClass   = $_.__SUPERCLASS;
                Server       = $_.__SERVER;
                ComputerName = $_.__SERVER;
                Path         = $_.__PATH;
                Credential   = $Credential;
                GuardTourID  = $_.ID;
                Name         = $_.NAME;
                SegmentID    = $_.SEGMENTID;
                LaunchTour   = $_.LaunchTour;
            } | Add-ObjectType -TypeName "DataConduIT.LnlGuardTour"
        }
    }
}