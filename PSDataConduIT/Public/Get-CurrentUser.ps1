<#
    .SYNOPSIS
    Gets the current Lenel user.

    .DESCRIPTION   
    Gets the current Lenel user. 
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Get-CurrentUser
    
    User
    ----
    System Account, System Account (-1)
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>

function Get-CurrentUser
{
    [CmdletBinding()]
    param
    (
        [Parameter(
            Position=0, 
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The name of the server where the DataConduIT service is running or localhost')]
        [string]$Server = $Script:Server,
        
        [Parameter(
            Position=1,
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The credentials used to authenticate the user to the DataConduIT service')]
        [PSCredential]$Credential = $Script:Credential
    )

    process { 
        $parameters = @{
            ComputerName=$Server;
            Namespace=$Script:OnGuardNamespace;
            Class="Lnl_DataConduITManager";
            Name="GetCurrentUser"
        }

        if($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        Invoke-WmiMethod @parameters | ForEach-Object { New-Object PSObject -Property @{
                User=$_.ReturnValue;
            }  | Add-ObjectType -TypeName "DataConduIT.LnlCurrentUser"
        }
    }
}