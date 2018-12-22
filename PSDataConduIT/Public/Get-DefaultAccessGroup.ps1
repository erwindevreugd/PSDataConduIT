<#
    .SYNOPSIS
    Gets the default access group for the given badge type.

    .DESCRIPTION
    Gets the default access group for the given badge type.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE
    Get-DefaultAccessGroup

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT

    .EXTERNALHELP PSDataConduIT-help.xml
#>
function Get-DefaultAccessGroup {
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
            HelpMessage = 'Specifies the badge type id for which to get the default access group(s).')]
        [int]
        $BadgeTypeID = $null
    )

    process {
        $parameters = @{
            Server = $Server;
        }

        if ($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        if (($badgeType = Get-BadgeType @parameters -BadgeTypeID $BadgeTypeID) -eq $null) {
            Write-Error -Message ("Badge type id '$($BadgeTypeID)' not found")
            return
        }

        Get-AccessGroup @parameters -AccessGroupID $badgeType.DefaultAccessGroup
    }
}