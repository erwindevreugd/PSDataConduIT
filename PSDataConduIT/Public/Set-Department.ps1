<#
    .SYNOPSIS
    Updates a department.

    .DESCRIPTION
    Updates a department.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT

    .EXTERNALHELP PSDataConduIT-help.xml
#>
function Set-Department {
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

        [ValidateRange(1, 2147483647)]
        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies id of the department to update.')]
        [int]
        $DepartmentID,

        [ValidateLength(1, 255)]
        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the new name of the department.')]
        [string]
        $Name
    )

    process {
        $query = "SELECT * FROM Lnl_Department WHERE __CLASS='Lnl_Department'"

        if ($DepartmentID) {
            $query += " AND ID=$DepartmentID"
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

        if (($department = Get-WmiObject @parameters) -eq $null) {
            Write-Error -Message ("Department id '$($DepartmentID)' not found")
            return
        }

        $updateSet = @{}

        if ($Name -and $Name -ne $department.Name) {
            Write-Verbose -Message ("Updating name '$($department.Name)' to '$($Name)' on department id '$($department.ID)'")
            $updateSet.Add("Name", $Name)
        }

        $department | Set-WmiInstance -Arguments $updateSet |
            Select-Object *, @{L = 'DepartmentID'; E = {$_.ID}} |
            Get-Department
    }
}