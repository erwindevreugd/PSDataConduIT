<#
    .SYNOPSIS
    Removes an accesslevel assignment.

    .DESCRIPTION   
    Removes an accesslevel assignment from the database. 
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Remove-AccessLevelAssignment
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
            HelpMessage='The badgekey from which the accesslevel will be removed')]
        [int]$BadgeKey,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The accesslevel to remove from the badge')]
        [int]$AccessLevelID,

        [switch]$Force
    )

    process { 
        $query = "SELECT * FROM Lnl_AccessLevelAssignment WHERE __CLASS='Lnl_AccessLevelAssignment'"

        if($BadgeKey) {
            $query += " AND BADGEKEY=$BadgeKey"
        }

        if($AccessLevelID) {
            $query += " AND ACCESSLEVELID='$AccessLevelID'"
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

        $accessLevelAssignments = Get-WmiObject @parameters 

        foreach($accessLevelAssignment in $accessLevelAssignments) {
            if($Force -or $PSCmdlet.ShouldProcess("$Server", "Removing accesslevel: $($accessLevelAssignment.ACCESSLEVELID) from $($accessLevelAssignment.BADGEKEY)")) {
               $accessLevelAssignment | Remove-WmiObject
            }
        }
    }
}