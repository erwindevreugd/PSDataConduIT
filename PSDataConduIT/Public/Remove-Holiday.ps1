<#
    .SYNOPSIS
    Removes a holiday.

    .DESCRIPTION   
    Removes a holiday from the database. 
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Remove-Holiday
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
            Mandatory=$true, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The holiday id parameter')]
        [int]$HolidayID,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The segment id parameter')]
        [int]$SegmentID = -1,

        [switch]$Force
    )

    process { 

        Write-Warning -Message "Currently not supported by DataConduIT"
        
        $query = "SELECT * FROM Lnl_Holiday WHERE __CLASS='Lnl_Holiday' AND ID!=0"

        if($HolidayID) {
            $query += " AND ID=$HolidayID"
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
            if($Force -or $PSCmdlet.ShouldProcess("$Server", "Removing HolidayID: $($item.ID), $($item.Name)")) {
                $item | Remove-WmiObject
             }
        }
    }
}