<#
    .SYNOPSIS
    Gets an intrusion zone.

    .DESCRIPTION
    Gets all intrusion zones or a single intrusion zones if an intrusion zone id is specified.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE
    Get-IntrusionZone

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-IntrusionZone {
    [CmdletBinding()]
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
            HelpMessage = 'The intrusion zone id parameter.')]
        [int]
        $IntrusionZoneID = $null
    )

    process {
        $query = "SELECT * FROM Lnl_IntrusionZone WHERE __CLASS='Lnl_IntrusionZone'"

        if ($IntrusionZoneID) {
            $query += " AND ID=$IntrusionZoneID"
        }

        LogQuery $query

        $parameters = @{
            ComputerName = $Server;
            Namespace    = $Script:OnGuardNamespace;
            Query        = $query
        }

        if ($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        Get-WmiObject @parameters | ForEach-Object { New-Object PSObject -Property @{
                Class             = $_.__CLASS;
                SuperClass        = $_.__SUPERCLASS;
                Server            = $_.__SERVER;
                ComputerName      = $_.__SERVER;
                Path              = $_.__PATH;
                Credential        = $Credential;
                IntrusionZoneID   = $_.ID;
                Name              = $_.NAME;
                PanelID           = $_.PANELID;
                DeviceID          = $_.DEVICEID;
                HostName          = $_.HOSTNAME;
                Bypass            = $_.BYPASS;
                UnBypass          = $_.UNBYPASS;
                GetHardwareStatus = $_.GETHARDWARESTATUS;
            } | Add-ObjectType -TypeName "DataConduIT.LnlIntrusionZone"
        }
    }
}