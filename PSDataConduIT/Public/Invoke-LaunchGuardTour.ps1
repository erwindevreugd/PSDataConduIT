<#
    .SYNOPSIS
    Start the guard tour.

    .DESCRIPTION   
    Starts the guard tour.
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Invoke-LaunchGuardTour
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Invoke-LaunchGuardTour {
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = "High"
    )]
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
            Mandatory = $true, 
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The guard tour id parameter.')]
        [int]
        $GuardTourID,

        [Parameter(
            Mandatory = $true, 
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The badge id parameter.')]
        [long]
        $BadgeID,

        [Parameter(
            Mandatory = $true, 
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The monitoring zone parameter.')]
        [int]
        $MonitoringZoneID,

        [switch]
        $PassThru,

        [Parameter(
            Mandatory = $false, 
            ValueFromPipelineByPropertyName = $false,
            HelpMessage = 'Forces the guard tour to launch with out displaying a should process.')]
        [switch]
        $Force
    )

    process {
        $parameters = @{
            Server = $Server;
        }

        if ($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        if (($guardTour = Get-GuardTour @parameters -GuardTourID $GuardTourID) -eq $null) {
            Write-Verbose -Message ("No guard tour found")
            return
        }

        if (($badge = Get-Badge @parameters -BadgeID $BadgeID) -eq $null) {
            Write-Verbose -Message ("Badge id '$($BadgeID)' not found")
            return
        }

        if (($monitoringZone = Get-MonitoringZone @parameters -MonitoringZoneID $MonitoringZoneID) -eq $null) {
            Write-Verbose -Message ("Monitoring zone id '$($MonitoringZoneID)' not found")
            return
        }

        if ($Force -or $PSCmdlet.ShouldProcess("$Server", "Launching guard tour '$($guardTour.Name) for badge id '$($badge.BageID)' on monitoring zone '$($monitoringZone.Name)'")) {
            $result = $guardTour.LaunchTour.Invoke($BadgeID, $MonitoringZoneID).ReturnValue
            
            switch ($result) {
                0 {
                    Write-Verbose -Message ("Guard tour '$($guardTour.Name)' started")
                }
                1 { 
                    Write-Verbose -Message ("Guard tour '$($guardTour.Name)' already in progress")
                }
                Default {
                    Write-Error -Message ("Launch guard tour returned an unexpected value, the value returned was '$($result)'")
                }
            }
        }


        if ($PassThru) {
            Write-Output $$guardTour
        }
    }
}