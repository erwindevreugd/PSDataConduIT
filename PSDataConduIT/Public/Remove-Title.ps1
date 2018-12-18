<#
    .SYNOPSIS
    Removes a title.

    .DESCRIPTION
    Removes a title.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Remove-Title {
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
            HelpMessage = 'Specifies the id of the title to remove.')]
        [int]
        $TitleID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the segment id parameter.')]
        [int]
        $SegmentID = -1,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $false,
            HelpMessage = 'Forces the removal of the title with out displaying a should process.')]
        [switch]
        $Force
    )

    process {
        $query = "SELECT * FROM Lnl_Title WHERE __CLASS='Lnl_Title' AND ID!=0"

        if ($TitleID) {
            $query += " AND ID=$TitleID"
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
            if ($Force -or $PSCmdlet.ShouldProcess("$Server", "Removing TitleID: $($item.ID), $($item.Name)")) {
                $item | Remove-WmiObject
            }
        }
    }
}