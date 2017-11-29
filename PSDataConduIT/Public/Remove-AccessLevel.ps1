<#
    .SYNOPSIS
    Removes an accesslevel.

    .DESCRIPTION   
    Removes an accesslevel from the database. 
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Remove-AccessLevel
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
            HelpMessage='The accesslevel id parameter')]
        [int]$AccessLevelID,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]$Name,

        [switch]$Force
    )

    process { 
        $query = "SELECT * FROM Lnl_AccessLevel WHERE __CLASS='Lnl_AccessLevel'"

        if($AccessLevelID) {
            $query += " AND ID=$AccessLevelID"
        }

        if($Name) {
            $query += " AND Name='$Name'"
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

        $accessLevel = Get-WmiObject @parameters 

        if($Force -or $PSCmdlet.ShouldProcess("$Server", "Removing AccessLevelID: $($accessLevel.ID), $($accessLevel.Name)")) {
           $accessLevel | Remove-WmiObject
        }
    }
}