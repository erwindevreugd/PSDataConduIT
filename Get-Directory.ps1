function Get-Directory
{
    [CmdletBinding()]
    param
    (
        [Parameter(Position=0, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]$Server = $Script:Server,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [PSCredential]$Credential = $Script:Credential,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
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