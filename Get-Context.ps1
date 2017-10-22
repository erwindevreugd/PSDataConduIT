<#
    .SYNOPSIS
    Gets the context server and credentials used to connect to DataConduIT.

    .DESCRIPTION   
    Gets the context server and credentials used to connect to DataConduIT. If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Get-Context

    Server=localhost;Credential=none
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-Context
{
    [CmdletBinding()]
    param
    (
    )

    process {
        $s = @{$true='localhost';$false=$Script:Server}[$Script:Server -eq '.']  
        $c = @{$true='none';$false=$($Script:Credential.UserName)}[$Script:Credential -eq $null] 

        Write-Output ("Server={0};Credential={1}" -f $s, $c)
    }
}