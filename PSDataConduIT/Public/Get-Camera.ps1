<#
    .SYNOPSIS
    Gets a camera.

    .DESCRIPTION   
    Gets all cameras or a single camera if a camera id is specified. 
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Get-Camera
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-Camera {
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
            HelpMessage = 'The camera id parameter.')]
        [int]
        $CameraID = $null
    )

    process { 
        $query = "SELECT * FROM Lnl_Camera WHERE __CLASS='Lnl_Camera' AND NAME!=''"

        if ($CameraID) {
            $query += " AND ID=$CameraID"
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
                Class                = $_.__CLASS;
                SuperClass           = $_.__SUPERCLASS;
                Server               = $_.__SERVER;
                ComputerName         = $_.__SERVER;
                Path                 = $_.__PATH;
                Credential           = $Credential;
                CameraID             = $_.ID;
                PanelID              = $_.PANELID;
                Name                 = $_.NAME;
                Type                 = $_.CAMERATYPENAME;
                IpAddress            = IntToIPAddress $_.IPADDRESS;
                Port                 = $_.PORT;
                Channel              = $_.CHANNEL;
                FrameRate            = $_.FRAMERATE;
                HorizontalResolution = $_.HORIZONTALRESOLUTION;
                VerticalResolution   = $_.VERTICALRESOLUTION;
                VideoStandard        = $_.VIDEOSTANDARD;
                MotionBitRate        = $_.MOTIONBITRATE;
                NonMotionBitRate     = $_.NONMOTIONBITRATE;
                Workstation          = $_.WORKSTATION;
            } | Add-ObjectType -TypeName "DataConduIT.LnlCamera"
        }
    }
}