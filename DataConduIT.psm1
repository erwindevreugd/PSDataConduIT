if (Get-Module DataConduIT) { 
	return 
}

$psv = $PSVersionTable.PSVersion

if ($psv.Major -lt 3) {
    Write-Warning ("DataConduIT is not supported on PowerShell $($psv) and requires at least PowerShell 3.0`n" +
    "To download version 3.0, please visit https://www.microsoft.com/en-us/download/details.aspx?id=34595`n")

	return
}

Push-Location $psScriptRoot

# Support files
. .\Strings.ps1
. .\Context.ps1
. .\Enumerations.ps1
. .\Functions.ps1

# DataConduIT Cmdlets
. .\Add-AccessLevelAssignment.ps1
. .\Add-AccessLevelReaderAssignment.ps1
. .\Get-AccessGroup.ps1
. .\Get-AccessLevel.ps1
. .\Get-AccessLevelAssignment.ps1
. .\Get-AccessLevelReaderAssignment.ps1
. .\Get-Account.ps1
. .\Get-Area.ps1
. .\Get-Badge.ps1
. .\Get-BadgeLastLocation.ps1
. .\Get-BadgeType.ps1
. .\Get-Cardholder.ps1
. .\Get-CurrentUser.ps1
. .\Get-Directory.ps1
. .\Get-MonitoringZone.ps1
. .\Get-Panel.ps1
. .\Get-PanelHardwareStatus.ps1
. .\Get-Person.ps1
. .\Get-Reader.ps1
. .\Get-ReaderHardwareStatus.ps1
. .\Get-ReaderMode.ps1
. .\Get-Segment.ps1
. .\Get-SegmentGroup.ps1
. .\Get-SegmentUnit.ps1
. .\Get-Timezone.ps1
. .\Get-TimezoneInterval.ps1
. .\Get-User.ps1
. .\Get-UserAccount.ps1
. .\Get-Visit.ps1
. .\Get-Visitor.ps1
. .\Invoke-DownloadDatabase.ps1
. .\Invoke-DownloadFirmware.ps1
. .\Invoke-OpenDoor.ps1
. .\Invoke-RefreshCache.ps1
. .\Invoke-SetClock.ps1
. .\Invoke-UpdateHardwareStatus.ps1
. .\Invoke-VisitSignIn.ps1
. .\Invoke-VisitSignOut.ps1
. .\New-AccessLevel.ps1
. .\New-Badge.ps1
. .\New-Cardholder.ps1
. .\New-Visit.ps1
. .\Remove-AccessLevel.ps1
. .\Set-ReaderMode.ps1

# DataConduIT Service Cmdlets
. .\Get-DataConduITService.ps1
. .\Start-DataConduITService.ps1
. .\Stop-DataConduITService.ps1

# Context Cmdlets
. .\Get-Context.ps1
. .\Set-Context.ps1

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