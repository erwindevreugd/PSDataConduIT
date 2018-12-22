<#
    .SYNOPSIS
    Disables an user.

    .DESCRIPTION
    Disables an user.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE
    Disable-User

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT

    .EXTERNALHELP PSDataConduIT-help.xml
#>
function Disable-User {
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
            HelpMessage = 'The id of the user to disable.')]
        [int]
        $UserID,

        [Parameter(
            HelpMessage = 'Returns an object representing the user. By default, this cmdlet does not generate any output.'
        )]
        [switch]
        $PassThru,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $false,
            HelpMessage = 'Forces the user to be disabled with out displaying a should process.')]
        [switch]
        $Force
    )

    process {
        $query = "SELECT * FROM Lnl_User WHERE __CLASS='Lnl_User'"

        if ($UserID) {
            $query += " AND ID=$UserID"
        }

        LogQuery $query

        $parameters = @{
            ComputerName = $Server;
            Namespace    = $Script:OnGuardNamespace;
            Query        = $query
        }

        if ($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        $users = Get-WmiObject @parameters

        foreach ($user in $users) {
            if ($Force -or $PSCmdlet.ShouldProcess("$Server", "Disable user '$($user.LastName)'")) {
                $user | Set-WmiInstance -Arguments @{ Enabled = $false } | Out-Null
            }

            if ($PassThru) {
                $user |
                    Select-Object *, @{L = 'UserID'; E = {$_.ID}} |
                    Get-User
            }
        }
    }
}