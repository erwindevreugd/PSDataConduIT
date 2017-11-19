<#
    .SYNOPSIS
    Gets a cardholder.

    .DESCRIPTION   
    Gets all cardholders or a single cardholder if a cardholder id is specified. If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Get-Cardholder
    
	Class             : Lnl_Cardholder
	BuildingID        : 0
	Path              : \\WS-084\root\OnGuard:Lnl_Cardholder.ID=1
	PhoneNumber       :
	OfficePhoneNumber :
	Lastname          : Smith
	Birthday          :
	SSNO              :
	PersonID          : 1
	State             :
	City              :
	Floor             : 0
	Credential        :
	Address           :
	LastChanged       : 19/10/2017 12:46:39
	SuperClass        : Lnl_Person
	Email             :
	ZipCode           :
	ComputerName      : SERVER
	DivisionID        : 0
	Extension         :
	IsGrant           : False
	Firstname         : John
	DepartmentID      : 0
	TitleID           : 0
	Midname           :
	Server            : SERVER
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-Cardholder
{
    [CmdletBinding()]
    param
    (
        [Parameter(
			Position=0, 
			Mandatory=$false, 
			ValueFromPipelineByPropertyName=$true,
			HelpMessage='The name of the server where the DataConduIT service is running or localhost')]
		[string]$Server = $Script:Server,
		
		[Parameter(
			Position=1,
			Mandatory=$false, 
			ValueFromPipelineByPropertyName=$true,
			HelpMessage='The credentials used to authenticate the user to the DataConduIT service')]
		[PSCredential]$Credential = $Script:Credential,

        [Parameter(
			Mandatory=$false, 
			ValueFromPipelineByPropertyName=$true,
			HelpMessage='The person id parameter')]
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
			} | Add-ObjectType -TypeName "DataConduIT.LnlCardholder"
		}
    }
}