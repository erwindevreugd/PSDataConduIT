<#
    .SYNOPSIS
    Refreshes the DataConduIT Manager cache.

    .DESCRIPTION
    Refreshes the DataConduIT Manager cache.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Invoke-RefreshCache {
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
        $parameters = @{
            ComputerName = $Server;
            Namespace    = $Script:OnGuardNamespace;
            Class        = "Lnl_DataConduITManager";
            Name         = "RefreshCache"
        }

        if ($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        Invoke-WmiMethod @parameters | Out-Null

        Write-Verbose -Message ("Refreshing DataConduIT Manager cache on '$($Server)'")
    }
}