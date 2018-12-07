<#
    .SYNOPSIS
    Adds a new division.

    .DESCRIPTION   
    Adds a new division to the database. 
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function New-Division {
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

        [ValidateLength(1, 255)]
        [Parameter(
            Mandatory = $true, 
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The name of the division.')]
        [string]
        $Name,

        [Parameter(
            Mandatory = $false, 
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The segment id to which to add the new division.')]
        [int]
        $SegmentID
    )

    process {

        $parameters = @{
            ComputerName = $Server;
            Namespace    = $Script:OnGuardNamespace;
            Class        = "Lnl_Division";
        }

        if ($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        Set-WmiInstance @parameters -Arguments @{
            Name      = $Name; 
            SegmentID = $SegmentID;
        } |
            Select-Object *, @{L = 'DivisionID'; E = {$_.ID}} | 
            Get-Division
    }
}