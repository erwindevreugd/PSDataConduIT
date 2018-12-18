<#
    .SYNOPSIS
    Gets a directory.

    .DESCRIPTION
    Gets all directories or a single directory if a directory id is specified.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE
    Get-Directory

    DirectoryID   Name                 Type                           Hostname             StartNode
    -----------   ----                 ----                           --------             ---------
    1             DOMAIN.local         MicrosoftActiveDirectory       DOMAIN.local         dc=DOAMIN, dc=local

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-Directory {
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
            HelpMessage = 'Specifies the id of the directory to get.')]
        [int]
        $DirectoryID
    )

    process {
        $query = "SELECT * FROM Lnl_Directory WHERE __CLASS='Lnl_Directory'"

        if ($DirectoryID) {
            $query += " AND ID=$DirectoryID"
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
                DirectoryID  = $_.ID;
                #AccountCatagory=$_.ACCOUNTCATEGORY;
                #AccountClass=$_.ACCOUNTCLASS;
                #AccountDisplayName=$_.ACCOUNTDISPLAYNAMEATTR;
                #AccountID=$_.ACCOUNTIDATTR;
                Hostname     = $_.HOSTNAME;
                Name         = $_.NAME;
                Port         = $_.PORT;
                StartNode    = $_.STARTNODE;
                Type         = MapEnum ([DirectoryType].AsType()) $_.TYPE;
                UseSSL       = $_.USESSL;
            } | Add-ObjectType -TypeName "DataConduIT.LnlDirectory"
        }
    }
}