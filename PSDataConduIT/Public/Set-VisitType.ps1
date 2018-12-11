<#
    .SYNOPSIS
    Sets visit type.

    .DESCRIPTION
    Sets visit type.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Set-VisitType {
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
            HelpMessage = 'The visit type id parameter')]
        [int]
        $VisitTypeID,

        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The name of the visit type.')]
        [string]
        $Name
    )

    process {
        $query = "SELECT * FROM Lnl_VisitType WHERE __CLASS='Lnl_VisitType'"

        if ($VisitTypeID) {
            $query += " AND ID=$VisitTypeID"
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

        if (($visitType = Get-WmiObject @parameters) -eq $null) {
            Write-Error -Message ("Visit type id '$($VisitTypeID)' not found")
            return
        }

        $updateSet = @{}

        if ($Name -and $Name -ne $visitType.Name) {
            Write-Verbose -Message ("Updating name '$($visitType.Name)' to '$($Name)' on visit type id '$($visitType.ID)'")
            $updateSet.Add("Name", $Name)
        }

        $visitType | Set-WmiInstance -Arguments $updateSet |
            Select-Object *, @{L = 'VisitTypeID'; E = {$_.ID}} |
            Get-VisitType
    }
}