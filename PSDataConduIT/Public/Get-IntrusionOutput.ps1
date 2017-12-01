<#
    .SYNOPSIS
    Gets an intrusion output.

    .DESCRIPTION   
    Gets all intrusion ouputs or a single intrusion output if an intrusion output id is specified. 
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Get-IntrusionOutput
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-IntrusionOutput
{
    [CmdletBinding()]
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
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The intrusion output id parameter')]
        [int]$IntrusionOutputID = $null
    )

    process { 
        $query = "SELECT * FROM Lnl_IntrusionOutput WHERE __CLASS='Lnl_IntrusionOutput'"

        if($IntrusionOutputID) {
            $query += " AND ID=$IntrusionOutputID"
        }

        LogQuery $query

        $parameters = @{
            ComputerName=$Server;
            Namespace=$Script:OnGuardNamespace;
            Query=$query
        }

        if($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        Get-WmiObject @parameters | ForEach-Object { New-Object PSObject -Property @{
                Class=$_.__CLASS;
                SuperClass=$_.__SUPERCLASS;
                Server=$_.__SERVER;
                ComputerName=$_.__SERVER;
                Path=$_.__PATH;
                Credential=$Credential;

                IntrusionOuputID=$_.ID;
                Name=$_.NAME;
                PanelID=$_.PANELID;
                DeviceID=$_.DEVICEID;
                HostName=$_.HOSTNAME;

                Activate=$_.ACTIVATE;
                Deactivate=$_.DEACTIVATE;
                
                GetHardwareStatus=$_.GETHARDWARESTATUS;
            } | Add-ObjectType -TypeName "DataConduIT.LnlIntrusionOutput"
        }
    }
}