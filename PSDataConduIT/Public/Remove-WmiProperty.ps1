function Remove-WmiProperty {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true
        )]
        [psobject]
        $InputObject
    )
    
    process {
        $wmiProperties = "ComputerName","Path","Server","SuperClass","Class","Credential"
        Select-Object -InputObject $InputObject -Property * -ExcludeProperty $wmiProperties
    }
}