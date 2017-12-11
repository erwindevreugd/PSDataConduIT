<#
    .SYNOPSIS
    Gets a monitoring zone.

    .DESCRIPTION   
    Gets all monitoring zones or a single monitoring zone if a monitoring zone id is specified. 
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Get-MonitoringZone
    
    MonitoringZoneID Name
    ---------------- ----
    1                Default Zone
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-MonitoringZone
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
            HelpMessage='The monitoring zone id parameter.')]
        [int]$MonitoringZoneID
    )

    process {
        $query = "SELECT * FROM Lnl_MonitoringZone WHERE __CLASS='Lnl_MonitoringZone'"

        if($MonitoringZoneID) {
            $query += " AND ID=$MonitoringZoneID"
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

                MonitoringZoneID=$_.ID;
                Name=$_.Name;
                SegmentID=$_.SegmentID;
            } | Add-ObjectType -TypeName "DataConduIT.LnlMonitoringZone"
        }
    }
}