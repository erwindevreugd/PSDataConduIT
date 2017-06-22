function Get-Cardholder
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
        $query = "SELECT * FROM Lnl_Cardholder WHERE __CLASS='Lnl_Cardholder'"

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
			
				Birthday=ToDateTime $_.BDATE;
				BuildingID=$_.BUILDING;
				Floor=$_.FLOOR;
				DepartmentID=$_.DEPT;
				DivisionID=$_.DIVISION;				
				TitleID=$_.TITLE;
				Firstname=$_.FIRSTNAME;
				Lastname=$_.LASTNAME;
				Midname=$_.MIDNAME;	
				PersonID=$_.ID;
				IsGrant=$_.IsGrant;
				LastChanged=ToDateTime $_.LASTCHANGED;
				Email=$_.EMAIL;
				Extension=$_.EXT;
				OfficePhoneNumber=$_.OPHONE;
				PhoneNumber=$_.PHONE;
				SSNO=$_.SSNO;
				Address=$_.ADDR1;
				State=$_.STATE;
				City=$_.CITY;
				ZipCode=$_.ZIP
			}
		}
    }
}