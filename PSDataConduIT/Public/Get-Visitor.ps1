<#
    .SYNOPSIS
    Gets a visitor.

    .DESCRIPTION   
    Gets all visitors or a single visitor if a visitor id is specified. If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Get-Visitor
    
    LastChanged       : 19/10/2017 11:29:03
    OfficePhoneNumber :
    Extension         :
    Server            : SERVER
    Lastname          : John
    PersonID          : 1
    ZipCode           :
    TitleID           :
    Organization      :
    Class             : Lnl_Visitor
    Firstname         :
    State             :
    Credential        :
    SSNO              :
    ComputerName      : SERVER
    City              :
    Address           :
    PhoneNumber       :
    Path              : \\SERVER\root\OnGuard:Lnl_Visitor.ID=1
    Midname           :
    SuperClass        : Lnl_Person
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-Visitor
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
            HelpMessage='The visitor id paramter')]
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
				Title=$_.TITLE;
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
			} | Add-ObjectType -TypeName "DataConduIT.LnlVisitor"
		}
    }
}