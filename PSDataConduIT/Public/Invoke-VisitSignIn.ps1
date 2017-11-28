<#
    .SYNOPSIS
    Signs in a visit.

    .DESCRIPTION   
    Sign in a visit.
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Invoke-VisitSignIn
{
    [CmdletBinding()]
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
        [int]$VisitID,

		[Parameter(
            Mandatory=$false,
            HelpMessage='The badge type id parameter')]
        [int]$BadgeTypeID,

		[Parameter(
            Mandatory=$false,
            HelpMessage='The assigned badge id parameter')]
        [long]$AssignedBadgeID,

		[Parameter(
            Mandatory=$false,
            HelpMessage='The printer name parameter')]
        [string]$PrinterName,

        [switch]$PassThru
    )

    process {
        $parameters = @{
            Server=$Server;
            VisitID=$VisitID;
        }

        if($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        if(($visit = Get-Visit @parameters) -eq $null) {
            Write-Error -Message ("Visit id '$($VisitID)' not found")
            return
        }

		$visit.SignInVisit.Invoke($BadgeTypeID, $PrinterName, $AssignedBadgeID)

        Write-Verbose -Message ("Visit '$($visit.VisitID)' signed in with badge id '$($AssignedBadgeID)'")
    
        if($PassThru) {
            Get-Visit @parameters
        }
    }
}