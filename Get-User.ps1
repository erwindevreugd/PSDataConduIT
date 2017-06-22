function Get-User
{
    [CmdletBinding()]
    param
    (
        [Parameter(Position=0, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]$Server = $Script:Server,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [PSCredential]$Credential = $Script:Credential,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
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