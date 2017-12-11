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
    [CmdletBinding(
        DefaultParameterSetName="SignInByAssignedBadgeID"
    )]
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
            Mandatory=$true, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The visit id parameter.')]
        [int]$VisitID,

        [Parameter(
            Mandatory=$true,
            HelpMessage='The assigned badge id parameter.',
            ParameterSetName="SignInByAssignedBadgeID")]
        [long]$AssignedBadgeID,

        [Parameter(
            Mandatory=$true,
            HelpMessage='The badge type id parameter.',
            ParameterSetName="SignInByBadgeTypeID")]
        [int]$BadgeTypeID,

        [Parameter(
            Mandatory=$false,
            HelpMessage='The printer name parameter.',
            ParameterSetName="SignInByBadgeTypeID")]
        [string]$PrinterName,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$false,
            HelpMessage='Returns an object that represents the visit. By default, this cmdlet does not generate any output.')]
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

        $visit.SignInVisit.Invoke($BadgeTypeID, $PrinterName, $AssignedBadgeID) | Out-Null

        Write-Verbose -Message ("Visit '$($visit.VisitID)' signed in with badge id '$($AssignedBadgeID)'")
    
        if($PassThru) {
            Get-Visit @parameters
        }
    }
}