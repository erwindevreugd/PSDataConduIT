<#
    .SYNOPSIS
    Gets a logged event.

    .DESCRIPTION
    Gets logged events or a single logged event if a logged event serial number is specified.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE
    Get-LoggedEvent

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT

    .EXTERNALHELP PSDataConduIT-help.xml
#>
function Get-LoggedEvent {
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
            HelpMessage = 'Specifies the serial number of the logged event to get.')]
        [int]
        $SerialNumber = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the description of the logged event(s) to get. Wildcard are permitted.')]
        [string]
        $Description,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the event text of the logged event(s) to get. Wildcard are permitted.')]
        [string]
        $EventText,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the badge id of the logged event(s) to get.')]
        [long]
        $BadgeID = $null,

        [Alias("CardholderID")]
        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the person id of the logged event(s) to get.')]
        [int]
        $PersonID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the panel id of the logged event(s) to get.')]
        [int]
        $PanelID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the device id of the logged event(s) to get.')]
        [int]
        $DeviceID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the secondary device id of the logged event(s) to get.')]
        [int]
        $SecondaryDeviceID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the extended id of the logged event(s) to get.')]
        [int]
        $ExtendedID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the asset id of the logged event(s) to get.')]
        [int]
        $AssetID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the type of access result of the logged event(s) to get.')]
        [accessresult]
        $AccessResult,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies wheter or not the duress field was set of the logged event(s) to get.')]
        [nullable[bool]]
        $Duress,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies wheter or not the cardholder entered field was set of the logged event(s) to get.')]
        [nullable[bool]]
        $CardholderEntered,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the segment id of the logged event(s) to get.')]
        [int]
        $SegmentID = 0
    )

    process {
        $query = "SELECT * FROM Lnl_LoggedEvent WHERE __CLASS='Lnl_LoggedEvent'"

        if ($SerialNumber) {
            $query += " AND SERIALNUMBER=$SerialNumber"
        }

        if ($Description) {
            $query += " AND DESCRIPTION like '$(ToWmiWildcard $Description)'"
        }

        if ($EventText) {
            $query += " AND EVENTTEXT like '$(ToWmiWildcard $EventText)'"
        }

        if ($BadgeID) {
            $query += " AND CARDNUMBER=$BadgeID"
        }

        if ($PersonID) {
            $query += " AND PERSONID=$PersonID"
        }

        if ($PanelID) {
            $query += " AND PANELID=$PanelID"
        }

        if ($DeviceID) {
            $query += " AND DEVICEID=$DeviceID"
        }

        if ($SecondaryDeviceID) {
            $query += " AND SECONDARYDEVICEID=$SecondaryDeviceID"
        }

        if ($ExtendedID) {
            $query += " AND EXTENDEDID=$ExtendedID"
        }

        if ($AssetID) {
            $query += " AND ASSETID=$AssetID"
        }

        if ($AccessResult) {
            $query += " AND ACCESSRESULT=$([int]$AccessResult)"
        }

        if ($Duress -or $Duress -eq $false) {
            $query += " AND DURESS=$($Duress)"
        }

        if ($CardholderEntered -or $CardholderEntered -eq $false) {
            $query += " AND CARDHOLDERENTERED=$($CardholderEntered)"
        }

        if ($SegmentID -ne 0) {
            $query += " AND SEGMENTID=$SegmentID"
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
                Class             = $_.__CLASS;
                SuperClass        = $_.__SUPERCLASS;
                Server            = $_.__SERVER;
                ComputerName      = $_.__SERVER;
                Path              = $_.__PATH;
                Credential        = $Credential;
                SerialNumber      = $_.SERIALNUMBER;
                PanelID           = $_.PANELID;
                DeviceID          = $_.DEVICEID;
                SecondaryDeviceID = $_.SECONDARYDEVICEID;
                ExtendedID        = $_.EXTENDEDID;
                Time              = ToDateTime $_.TIME;
                Description       = $_.DESCRIPTION;
                EventText         = $_.EVENTTEXT;
                Type              = $_.TYPE;
                SubType           = $_.SUBTYPE;
                BadgeID           = $_.CARDNUMBER;
                IssueCode         = $_.ISSUECODE;
                AssetID           = $_.ASSETID;
                AccessResult      = MapEnum ([AccessResult].AsType()) $_.ACCESSRESULT;
                CardholderEntered = $_.CARDHOLDERENTERED;
                Duress            = $_.DURESS;
                PersonID          = $_.PERSONID;
                SegmentID         = $_.SEGMENTID;
            } | Add-ObjectType -TypeName "DataConduIT.LnlLoggedEvent"
        }
    }
}