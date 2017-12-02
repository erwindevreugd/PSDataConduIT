<#
    .SYNOPSIS
    Gets a division.

    .DESCRIPTION   
    Gets all divisions or a single division if a division id is specified. 
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Get-Division
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-Division
{
    [CmdletBinding()]
    param
    (
        [Parameter(
            Position=0, 
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The name of the server where the DataConduIT service is running or localhost.')]
        [string]$Server = $Script:Server,
        
        [Parameter(
            Position=1,
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The credentials used to authenticate the user to the DataConduIT service.')]
        [PSCredential]$Credential = $Script:Credential,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The category id parameter.')]
        [int]$DivisionID = $null,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The segment id parameter.')]
        [int]$SegmentID = -1
    )

    process { 
        $query = "SELECT * FROM Lnl_Division WHERE __CLASS='Lnl_Division' AND NAME!=''"

        if($DivisionID) {
            $query += " AND ID=$DivisionID"
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

                DivisionID=$_.ID;
                Name=$_.NAME;
                
                SegmentID=$_.SEGMENTID;
            } | Add-ObjectType -TypeName "DataConduIT.LnlDivision"
        }
    }
}