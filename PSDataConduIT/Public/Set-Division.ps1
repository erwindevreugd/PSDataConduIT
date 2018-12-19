<#
    .SYNOPSIS
    Updates a division.

    .DESCRIPTION
    Updates a division.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT

    .EXTERNALHELP PSDataConduIT-help.xml
#>
function Set-Division {
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
            HelpMessage = 'Specifies the id of the division to update.')]
        [int]
        $DivisionID,

        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the new name of the division.')]
        [string]
        $Name
    )

    process {
        $query = "SELECT * FROM Lnl_Division WHERE __CLASS='Lnl_Division'"

        if ($DivisionID) {
            $query += " AND ID=$DivisionID"
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

        if (($division = Get-WmiObject @parameters) -eq $null) {
            Write-Error -Message ("Division id '$($DivisionID)' not found")
            return
        }

        $updateSet = @{}

        if ($Name -and $Name -ne $division.Name) {
            Write-Verbose -Message ("Updating name '$($division.Name)' to '$($Name)' on division id '$($division.ID)'")
            $updateSet.Add("Name", $Name)
        }

        $division | Set-WmiInstance -Arguments $updateSet |
            Select-Object *, @{L = 'DivisionID'; E = {$_.ID}} |
            Get-Division
    }
}