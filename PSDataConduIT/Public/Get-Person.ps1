<#
    .SYNOPSIS
    Gets a person.

    .DESCRIPTION
    Gets all persons or a single person if a person id is specified.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE
    Get-Person

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT

    .EXTERNALHELP PSDataConduIT-help.xml
#>
function Get-Person {
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
            HelpMessage = 'Specifies the first name of the person to get. Wildcards are permitted.')]
        [string]
        $Firstname,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the mid name of the person to get. Wildcards are permitted.')]
        [string]
        $Midname,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the last name of the person to get. Wildcards are permitted.')]
        [string]
        $Lastname,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the ssno of the person to get. Wildcards are permitted.')]
        [string]
        $SSNO
    )

    process {
        $query = "SELECT * FROM Lnl_Person WHERE __CLASS='Lnl_Cardholder'"

        if ($PersonID) {
            $query += " AND ID=$PersonID"
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
                Class        = $_.__CLASS;
                SuperClass   = $_.__SUPERCLASS;
                Server       = $_.__SERVER;
                ComputerName = $_.__SERVER;
                Path         = $_.__PATH;
                Credential   = $Credential;
                PersonID     = $_.ID;
                Firstname    = $_.FIRSTNAME;
                Lastname     = $_.LASTNAME;
                Midname      = $_.MIDNAME;
                LastChanged  = ToDateTime $_.LASTCHANGED;
                SSNO         = $_.SSNO;
            } | Add-ObjectType -TypeName "DataConduIT.LnlPerson"
        }
    }
}