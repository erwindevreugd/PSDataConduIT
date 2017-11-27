<#
    .SYNOPSIS
    Gets an alarm output.

    .DESCRIPTION   
    Gets all alarm output or a single alarm output if a alarm output id is specified. If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Get-AlarmOutput
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-AlarmOutput
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
        [int]$PanelID,

        [Parameter(
			Mandatory=$false, 
			ValueFromPipelineByPropertyName=$true,
			HelpMessage='The alarm panel id parameter')]
        [int]$AlarmPanelID,

        [Parameter(
			Mandatory=$false, 
			ValueFromPipelineByPropertyName=$true,
			HelpMessage='The output id parameter')]
        [int]$OutputID,

        [Parameter(
			Mandatory=$false, 
			ValueFromPipelineByPropertyName=$true,
			HelpMessage='The alarm output id parameter')]
        [int]$AlarmOutputID
    )

    process {
        $query = "SELECT * FROM Lnl_AlarmOutput WHERE __CLASS='Lnl_AlarmOutput'"

        if($PanelID) {
            $query += " AND PANELID=$PanelID"
        }

        if($AlarmPanelID) {
            $query += " AND ALARMPANELID=$AlarmPanelID"
        }

        if($OutputID) {
            $query += " AND OUTPUTID=$OutputID"
        }

        if($AlarmOutputID) {
            $query += " AND ID=$AlarmOutputID"
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

				PanelID=$_.PANELID;
                AlarmPanelID=$_.ALARMPANELID;
                OutputID=$_.OUTPUTID;
                AlarmOutputID=$_.ID;
				Name=$_.NAME;

                GetHardwareStatus=$_.GetHardwareStatus;
                Activate=$_.ACTIVATE;
                Deactivate=$_.DEACTIVATE;
                Pulse=$_.PULSE;
			} | Add-ObjectType -TypeName "DataConduIT.LnlAlarmOutput"
		}
    }
}