<#
    .SYNOPSIS
    Gets a guard tour.

    .DESCRIPTION   
    Gets all guard tours or a single guard tour if a guard tour id is specified. 
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Get-GuardTour
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-GuardTour
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
            HelpMessage='The guard tour id parameter.')]
        [int]$GuardTourID = $null
    )

    process { 
        $query = "SELECT * FROM Lnl_GuardTour WHERE __CLASS='Lnl_GuardTour'"

        if($GuardTourID) {
            $query += " AND ID=$GuardTourID"
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

                GuardTourID=$_.ID;
                Name=$_.NAME;

                SegmentID=$_.SEGMENTID;
            } | Add-ObjectType -TypeName "DataConduIT.LnlGuardTour"
        }
    }
}