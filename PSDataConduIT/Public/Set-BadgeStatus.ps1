<#
    .SYNOPSIS
    Updates a badge status.

    .DESCRIPTION
    Updates a badge status.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Set-BadgeStatus {
    [CmdletBinding()]
    param
    (
        [Parameter(
            Position = 0,
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The name of the server where the DataConduIT service is running or localhost')]
        [string]
        $Server = $Script:Server,

        [Parameter(
            Position = 1,
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The credentials used to authenticate the user to the DataConduIT service')]
        [PSCredential]
        $Credential = $Script:Credential,

        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the id of the badge status to update.')]
        [int]
        $BadgeStatusID,

        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the new name of the badge status.')]
        [string]
        $Name
    )

    process {
        $query = "SELECT * FROM Lnl_BadgeStatus WHERE __CLASS='Lnl_BadgeStatus'"

        if ($BadgeStatusID) {
            $query += " AND ID=$BadgeStatusID"
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

        if (($badgeStatus = Get-WmiObject @parameters) -eq $null) {
            Write-Error -Message ("Badge status id '$($BadgeStatusID)' not found")
            return
        }

        $updateSet = @{}

        if ($Name -and $Name -ne $badgeStatus.Name) {
            Write-Verbose -Message ("Updating name '$($badgeStatus.Name)' to '$($Name)' on badge status id '$($badgeStatus.ID)'")
            $updateSet.Add("Name", $Name)
        }

        $badgeStatus | Set-WmiInstance -Arguments $updateSet |
            Select-Object *, @{L = 'BadgeStateID'; E = {$_.ID}} |
            Get-BadgeStatus
    }
}