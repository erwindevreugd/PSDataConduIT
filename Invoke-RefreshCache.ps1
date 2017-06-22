function Invoke-RefreshCache
{
    [CmdletBinding()]
    param
    (
        [Parameter(Position=0, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]$Server = $Script:Server,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [PSCredential]$Credential = $Script:Credential
    )

    process { 
        $parameters = @{
            ComputerName=$Server;
            Namespace=$Script:OnGuardNamespace;
			Class="Lnl_DataConduITManager";
			Name="RefreshCache"
        }

        if($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        Invoke-WmiMethod @parameters
    }
}