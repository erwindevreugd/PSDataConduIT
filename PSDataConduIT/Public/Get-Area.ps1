<#
    .SYNOPSIS
    Gets an area.

    .DESCRIPTION   
    Gets all areas or a single area if an area id is specified. If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Get-Area
    
    ComputerName : SERVER
    Path         : \\SERVER\root\OnGuard:Lnl_Area.ID=1
    Server       : SERVER
    SuperClass   : Lnl_Element
    AreaType     : GlobalArea
    AreaID       : 1
    Name         : Default Area
    Credential   :
    Class        : Lnl_Area
    MoveBadge    :
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-Area
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
            HelpMessage='The area id parameter')]
        [int]$AreaID = $null
    )

    process { 
        $query = "SELECT * FROM Lnl_Area WHERE __CLASS='Lnl_Area'"

        if($AreaID) {
            $query += " AND ID=$AreaID"
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

				AreaID=$_.ID;
				AreaType=MapEnum ([AreaType].AsType()) $_.AREATYPE;
				Name=$_.NAME;

				MoveBadge=$_.MoveBadge;
			} | Add-ObjectType -TypeName "DataConduIT.LnlArea"
		}
    }
}