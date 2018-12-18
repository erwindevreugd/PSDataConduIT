<#
    .SYNOPSIS
    Sets an intrusion door mode.

    .DESCRIPTION
    Sets an intrusion door mode.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE
    Set-IntrusionDoorMode

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-IntrusionDoorMode {
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
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the id of the intrusion door for which to set the intrusion door mode.')]
        [int]
        $IntrusionDoorID = $null,

        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the new intrusion door mode for the intrusion door.')]
        [DoorMode]
        $Mode
    )

    process {
        $parameters = @{
            ComputerName = $Server;
            Namespace    = $Script:OnGuardNamespace;
        }

        if ($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        if (($intrusionDoor = Get-IntrusionDoor @parameters -IntrusionDoorID $IntrusionDoorID) -eq $null) {
            Write-Error -Message ("Intrusion door id '$($IntrusionDoorID)' not found")
            return
        }

        $intrusionDoor.SetMode.Invoke($Mode)

        Write-Verbose -Message ("Intrusion door '$($intrusionDoor.Name)' mode set to '$($Mode)'")
    }
}