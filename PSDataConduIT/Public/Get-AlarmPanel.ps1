<#
    .SYNOPSIS
    Gets an alarm panel.

    .DESCRIPTION
    Gets all alarm panels or a single alarm panel if a panel id and an alarm panel id are specified.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE
    Get-AlarmPanel

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT

    .EXTERNALHELP PSDataConduIT-help.xml
#>
function Get-AlarmPanel {
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
            HelpMessage = 'Specifies the panel id of the alarm panel(s) to get.')]
        [int]
        $PanelID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the alarm panel id of the alarm panel(s) to get.')]
        [int]
        $AlarmPanelID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the name of the alarm panel to get. Wildcards are permitted.')]
        [string]
        $Name
    )

    process {
        $query = "SELECT * FROM Lnl_AlarmPanel WHERE __CLASS='Lnl_AlarmPanel'"

        if ($AlarmPanelID) {
            $query += " AND ID=$AlarmPanelID"
        }

        if ($PanelID) {
            $query += " AND PANELID=$PanelID"
        }

        if ($Name) {
            $query += " AND NAME like '$(ToWmiWildcard $Name)'"
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
                AlarmPanelID      = $_.ID;
                PanelID           = $_.PANELID;
                Type              = MapEnum ([ControlType].AsType()) $_.CONTROLTYPE;
                Name              = $_.NAME;
                GetHardwareStatus = $_.GetHardwareStatus;
            } | Add-ObjectType -TypeName "DataConduIT.LnlAlarmPanel"
        }
    }
}