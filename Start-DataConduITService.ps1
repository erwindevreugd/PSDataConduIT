<#
    .SYNOPSIS
    Starts the DataConduIT service.

    .DESCRIPTION   
    Starts the DataConduIT service. If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Start-DataConduITService
    
    ComputerName : SERVER
    Path         : \\SERVER\root\CIMV2:Win32_Service.Name="LS DataConduIT Service"
    Server       : SERVER
    SuperClass   : Win32_BaseService
    StartService : System.Management.ManagementBaseObject StartService()
    Name         : LS DataConduIT Service
    StopService  : System.Management.ManagementBaseObject StopService()
    Credential   :
    Class        : Win32_Service
    IsStarted    : True
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Start-DataConduITService
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
        [PSCredential]$Credential = $Script:Credential
    )

    process {   
        if((Get-DataConduITService -Server $Server -Credential $Credential) -eq $null) {
            Write-Error -Message ("DataConduIT service not found on server '$($Server)'")
            return
        }

		[void]$service.StartService.Invoke();
        
        Write-Verbose -Message ("DataConduIT Service started on '$($Server)'")

        Get-DataConduITService -Server $Server -Credential $Credential
    }
}