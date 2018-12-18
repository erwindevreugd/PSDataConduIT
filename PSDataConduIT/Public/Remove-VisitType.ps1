<#
    .SYNOPSIS
    Removes a visit type.

    .DESCRIPTION
    Removes a visit type.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Remove-VisitType {
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
            HelpMessage = 'Specifies the id of the visit type to remove.')]
        [int]
        $VisitTypeID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the segment id parameter.')]
        [int]
        $SegmentID = -1,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $false,
            HelpMessage = 'Forces the removal of the visit type with out displaying a should process.')]
        [switch]
        $Force
    )

    process {
        $query = "SELECT * FROM Lnl_VisitType WHERE __CLASS='Lnl_VisitType' AND ID!=0"

        if ($VisitTypeID) {
            $query += " AND ID=$VisitTypeID"
        }

        if ($SegmentID -ne -1) {
            $query += " AND SEGMENTID=$SegmentID"
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
            if ($Force -or $PSCmdlet.ShouldProcess("$Server", "Removing VisitTypeID: $($item.ID), $($item.Name)")) {
                $item | Remove-WmiObject
            }
        }
    }
}