<#
    .SYNOPSIS
    Updates a location.

    .DESCRIPTION
    Updates a location.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Set-Location {
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
            HelpMessage = 'Specifies the id of the location to update.')]
        [int]
        $LocationID,

        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the new name of the location.')]
        [string]
        $Name
    )

    process {
        $query = "SELECT * FROM Lnl_Location WHERE __CLASS='Lnl_Location'"

        if ($LocationID) {
            $query += " AND ID=$LocationID"
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

        if (($location = Get-WmiObject @parameters) -eq $null) {
            Write-Error -Message ("Location id '$($LocationID)' not found")
            return
        }

        $updateSet = @{}

        if ($Name -and $Name -ne $location.Name) {
            Write-Verbose -Message ("Updating name '$($location.Name)' to '$($Name)' on location id '$($location.ID)'")
            $updateSet.Add("Name", $Name)
        }

        $location | Set-WmiInstance -Arguments $updateSet |
            Select-Object *, @{L = 'LocationID'; E = {$_.ID}} |
            Get-Location
    }
}