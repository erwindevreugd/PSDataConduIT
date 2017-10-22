<#
    .SYNOPSIS
    Adds a new cardholder.

    .DESCRIPTION   
    Adds a new cardholder to the database. If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function New-Cardholder
{
    [CmdletBinding()]
    param
    (
        [Parameter(
            Position=0, 
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The name of the server where the DataConduIT service is running or localhost')]
        [string]$Server = $Script:Server,
        
        [Parameter(
            Position=1,
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The credentials used to authenticate the user to the DataConduIT service')]
        [PSCredential]$Credential = $Script:Credential,

		[Parameter(
            Mandatory=$true, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The last name of the new cardholder')]
        [string]$Lastname,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The first name of the new cardholder')]
        [string]$Firstname = $null,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The social security number (SSNO) of the new cardholder')]
        [string]$SSNO = $null,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The email of the new cardholder')]
        [string]$Email = $null,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The floor of the new cardholder')]
        [int]$Floor = $null,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='Allow the new cardholder to receive visitors')]
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