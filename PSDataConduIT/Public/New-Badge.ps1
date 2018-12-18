<#
    .SYNOPSIS
    Creates a new badge.

    .DESCRIPTION
    Creates a new badge.

    If the result returns null, try the parameter "-Verbose" to get more details.

    .EXAMPLE

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function New-Badge {
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
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the id of the person/cardholder to which to add the new badge.')]
        [int]
        $PersonID,

        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the id of the new badge.')]
        [long]
        $BadgeID,

        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies the badge type id of the new badge.')]
        [long]
        $BadgeTypeID,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies activation date of the badge. The default value is the current date time.')]
        [datetime]
        $Activate = ([DateTime]::Now),

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies deactivation date of the badge. The default value is the current date time + 5 years.')]
        [datetime]
        $Deactivate = ([DateTime]::Now).AddYears(5),

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies whether the badge is exempted from anti-passback. When omitted the new badge will not be exempted from anti-passback.')]
        [switch]
        $APBExempt,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies whether the badge is exempted from destination assurance. When omitted the new badge will not be exempted.')]
        [switch]
        $DestinationExempt,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies whether the badge is allowed to override deadbolt. When omitted the new badge will not be allowed to override deadbolt.')]
        [switch]
        $DeadboltOverride,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies whether the badge is using extended strike and held times. When omitted the new badge will not use extened strik and held times.')]
        [switch]
        $ExtendedStrikeHeldTime,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies whether the badge is allowed to use passage mode. When omitted the new badge will not be allowed to use passage mode.')]
        [switch]
        $PassageMode,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies pin code for the new badge.')]
        [string]
        $Pin,

        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specifies use limit for the new badge.')]
        [int]
        $UseLimit
    )

    process {
        $parameters = @{
            ComputerName = $Server;
            Namespace    = $Script:OnGuardNamespace;
            Class        = "Lnl_Badge";
        }

        if ($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        if ((Get-Badge -BadgeID $BadgeID) -ne $null) {
            Write-Error -Message ("A badge with id '$($BadgeID)' already exists")
            return
        }

        Set-WmiInstance @parameters -Arguments @{
            ID                 = $BadgeID;
            PERSONID           = $PersonID;
            TYPE               = $BadgeTypeID;
            STATUS             = 1;
            ACTIVATE           = ToWmiDateTime $Activate;
            DEACTIVATE         = ToWmiDateTime $Deactivate;
            APBEXEMPT          = $APBExempt.IsPresent;
            DEST_EXEMPT        = $DestinationExempt.IsPresent;
            DEADBOLT_OVERRIDE  = $DeadboltOverride.IsPresent;
            EXTEND_STRIKE_HELD = $ExtendedStrikeHeldTime.IsPresent;
            PASSAGE_MODE       = $PassageMode.IsPresent;
            PIN                = $Pin;
            USELIMIT           = $UseLimit;
        } |
            Select-Object *, @{L = 'BadgeID'; E = {$_.ID}} |
            Get-Badge
    }
}