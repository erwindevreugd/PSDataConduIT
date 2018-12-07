<#
    .SYNOPSIS
    Gets a logged event.

    .DESCRIPTION   
    Gets logged events or a single logged event if a logged event serial number is specified. 
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Get-LoggedEvent
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
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
            HelpMessage = 'The serial number parameter.')]
        [int]
        $SerialNumber = $null,

        [Parameter(
            Mandatory = $false, 
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The segment id parameter.')]
        [int]
        $SegmentID = 0
    )

    process { 
        $query = "SELECT * FROM Lnl_LoggedEvent WHERE __CLASS='Lnl_LoggedEvent'"

        if ($SerialNumber) {
            $query += " AND SERIALNUMBER=$SerialNumber"
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