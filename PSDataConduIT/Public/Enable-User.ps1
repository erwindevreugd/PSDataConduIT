<#
    .SYNOPSIS
    Enables an user.

    .DESCRIPTION
    Enables an user.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE
    Enable-User

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Enable-User {
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
            HelpMessage = 'The id of the user to enable.')]
        [int]
        $UserID,

        [switch]
        $PassThru,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $false,
            HelpMessage = 'Forces the user to be enabled with out displaying a should process.')]
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
            if ($Force -or $PSCmdlet.ShouldProcess("$Server", "Enable user '$($user.LastName)'")) {
                $user | Set-WmiInstance -Arguments @{ Enabled = $true }
            }

            if ($PassThru) {
                $user |
                    Select-Object *, @{L = 'UserID'; E = {$_.ID}} |
                    Get-User
            }
        }
    }
}