<#
    .SYNOPSIS
    Unmasks an alarm input.

    .DESCRIPTION   
    Unmasks an alarm input. If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Invoke-UnmaskAlarmInput
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
        [int]$AlarmInputID,

        [switch]$PassThru
    )

    process {
        $parameters = @{
            Server=$Server;
        }

        if($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        if(($alarmInput = Get-AlarmInput @parameters -PanelID $PanelID -AlarmPanelID $AlarmPanelID -InputID $InputID -AlarmInputID $AlarmInputID) -eq $null) {
            Write-Error -Message ("Alarm input id '$($AlarmInputID)' on panel id '$($AlarmPanelID)' not found")
            return
        }

		$alarmInput.Unmask.Invoke()

        Write-Verbose -Message ("Alarm input '$($alarmInput.Name)' unmasked")

        if($PassThru) {
            Write-Output $$alarmInput
        }
    }
}