<#
    .SYNOPSIS
    Gets cardholder accounts.

    .DESCRIPTION
    Gets all cardholder accounts or a single carholder account if an account id is specified.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE
    Get-Account

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-Account {
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
            HelpMessage = 'Specifies the account id of the account to get.')]
        [int]
        $AccountID = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the Active Directory Security Identifier of the account to get.'
        )]
        [string]
        $ExternalAccountID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the directory id of the account(s) to get.')]
        [int]
        $DirectoryID = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the person id of the account to get.')]
        [int]
        $PersonID = $null
    )

    process {
        $query = "SELECT * FROM Lnl_Account WHERE __CLASS='Lnl_Account'"

        if ($AccountID) {
            $query += " AND ID=$AccountID"
        }

        if ($ExternalAccountID) {
            $query += " AND AccountID='$ExternalAccountID'"
        }

        if ($DirectoryID) {
            $query += " AND DirectoryID=$DirectoryID"
        }

        if ($PersonID) {
            $query += " AND PersonID=$PersonID"
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
                Class             = $_.__CLASS;
                SuperClass        = $_.__SUPERCLASS;
                Server            = $_.__SERVER;
                ComputerName      = $_.__SERVER;
                Path              = $_.__PATH;
                Credential        = $Credential;
                AccountID         = $_.ID;
                ExternalAccountID = $_.AccountID;
                DirectoryID       = $_.DirectoryID;
                PersonID          = $_.PersonID;
            } | Add-ObjectType -TypeName "DataConduIT.LnlAccount"
        }
    }
}