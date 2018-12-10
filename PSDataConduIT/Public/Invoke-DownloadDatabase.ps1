<#
    .SYNOPSIS
    Download the database to the specified panel.

    .DESCRIPTION
    Downloads the database to the specified panel.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Invoke-DownloadDatabase {
    [Alias("Download-Database")]
    [CmdletBinding(
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
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The panel id parameter.')]
        [int]
        $PanelID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $false,
            HelpMessage = 'Forces the download database with out displaying a should process.')]
        [switch]
        $Force
    )

    process {
        $parameters = @{
            Server  = $Server;
            PanelID = $PanelID;
        }

        if ($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        if (($panels = Get-Panel @parameters) -eq $null) {
            Write-Error -Message ("Panel id '$($PanelID)' not found")
            return
        }

        foreach ($panel in $panels) {
            if ($panel.Type -eq "Logical Source") {
                Write-Verbose -Message ("Download database is not possible on panel '$($panel.Name)' of type '$($panel.Type)', skipping.")
                continue
            }

            if ($Force -or $PSCmdlet.ShouldProcess("$Server", "Download database to panel '$($panel.Name)'")) {
                $panel.DownloadDatabase.Invoke() | Out-Null
                Write-Verbose -Message ("Downloading database to panel '$($panel.Name)'")
            }
        }
    }
}