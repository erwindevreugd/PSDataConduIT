function Get-AccessLevelAssignment
{
    [CmdletBinding()]
    param
    (
        [Parameter(Position=0, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]$Server = $Script:Server,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [PSCredential]$Credential = $Script:Credential,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int]$AccessLevelID = $null,

		[Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int]$BadgeKey = $null
    )

    process { 
        $query = "SELECT * FROM Lnl_AccessLevelAssignment WHERE __CLASS='Lnl_AccessLevelAssignment'"

        if($AccessLevelID) {
            $query += " AND ACCESSLEVELID=$AccessLevelID"
        }

		if($BadgeKey) {
            $query += " AND BADGEKEY=$BadgeKey"
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

				SegmentID=$_.SegmentID;

				AccessLevelID=$_.ACCESSLEVELID;
				BadgeKey=$_.BADGEKEY;
				Activate=ToDateTime $_.ACTIVATE;
				Deactivate=ToDateTime $_.DEACTIVATE;
			}
		}
    }
}