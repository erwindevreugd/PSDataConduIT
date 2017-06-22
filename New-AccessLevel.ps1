function New-AccessLevel
{
    [CmdletBinding()]
    param
    (
        [Parameter(Position=0, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]$Server = $Script:Server,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [PSCredential]$Credential = $Script:Credential,

		[ValidateLength(1, 255)]
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$Name,

		[Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int]$SegmentID
    )

    process {

        $parameters = @{
            ComputerName=$Server;
            Namespace=$Script:OnGuardNamespace;
            Class="Lnl_AccessLevel";
        }

        if($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

		if((Get-AccessLevel -Name $Name) -ne $null) {
			throw $STR_ACCESSLEVEL_ALREADY_EXISTS -f $Name
		}

		Set-WmiInstance @parameters -Arguments @{
			Name=$Name; 
			SegmentID=$SegmentID;} |
			Select-Object *,@{L='AccessLevelID';E={$_.ID}} | 
			Get-AccessLevel
	}
}