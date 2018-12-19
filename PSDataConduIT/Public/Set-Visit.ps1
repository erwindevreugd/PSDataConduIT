<#
    .SYNOPSIS
    Updates a visit.

    .DESCRIPTION
    Updates a visit.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT

    .EXTERNALHELP PSDataConduIT-help.xml
#>
function Set-Visit {
    [CmdletBinding()]
    param
    (
        [Parameter(
            Position = 0,
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The name of the server where the DataConduIT service is running or localhost')]
        [string]
        $Server = $Script:Server,

        [Parameter(
            Position = 1,
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The credentials used to authenticate the user to the DataConduIT service')]
        [PSCredential]
        $Credential = $Script:Credential,

        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the id of the visit to update.')]
        [int]
        $VisitID,

        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the new id of the visitor to assign to the visit.')]
        [int]
        $VisitorID,

        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the new id of the cardholder that will host the visit.')]
        [int]
        $CardholderID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the new duration of the visit. If the ScheduledTimeout parameter is specified this parameter is ignored.')]
        [int]
        $Hours = 4,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the new scheduled starting time of the visit. The default value is now.')]
        [datetime]
        $ScheduledTimeIn = ([DateTime]::Now),

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the new scheduled ending time of the visit.')]
        [datetime]
        $ScheduledTimeOut = ([DateTime]::Now).AddHours($Hours),

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the new purpose of the visit.')]
        [string]
        $Purpose,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the new list of email addresses for the visit.')]
        [string]
        $EmailList
    )

    process {
        $query = "SELECT * FROM Lnl_Visit WHERE __CLASS='Lnl_Visit'"

        if ($VisitID) {
            $query += " AND ID=$VisitID"
        }

        LogQuery $query

        $parameters = @{
            ComputerName = $Server;
            Namespace    = $Script:OnGuardNamespace;
            Query        = $query
        }

        if ($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        if (($visit = Get-WmiObject @parameters) -eq $null) {
            Write-Error -Message ("Visit id '$($VisitID)' not found")
            return
        }

        $updateSet = @{}

        if ($VisitorID -and $VisitorID -ne $visit.VISITORID) {
            Write-Verbose -Message ("Updating visitor id '$($visit.VISITORID)' to '$($VisitorID)' on visit id '$($visit.ID)'")
            $updateSet.Add("VISITORID", $VisitorID)
        }

        if ($CardholderID -and $CardholderID -ne $visit.CARDHOLDERID) {
            Write-Verbose -Message ("Updating cardholder id '$($visit.CARDHOLDERID)' to '$($CardholderID)' on visit id '$($visit.ID)'")
            $updateSet.Add("CARDHOLDERID", $CardholderID)
        }

        if ($ScheduledTimeIn -and $ScheduledTimeIn -ne (ToDateTime $visit.SCHEDULED_TIMEIN)) {
            $currentScheduledTimeIn = ToDateTime $visit.SCHEDULED_TIMEIN;
            Write-Verbose -Message ("Updating scheduled time in '$($currentScheduledTimeIn)' to '$($ScheduledTimeIn)' on visit id '$($visit.ID)'")
            $updateSet.Add("SCHEDULED_TIMEIN", (ToWmiDateTime $ScheduledTimeIn))
        }

        if ($ScheduledTimeOut -and $ScheduledTimeOut -ne (ToDateTime $visit.SCHEDULED_TIMEOUT)) {
            $currentScheduledTimeOut = ToDateTime $visit.SCHEDULED_TIMEOUT;
            Write-Verbose -Message ("Updating scheduled time out '$($currentScheduledTimeOut)' to '$($ScheduledTimeOut)' on visit id '$($visit.ID)'")
            $updateSet.Add("SCHEDULED_TIMEOUT", (ToWmiDateTime $ScheduledTimeOut))
        }

        if ($Purpose -and $Purpose -ne $visit.PURPOSE) {
            Write-Verbose -Message ("Updating purpose '$($visit.PURPOSE)' to '$($Purpose)' on visit id '$($visit.ID)'")
            $updateSet.Add("PURPOSE", $Purpose)
        }

        if ($EmailList -and $EmailList -ne $visit.EMAIL_LIST) {
            Write-Verbose -Message ("Updating email list '$($visit.EMAIL_LIST)' to '$($EmailList)' on visit id '$($visit.ID)'")
            $updateSet.Add("EMAIL_LIST", $EmailList)
        }

        $visit | Set-WmiInstance -Arguments $updateSet |
            Select-Object *, @{L = 'VisitID'; E = {$_.ID}} |
            Get-Visit
    }
}