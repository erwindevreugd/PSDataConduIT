function New-Visit
{
    [CmdletBinding()]
    param
    (
        [Parameter(Position=0, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]$Server = $Script:Server,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [PSCredential]$Credential = $Script:Credential,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [int]$VisitorID,

		[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [int]$CardholderID,

		[Parameter(Mandatory=$false)]
        [int]$Hours = 4,

		[Parameter(Mandatory=$false)]
        [datetime]$ScheduledTimeIn = ([DateTime]::Now),

		[Parameter(Mandatory=$false)]
        [datetime]$ScheduledTimeOut = ([DateTime]::Now).AddHours($Hours),

		[Parameter(Mandatory=$false)]
        [string]$Purpose,

		[Parameter(Mandatory=$false)]
        [string]$EmailList
    )

    process {

        $parameters = @{
            ComputerName=$Server;
            Namespace=$Script:OnGuardNamespace;
            Class="Lnl_Visit";
        }

        if($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        New-WmiInstance @parameters -Arguments @{
			CARDHOLDERID=$CardholderID;
			VISITORID=$VisitorID;
			SCHEDULED_TIMEIN=ToWmiDateTime $ScheduledTimeIn;
			SCHEDULED_TIMEOUT=ToWmiDateTime $ScheduledTimeOut;
			PURPOSE=$Purpose;
			EMAIL_LIST=$EmailList;} |
			Select-Object *,@{L='VisitID';E={$_.ID}} | 
			Get-Visit
    }
}