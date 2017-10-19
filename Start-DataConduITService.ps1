function Start-DataConduITService
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
		[void]$service.StartService.Invoke();
        
        Write-Verbose -Message "DataConduIT Service started on '$Server'"

        Get-DataConduITService -Server $Server -Credential $Credential
    }
}