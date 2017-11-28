<#
    .SYNOPSIS
    Removes a badge status.

    .DESCRIPTION   
    Removes a badge status from the database. 
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Remove-BadgeStatus
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
            HelpMessage='The badge status id parameter')]
        [int]$BadgeStatusID,

        [switch]$Force
    )

    process { 
        $query = "SELECT * FROM Lnl_BadgeStatus WHERE __CLASS='Lnl_BadgeStatus' AND ID!=0"

        if($BadgeStatusID) {
            $query += " AND ID=$BadgeStatusID"
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
            if($Force -or $PSCmdlet.ShouldProcess("$Server", "Removing BadgeStatusID: $($item.ID), $($item.Name)")) {
                $item | Remove-WmiObject
             }
        }
    }
}