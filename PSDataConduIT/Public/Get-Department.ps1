<#
    .SYNOPSIS
    Gets a department.

    .DESCRIPTION   
    Gets all departments or a single department if a department id is specified. If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Get-Department
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-Department
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
            HelpMessage='The department id parameter')]
        [int]$DepartmentID = $null,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The segment id parameter')]
        [int]$SegmentID = -1
    )

    process { 
        $query = "SELECT * FROM Lnl_Department WHERE __CLASS='Lnl_Department' AND NAME!=''"

        if($DepartmentID) {
            $query += " AND ID=$DepartmentID"
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

				DepartmentID=$_.ID;
                Name=$_.NAME;
                
                SegmentID=$_.SEGMENTID;
			} | Add-ObjectType -TypeName "DataConduIT.LnlDepartment"
		}
    }
}