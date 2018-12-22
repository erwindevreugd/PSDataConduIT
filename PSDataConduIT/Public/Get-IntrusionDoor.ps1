<#
    .SYNOPSIS
    Gets an intrusion door.

    .DESCRIPTION
    Gets all intrusion door or a single intrusion door if an intrusion door id is specified.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE
    Get-IntrusionDoor

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT

    .EXTERNALHELP PSDataConduIT-help.xml
#>
function Get-IntrusionDoor {
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
            HelpMessage = 'Specifies the id of the intrusion door to get.')]
        [int]
        $IntrusionDoorID = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the panel id of the intrusion door to get.')]
        [int]
        $PanelID = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the device id of the intrusion door to get.')]
        [int]
        $DeviceID = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the name of the intrusion door to get. Wildcards are permitted.')]
        [string]
        $Name,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the host name of the door output to get. Wildcards are permitted.')]
        [string]
        $HostName
    )

    process {
        $query = "SELECT * FROM Lnl_IntrusionDoor WHERE __CLASS='Lnl_IntrusionDoor'"

        if ($IntrusionDoorID) {
            $query += " AND ID=$IntrusionDoorID"
        }

        if ($PanelID) {
            $query += " AND PANELID=$PanelID"
        }

        if ($DeviceID) {
            $query += " AND DEVICEID=$DeviceID"
        }

        if ($Name) {
            $query += " AND NAME like '$(ToWmiWildcard $Name)'"
        }

        if ($HostName) {
            $query += " AND HOSTNAME like '$(ToWmiWildcard $HostName)'"
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
                IntrusionDoorID   = $_.ID;
                Name              = $_.NAME;
                PanelID           = $_.PANELID;
                DeviceID          = $_.DEVICEID;
                HostName          = $_.HOSTNAME;
                Open              = $_.OPEN;
                SetMode           = $_.SETMODE;
                GetHardwareStatus = $_.GETHARDWARESTATUS;
            } | Add-ObjectType -TypeName "DataConduIT.LnlIntrusionDoor"
        }
    }
}