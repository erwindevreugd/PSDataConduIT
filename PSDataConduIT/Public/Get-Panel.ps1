<#
    .SYNOPSIS
    Gets a panel.

    .DESCRIPTION   
    Gets all panels or a single panel if a panel id is specified. If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Get-AccessLevel
    
	Server                    : SERVER
	Name                      : Panel
	PrimaryIPAddress          : 0
	PanelID                   : 1
	DownloadDatabase          : System.Management.ManagementBaseObject DownloadDatabase()
	DownloadFirmware          : System.Management.ManagementBaseObject DownloadFirmware()
	Online                    : True
	PrimaryDialupHostNumber   :
	SetClock                  : System.Management.ManagementBaseObject SetClock()
	Credential                :
	GetHardwareStatus         : System.Management.ManagementBaseObject GetHardwareStatus()
	SuperClass                : Lnl_Element
	Connect                   : System.Management.ManagementBaseObject Connect()
	Workstation               : WORKSTATION
	ResetUseLimit             : System.Management.ManagementBaseObject ResetUseLimit()
	SecondaryDialupHostNumber :
	Type                      : Logical Source
	ComputerName              : SERVER
	Disconnect                : System.Management.ManagementBaseObject Disconnect()
	Class                     : Lnl_Panel
	Path                      : \\SERVER\root\OnGuard:Lnl_Panel.ID=1
	SegmentID                 : 0
	UpdateHardwareStatus      : System.Management.ManagementBaseObject UpdateHardwareStatus()
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-Panel
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
			Mandatory=$false, 
			ValueFromPipelineByPropertyName=$true,
			HelpMessage='The panel id parameter')]
        [int]$PanelID    
    )

    process {
        $query = "SELECT * FROM Lnl_Panel WHERE __CLASS='Lnl_Panel'"

        if($PanelID) {
            $query += " AND ID=$PanelID"
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

				PanelID=$_.ID;
				Type=$_.PanelType;
				Online=$_.IsOnline;
				Name=$_.Name;
				Workstation=$_.Workstation;
				PrimaryDialupHostNumber=$_.PrimaryDialupHostNumber;
				SecondaryDialupHostNumber=$_.PrimaryDialupHostNumber;
				PrimaryIPAddress=$_.PrimaryIPAddress;
				SegmentID=$_.SegmentId;

				DownloadDatabase=$_.DownloadDatabase;
				DownloadFirmware=$_.DownloadFirmware;
				ResetUseLimit=$_.ResetUseLimit;
				UpdateHardwareStatus=$_.UpdateHardwareStatus;
				Connect=$_.Connect;
				Disconnect=$_.Disconnect;
				SetClock=$_.SetClock;
				GetHardwareStatus=$_.GetHardwareStatus
			}
		}
    }
}