<#
    .SYNOPSIS
    Removes a visitor.

    .DESCRIPTION
    Removes a visitor from the database.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Remove-Visitor {
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
            HelpMessage = 'The visitor id parameter.')]
        [int]
        $VisitorID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $false,
            HelpMessage = 'Forces the removal of the visitor with out displaying a should process.')]
        [switch]
        $Force
    )

    process {
        $query = "SELECT * FROM Lnl_Visitor WHERE __CLASS='Lnl_Visitor'"

        if ($VisitorID) {
            $query += " AND ID=$VisitorID"
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

        $items = Get-WmiObject @parameters

        foreach ($item in $items) {
            if ($Force -or $PSCmdlet.ShouldProcess("$Server", "Removing VisitorID: $($item.ID), $($item.Name)")) {
                $item | Remove-WmiObject
            }
        }
    }
}