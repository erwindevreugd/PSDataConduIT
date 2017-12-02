<#
    .SYNOPSIS
    Adds a new visitor.

    .DESCRIPTION   
    Adds a new visitor to the database. 
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function New-Visitor
{
    [CmdletBinding()]
    param
    (
        [Parameter(
            Position=0, 
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The name of the server where the DataConduIT service is running or localhost.')]
        [string]$Server = $Script:Server,
        
        [Parameter(
            Position=1,
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The credentials used to authenticate the user to the DataConduIT service.')]
        [PSCredential]$Credential = $Script:Credential,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The first name of the new visitor.')]
        [string]$Firstname = $null,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The mid name of the new visitor.')]
        [string]$Midname = $null,

        [Parameter(
            Mandatory=$true, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The last name of the new visitor.')]
        [string]$Lastname,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The social security number (SSNO) of the new visitor.')]
        [string]$SSNO = $null,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The address of the new visitor.')]
        [string]$Address = $null,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The city of the new visitor.')]
        [string]$City = $null,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The email of the new visitor.')]
        [string]$Email = $null,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The extension of the new visitor.')]
        [string]$Extension = $null,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The office phone number of the new visitor.')]
        [string]$OfficePhone = $null,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The organization of the new visitor.')]
        [string]$Organization = $null,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The state of the new visitor.')]
        [string]$State = $null,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The title of the new visitor.')]
        [string]$Title = $null,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The zip code of the new visitor.')]
        [string]$ZipCode = $null
    )

    process {

        $parameters = @{
            ComputerName=$Server;
            Namespace=$Script:OnGuardNamespace;
            Class="Lnl_Visitor";
        }

        if($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        Set-WmiInstance @parameters -Arguments @{
            FIRSTNAME=$Firstname;
            MIDNAME=$Midname;
            LASTNAME=$Lastname;
            SSNO=$SSNO;
            ADDRESS=$Address;
            CITY=$City;
            EMAIL=$Email;
            EXT=$Extension;
            OPHONE=$OfficePhone;
            ORGANIZATION=$Organization;
            STATE=$State;
            TITLE=$Title;
            ZIP=$ZipCode;
        } |
        Select-Object *,@{L='VisitID';E={$_.ID}} | 
        Get-Visitor
    }
}