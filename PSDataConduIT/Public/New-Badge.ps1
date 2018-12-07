<#
    .SYNOPSIS
    Adds a new badge.

    .DESCRIPTION   
    Adds a new badge to the database. 
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
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
            HelpMessage = 'The id of the person/cardholder to which to add the new badge.')]
        [int]
        $PersonID,

        [Parameter(
            Mandatory = $true, 
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The id of the new badge.')]
        [long]
        $BadgeID,

        [Parameter(
            Mandatory = $true, 
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The badge type id of the new badge.')]
        [long]
        $BadgeTypeID,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'The activation date of the badge.')]
        [datetime]
        $Activate = ([DateTime]::Now),

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'The deactivation date of the badge.')]
        [datetime]
        $Deactivate = ([DateTime]::Now).AddYears(5),

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Indicates whether the badge is exempted from anti-passback.')]
        [switch]
        $APBExempt,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Indicates whether the badge is exempted from destination assurance.')]
        [switch]
        $DestinationExempt,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Indicates whether the badge is allowed to override deadbolt.')]
        [switch]
        $DeadboltOverride,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Indicates whether the badge is using extended strike held time.')]
        [switch]
        $ExtendedStrikeHeldTime,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Indicates whether the badge is allowed to use passage mode.')]
        [switch]
        $PassageMode,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'The pin code for the new badge.')]
        [string]
        $Pin,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'The use limit for the new badge.')]
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