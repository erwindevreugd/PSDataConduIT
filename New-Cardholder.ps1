function New-Cardholder
{
    [CmdletBinding()]
    param
    (
        [Parameter(Position=0, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]$Server = $Script:Server,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [PSCredential]$Credential = $Script:Credential,

		[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$Lastname,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]$Firstname = $null,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]$SSNO = $null,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]$Email = $null,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int]$Floor = $null,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [switch]$AllowedVisitors
    )

    process {

        $parameters = @{
            ComputerName=$Server;
            Namespace=$Script:OnGuardNamespace;
            Class="Lnl_Cardholder";
        }

        if($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

		#if((Get-Badge -ID $ID) -ne $null) {
		#	throw $STR_CARDHOLDER_ALREADY_EXISTS -f $
		#}

		Set-WmiInstance @parameters -Arguments @{
			LASTNAME=$Lastname;
            FIRSTNAME=$Firstname;
            EMAIL=$Email;
            FLOOR=$Floor;
            SSNO=$SSNO;
            ALLOWEDVISITORS=[bool]$AllowedVisitors} |
			Select-Object *,@{L='PersonID';E={$_.ID}} | 
			Get-Cardholder
	}
}