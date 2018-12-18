<#
    .SYNOPSIS
    Creates a new visitor.

    .DESCRIPTION
    Creates a new visitor.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function New-Visitor {
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
            HelpMessage = 'Specifies the first name of the new visitor.')]
        [string]
        $Firstname = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the mid name of the new visitor.')]
        [string]
        $Midname = $null,

        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the last name of the new visitor.')]
        [string]$Lastname,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the social security number (SSNO) of the new visitor.')]
        [string]$SSNO = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the address of the new visitor.')]
        [string]$Address = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the city of the new visitor.')]
        [string]$City = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the email of the new visitor.')]
        [string]$Email = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the extension of the new visitor.')]
        [string]$Extension = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the office phone number of the new visitor.')]
        [string]$OfficePhone = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the organization of the new visitor.')]
        [string]$Organization = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the state of the new visitor.')]
        [string]$State = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the title of the new visitor.')]
        [string]$Title = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the zip code of the new visitor.')]
        [string]$ZipCode = $null
    )

    process {

        $parameters = @{
            ComputerName = $Server;
            Namespace    = $Script:OnGuardNamespace;
            Class        = "Lnl_Visitor";
        }

        if ($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        Set-WmiInstance @parameters -Arguments @{
            FIRSTNAME    = $Firstname;
            MIDNAME      = $Midname;
            LASTNAME     = $Lastname;
            SSNO         = $SSNO;
            ADDRESS      = $Address;
            CITY         = $City;
            EMAIL        = $Email;
            EXT          = $Extension;
            OPHONE       = $OfficePhone;
            ORGANIZATION = $Organization;
            STATE        = $State;
            TITLE        = $Title;
            ZIP          = $ZipCode;
        } |
            Select-Object *, @{L = 'VisitorID'; E = {$_.ID}} |
            Get-Visitor
    }
}