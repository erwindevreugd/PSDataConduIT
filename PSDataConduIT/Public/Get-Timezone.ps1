<#
    .SYNOPSIS
    Gets a timezone.

    .DESCRIPTION
    Gets all timezones or a single timezone if a timezone id is specified.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE
    Get-Timezone

    TimezoneID    Name
    ----------    ----
    1             Never
    2             Always
    0             Not Used

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-Timezone {
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
            HelpMessage = 'The timezone id parameter.')]
        [int]
        $TimezoneID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The timezone name parameter.')]
        [string]
        $Name
    )

    process {
        $query = "SELECT * FROM Lnl_Timezone WHERE __CLASS='Lnl_Timezone'"

        if ($TimezoneID) {
            $query += " AND ID=$TimezoneID"
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
                TimezoneID   = $_.ID;
                Name         = $_.Name;
                SegmentID    = $_.SegmentID;
            } | Add-ObjectType -TypeName "DataConduIT.LnlTimezone"
        }
    }
}