<#
    .SYNOPSIS
    Adds a new holiday.

    .DESCRIPTION   
    Adds a new holiday to the database. 
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function New-Holiday
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

		[ValidateLength(1, 255)]
        [Parameter(
            Mandatory=$true, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The name of the holiday')]
        [string]$Name,

        [Parameter(
            Mandatory=$true, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The starting date of the holiday')]
        [datetime]$StartDate,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The extent days of the holiday')]
        [int]$ExtentDays,

		[Parameter(
            Mandatory=$true, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The segment id to which to add the new holiday')]
        [int]$SegmentID
    )

    process {

        Write-Warning -Message "Currently not supported by DataConduIT"
        
        $parameters = @{
            ComputerName=$Server;
            Namespace=$Script:OnGuardNamespace;
            Class="Lnl_Holiday";
        }

        if($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

		Set-WmiInstance @parameters -Arguments @{
            Name=$Name;
            StartDate=ToWmiDateTime $StartDate;
            ExtentDays=$ExtentDays;
			SegmentID=$SegmentID;} |
			Select-Object *,@{L='HolidayID';E={$_.ID}} | 
			Get-Holiday
	}
}