<#
    .SYNOPSIS
    Disarms the intrusion area.

    .DESCRIPTION
    Disarms the intrusion area.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE
    Invoke-DisarmIntrusionArea

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Invoke-DisarmIntrusionArea {
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
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the id of the intrusion area to disarm.')]
        [int]
        $IntrusionAreaID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $false,
            HelpMessage = 'Returns an object that represents the intrusion area. By default, this cmdlet does not generate any output.')]
        [switch]
        $PassThru,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $false,
            HelpMessage = 'Forces the intrusion area to disarm with out displaying a should process.')]
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

        if (($intrusionAreas = Get-IntrusionArea @parameters -IntrusionAreaID $IntrusionAreaID) -eq $null) {
            Write-Verbose -Message ("No intrusion areas found")
            return
        }

        foreach ($intrusionArea in $intrusionAreas) {
            if ($Force -or $PSCmdlet.ShouldProcess("$Server", "Disarm intrusion area '$($intrusionArea.Name)'")) {
                $intrusionArea.Disarm.Invoke() | Out-Null
                Write-Verbose -Message ("Intrusion area '$($intrusionArea.Name)' disarmed")
            }

            if ($PassThru) {
                Write-Output $$intrusionArea
            }
        }
    }
}