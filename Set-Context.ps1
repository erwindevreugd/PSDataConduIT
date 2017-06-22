function Set-Context
{
    [CmdletBinding()]
    param
    (
        [Parameter(Position=0, Mandatory=$true)]
        [string]$Server,

        [Parameter(Position=1, Mandatory=$false)]
        [PSCredential]$Credential
    )

    process {
        if($Server.ToLowerInvariant() -eq 'localhost') {
            $Server = '.'
        }

        Set-Variable -Name Server -Value $Server -Scope Script
        Write-Verbose -Message "Changed context server to '$Server'"

        Set-Variable -Name Credential -Value $Credential -Scope Script
        Write-Verbose -Message "Changed context credential to '$($Credential.UserName)'"
    }
}