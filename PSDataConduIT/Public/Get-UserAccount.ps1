<#
    .SYNOPSIS
    Gets an user account.

    .DESCRIPTION   
    Gets all user accounts or a single user account if an user account id is specified. 
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Get-UserAccount
    
    ComputerName  : SERVER
    Path          : \\SERVER\root\OnGuard:Lnl_UserAccount.ID=1,UserID=-1
    Server        : SERVER
    SuperClass    : Lnl_Element
    DirectoryID   : 1
    UserAccountID : 1
    UserID        : -1
    Credential    :
    Class         : Lnl_UserAccount
    AccountID     : S-1-5-21-0000000000-0000000000-000000000-0000
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-UserAccount
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
            HelpMessage='The user account id parameter')]
        [int]$UserAccountID    
    )

    process {
        $query = "SELECT * FROM Lnl_UserAccount WHERE __CLASS='Lnl_UserAccount'"

        if($UserAccountID) {
            $query += " AND ID=$UserAccountID"
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
            
                UserAccountID=$_.ID;
                AccountID=$_.AccountID;
                DirectoryID=$_.DirectoryID;
                UserID=$_.UserID;
            } | Add-ObjectType -TypeName "DataConduIT.LnlUserAccount"
        }
    }
}