function Get-Person
{
    [CmdletBinding()]
    param
    (
        [Parameter(Position=0, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]$Server = $Script:Server,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [PSCredential]$Credential = $Script:Credential,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int]$PersonID
    )

    process {
        $query = "SELECT * FROM Lnl_Person WHERE __CLASS='Lnl_Cardholder'"

        if($PersonID) {
            $query += " AND ID=$PersonID"
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

				PersonID=$_.ID;
				Firstname=$_.FIRSTNAME;
				Lastname=$_.LASTNAME;
				Midname=$_.MIDNAME;
				LastChanged=ToDateTime $_.LASTCHANGED;
				SSNO=$_.SSNO;
			}
		}
    }
}