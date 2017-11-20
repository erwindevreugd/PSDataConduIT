<#
    .SYNOPSIS
    Gets a category.

    .DESCRIPTION   
    Gets all categories or a single category if a category id is specified. If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Get-Category
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-Category
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
            HelpMessage='The category id parameter')]
        [int]$CategoryID = $null
    )

    process { 
        $query = "SELECT * FROM Lnl_Category WHERE __CLASS='Lnl_Category' AND NAME!=''"

        if($CategoryID) {
            $query += " AND ID=$CategoryID"
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

				CategoryID=$_.ID;
                Name=$_.NAME;
                
			} | Add-ObjectType -TypeName "DataConduIT.LnlCategory"
		}
    }
}