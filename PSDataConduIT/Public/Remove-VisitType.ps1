<#
    .SYNOPSIS
    Removes a visit type.

    .DESCRIPTION   
    Removes a visit type from the database. 
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Remove-VisitType
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
            HelpMessage='The visit type id parameter')]
        [int]$VisitTypeID,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The segment id parameter')]
        [int]$SegmentID = -1,

        [switch]$Force
    )

    process { 
        $query = "SELECT * FROM Lnl_VisitType WHERE __CLASS='Lnl_VisitType' AND ID!=0"

        if($VisitTypeID) {
            $query += " AND ID=$VisitTypeID"
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
            if($Force -or $PSCmdlet.ShouldProcess("$Server", "Removing VisitTypeID: $($item.ID), $($item.Name)")) {
                $item | Remove-WmiObject
             }
        }
    }
}