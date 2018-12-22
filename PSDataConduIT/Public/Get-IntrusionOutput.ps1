<#
    .SYNOPSIS
    Gets an intrusion output.

    .DESCRIPTION
    Gets all intrusion ouputs or a single intrusion output if an intrusion output id is specified.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE
    Get-IntrusionOutput

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT

    .EXTERNALHELP PSDataConduIT-help.xml
#>
function Get-IntrusionOutput {
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
            HelpMessage = 'Specifies the id of the intrusion output to get.')]
        [int]
        $IntrusionOutputID = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the panel id of the intrusion output to get.')]
        [int]
        $PanelID = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the device id of the intrusion output to get.')]
        [int]
        $DeviceID = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the name of the intrusion output to get. Wildcards are permitted.')]
        [string]
        $Name,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the host name of the output output to get. Wildcards are permitted.')]
        [string]
        $HostName
    )

    process {
        $query = "SELECT * FROM Lnl_IntrusionOutput WHERE __CLASS='Lnl_IntrusionOutput'"

        if ($IntrusionOutputID) {
            $query += " AND ID=$IntrusionOutputID"
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
                IntrusionOuputID  = $_.ID;
                Name              = $_.NAME;
                PanelID           = $_.PANELID;
                DeviceID          = $_.DEVICEID;
                HostName          = $_.HOSTNAME;
                Activate          = $_.ACTIVATE;
                Deactivate        = $_.DEACTIVATE;
                GetHardwareStatus = $_.GETHARDWARESTATUS;
            } | Add-ObjectType -TypeName "DataConduIT.LnlIntrusionOutput"
        }
    }
}