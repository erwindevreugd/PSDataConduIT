function Get-CurrentUser
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
			Name="GetCurrentUser"
        }

        if($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        Invoke-WmiMethod @parameters | ForEach-Object { New-Object PSObject -Property @{
				Class=$_.__CLASS;
				SuperClass=$_.__SUPERCLASS;
				Server=$_.__SERVER;
				ComputerName=$_.__SERVER;
				Path=$_.__PATH;
				Credential=$Credential;

				User=$_.ReturnValue;
			}
		}
    }
}