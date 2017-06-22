function Add-AccessLevelAssignment
{
    [CmdletBinding()]
    param
    (
        [Parameter(Position=0, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]$Server = $Script:Server,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [PSCredential]$Credential = $Script:Credential,

		[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [int]$BadgeKey,

		[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [int]$AccessLevelID,

		[Parameter(Mandatory=$false)]
        [datetime]$Activate,

		[Parameter(Mandatory=$false)]
        [datetime]$Deactivate
    )

    process {

        $parameters = @{
            ComputerName=$Server;
            Namespace=$Script:OnGuardNamespace;
            Class="Lnl_AccessLevelAssignment";
        }

        if($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

		if(($accessLevel = Get-AccessLevel -AccessLevelID $AccessLevelID) -eq $null) {
			throw $STR_ACCESSLEVEL_DOESNT_EXIST -f $AccessLevelID
		}

		if(($badge = Get-Badge -BadgeKey $BadgeKey) -eq $null) {
			throw $STR_BADGEKEY_DOESNT_EXIST -f $BadgeKey
		}

		if((Get-AccessLevelAssignment -BadgeKey $BadgeKey -AccessLevelID $AccessLevelID) -ne $null) {
			throw $STR_ACCESSLEVEL_ALREADY_ASSIGNED -f $accessLevel.Name, $BadgeKey
		}

		Set-WmiInstance @parameters -Arguments @{
			BADGEKEY=$BadgeKey;
			ACCESSLEVELID=$AccessLevelID; 
			ACTIVATE=$Activate;
			DEACTIVATE=$Deactivate} |
			Get-AccessLevelAssignment
	}
}