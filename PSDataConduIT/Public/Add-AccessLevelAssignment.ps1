<#
    .SYNOPSIS
    Adds an accesslevel assignment to a badge.

    .DESCRIPTION
    Adds an accesslevel assignment to a badge. Optionally you can provide an activation and deactivation date for the accesslevel assignment.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE
    Add-AccessLevelAssignment -BadgeKey 1 -AccessLevelID 1

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Add-AccessLevelAssignment {
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
            HelpMessage = 'The badgekey to which the accesslevel will be assigned.')]
        [int]
        $BadgeKey,

        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The accesslevel id to add to the accesslevel assignment.')]
        [int]
        $AccessLevelID,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'The activation date of the accesslevel assignment.')]
        [datetime]
        $Activate,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'The deactivation date of the accesslevel assignment.')]
        [datetime]
        $Deactivate
    )

    process {
        $parameters = @{
            ComputerName = $Server;
            Namespace    = $Script:OnGuardNamespace;
            Class        = "Lnl_AccessLevelAssignment";
        }

        if ($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        if (($accessLevel = Get-AccessLevel -AccessLevelID $AccessLevelID) -eq $null) {
            Write-Error -Message ("Accesslevel with id '$($AccessLevelID)' not found")
            return
        }

        if (($badge = Get-Badge -BadgeKey $BadgeKey) -eq $null) {
            Write-Error -Message ("BadgeKey '$($BadgeKey)' not found")
            return
        }

        if ((Get-AccessLevelAssignment -BadgeKey $BadgeKey -AccessLevelID $AccessLevelID) -ne $null) {
            Write-Error -Message ("Accesslevel '$($accessLevel.Name)' is already assigned to BadgeKey '$($BadgeKey)'")
            return
        }

        Set-WmiInstance @parameters -Arguments @{
            BADGEKEY      = $BadgeKey;
            ACCESSLEVELID = $AccessLevelID;
            ACTIVATE      = $Activate;
            DEACTIVATE    = $Deactivate
        } |
            Get-AccessLevelAssignment

        Write-Verbose -Message ("Added accesslevel '$($accessLevel.Name)' to badge key '$($badge.BadgeKey)'")
    }
}