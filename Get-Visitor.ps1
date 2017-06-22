function Get-Visitor
{
    [CmdletBinding()]
    param
    (
        [Parameter(Position=0, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]$Server = $Script:Server,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [PSCredential]$Credential = $Script:Credential,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int]$VisitorID
    )

    process {
        $query = "SELECT * FROM Lnl_Visitor WHERE __CLASS='Lnl_Visitor'"

        if($VisitorID) {
            $query += " AND ID=$VisitorID"
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
				TitleID=$_.TITLE;
				Firstname=$_.FIRSTNAME;
				Lastname=$_.LASTNAME;
				Midname=$_.MIDNAME;	
				LastChanged=ToDateTime $_.LASTCHANGED;
				Organization=$_.ORGANIZATION;
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