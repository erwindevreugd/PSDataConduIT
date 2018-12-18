<#
    .SYNOPSIS
    Gets a visit.

    .DESCRIPTION
    Gets all visits or a single visit if a visit id is specified.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE
    Get-Visit

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-Visit {
    [CmdletBinding()]
    param
    (
        [Parameter(
            Position = 0,
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The name of the server where the DataConduIT service is running or localhost.')]
        [string]
        $Server = $Script:Server,

        [Parameter(
            Position = 1,
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The credentials used to authenticate the user to the DataConduIT service.')]
        [PSCredential]
        $Credential = $Script:Credential,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the id of the visit to get.')]
        [int]
        $VisitID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the id of the cardholder who owns the visit.')]
        [int]
        $CardholderID
    )

    process {
        $query = "SELECT * FROM Lnl_Visit WHERE __CLASS='Lnl_Visit'"

        if ($VisitID) {
            $query += " AND ID=$VisitID"
        }

        if ($CardholderID) {
            $query += " AND CARDHOLDERID=$CardholderID"
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

        Get-WmiObject @parameters | ForEach-Object { New-Object PSObject -Property @{
                Class            = $_.__CLASS;
                SuperClass       = $_.__SUPERCLASS;
                Server           = $_.__SERVER;
                ComputerName     = $_.__SERVER;
                Path             = $_.__PATH;
                Credential       = $Credential;
                VisitID          = $_.ID;
                VisitorID        = $_.VISITORID;
                VisitKey         = $_.VISIT_KEY;
                CardholderID     = $_.CARDHOLDERID;
                LastChanged      = ToDateTime $_.LASTCHANGED;
                Purpose          = $_.PURPOSE;
                ScheduledTimeIn  = ToDateTime $_.SCHEDULED_TIMEIN;
                ScheduledTimeOut = ToDateTime $_.SCHEDULED_TIMEOUT;
                TimeIn           = ToDateTime $_.TIMEIN;
                TimeOut          = ToDateTime $_.TIMEOUT;
                VisitType        = $_.TYPE;
                EmailList        = $_.EMAIL_LIST;
                SignInVisit      = $_.SignVisitIn;
                SignOutVisit     = $_.SignVisitOut;
            } | Add-ObjectType -TypeName "DataConduIT.LnlVisit"
        }
    }
}