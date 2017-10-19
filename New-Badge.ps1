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
        [long]$BadgeID,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [long]$BadgeTypeID
    )

    # DynamicParam {
    #     # Set the dynamic parameters' name
    #     $ParamName_BadgeType = 'BadgeType'
    #     # Create the collection of attributes
    #     $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
    #     # Create and set the parameters' attributes
    #     $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
    #     $ParameterAttribute.Mandatory = $true
    #     $ParameterAttribute.Position = 4
    #     # Add the attributes to the attributes collection
    #     $AttributeCollection.Add($ParameterAttribute) 
    #     # Create the dictionary 
    #     $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
    #     # Generate and set the ValidateSet 
    #     $arrSet = (Get-BadgeType).Name
    #     $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)    
    #     # Add the ValidateSet to the attributes collection
    #     $AttributeCollection.Add($ValidateSetAttribute)
    #     # Create and return the dynamic parameter
    #     $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParamName_BadgeType, [string], $AttributeCollection)
    #     $RuntimeParameterDictionary.Add($ParamName_BadgeType, $RuntimeParameter)

    #     return $RuntimeParameterDictionary
    # }

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
			ID=$BadgeID;
            PERSONID=$PersonID;
            TYPE=$BadgeTypeID;
            STATUS=1} |
			Select-Object *,@{L='BadgeID';E={$_.ID}} | 
			Get-Badge
	}
}