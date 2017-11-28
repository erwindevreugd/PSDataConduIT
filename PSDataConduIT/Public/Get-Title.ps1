<#
    .SYNOPSIS
    Gets a title.

    .DESCRIPTION   
    Gets all titles or a single title if a title id is specified. 
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Get-Title
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-Title
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
            HelpMessage='The title id parameter')]
        [int]$TitleID = $null,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The segment id parameter')]
        [int]$SegmentID = -1
    )

    process { 
        $query = "SELECT * FROM Lnl_Title WHERE __CLASS='Lnl_Title' AND NAME!=''"

        if($TitleID) {
            $query += " AND ID=$TitleID"
        }

        if($SegmentID -ne -1) {
            $query += " AND SEGMENTID=$SegmentID"
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

				TitleID=$_.ID;
                Name=$_.NAME;
                
                SegmentID=$_.SEGMENTID;
			} | Add-ObjectType -TypeName "DataConduIT.LnlTitle"
		}
    }
}