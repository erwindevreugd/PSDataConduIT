<#
    .SYNOPSIS
    Adds a new badge status.

    .DESCRIPTION   
    Adds a new badge status to the database. 
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function New-BadgeStatus
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

        [ValidateLength(1, 255)]
        [Parameter(
            Mandatory=$true, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The name of the badge status.')]
        [string]$Name
    )

    process {

        $parameters = @{
            ComputerName=$Server;
            Namespace=$Script:OnGuardNamespace;
            Class="Lnl_BadgeStatus";
        }

        if($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        Set-WmiInstance @parameters -Arguments @{
            Name=$Name;} |
            Select-Object *,@{L='BadgeStatusID';E={$_.ID}} | 
            Get-BadgeStatus
    }
}