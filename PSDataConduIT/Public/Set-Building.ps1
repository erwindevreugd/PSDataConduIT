<#
    .SYNOPSIS
    Sets building.

    .DESCRIPTION
    Sets building.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Set-Building {
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
            HelpMessage = 'The building id parameter')]
        [int]
        $BuildingID,

        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The name of the building.')]
        [string]
        $Name
    )

    process {
        $query = "SELECT * FROM Lnl_Building WHERE __CLASS='Lnl_Building'"

        if ($BuildingID) {
            $query += " AND ID=$BuildingID"
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

        if (($building = Get-WmiObject @parameters) -eq $null) {
            Write-Error -Message ("Building id '$($BuildingID)' not found")
            return
        }

        $updateSet = @{}

        if ($Name -and $Name -ne $building.Name) {
            Write-Verbose -Message ("Updating name '$($building.Name)' to '$($Name)' on building id '$($building.ID)'")
            $updateSet.Add("Name", $Name)
        }

        $badgeStatus | Set-WmiInstance -Arguments $updateSet |
            Select-Object *, @{L = 'BuildingID'; E = {$_.ID}} |
            Get-Building
    }
}