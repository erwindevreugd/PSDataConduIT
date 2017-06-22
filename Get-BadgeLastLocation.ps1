function Get-BadgeLastLocation
{
    [CmdletBinding()]
    param
    (
        [Parameter(Position=0, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]$Server = $Script:Server,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [PSCredential]$Credential = $Script:Credential,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
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