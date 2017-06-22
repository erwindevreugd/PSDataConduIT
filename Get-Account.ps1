function Get-Account
{
    [CmdletBinding()]
    param
    (
        [Parameter(Position=0, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]$Server = $Script:Server,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [PSCredential]$Credential = $Script:Credential,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int]$AccountID = $null,

		[Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int]$DirectoryID = $null,

		[Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int]$PersonID = $null
    )

    process { 
        $query = "SELECT * FROM Lnl_Account WHERE __CLASS='Lnl_Account'"

        if($AccountID) {
            $query += " AND ID=$AccountID"
        }

		if($DirectoryID) {
            $query += " AND DIRECTORYID=$DirectoryID"
        }

		if($PersonID) {
            $query += " AND PERSONID=$PersonID"
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

				AccountID=$_.ID;
				ExternalAccountID=$_.ACCOUNTID;
				DirectoryID=$_.DIRECTORYID;
				PersonID=$_.PERSONID;
			}
		}
    }
}