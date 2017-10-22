<#
    .SYNOPSIS
    Gets a timezone interval.

    .DESCRIPTION   
    Gets all timezone intervals or a single timezone interval if an timezone interval id is specified. If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Get-TimezoneInterval
    
    Class              : Lnl_TimezoneInterval
    ComputerName       : SERVER
    TimezoneIntervalID : 0
    SuperClass         : Lnl_Element
    Credential         :
    TimezoneID         : 2
    Path               : \\SERVER\root\OnGuard:Lnl_TimezoneInterval.ID=0,TimezoneID=2
    Server             : SERVER
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-TimezoneInterval
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
            HelpMessage='The timezone interval id parameter')]
        [int]$TimezoneIntervalID
    )

    process {
        $query = "SELECT * FROM Lnl_TimezoneInterval WHERE __CLASS='Lnl_TimezoneInterval'"

        if($TimezoneIntervalID) {
            $query += " AND ID=$TimezoneIntervalID"
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

				TimezoneIntervalID=$_.ID;
				TimezoneID=$_.TimezoneID;
			}
		}
    }
}