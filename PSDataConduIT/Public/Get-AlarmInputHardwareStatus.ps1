<#
    .SYNOPSIS
    Gets the alarm input hardware status.

    .DESCRIPTION   
    Gets the alarm input hardware status for all alarm input or the hardware status for a single alarm input if an alarm panel id is specified. 
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Get-AlarmInputHardwareStatus

    Name                           Status               Panel
    ----                           ------               -----
    Alarm Input 1                  MaskedOpenFault      AccessPanel 1
    
    Online
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-AlarmInputHardwareStatus
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
            HelpMessage='The input id parameter')]
        [int]$InputID,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The alarm input id parameter')]
        [int]$AlarmInputID  
    )

    process {
        $parameters = @{
            Server=$Server;
        }

        if($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        if(($alarmInputs = Get-AlarmInput @parameters -PanelID $PanelID -AlarmPanelID $AlarmPanelID -InputID $InputID -AlarmInputID $AlarmInputID) -eq $null) {
            return
        }

        foreach($alarmInput in $alarmInputs) {
            if(($panel = Get-Panel @parameters -PanelID ($alarmInput.PanelID)) -eq $null) {
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
                $s = [int]($alarmInput.GetHardwareStatus.Invoke().Status)
                $status = MapEnum ([InputStatus].AsType()) $s
    
                Write-Verbose -Message ("Alarm input '$($alarmInput.Name)' status is '$($status)'")
            }
            catch {
                Write-Warning -Message ("Failed to get hardware status for alarm input '$($alarmInput.Name)'")
            }
            
            New-Object PSObject -Property @{
                Name=$alarmInput.Name;
                Status=$status;
                Panel=$panel.Name;
            } | Add-ObjectType -TypeName "DataConduIT.LnlAlarmInputHardwareStatus"
        }
    }
}