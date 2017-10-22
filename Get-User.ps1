<#
    .SYNOPSIS
    Gets an user.

    .DESCRIPTION   
    Gets all users or a single user if an user id is specified. If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Get-User
    
	LastChanged                 : 20/07/2017 06:32:27
	FieldPermissionGroupID      :
	Lastname                    : User
	Server                      : SERVER
	CardPermissionGroupID       : 6
	SegmentID                   : 0
	MonitoringPermissionGroupID : 9
	Password                    :
	AllowUnifiedLogon           :
	Firstname                   : User
	Credential                  :
	Notes                       :
	SuperClass                  : Lnl_Element
	SystemPermissionGroupID     : 3
	Created                     : 20/07/2017 06:32:27
	UserID                      : 3
	MonitoringZoneID            : 0
	LogonID                     : USER
	DatabaseID                  : 0
	ComputerName                : SERVER
	Class                       : Lnl_User
	Path                        : \\SERVER\root\OnGuard:Lnl_User.ID=3
	AutomaticallyCreated        : False
	AllowManualLogon            :
	Enabled                     : False
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-User
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
			HelpMessage='The user id parameter')]
        [int]$UserID    
    )

    process {
        $query = "SELECT * FROM Lnl_User WHERE __CLASS='Lnl_User'"

        if($UserID) {
            $query += " AND ID=$UserID"
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
			
				UserID=$_.ID;
				LogonID=$_.LogonID;
				Password=$_.Password;
				Firstname=$_.FirstName;
				Lastname=$_.LastName;
				AllowManualLogon=$_.AllowManualLogon;
				AllowUnifiedLogon=$_.AllowUnifiedLogon;
				Enabled=$_.Enabled;
				SystemPermissionGroupID=$_.SystemPermissionGroupID;
				MonitoringPermissionGroupID=$_.MonitoringPermissionGroupID;
				CardPermissionGroupID=$_.CardPermissionGroupID;
				FieldPermissionGroupID=$_.FieldPermissionGroupID;
				SegmentID=$_.PrimarySegmentID;
				MonitoringZoneID=$_.MonitoringZoneID;
				Created=ToDateTime $_.Created;
				LastChanged=ToDateTime $_.LastChanged;
				Notes=$_.Notes;
				AutomaticallyCreated=$_.AutomaticallyCreated;
				DatabaseID=$_.DatabaseID;
			}
		}
    }
}