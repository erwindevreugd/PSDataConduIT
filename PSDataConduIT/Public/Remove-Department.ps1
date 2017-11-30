<#
    .SYNOPSIS
    Removes a department.

    .DESCRIPTION   
    Removes a department from the database. 
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Remove-Department
{
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact="High"
    )]
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
        [int]$DepartmentID,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The segment id parameter')]
        [int]$SegmentID = -1,

        [switch]$Force
    )

    process { 
        $query = "SELECT * FROM Lnl_Department WHERE __CLASS='Lnl_Department' AND ID!=0"

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

        $items = Get-WmiObject @parameters 

        foreach($item in $items) {
            if($Force -or $PSCmdlet.ShouldProcess("$Server", "Removing DepartmentID: $($item.ID), $($item.Name)")) {
                $item | Remove-WmiObject
             }
        }
    }
}