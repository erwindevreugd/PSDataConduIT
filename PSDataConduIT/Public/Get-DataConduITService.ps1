<#
    .SYNOPSIS
    Gets the DataConduIT service.

    .DESCRIPTION   
    Get the DataConduIT service. 
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Get-DataConduITService
    
    Name                                     Server                       IsStarted
    ----                                     ------                       ---------
    LS DataConduIT Service                   WS-084                       True
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-DataConduITService {
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
        $Credential = $Script:Credential
    )

    process {
        $query = "SELECT * FROM Win32_Service WHERE Name='LS DataConduIT Service'"

        LogQuery $query

        $parameters = @{
            ComputerName = $Server;
            Namespace    = 'root/CIMV2';
            Query        = $query
        }

        if ($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        Get-WmiObject @parameters | ForEach-Object { New-Object PSObject -Property @{
                Class        = $_.__CLASS;
                SuperClass   = $_.__SUPERCLASS;
                Server       = $_.__SERVER;
                ComputerName = $_.__SERVER;
                Path         = $_.__PATH;
                Credential   = $Credential;
                Name         = $_.Name;
                IsStarted    = $_.Started;
                StartService = $_.StartService;
                StopService  = $_.StopService;
            } | Add-ObjectType -TypeName "DataConduIT.LnlDataConduITService"
        }
    }
}