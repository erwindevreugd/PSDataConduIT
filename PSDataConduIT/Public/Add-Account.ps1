<#
    .SYNOPSIS
    Adds an account.

    .DESCRIPTION
    Adds an account.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT

    .EXTERNALHELP PSDataConduIT-help.xml
#>
function Add-Account {
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
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the Active Directory Security Identifier of the account to add.'
        )]
        [string]
        $ExternalAccountID,

        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the directory id of the account(s) to add.')]
        [int]
        $DirectoryID = $null,

        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the person id of the account to add.')]
        [int]
        $PersonID = $null
    )

    process {
        $parameters = @{
            ComputerName = $Server;
            Namespace    = $Script:OnGuardNamespace;
            Class        = "Lnl_Account";
        }

        if ($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        if (($directory = Get-Directory -Server $Server -Credential $Credential -DirectoryID $DirectoryID) -eq $null) {
            Write-Error -Message ("Directory with id '$($DirectoryID)' not found")
            return
        }

        if (($person = Get-Person -Server $Server -Credential $Credential -PersonID $PersonID) -eq $null) {
            Write-Error -Message ("Person with id '$($PersonID)' not found")
            return
        }

        if (($account = Get-Account -Server $Server -Credential $Credential -ExternalAccountID $ExternalAccountID -DirectoryID $DirectoryID -PersonID $PersonID) -ne $null) {
            Write-Error -Message ("Person with id '$($PersonID)' already has external account id '$($ExternalAccountID)' assigned")
            return
        }

        Set-WmiInstance @parameters -Arguments @{
            AccountID   = $ExternalAccountID;
            DirectoryID = $DirectoryID;
            PersonID    = $PersonID;
        } | Select-Object ID, @{L = 'AccountID'; E = {$_.ID}} | Get-Account

        Write-Verbose -Message ("Added external account id '$($ExternalAccountID)' to person id '$($PersonID)'")
    }
}