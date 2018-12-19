<#
    .SYNOPSIS
    Creates a new cardholder.

    .DESCRIPTION
    Creates a new cardholder.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT

    .EXTERNALHELP PSDataConduIT-help.xml
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
            HelpMessage = 'Specifies the first name of the new cardholder.')]
        [string]
        $Firstname = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the mid name of the new cardholder.')]
        [string]
        $Midname = $null,

        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the last name of the new cardholder.')]
        [string]
        $Lastname,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the social security number (SSNO) of the new cardholder.')]
        [string]
        $SSNO = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the email of the new cardholder.')]
        [string]
        $Email = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the floor of the new cardholder.')]
        [int]
        $Floor = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the address of the new cardholder.')]
        [string]
        $Address = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the zip code of the new cardholder.')]
        [string]
        $ZipCode = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the city of the new cardholder.')]
        [string]
        $City = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the state of the new cardholder.')]
        [string]
        $State = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the phone number of the new cardholder.')]
        [string]
        $Phone = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the office phone number of the new cardholder.')]
        [string]
        $OfficePhone = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the office phone number extension of the new cardholder.')]
        [string]
        $Extension = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the birthday of the new cardholder.')]
        [Nullable[datetime]]
        $Birthday = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the the new cardholder to receive visitors.')]
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