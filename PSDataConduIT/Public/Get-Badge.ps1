<#
    .SYNOPSIS
    Gets a badge.

    .DESCRIPTION   
    Gets all badges or a single badge if a badge id or badgekey is specified. If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Get-Badge
    
    BadgeID      : 123456
    Path         : \\SERVER\root\OnGuard:Lnl_Badge.BADGEKEY=1
    Credential   :
    SuperClass   : Lnl_Element
    UseLimit     :
    Class        : Lnl_Badge
    TwoManType   : 0
    Server       : SERVER
    APBExempt    : False
    ComputerName : SERVER
    Deactivate   : 19/10/2022 00:00:00
    BadgeTypeID  : 1
    LastPrint    :
    LastChanged  : 19/10/2017 12:44:52
    Status       : 1
    Activate     : 19/10/2017 00:00:00
    BadgeKey     : 1
    PersonID     : 1
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-Badge
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
            HelpMessage='The badge id parameter')]
        [long]$BadgeID,

		[Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The badge key parameter')]
        [int]$BadgeKey
    )

    process {
        $query = "SELECT * FROM Lnl_Badge WHERE __CLASS='Lnl_Badge'"

        if($BadgeID) {
            $query += " AND ID=$BadgeID"
        }

		if($BadgeKey) {
            $query += " AND BADGEKEY=$BadgeKey"
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

				Activate=ToDateTime($_.ACTIVATE);
				Deactivate=ToDateTime($_.DEACTIVATE);
				APBExempt=$_.APBEXEMPT;
				BadgeKey=$_.BADGEKEY;
				BadgeID=$_.ID;
				PersonID=$_.PERSONID;
				Status=$_.STATUS;
				TwoManType=$_.TWO_MAN_TYPE;
				BadgeTypeID=$_.TYPE;
				UseLimit=$_.USELIMIT;
				LastChanged=ToDateTime($_.LASTCHANGED);
				LastPrint=ToDateTime($_.LASTPRINT);
			}
		}
    }
}