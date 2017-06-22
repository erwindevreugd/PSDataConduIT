function Stop-DataConduITService
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
        $service = Get-DataConduITService -Server $Server -Credential $Credential
		[void]$service.StopService.Invoke();

		Get-DataConduITService -Server $Server -Credential $Credential
    }
}