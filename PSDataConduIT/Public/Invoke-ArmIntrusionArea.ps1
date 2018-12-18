<#
    .SYNOPSIS
    Arms the intrusion area.

    .DESCRIPTION
    Arms the intrusion area.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE
    Invoke-ArmIntrusionArea

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Invoke-ArmIntrusionArea {
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
            HelpMessage = 'Specifies the intrusion area id of the intrusion area to arm.')]
        [int]
        $IntrusionAreaID,

        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the arm method used to are the intrusion area.')]
        [ArmState]
        $Method,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $false,
            HelpMessage = 'Returns an object that represents the intrusion area. By default, this cmdlet does not generate any output.')]
        [switch]
        $PassThru,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $false,
            HelpMessage = 'Forces the intrusion area to arm with out displaying a should process.')]
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
            if ($Force -or $PSCmdlet.ShouldProcess("$Server", "Arm intrusion area '$($intrusionArea.Name)' '$($Method)'")) {
                $intrusionArea.Arm.Invoke($Method) | Out-Null
                Write-Verbose -Message ("Intrusion area '$($intrusionArea.Name)' '$($Method)'")
            }

            if ($PassThru) {
                Write-Output $$intrusionArea
            }
        }
    }
}