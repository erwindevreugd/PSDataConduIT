<#
    .SYNOPSIS
    Removes common wmi properties from the input object.

    .DESCRIPTION   
    Removes common wmi properties from the input object.
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Get-Cardholder | Remove-WmiProperty | Export-CSV

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Remove-WmiProperty {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            HelpMessage="The psobject parameter from which to remove the wmi properties."
        )]
        [psobject]$InputObject
    )
    
    process {
        $wmiProperties = "ComputerName","Path","Server","SuperClass","Class","Credential"
        Select-Object -InputObject $InputObject -Property * -ExcludeProperty $wmiProperties
    }
}