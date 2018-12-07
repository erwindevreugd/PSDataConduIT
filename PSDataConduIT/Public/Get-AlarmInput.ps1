<#
    .SYNOPSIS
    Gets an alarm input.

    .DESCRIPTION   
    Gets all alarm input or a single alarm input if a alarm input id is specified. 
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Get-AlarmInput

    PanelID       AlarmPanelID  InputID       AlarmInputID  Name
    -------       ------------  -------       ------------  ----
    1             66            1             1             Alarm Input 1
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-AlarmInput {
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
            HelpMessage = 'The panel id parameter.')]
        [int]
        $PanelID,

        [Parameter(
            Mandatory = $false, 
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The alarm panel id parameter.')]
        [int]
        $AlarmPanelID,

        [Parameter(
            Mandatory = $false, 
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The input id parameter.')]
        [int]
        $InputID,

        [Parameter(
            Mandatory = $false, 
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The alarm input id parameter.')]
        [int]
        $AlarmInputID
    )

    process {
        $query = "SELECT * FROM Lnl_AlarmInput WHERE __CLASS='Lnl_AlarmInput'"

        if ($PanelID) {
            $query += " AND PANELID=$PanelID"
        }

        if ($AlarmPanelID) {
            $query += " AND ALARMPANELID=$AlarmPanelID"
        }

        if ($InputID) {
            $query += " AND INPUTID=$InputID"
        }

        if ($AlarmInputID) {
            $query += " AND ID=$AlarmInputID"
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
                PanelID           = $_.PANELID;
                AlarmPanelID      = $_.ALARMPANELID;
                InputID           = $_.INPUTID;
                AlarmInputID      = $_.ID;
                Name              = $_.NAME;
                GetHardwareStatus = $_.GetHardwareStatus;
                Mask              = $_.MASK;
                Unmask            = $_.UNMASK;
            } | Add-ObjectType -TypeName "DataConduIT.LnlAlarmInput"
        }
    }
}