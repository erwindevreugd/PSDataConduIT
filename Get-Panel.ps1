function Get-Panel
{
    [CmdletBinding()]
    param
    (
        [Parameter(Position=0, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]$Server = $Script:Server,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [PSCredential]$Credential = $Script:Credential,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int]$PanelID    
    )

    process {
        $query = "SELECT * FROM Lnl_Panel WHERE __CLASS='Lnl_Panel'"

        if($ID) {
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