function Get-AccessLevel
{
    [CmdletBinding()]
    param
    (
        [Parameter(Position=0, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]$Server = $Script:Server,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [PSCredential]$Credential = $Script:Credential,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int]$AccessLevelID,

		[Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]$Name
    )

    process { 
        $query = "SELECT * FROM Lnl_AccessLevel WHERE __CLASS='Lnl_AccessLevel'"

        if($AccessLevelID) {
            $query += " AND ID=$AccessLevelID"
        }

		if($Name) {
            $query += " AND Name='$Name'"
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

				AccessLevelID=$_.ID;
				Name=$_.Name;
				HasCommandAuthority=$_.HasCommandAuthority;
				DownloadToIntelligentReaders=$_.DownloadToIntelligentReaders;
				FirstCardUnlock=$_.FirstCardUnlock;
			}
		}
    }
}