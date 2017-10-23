<#
    .SYNOPSIS
    Adds a new visit.

    .DESCRIPTION   
    Adds a new visit to the database. If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function New-Visit
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
            HelpMessage='The id of the visitor to assign to the new visit')]
        [int]$VisitorID,

		[Parameter(
            Mandatory=$true, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The id of the cardholder that will host the new visit')]
        [int]$CardholderID,

		[Parameter(
            Mandatory=$false,
            HelpMessage='The duration of the new visit. If the ScheduledTimeout parameter is specified this parameter is ignored')]
        [int]$Hours = 4,

		[Parameter(
            Mandatory=$false,
            HelpMessage='The scheduled starting time of the new visit. The default value is now')]
        [datetime]$ScheduledTimeIn = ([DateTime]::Now),

		[Parameter(
            Mandatory=$false,
            HelpMessage='The scheduled ending time of the new visit')]
        [datetime]$ScheduledTimeOut = ([DateTime]::Now).AddHours($Hours),

		[Parameter(
            Mandatory=$false,
            HelpMessage='The purpose of the visit')]
        [string]$Purpose,

		[Parameter(
            Mandatory=$false,
            HelpMessage='List of email addresses to add to the new visit')]
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

        Set-WmiInstance @parameters -Arguments @{
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