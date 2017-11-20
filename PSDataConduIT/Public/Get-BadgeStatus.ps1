<#
    .SYNOPSIS
    Gets a badge status.

    .DESCRIPTION   
    Gets all badge statuses or a single badge status if a badge status id is specified. If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Get-BadgeStatus
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-BadgeStatus
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
            HelpMessage='The badge status id parameter')]
        [int]$BadgeStatusID = $null
    )

    process { 
        $query = "SELECT * FROM Lnl_BadgeStatus WHERE __CLASS='Lnl_BadgeStatus' AND NAME!=''"

        if($BadgeStatusID) {
            $query += " AND ID=$BadgeStatusID"
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

				BadgeStatusID=$_.ID;
                Name=$_.NAME;
                
			} | Add-ObjectType -TypeName "DataConduIT.LnlBadgeStatus"
		}
    }
}