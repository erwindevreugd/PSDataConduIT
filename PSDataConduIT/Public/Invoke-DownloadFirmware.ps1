<#
    .SYNOPSIS
    Downloads firmware to the specified panel or reader.

    .DESCRIPTION   
    Downloads firmware to the specified panel or reader. 
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Invoke-DownloadFirmware
{
    [CmdletBinding(
        DefaultParameterSetName='DownloadFirmwareToPanel'
    )]
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
            ParameterSetName='DownloadFirmwareToPanel',
            Mandatory=$true, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The panel id parameter')]
        [Parameter(
            ParameterSetName='DownloadFirmwareToReader',
            Mandatory=$true, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The panel id parameter')]
        [int]$PanelID,

        [Parameter(
            ParameterSetName='DownloadFirmwareToReader',
            Mandatory=$true, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The reader id parameter')]
        [int]$ReaderID   
    )

    process {
        $parameters = @{
            Server=$Server;
        }

        if($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        switch ($PSCmdlet.ParameterSetName) {
            "DownloadFirmwareToPanel" {
                if(($panel = Get-Panel @parameters -PanelID $PanelID) -eq $null) {
                    Write-Error -Message ("Panel id '$($PanelID)' not found")
                    return
                }
                
                $panel.DownloadFirmware.Invoke() | Out-Null
        
                Write-Verbose -Message ("Downloaded firmware to panel '$($panel.Name)'")
            }
            "DownloadFirmwareToReader" {
                if(($reader = Get-Reader @parameters -PanelID $PanelID -ReaderID $ReaderID) -eq $null) {
                    Write-Error -Message ("Reader id '$($ReaderID)' on panel id '$($PanelID)' not found")
                    return
                }
                
                $reader.DownloadFirmware.Invoke() | Out-Null
        
                Write-Verbose -Message ("Downloaded firmware to reader '$($reader.Name)'")
            }
            Default { return }
        }
    }
}