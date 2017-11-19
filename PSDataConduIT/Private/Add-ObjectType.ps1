function Add-ObjectType {
    [CmdletBinding()]
    param (
        [parameter(
            ValueFromPipeline=$true
        )]
        [psobject]$Object,
        [string]$TypeName = ""
    )

    process {
        if($Object -ne $null -and $TypeName -ne "") {
            $Object.pstypenames.insert(0, $TypeName)
        }

        Write-Output $Object
    }
}