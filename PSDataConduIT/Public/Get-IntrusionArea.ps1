<#
    .SYNOPSIS
    Gets an intrusion area.

    .DESCRIPTION
    Gets all intrusion areas or a single intrusion area if an intrusion area id is specified.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE
    Get-IntrusionArea

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-IntrusionArea {
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
            HelpMessage = 'The intrusion area id parameter.')]
        [int]
        $IntrusionAreaID = $null
    )

    process {
        $query = "SELECT * FROM Lnl_IntrusionArea WHERE __CLASS='Lnl_IntrusionArea'"

        if ($IntrusionAreaID) {
            $query += " AND ID=$IntrusionAreaID"
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
                Class               = $_.__CLASS;
                SuperClass          = $_.__SUPERCLASS;
                Server              = $_.__SERVER;
                ComputerName        = $_.__SERVER;
                Path                = $_.__PATH;
                Credential          = $Credential;
                IntrusionAreaID     = $_.ID;
                Name                = $_.NAME;
                Type                = MapEnum ([AreaType].AsType()) $_.AREATYPE;
                Number              = $_.AREANUMBER;
                PanelID             = $_.PANELID;
                Arm                 = $_.ARM;
                Disarm              = $_.DISARM;
                MasterDelayArm      = $_.MASTERDELAYARM;
                MasterInstantArm    = $_.MASTERINSTANTARM;
                PerimeterDelayArm   = $_.PERIMETERDELAYARM;
                PerimeterInstantArm = $_.PERIMETERINSTANTARM;
                SilenceAlarms       = $_.SILENCEALARMS;
                GetHardwareStatus   = $_.GETHARDWARESTATUS;
            } | Add-ObjectType -TypeName "DataConduIT.LnlIntrusionArea"
        }
    }
}