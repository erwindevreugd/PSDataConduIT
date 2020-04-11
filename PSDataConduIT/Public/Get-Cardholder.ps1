<#
    .SYNOPSIS
    Gets a cardholder.

    .DESCRIPTION
    Gets all cardholders or a single cardholder if a cardholder id is specified.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE
    Get-Cardholder

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT

    .EXTERNALHELP PSDataConduIT-help.xml
#>
function Get-Cardholder {
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
            HelpMessage = 'Specifies the id of the person to get.')]
        [int]
        $PersonID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the first name of the cardholder to get. Wildcard are permitted.')]
        [string]
        $Firstname,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the mid name of the cardholder(s) to get. Wildcard are permitted.')]
        [string]
        $Midname,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the last name of the cardholder(s) to get. Wildcard are permitted.')]
        [string]
        $Lastname,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the email address of the cardholder(s) to get. Wildcard are permitted.')]
        [string]
        $Email,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the ssno of the cardholder(s) to get. Wildcard are permitted.')]
        [string]
        $SSNO
    )

    process {
        $query = "SELECT * FROM Lnl_Cardholder WHERE __CLASS='Lnl_Cardholder'"

        if ($PersonID) {
            $query += " AND ID=$PersonID"
        }

        if ($Firstname) {
            $query += " AND FIRSTNAME like '$(ToWmiWildcard $Firstname)'"
        }

        if ($Midname) {
            $query += " AND MIDNAME like '$(ToWmiWildcard $Midname)'"
        }

        if ($Lastname) {
            $query += " AND LASTNAME like '$(ToWmiWildcard $Lastname)'"
        }

        if ($Email) {
            $query += " AND EMAIL like '$(ToWmiWildcard $Email)'"
        }

        if ($SSNO) {
            $query += " AND SSNO like '$(ToWmiWildcard $SSNO)'"
        }

        LogQuery $query

        $parameters = @{
            ComputerName = $Server;
            Namespace    = $Script:OnGuardNamespace;
            Query        = $query
        }

        if ($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        Get-WmiObject @parameters | ForEach-Object { New-Object PSObject -Property @{
                Class             = $_.__CLASS;
                SuperClass        = $_.__SUPERCLASS;
                Server            = $_.__SERVER;
                ComputerName      = $_.__SERVER;
                Path              = $_.__PATH;
                Credential        = $Credential;
                Birthday          = ToDateTime $_.BDATE;
                BuildingID        = $_.BUILDING;
                Floor             = $_.FLOOR;
                DepartmentID      = $_.DEPT;
                DivisionID        = $_.DIVISION;
                TitleID           = $_.TITLE;
                Firstname         = $_.FIRSTNAME;
                Lastname          = $_.LASTNAME;
                Midname           = $_.MIDNAME;
                PersonID          = $_.ID;
                CardholderID      = $_.ID;
                AllowedVisitors   = $_.ALLOWEDVISITORS;
                LastChanged       = ToDateTime $_.LASTCHANGED;
                Email             = $_.EMAIL;
                Extension         = $_.EXT;
                OfficePhoneNumber = $_.OPHONE;
                PhoneNumber       = $_.PHONE;
                SSNO              = $_.SSNO;
                Address           = $_.ADDR1;
                State             = $_.STATE;
                City              = $_.CITY;
                ZipCode           = $_.ZIP
            } | Add-ObjectType -TypeName "DataConduIT.LnlCardholder"
        }
    }
}