<#
    .SYNOPSIS
    Signs out a visit.

    .DESCRIPTION   
    Signs out a visit .If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Invoke-VisitSignOut
{
    [CmdletBinding()]
    [OutputType([int])]
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
            HelpMessage='The visit id parameter')]
        [int]$VisitID    
    )

    process {
        $parameters = @{
            Server=$Server;
            VisitID=$VisitID;
        }

        if($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        $visit = Get-Visit @parameters
        
        if($visit -eq $null) {
            Write-Debug -Message "Visit id '$VisitID' does not exist"
            return
        }
        
		$visit.SignOutVisit.Invoke()

        Write-Verbose -Message "Visit '$($visit.VisitID)' signed out"
    }
}