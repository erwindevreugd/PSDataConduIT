<#
    .SYNOPSIS
    Gets a segment.

    .DESCRIPTION   
    Gets all segments or a single segment if a segment id is specified. 
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Get-Segment
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-Segment {
    [CmdletBinding()]
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
            HelpMessage = 'The segment id parameter.')]
        [int]
        $SegmentID
    )

    process {
        $query = "SELECT * FROM Lnl_Segment"

        if ($SegmentID) {
            $query += " WHERE ID=$SegmentID"
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

        Get-WmiObject @parameters | ForEach-Object { New-Object PSObject -Property @{
                Class        = $_.__CLASS;
                SuperClass   = $_.__SUPERCLASS;
                Server       = $_.__SERVER;
                ComputerName = $_.__SERVER;
                Path         = $_.__PATH;
                Credential   = $Credential;
                SegmentID    = $_.ID;
                Name         = $_.NAME
            } | Add-ObjectType -TypeName "DataConduIT.LnlSegment"
        } 
    }
}