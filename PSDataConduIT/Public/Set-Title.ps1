<#
    .SYNOPSIS
    Sets title.

    .DESCRIPTION
    Sets title.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Set-Title {
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
            HelpMessage = 'The title id parameter')]
        [int]
        $TitleID,

        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The name of the title.')]
        [string]
        $Name
    )

    process {
        $query = "SELECT * FROM Lnl_Title WHERE __CLASS='Lnl_Title'"

        if ($TitleID) {
            $query += " AND ID=$TitleID"
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

        if (($title = Get-WmiObject @parameters) -eq $null) {
            Write-Error -Message ("Title id '$($TitleID)' not found")
            return
        }

        $updateSet = @{}

        if ($Name -and $Name -ne $title.Name) {
            Write-Verbose -Message ("Updating name '$($title.Name)' to '$($Name)' on title id '$($title.ID)'")
            $updateSet.Add("Name", $Name)
        }

        $title | Set-WmiInstance -Arguments $updateSet |
            Select-Object *, @{L = 'TitleID'; E = {$_.ID}} |
            Get-Title
    }
}