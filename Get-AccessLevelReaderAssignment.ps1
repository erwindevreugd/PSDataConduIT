function Get-AccessLevelReaderAssignment
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
        [int]$PanelID = $null,

		[Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int]$ReaderID = $null
    )

    process { 
        $query = "SELECT * FROM Lnl_AccessLevelReaderAssignment WHERE __CLASS='Lnl_AccessLevelReaderAssignment'"

        if($AccessLevelID) {
            $query += " AND ACCESSLEVELID=$AccessLevelID"
        }

		if($PanelID) {
            $query += " AND PanelID=$PanelID"
        }

		if($ReaderID) {
            $query += " AND ReaderID=$ReaderID"
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

				AccessLevelID=$_.ACCESSLEVELID;
				PanelID=$_.PanelID;
				ReaderID=$_.ReaderID;
				TimezoneID=$_.TimezoneID;
			}
		}
    }
}