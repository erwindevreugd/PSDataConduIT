<#
    .SYNOPSIS
    Gets a visitor.

    .DESCRIPTION
    Gets all visitors or a single visitor if a visitor id is specified.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE
    Get-Visitor

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT

    .EXTERNALHELP PSDataConduIT-help.xml
#>
function Get-Visitor {
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
            HelpMessage = 'Specifies the id of the visitor to get.')]
        [int]
        $VisitorID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the first name of the visitor to get. Wildcard are permitted.')]
        [string]
        $Firstname,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the mid name of the visitor(s) to get. Wildcard are permitted.')]
        [string]
        $Midname,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the last name of the visitor(s) to get. Wildcard are permitted.')]
        [string]
        $Lastname,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the ssno of the visitor(s) to get. Wildcard are permitted.')]
        [string]
        $SSNO,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the organization of the visitor(s) to get. Wildcard are permitted.')]
        [string]
        $Organization
    )

    process {
        $query = "SELECT * FROM Lnl_Visitor WHERE __CLASS='Lnl_Visitor'"

        if ($VisitorID) {
            $query += " AND ID=$VisitorID"
        }

        if ($Firstname) {
            $query += " AND MIDNAME like '$(ToWmiWildcard $Midname)'"
        }

        if ($Midname) {
            $query += " AND FIRSTNAME like '$(ToWmiWildcard $Firstname)'"
        }

        if ($Lastname) {
            $query += " AND LASTNAME like '$(ToWmiWildcard $Lastname)'"
        }

        if ($SSNO) {
            $query += " AND SSNO like '$(ToWmiWildcard $SSNO)'"
        }

        if ($Organization) {
            $query += " AND ORGANIZATION like '$(ToWmiWildcard $Organization)'"
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
                VisitorID         = $_.ID;
                Title             = $_.TITLE;
                Firstname         = $_.FIRSTNAME;
                Lastname          = $_.LASTNAME;
                Midname           = $_.MIDNAME;
                LastChanged       = ToDateTime $_.LASTCHANGED;
                Organization      = $_.ORGANIZATION;
                Extension         = $_.EXT;
                OfficePhoneNumber = $_.OPHONE;
                PhoneNumber       = $_.PHONE;
                SSNO              = $_.SSNO;
                Address           = $_.ADDR1;
                State             = $_.STATE;
                City              = $_.CITY;
                ZipCode           = $_.ZIP
            } | Add-ObjectType -TypeName "DataConduIT.LnlVisitor"
        }
    }
}