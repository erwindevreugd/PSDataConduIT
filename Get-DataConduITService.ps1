function Get-DataConduITService
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
        $query = "SELECT * FROM Win32_Service WHERE Name='LS DataConduIT Service'"

        LogQuery $query

        $parameters = @{
            ComputerName=$Server;
            Namespace='root/CIMV2';
            Query=$query
        }

        if($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

		Get-WmiObject @parameters | ForEach-Object { New-Object PSObject -Property @{
				Class=$_.__CLASS;
				SuperClass=$_.__SUPERCLASS;
				Server=$_.__SERVER;
				ComputerName=$_.__SERVER;
				Path=$_.__PATH;
				Credential=$Credential;

				Name=$_.Name;
				IsStarted=$_.Started;

				StartService=$_.StartService;
				StopService=$_.StopService;
			}
		}
    }
}