<#
    .SYNOPSIS
    Gets the panel hardware status.

    .DESCRIPTION   
    Gets the panel hardware status for all panels or the hardware status for a single panel if an panel id is specified. 
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Get-PanelHardwareStatus
    
    Name                 Status
    ----                 ------
    AccessPanel 1        Online
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-PanelHardwareStatus
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
        $parameters = @{
            Server=$Server;
        }

        if($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        if(($panels = Get-Panel @parameters -PanelID $PanelID) -eq $null) {
            return
        }

        foreach($panel in $panels) {
            try {
                Write-Verbose -Message "Updating hardware status for panel '$($panel.Name)'"
                $panel.UpdateHardwareStatus.Invoke() | Out-Null
            }
            catch {
                Write-Warning -Message ("Failed to update hardware status for panel '$($panel.Name)'")
            }
        }

        foreach($panel in $panels) {
            try {
                $status = $panel.GetHardwareStatus.Invoke().Status          
                $panelStatus = [Enum]::GetValues([PanelStatus]) | Where-Object { $_ -band [int]$status }
    
                Write-Verbose -Message ("Panel '$($panel.Name)' status is '$($panelStatus)'")
            }
            catch {
            }
            
            New-Object PSObject -Property @{
                Name=$panel.Name;
                Status=$panelStatus;
            } | Add-ObjectType -TypeName "DataConduIT.LnlPanelHardwareStatus"
        }
    }
}