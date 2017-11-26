<#
    .SYNOPSIS
    Gets the alarm output hardware status.

    .DESCRIPTION   
    Gets the alarm output hardware status for all alarm output or the hardware status for a single alarm output if an alarm panel id is specified. If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Get-AlarmOutputHardwareStatus
    
    Online
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-AlarmOutputHardwareStatus
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
        $parameters = @{
            Server=$Server;
        }

        if($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        if(($alarmOutputs = Get-AlarmOutput @parameters -PanelID $PanelID -AlarmPanelID $AlarmPanelID -OutputID $OutputID -AlarmOutputID $AlarmOutputID) -eq $null) {
            return
        }

        foreach($alarmOutput in $alarmOutputs) {
            if(($panel = Get-Panel @parameters -PanelID ($alarmOutput.PanelID)) -eq $null) {
                continue
            }

            try {
                Write-Verbose -Message "Updating hardware status for panel '$($panel.Name)'"
                $panel.UpdateHardwareStatus.Invoke() | Out-Null
            }
            catch {
                Write-Warning -Message ("Failed to update hardware status for panel '$($panel.Name)'")
            }

            try {
                $status = $alarmOutput.GetHardwareStatus.Invoke().Status          
                $outputStatus = MapEnum ([OutputStatus]) [int]$status

                Write-Verbose -Message ("Alarm Panel '$($alarmOutput.Name)' status is '$($outputStatus)'")
            }
            catch {
                Write-Warning -Message ("Failed to get hardware status for alarm output '$($alarmOutput.Name)'")
            }
            
            New-Object PSObject -Property @{
                Name=$alarmOutput.Name;
                Status=$outputStatus;
                Panel=$panel.Name;
            } | Add-ObjectType -TypeName "DataConduIT.LnlAlarmOutputHardwareStatus"
        }
    }
}