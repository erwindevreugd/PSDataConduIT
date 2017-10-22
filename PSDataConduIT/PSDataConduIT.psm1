if (Get-Module DataConduIT) { 
	return 
}

$psv = $PSVersionTable.PSVersion

if ($psv.Major -lt 3) {
    Write-Warning ("PSDataConduIT is not supported on PowerShell $($psv) and requires at least PowerShell 3.0`n" +
    "To download version 3.0, please visit https://www.microsoft.com/en-us/download/details.aspx?id=34595`n")

	return
}

Push-Location $psScriptRoot

# Support files
. .\Private\Strings.ps1
. .\Private\Context.ps1
. .\Private\Enumerations.ps1
. .\Private\Functions.ps1

# DataConduIT Cmdlets
. .\Public\Add-AccessLevelAssignment.ps1
. .\Public\Add-AccessLevelReaderAssignment.ps1
. .\Public\Get-AccessGroup.ps1
. .\Public\Get-AccessLevel.ps1
. .\Public\Get-AccessLevelAssignment.ps1
. .\Public\Get-AccessLevelReaderAssignment.ps1
. .\Public\Get-Account.ps1
. .\Public\Get-Area.ps1
. .\Public\Get-Badge.ps1
. .\Public\Get-BadgeLastLocation.ps1
. .\Public\Get-BadgeType.ps1
. .\Public\Get-Cardholder.ps1
. .\Public\Get-CurrentUser.ps1
. .\Public\Get-Directory.ps1
. .\Public\Get-MonitoringZone.ps1
. .\Public\Get-Panel.ps1
. .\Public\Get-PanelHardwareStatus.ps1
. .\Public\Get-Person.ps1
. .\Public\Get-Reader.ps1
. .\Public\Get-ReaderHardwareStatus.ps1
. .\Public\Get-ReaderMode.ps1
. .\Public\Get-Segment.ps1
. .\Public\Get-SegmentGroup.ps1
. .\Public\Get-SegmentUnit.ps1
. .\Public\Get-Timezone.ps1
. .\Public\Get-TimezoneInterval.ps1
. .\Public\Get-User.ps1
. .\Public\Get-UserAccount.ps1
. .\Public\Get-Visit.ps1
. .\Public\Get-Visitor.ps1
. .\Public\Invoke-DownloadDatabase.ps1
. .\Public\Invoke-DownloadFirmware.ps1
. .\Public\Invoke-OpenDoor.ps1
. .\Public\Invoke-RefreshCache.ps1
. .\Public\Invoke-SetClock.ps1
. .\Public\Invoke-SetFirstCardUnlockMode.ps1
. .\Public\Invoke-UpdateHardwareStatus.ps1
. .\Public\Invoke-VisitSignIn.ps1
. .\Public\Invoke-VisitSignOut.ps1
. .\Public\New-AccessLevel.ps1
. .\Public\New-Badge.ps1
. .\Public\New-Cardholder.ps1
. .\Public\New-Visit.ps1
. .\Public\Remove-AccessLevel.ps1
. .\Public\Set-ReaderMode.ps1

# DataConduIT Service Cmdlets
. .\Public\Get-DataConduITService.ps1
. .\Public\Start-DataConduITService.ps1
. .\Public\Stop-DataConduITService.ps1

# Context Cmdlets
. .\Public\Get-Context.ps1
. .\Public\Set-Context.ps1

Pop-Location

$variables = @(
)

$aliases = @(
)

$functions = @(
	# DataConduIT Cmdlets
	'Add-AccessLevelAssignment',
	'Add-AccessLevelReaderAssignment',
	'Get-AccessGroup',
	'Get-AccessLevel',
	'Get-AccessLevelAssignment',
	'Get-AccessLevelReaderAssignment',
	'Get-Account',
	'Get-Area',
	'Get-Badge',
	'Get-BadgeLastLocation',
	'Get-BadgeType',
	'Get-Cardholder',
	'Get-CurrentUser',
	'Get-Directory',
	'Get-MonitoringZone',
	'Get-Panel',
	'Get-PanelHardwareStatus',
	'Get-Person',
	'Get-Reader',
	'Get-ReaderHardwareStatus',
	'Get-ReaderMode',
	'Get-Segment',
	'Get-SegmentGroup',
	'Get-SegmentUnit',
	'Get-Timezone',
	'Get-TimezoneInterval',
	'Get-User',
	'Get-UserAccount',
	'Get-Visit',
	'Get-Visitor',
	'Invoke-DownloadDatabase',
	'Invoke-DownloadFirmware',
	'Invoke-OpenDoor',
	'Invoke-RefreshCache',
	'Invoke-SetClock',
	'Invoke-SetFirstCardUnlockMode',
	'Invoke-UpdateHardwareStatus',
	'Invoke-VisitSignIn',
	'Invoke-VisitSignOut',
	'New-AccessLevel',
    'New-Badge',
    'New-Cardholder',
	'New-Visit',
	'Remove-AccessLevel',
	'Set-ReaderMode'

	# DataConduIT Service Cmdlets
	'Get-DataConduITService',
	'Start-DataConduITService',
	'Stop-DataConduITService',

	# Context Cmdlets
	'Get-Context',
	'Set-Context'
)

$cmdlets = @(
)

# Set default context to localhost with no credentials
Set-Context -Server 'localhost'

Export-ModuleMember -Variable $variables -Alias $aliases -Function $functions -Cmdlet $cmdlets

cd\