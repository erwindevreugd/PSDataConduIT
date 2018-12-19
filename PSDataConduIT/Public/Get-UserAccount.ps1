<#
    .SYNOPSIS
    Gets an user account.

    .DESCRIPTION
    Gets all user accounts or a single user account if an user account id is specified.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE
    Get-UserAccount

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT

    .EXTERNALHELP PSDataConduIT-help.xml
#>
function Get-UserAccount {
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
            HelpMessage = 'Specifies the id of the user account to get.')]
        [int]
        $UserAccountID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the directory id of the user account(s) to get.')]
        [int]
        $DirectoryID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the account id of the user account(s) to get. Wildcards are permitted.')]
        [string]
        $AccountID
    )

    process {
        $query = "SELECT * FROM Lnl_UserAccount WHERE __CLASS='Lnl_UserAccount'"

        if ($UserAccountID) {
            $query += " AND ID=$UserAccountID"
        }

        if ($DirectoryID) {
            $query += " AND DirectoryID=$DirectoryID"
        }

        if ($AccountID) {
            $query += " AND AccountID like '$(ToWmiWildcard $AccountID)'"
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
                UserAccountID = $_.ID;
                AccountID     = $_.AccountID;
                DirectoryID   = $_.DirectoryID;
                UserID        = $_.UserID;
            } | Add-ObjectType -TypeName "DataConduIT.LnlUserAccount"
        }
    }
}