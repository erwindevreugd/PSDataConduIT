<#
    .SYNOPSIS
    Udpates a cardholder.

    .DESCRIPTION
    Updates a cardholder.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT

    .EXTERNALHELP PSDataConduIT-help.xml
#>
function Set-Cardholder {
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

        [ValidateRange(1, 2147483647)]
        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the id of the cardholder to update.')]
        [int]
        $CardholderID,

        [ValidateLength(1, 64)]
        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the new first name of the cardholder.')]
        [string]
        $Firstname = $null,

        [ValidateLength(1, 64)]
        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the new mid name of the cardholder.')]
        [string]
        $Midname = $null,

        [ValidateLength(1, 64)]
        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the new last name of the cardholder.')]
        [string]
        $Lastname,

        [ValidateLength(1, 13)]
        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the new social security number (SSNO) of the cardholder.')]
        [string]
        $SSNO = $null,

        [ValidateLength(0, 80)]
        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the new email of the cardholder.')]
        [mailaddress]
        $Email = $null,

        [ValidateRange(1, 8)]
        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the new floor of the cardholder.')]
        [int]
        $Floor = $null,

        [ValidateLength(0, 250)]
        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the new address of the cardholder.')]
        [string]
        $Address = $null,

        [ValidateLength(0, 15)]
        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the new zip code of the cardholder.')]
        [string]
        $ZipCode = $null,

        [ValidateLength(0, 40)]
        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the new city of the cardholder.')]
        [string]
        $City = $null,

        [ValidateLength(0, 32)]
        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the new state of the cardholder.')]
        [string]
        $State = $null,

        [ValidateLength(0, 32)]
        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the new phone number of the cardholder.')]
        [string]
        $PhoneNumber = $null,

        [ValidateLength(0, 32)]
        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The office phone number of the cardholder.')]
        [string]
        $OfficePhoneNumber = $null,

        [ValidateLength(0, 8)]
        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The office phone number extension of the cardholder.')]
        [string]
        $Extension = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The birthday of the cardholder.')]
        [Nullable[datetime]]
        $Birthday = $null,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Allow the cardholder to receive visitors.')]
        [bool]
        $AllowedVisitors
    )

    process {
        $query = "SELECT * FROM Lnl_Cardholder WHERE __CLASS='Lnl_Cardholder'"

        if ($CardholderID) {
            $query += " AND ID=$CardholderID"
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

        if (($cardholder = Get-WmiObject @parameters) -eq $null) {
            Write-Error -Message ("Cardholder id '$($CardholderID)' not found")
            return
        }

        $updateSet = @{}

        if ($Firstname -and $Firstname -ne $cardholder.FIRSTNAME) {
            Write-Verbose -Message ("Updating firstname '$($cardholder.FIRSTNAME)' to '$($Firstname)' on cardholder id '$($cardholder.ID)'")
            $updateSet.Add("FIRSTNAME", $Firstname)
        }

        if ($Midname -and $Midname -ne $cardholder.MIDNAME) {
            Write-Verbose -Message ("Updating midname '$($cardholder.MIDNAME)' to '$($Midname)' on cardholder id '$($cardholder.ID)'")
            $updateSet.Add("MIDNAME", $Midname)
        }

        if ($Lastname -and $Lastname -ne $cardholder.LASTNAME) {
            Write-Verbose -Message ("Updating lastname '$($cardholder.LASTNAME)' to '$($Lastname)' on cardholder id '$($cardholder.ID)'")
            $updateSet.Add("LASTNAME", $Lastname)
        }

        if ($SSNO -and $SSNO -ne $cardholder.SSNO) {
            Write-Verbose -Message ("Updating ssno '$($cardholder.SSNO)' to '$($SSNO)' on cardholder id '$($cardholder.ID)'")
            $updateSet.Add("SSNO", $SSNO)
        }

        if ($Email -and $Email -ne $cardholder.EMAIL) {
            Write-Verbose -Message ("Updating email '$($cardholder.EMAIL)' to '$($Email)' on cardholder id '$($cardholder.ID)'")
            $updateSet.Add("EMAIL", $Email)
        }

        if ($Floor -and $Floor -ne $cardholder.FLOOR) {
            Write-Verbose -Message ("Updating floor '$($cardholder.FLOOR)' to '$($Floor)' on cardholder id '$($cardholder.ID)'")
            $updateSet.Add("FLOOR", $Floor)
        }

        if ($Address -and $Address -ne $cardholder.ADDR1) {
            Write-Verbose -Message ("Updating address '$($cardholder.ADDR1)' to '$($Address)' on cardholder id '$($cardholder.ID)'")
            $updateSet.Add("ADDR1", $Address)
        }

        if ($ZipCode -and $ZipCode -ne $cardholder.ZIP) {
            Write-Verbose -Message ("Updating zip code '$($cardholder.ZIP)' to '$($ZipCode)' on cardholder id '$($cardholder.ID)'")
            $updateSet.Add("ZIP", $ZipCode)
        }

        if ($City -and $City -ne $cardholder.CITY) {
            Write-Verbose -Message ("Updating city '$($cardholder.CITY)' to '$($City)' on cardholder id '$($cardholder.ID)'")
            $updateSet.Add("CITY", $City)
        }

        if ($State -and $State -ne $cardholder.STATE) {
            Write-Verbose -Message ("Updating state '$($cardholder.STATE)' to '$($State)' on cardholder id '$($cardholder.ID)'")
            $updateSet.Add("STATE", $State)
        }

        if ($PhoneNumber -and $PhoneNumber -ne $cardholder.PHONE) {
            Write-Verbose -Message ("Updating phone number '$($cardholder.PHONE)' to '$($PhoneNumber)' on cardholder id '$($cardholder.ID)'")
            $updateSet.Add("PHONE", $PhoneNumber)
        }

        if ($OfficePhoneNumber -and $OfficePhoneNumber -ne $cardholder.OPHONE) {
            Write-Verbose -Message ("Updating office phone number '$($cardholder.OPHONE)' to '$($OfficePhoneNumber)' on cardholder id '$($cardholder.ID)'")
            $updateSet.Add("OPHONE", $OfficePhoneNumber)
        }

        if ($Extension -and $Extension -ne $cardholder.EXT) {
            Write-Verbose -Message ("Updating extension '$($cardholder.EXT)' to '$($Extension)' on cardholder id '$($cardholder.ID)'")
            $updateSet.Add("EXT", $Extension)
        }

        if ($AllowedVisitors -and $AllowedVisitors -ne $cardholder.ALLOWEDVISITORS) {
            Write-Verbose -Message ("Updating allowed visitors '$($cardholder.ALLOWEDVISITORS)' to '$($AllowedVisitors)' on cardholder id '$($cardholder.ID)'")
            $updateSet.Add("ALLOWEDVISITORS", $AllowedVisitors)
        }

        if ($Birthday -and $Birthday -ne (ToDateTime $cardholder.BDATE)) {
            $currentBirthDay = ToDateTime $cardholder.BDATE;
            Write-Verbose -Message ("Updating birthday '$($currentBirthDay)' to '$($Birthday)' on cardholder id '$($cardholder.ID)'")
            $updateSet.Add("BDATE", (ToWmiDateTime $Birthday))
        }

        $cardholder | Set-WmiInstance -Arguments $updateSet |
            Select-Object *, @{L = 'CardholderID'; E = {$_.ID}} |
            Get-Cardholder
    }
}