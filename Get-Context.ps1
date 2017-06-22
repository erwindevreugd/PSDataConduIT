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