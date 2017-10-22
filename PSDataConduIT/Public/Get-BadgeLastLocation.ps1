<#
    .SYNOPSIS
    Gets the badge last location.

    .DESCRIPTION   
    Gets all badge last locations or a single badge last location if a badge id is specified. If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Get-BadgeLastLocation
    
    Class        : Lnl_BadgeLastLocation
    ComputerName : SERVER
    EventID      : 4
    PersonID     : 0
    EventTime    : 20/10/2017 01:17:40
    SuperClass   :
    Credential   :
    PanelID      : 1
    ReaderID     : 1
    AccessFlag   : 1
    EventType    : 1
    IsReplicated : 0
    Path         : \\SERVER\root\OnGuard:Lnl_BadgeLastLocation.AccessFlag=1,BadgeID="123456",DatabaseID=0
    BadgeID      : 123456
    Server       : SERVER
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-BadgeLastLocation
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
            HelpMessage='The badge id parameter')]
        [int]$BadgeID    
    )

    process {
        $query = "SELECT * FROM Lnl_BadgeLastLocation WHERE __CLASS='Lnl_BadgeLastLocation'"

        if($BadgeID) {
            $query += " AND BADGEID=$BadgeID"
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

				AccessFlag=$_.AccessFlag;
				BadgeID=$_.BadgeID;
				PersonID=$_.PersonID;
				EventID=$_.EventID;
				EventTime=ToDateTime $_.EventTime;
				EventType=$_.EventType;
				IsReplicated=$_.IsFromReplication;
				PanelID=$_.PanelID;
				ReaderID=$_.ReaderID;
			}
		}
    }
}