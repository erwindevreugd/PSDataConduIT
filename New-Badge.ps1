function New-Badge
{
    [CmdletBinding()]
    param
    (
        [Parameter(Position=0, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]$Server = $Script:Server,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [PSCredential]$Credential = $Script:Credential,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [int]$PersonID,

		[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [long]$BadgeID
    )

    DynamicParam {
        $PrinterNameAttribute = New-Object System.Management.Automation.ParameterAttribute
        $PrinterNameAttribute.Mandatory = $true

        $attributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $attributeCollection.Add($PrinterNameAttribute)

        $PrinterNameParameter = New-Object System.Management.Automation.RuntimeDefinedParameter(
            'BadgeType', [string], $attributeCollection
        )
        $paramDictionary = new-object System.Management.Automation.RuntimeDefinedParameterDictionary
        $paramDictionary.Add('BadgeType', $PrinterNameParameter)
        return $paramDictionary
    }

    process {
        $parameters = @{
            ComputerName=$Server;
            Namespace=$Script:OnGuardNamespace;
            Class="Lnl_Badge";
        }

        if($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

		if((Get-Badge -BadgeID $BadgeID) -ne $null) {
			throw $STR_BADGE_ALREADY_EXISTS -f $BadgeID
		}

		Set-WmiInstance @parameters -Arguments @{
			ID=$ID;
            PERSONID=$PersonID;
            TYPE=$Type;
            STATUS=1} |
			Select-Object *,@{L='BadgeID';E={$_.ID}} | 
			Get-Badge
	}
}