<#
    .SYNOPSIS
    Gets the context server and credentials used to connect to DataConduIT.

    .DESCRIPTION
    Gets the context server and credentials used to connect to DataConduIT.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE
    Get-Context

    Credential                               Server                       EventSource
    ----------                               ------                       -----------
    None                                     localhost                    Not Set

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-Context {
    [CmdletBinding()]
    param
    (
    )

    process {
        $server = @{$true = 'localhost'; $false = $Script:Server}[$Script:Server -eq '.']
        $credential = @{$true = 'None'; $false = $($Script:Credential.UserName)}[$Script:Credential -eq $null]
        $eventSource = @{$true = 'Not Set'; $false = $($Script:EventSource)}[$Script:EventSource -eq [String]::Empty]

        $hash = @{
            Server      = $server;
            Credential  = $credential;
            EventSource = $eventSource;
        }

        New-Object PSObject -Property $hash | Add-ObjectType -TypeName "DataConduIT.LnlContext"
    }
}