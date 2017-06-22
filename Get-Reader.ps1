function Get-Reader
{
    [CmdletBinding()]
    param
    (
        [Parameter(Position=0, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]$Server = $Script:Server,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [PSCredential]$Credential = $Script:Credential,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int]$PanelID = $null,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int]$ReaderID = $null
    )

    process { 
        $query = "SELECT * FROM Lnl_Reader WHERE __CLASS='Lnl_Reader'"

        if($PanelID) {
            $query += " AND PanelID=$PanelID"
        }

        if($ReaderID) {
            $query += " AND ReaderID=$ReaderID"
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

				SegmentId=$_.SegmentId;

				Name=$_.Name;
				HostName=$_.HostName;
				PanelID=$_.PanelID;
				ReaderID=$_.ReaderID;
				ControlType=$_.ControlType;
				TimeAttendanceType=MapEnum ([TimeAttandanceType]) $_.TimeAttendanceType

				OpenDoor=$_.OpenDoor;
				SetReaderMode=$_.SetMode;
				GetReaderMode=$_.GetMode;
				SetFirstCardUnlockMode=$_.SetFirstCardUnlockMode;
				DownloadFirmware=$_.DownloadFirmware;
				GetHardwareStatus=$_.GetHardwareStatus
			}
		}
    }
}