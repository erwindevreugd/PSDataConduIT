<#
    .SYNOPSIS
    Gets cardholder accounts.

    .DESCRIPTION   
    Gets all cardholder accounts or a single carholder account if an account id is specified. 
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Get-Account
    
    AccountID     PersonID      AccountID     DirectoryID
    ---------     --------      ---------     -----------
    1             2             1             1
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-Account
{
    [CmdletBinding()]
    param
    (
        [Parameter(
            Position=0, 
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The name of the server where the DataConduIT service is running or localhost')]
        [string]$Server = $Script:Server,
        
        [Parameter(
            Position=1,
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The credentials used to authenticate the user to the DataConduIT service')]
        [PSCredential]$Credential = $Script:Credential,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The account id')]
        [int]$AccountID = $null,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The directory id')]
        [int]$DirectoryID = $null,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The person id')]
        [int]$PersonID = $null
    )

    process { 
        $query = "SELECT * FROM Lnl_Account WHERE __CLASS='Lnl_Account'"

        if($AccountID) {
            $query += " AND ID=$AccountID"
        }

        if($DirectoryID) {
            $query += " AND DIRECTORYID=$DirectoryID"
        }

        if($PersonID) {
            $query += " AND PERSONID=$PersonID"
        }

        LogQuery $query

        $parameters = @{
            ComputerName=$Server;
            Namespace=$Script:OnGuardNamespace;
            Query=$query
        }

        if($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        Get-WmiObject @parameters | ForEach-Object { New-Object PSObject -Property @{
                Class=$_.__CLASS;
                SuperClass=$_.__SUPERCLASS;
                Server=$_.__SERVER;
                ComputerName=$_.__SERVER;
                Path=$_.__PATH;
                Credential=$Credential;

                AccountID=$_.ID;
                ExternalAccountID=$_.ACCOUNTID;
                DirectoryID=$_.DIRECTORYID;
                PersonID=$_.PERSONID;
            } | Add-ObjectType -TypeName "DataConduIT.LnlAccount"
        }
    }
}