function Get-Visit
{
    [CmdletBinding()]
    param
    (
        [Parameter(Position=0, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]$Server = $Script:Server,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [PSCredential]$Credential = $Script:Credential,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int]$VisitID,

		[Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int]$CardholderID
    )

    process {
        $query = "SELECT * FROM Lnl_Visit WHERE __CLASS='Lnl_Visit'"

        if($VisitID) {
            $query += " AND ID=$VisitID"
        }

		if($CardholderID) {
            $query += " AND CARDHOLDERID=$CardholderID"
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

        Get-WmiObject @parameters | ForEach-Object { New-Object PSObject -Property @{
				Class=$_.__CLASS;
				SuperClass=$_.__SUPERCLASS;
				Server=$_.__SERVER;
				ComputerName=$_.__SERVER;
				Path=$_.__PATH;
				Credential=$Credential;
			
				VisitID=$_.ID;
				VisitorID=$_.VISITORID;
				CardholderID=$_.CARDHOLDERID;
				LastChanged=ToDateTime $_.LASTCHANGED;
				Purpose=$_.PURPOSE;
				ScheduledTimeIn=ToDateTime $_.SCHEDULEDTIMEIN;
				ScheduledTimeOut=ToDateTime $_.SCHEDULEDTIMEOUT;
				TimeIn=ToDateTime $_.TIMEIN;
				TimeOut=ToDateTime $_.TIMEOUT;
				VisitType=$_.TYPE;
				EmailList=$_.EMAIL_LIST;

				SignInVisit=$_.SignVisitIn;
				SignOutVisit=$_.SignVisitOut;			
			}
		}
    }
}