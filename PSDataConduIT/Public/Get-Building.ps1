<#
    .SYNOPSIS
    Gets a building.

    .DESCRIPTION   
    Gets all buildings or a single building if a building id is specified. If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Get-Building
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-Building
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
            HelpMessage='The building id parameter')]
        [int]$BuildingID = $null
    )

    process { 
        $query = "SELECT * FROM Lnl_Building WHERE __CLASS='Lnl_Building' AND NAME!=''"

        if($BuildingID) {
            $query += " AND ID=$BuildingID"
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

				BuildingID=$_.ID;
                Name=$_.NAME;
                
			} | Add-ObjectType -TypeName "DataConduIT.LnlBuilding"
		}
    }
}