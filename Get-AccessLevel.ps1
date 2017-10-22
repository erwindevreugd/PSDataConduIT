<#
    .SYNOPSIS
    Gets an accesslevel.

    .DESCRIPTION   
    Gets all accesslevels or a single accesslevel if an accesslevel id or name is specified. If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Get-AccessLevel
    
    ComputerName                 : SERVER
    FirstCardUnlock              : False
    Path                         : \\SERVER\root\OnGuard:Lnl_AccessLevel.ID=1
    SegmentID                    : 0
    Server                       : SERVER
    SuperClass                   : Lnl_Element
    AccessLevelID                : 1
    Name                         : AccessLevel
    Credential                   :
    HasCommandAuthority          : False
    Class                        : Lnl_AccessLevel
    DownloadToIntelligentReaders : False
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-AccessLevel
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
            HelpMessage='The credentials used to authenitcate the user to the DataConduIT service')]
        [PSCredential]$Credential = $Script:Credential,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The id of the accesslevel to get')]
        [int]$AccessLevelID,

		[Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The name of the accesslevel to get')]
        [string]$Name
    )

    process { 
        $query = "SELECT * FROM Lnl_AccessLevel WHERE __CLASS='Lnl_AccessLevel'"

        if($AccessLevelID) {
            $query += " AND ID=$AccessLevelID"
        }

		if($Name) {
            $query += " AND Name='$Name'"
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

				SegmentID=$_.SegmentID;

				AccessLevelID=$_.ID;
				Name=$_.Name;
				HasCommandAuthority=$_.HasCommandAuthority;
				DownloadToIntelligentReaders=$_.DownloadToIntelligentReaders;
				FirstCardUnlock=$_.FirstCardUnlock;
			}
		}
    }
}