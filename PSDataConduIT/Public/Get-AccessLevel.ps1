<#
    .SYNOPSIS
    Gets an access level.

    .DESCRIPTION
    Gets all access levels or a single access level if an access level id or name is specified.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE
    Get-AccessLevel

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT

    .EXTERNALHELP PSDataConduIT-help.xml
#>
function Get-AccessLevel {
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
            HelpMessage = 'The credentials used to authenitcate the user to the DataConduIT service.')]
        [PSCredential]
        $Credential = $Script:Credential,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The id of the accesslevel to get.')]
        [int]
        $AccessLevelID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The name of the accesslevel to get. Wildcards are permitted.')]
        [string]
        $Name,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the segment id of the access level(s) to get.')]
        [nullable[int]]
        $SegmentID = $null
    )

    process {
        $query = "SELECT * FROM Lnl_AccessLevel WHERE __CLASS='Lnl_AccessLevel'"

        if ($AccessLevelID) {
            $query += " AND ID=$AccessLevelID"
        }

        if ($Name) {
            $query += " AND Name like '$(ToWmiWildcard $Name)'"
        }

        if ($SegmentID) {
            $query += " AND SegmentID=$SegmentID"
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
                Class                        = $_.__CLASS;
                SuperClass                   = $_.__SUPERCLASS;
                Server                       = $_.__SERVER;
                ComputerName                 = $_.__SERVER;
                Path                         = $_.__PATH;
                Credential                   = $Credential;
                SegmentID                    = $_.SegmentID;
                AccessLevelID                = $_.ID;
                Name                         = $_.Name;
                HasCommandAuthority          = $_.HasCommandAuthority;
                DownloadToIntelligentReaders = $_.DownloadToIntelligentReaders;
                FirstCardUnlock              = $_.FirstCardUnlock;
            } | Add-ObjectType -TypeName "DataConduIT.LnlAccessLevel"
        }
    }
}