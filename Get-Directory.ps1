<#
    .SYNOPSIS
    Gets a directory.

    .DESCRIPTION   
    Gets all directories or a single directory if a directory id is specified. If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Get-Directory
    
    Class        : Lnl_Directory
    ComputerName : SERVER
    StartNode    : dc=DOMAIN, dc=local
    SuperClass   : Lnl_Element
    UseSSL       : False
    Credential   :
    Name         : DOMAIN.local
    Type         : MicrosoftActiveDirectory
    Port         : 389
    Path         : \\SERVER\root\OnGuard:Lnl_Directory.ID=1
    Hostname     : DOMAIN.local
    DirectoryID  : 1
    Server       : SERVER
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-Directory
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
            HelpMessage='The directory id parameter')]
        [int]$DirectoryID
    )

    process {
        $query = "SELECT * FROM Lnl_Directory WHERE __CLASS='Lnl_Directory'"

        if($DirectoryID) {
            $query += " AND ID=$DirectoryID"
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

				DirectoryID=$_.ID;
				#AccountCatagory=$_.ACCOUNTCATEGORY;
				#AccountClass=$_.ACCOUNTCLASS;
				#AccountDisplayName=$_.ACCOUNTDISPLAYNAMEATTR;
				#AccountID=$_.ACCOUNTIDATTR;
				Hostname=$_.HOSTNAME;
				Name=$_.NAME;
				Port=$_.PORT;
				StartNode=$_.STARTNODE;
				Type=MapEnum ([DirectoryType].AsType()) $_.TYPE;
				UseSSL=$_.USESSL;
			}
		}
    }
}