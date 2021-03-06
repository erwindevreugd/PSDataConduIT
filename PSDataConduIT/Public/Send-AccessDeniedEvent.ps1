<#
    .SYNOPSIS
    Sends an access denied event to DataConduIT.

    .DESCRIPTION
    Sends an access denied event to DataConduIT.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE
    Send-AccessDeniedEvent

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT

    .EXTERNALHELP PSDataConduIT-help.xml
#>
function Send-AccessDeniedEvent {
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
            HelpMessage = 'Specifies the source used to send the event. This must match a configured "Logical Source" exactly.')]
        [string]
        $Source = $Script:EventSource,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the device used to send the event. When specified this must match a configured "Logical Device" exactly.')]
        [string]
        $Device = [String]::Empty,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the sub device used to send the event. When specified this must match a configured "Logical Sub-Device" exactly.')]
        [string]
        $SubDevice = [String]::Empty,

        [ValidateRange(1, 9223372036854775807)]
        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the badge id parameter of the event.')]
        [long]
        $BadgeID = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the time parameter of the event. The default value is the current date time.')]
        [DateTime]
        $Time = [DateTime]::UtcNow
    )

    process {
        $parameters = @{
            ComputerName = $Server;
            Namespace    = $Script:OnGuardNamespace;
            Class        = "Lnl_IncomingEvent";
            Name         = "SendIncomingEvent";
        }

        if ($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        # long BadgeID, string Description, string Device, string ExtendedID, bool IsAccessDeny, bool IsAccessGrant, string Source, string SubDevice, datetime Time
        Invoke-WmiMethod @parameters -ArgumentList $BadgeID, $null, $Device, $null, $true, $false, $Source, $SubDevice, (ToWmiDateTime $Time)
    }
}