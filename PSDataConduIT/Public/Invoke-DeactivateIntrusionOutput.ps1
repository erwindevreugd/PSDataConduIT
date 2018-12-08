<#
    .SYNOPSIS
    Deactivates an intrusion output.

    .DESCRIPTION
    Deactivates an intrusion output.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE
    Invoke-DeactivateIntrusionOutput

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Invoke-DeactivateIntrusionOutput {
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
            HelpMessage = 'The intrusion output id parameter.')]
        [int]
        $IntrusionOutputID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $false,
            HelpMessage = 'Returns an object that represents the intrusion output. By default, this cmdlet does not generate any output.')]
        [switch]
        $PassThru
    )

    process {
        $parameters = @{
            Server = $Server;
        }

        if ($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        if (($intrusionOutputs = Get-IntrusionOutput @parameters -IntrusionOutputID $IntrusionOutputID) -eq $null) {
            Write-Error -Message ("No intrusion outputs found")
            return
        }

        foreach ($intrusionOutput in $intrusionOutputs) {
            $intrusionOutput.Deactivate.Invoke() | Out-Null

            Write-Verbose -Message ("Intrusion output '$($intrusionOutput.Name)' deactivated")

            if ($PassThru) {
                Write-Output $intrusionOutput
            }
        }
    }
}