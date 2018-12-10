<#
    .SYNOPSIS
    Downloads firmware to the specified panel or reader.

    .DESCRIPTION
    Downloads firmware to the specified panel or reader.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Invoke-DownloadFirmware {
    [Alias("Download-Firmware")]
    [CmdletBinding(
        DefaultParameterSetName = 'DownloadFirmwareToAll',
        SupportsShouldProcess,
        ConfirmImpact = "High"
    )]
    param
    (
        [Parameter(
            Position = 0,
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The name of the server where the DataConduIT service is running or localhost.')]
        [string]
        $Server = $Script:Server,

        [Parameter(
            Position = 1,
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The credentials used to authenticate the user to the DataConduIT service.')]
        [PSCredential]
        $Credential = $Script:Credential,

        [Parameter(
            ParameterSetName = 'DownloadFirmwareToPanel',
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The panel id parameter.')]
        [Parameter(
            ParameterSetName = 'DownloadFirmwareToReader',
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The panel id parameter.')]
        [int]
        $PanelID,

        [Parameter(
            ParameterSetName = 'DownloadFirmwareToReader',
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The reader id parameter.')]
        [int]
        $ReaderID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $false,
            HelpMessage = 'Forces the download firmware with out displaying a should process.')]
        [switch]
        $Force
    )

    process {
        $parameters = @{
            Server = $Server;
        }

        if ($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        function DownloadFirmwareToPanel($PanelID) {
            if (($panels = Get-Panel @parameters -PanelID $PanelID) -eq $null) {
                Write-Error -Message ("Panel id '$($PanelID)' not found")
                return
            }

            foreach ($panel in $panels) {
                if ($panel.Type -eq "Logical Source") {
                    Write-Verbose -Message ("Download firmware is not possible on panel '$($panel.Name)' of type '$($panel.Type)', skipping.")
                    continue
                }

                if ($Force -or $PSCmdlet.ShouldProcess("$Server", "Download firmware to panel '$($panel.Name)'")) {
                    $panel.DownloadFirmware.Invoke() | Out-Null
                    Write-Verbose -Message ("Downloaded firmware to panel '$($panel.Name)'")
                }
            }
        }

        function DownloadFirmwareToReader($PanelID, $ReaderID) {
            if (($readers = Get-Reader @parameters -PanelID $PanelID -ReaderID $ReaderID) -eq $null) {
                Write-Error -Message ("Reader id '$($ReaderID)' on panel id '$($PanelID)' not found")
                return
            }

            foreach ($reader in $readers) {
                if ($Force -or $PSCmdlet.ShouldProcess("$Server", "Download firmware to reader '$($reader.Name)'")) {
                    $reader.DownloadFirmware.Invoke() | Out-Null
                    Write-Verbose -Message ("Downloaded firmware to reader '$($reader.Name)'")
                }
            }
        }

        switch ($PSCmdlet.ParameterSetName) {
            "DownloadFirmwareToPanel" {
                Write-Verbose -Message ("Download firmware to panel(s)")
                DownloadFirmwareToPanel $PanelID
            }
            "DownloadFirmwareToReader" {
                Write-Verbose -Message ("Download firmware to reader(s)")
                DownloadFirmwareToReader $PanelID $ReaderID
            }
            "DownloadFirmwareToAll" {
                Write-Verbose -Message ("Download firmware to panel(s) and reader(s)")
                DownloadFirmwareToPanel $PanelID
                DownloadFirmwareToReader $PanelID $ReaderID
            }
            Default { return }
        }
    }
}