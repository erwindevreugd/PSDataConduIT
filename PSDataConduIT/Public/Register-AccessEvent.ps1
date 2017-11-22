<#
    .SYNOPSIS

    .DESCRIPTION   

    .EXAMPLE
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>

# __GENUS             : 2
# __CLASS             : Lnl_AccessEvent
# __SUPERCLASS        : Lnl_SecurityEvent
# __DYNASTY           : __SystemClass
# __RELPATH           :
# __PROPERTY_COUNT    : 27
# __DERIVATION        : {Lnl_SecurityEvent, Lnl_Event, __ExtrinsicEvent, __Event...}
# __SERVER            :
# __NAMESPACE         :
# __PATH              :
# AccessResult        : 3
# Alarm               : System.Management.ManagementBaseObject
# AreaEnteredID       :
# AreaExitedID        :
# AssetID             :
# CardholderEntered   : False
# CardNumber          :
# CommServerHostName  : WS-084
# Description         : Open Door Command Issued - Door Not Used
# DeviceID            : 1
# Duress              : False
# ElevatorFloor       :
# EventText           :
# ExtendedID          :
# FacilityCode        :
# ID                  : 1939
# IsReadableCard      : False
# IssueCode           :
# PanelID             : 1
# SecondaryDeviceID   : 0
# SECURITY_DESCRIPTOR :
# SegmentID           : -1
# SerialNumber        : 1510855474
# SubType             : 11
# Time                : 20171122162622.000000+060
# TIME_CREATED        : 131558379835078552
# Type                : 0
# PSComputerName      :

function Register-AccessEvent
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
            ValueFromPipelineByPropertyName=$false)]
        [scriptblock]$Callback
    )

    process {

        $parameters = @{
            ComputerName=$Server;
            Namespace=$Script:OnGuardNamespace;
            Query="select * from Lnl_AccessEvent";
        }

        if($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

		Register-WmiEvent @parameters -Action {
            Invoke-Command -ScriptBlock $Callback -ArgumentList $Event.SourceArgs.NewEvent
        }
	}
}