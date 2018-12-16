<#
    .SYNOPSIS
    Adds a new cardholder.

    .DESCRIPTION
    Adds a new cardholder to the database.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function New-Cardholder {
    [CmdletBinding()]
    param
    (
        [Parameter(
            Position = 0,
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The name of the server where the DataConduIT service is running or localhost.')]
        [string]
        $Server = $Script:Server,

        [Parameter(
            Position = 1,
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The credentials used to authenticate the user to the DataConduIT service.')]
        [PSCredential]
        $Credential = $Script:Credential,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The first name of the new cardholder.')]
        [string]
        $Firstname = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The mid name of the new cardholder.')]
        [string]
        $Midname = $null,

        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The last name of the new cardholder.')]
        [string]
        $Lastname,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The social security number (SSNO) of the new cardholder.')]
        [string]
        $SSNO = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The email of the new cardholder.')]
        [string]
        $Email = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The floor of the new cardholder.')]
        [int]
        $Floor = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The address of the new cardholder.')]
        [string]
        $Address = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The zip code of the new cardholder.')]
        [string]
        $ZipCode = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The city of the new cardholder.')]
        [string]
        $City = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The state of the new cardholder.')]
        [string]
        $State = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The phone number of the new cardholder.')]
        [string]
        $Phone = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The office phone number of the new cardholder.')]
        [string]
        $OfficePhone = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The office phone number extension of the new cardholder.')]
        [string]
        $Extension = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The birthday of the new cardholder.')]
        [Nullable[datetime]]
        $Birthday = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Allow the new cardholder to receive visitors.')]
        [switch]
        $AllowedVisitors
    )

    process {

        $parameters = @{
            ComputerName = $Server;
            Namespace    = $Script:OnGuardNamespace;
            Class        = "Lnl_Cardholder";
        }

        if ($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        Set-WmiInstance @parameters -Arguments @{
            FIRSTNAME       = $Firstname;
            MIDNAME         = $Midname;
            LASTNAME        = $Lastname;
            SSNO            = $SSNO;
            EMAIL           = $Email;
            FLOOR           = $Floor;
            ADDR1           = $Address;
            ZIP             = $ZipCode;
            CITY            = $City;
            STATE           = $State;
            PHONE           = $Phone;
            OPHONE          = $OfficePhone;
            EXT             = $Extension;
            BDATE           = if($Birthday) { ToWmiDateTime $Birthday } else { $null };
            ALLOWEDVISITORS = [bool]$AllowedVisitors
        } |
            Select-Object *, @{L = 'PersonID'; E = {$_.ID}} |
            Get-Cardholder
    }
}