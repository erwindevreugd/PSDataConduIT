function Invoke-VisitSignOut
{
    [CmdletBinding()]
    [OutputType([int])]
    param
    (
        [Parameter(Position=0, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]$Server = $Script:Server,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [PSCredential]$Credential = $Script:Credential,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
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
		$visit.SignOutVisit.Invoke()

        Write-Verbose -Message "Visit '$($visit.VisitID)' signed out"
    }
}