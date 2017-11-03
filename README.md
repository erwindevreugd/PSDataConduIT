# PSDataConduIT

[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://paypal.me/erwindevreugd)

A PowerShell module to access DataConduIT: the WMI namespace of Lenel OnGuard.

### Requirements:

* Windows PowerShell version 3.0 (at least)
* A Lenel license for DataConduIT

## Cmdlet Name Collision

To avoid name collision between the cmdlet in this module and other cmdlets you can import this module with a prefix.

```powershell
Import-Module -Name PSDataConduIT -Prefix DC
```

## Concepts

### Context

This PowerShell module uses various script variables which all cmdlets will use when they are executed. These global variables are located in **Context.ps1** and can be viewed and set with the `Get-Context` and `Set-Context` cmdlets.

If you are connecting to a server other than **localhost** you only need the use the `Set-Context` cmdlet once per PowerShell session.

#### Context Variables

* `OnGuardNamespace` is the default DataConduIT wmi namespace **root\OnGuard**. This setting cannot be changed using the `Set-Context` cmdlet, if you need to connect to an other namespace you can change this setting in the **Context.ps1** file.
* `Server` contains the server name on which the cmdlets will be executed. The default value is **localhost**.
* `Credential` contains the optional credetials used to connect to a remote server. Local connections do not support using credentials. The default value is **none** (no credentials).

#### Override Context Server and Credentials

Most cmdlets allow you to override the context server and credentials settings by specifing the `-Server` or `-Credential` parameters.

## Getting Help

To view the available command simply use the following command:

```powershell
Get-Command -Module PSDataConduIT
```

To view command specific help use the following command:

```powershell
Get-Help Get-Cardholder
```

## Available Cmdlets

### Get-Context

Shows the server name and credentials of the current context.

```powershell
SYNTAX:
    Get-Context
```

### Set-Context

Allows you to set the context variables.

```powershell
SYNTAX:
    Set-Context [-Server] <string>
    Set-Context [-Server] <string> [[-Credential] <pscredential>]
```

##### Connection to a remote server using credentials:
```powershell
SYNTAX:
    Set-Context -Server remoteservername -Credential (Get-Credential)
```

To remove a credential execute the `Set-Context` cmdlet without the `-Credential` parameter.

```powershell
SYNTAX:
    Set-Context -Server localhost
```

### Get-DataConduITService

Displays information and status of the Lenel DataConduIT Windows Service.

```powershell
SYNTAX:
    Get-DataConduITService
```

### Stop-DataConduITService

Stops the Lenel DataConduIT Windows Service.

```powershell
SYNTAX:
    Stop-DataConduITService
```

### Start-DataConduITService

Starts the Lenel DataConduIT Windows Service.

```powershell
SYNTAX:
    Start-DataConduITService
```

### Get-AccessGroup

Gets all access groups or a single access group by **AccessGroupID**.

```powershell
SYNTAX:
    Get-AccessGroup
    Get-AccessGroup [-AccessGroupID <int>]
```

### Get-AccessLevel

Gets all access levels or a single access level by **AccessLevelID** or **Name**.

```powershell
SYNTAX:
    Get-AccessLevel
    Get-AccessLevel [-AccessLevelID <int>]
    Get-AccessLevel [-Name <string>]
```

### Get-AccessLevelAssignment

Gets all access level assignments or a single access level assignemnt by **AccessLevelID** and/or **BadgeKey**.

```powershell
SYNTAX:
    Get-AccessLevelAssignment
    Get-AccessLevelAssignment [-AccessLevelID <int>]
    Get-AccessLevelAssignment [-BadgeKey <int>]
    Get-AccessLevelAssignment [-AccessLevelID <int>] [-BadgeKey <int>]
```

### Get-AccessLevelReaderAssignment

Gets all access level reader assignments or a single access level reader assignemnt by **AccessLevelID** and/or **PanelID** and **ReaderID**.

```powershell
SYNTAX:
    Get-AccessLevelReaderAssignment
    Get-AccessLevelReaderAssignment [-AccessLevelID <int>]
    Get-AccessLevelReaderAssignment [-PanelID <int>]
    Get-AccessLevelReaderAssignment [-ReaderID <int>]
    Get-AccessLevelReaderAssignment [-PanelID <int>] [-ReaderID <int>]
```

### Get-Area

Gets all antipassback areas or a single antipassback area by **AreaID**.

```powershell
SYNTAX:
    Get-Area
    Get-Area [-AreaID <int>]
```

### Get-Badge

Gets all badges or a single badge by **BadgeID** or **BadgeKey**.

```powershell
SYNTAX:
    Get-Badge
    Get-Badge [-BadgeID <long>]
    Get-Badge [-BadgeKey <int>]
```

### Get-BadgeLastLocation

Gets the last badge location for a single badge by **BadgeID**.

```powershell
SYNTAX:
    Get-BadgeLastLocation
    Get-BadgeLastLocation [-BadgeID <long>]
```

### Get-BadgeType

Gets all badge types or a single badge badge type by **BadgeTypeID**.

```powershell
SYNTAX:
    Get-BadgeType
    Get-BadgeType [-BadgeTypeID <int>]
```

### Get-Cardholder

Gets all cardholders or a single cardholder by **PersonID**.

```powershell
SYNTAX:
    Get-Cardholder
    Get-Cardholder [-PersonID <int>]
```

### Get-CurrentUser

Gets the current Lenel user account in which context the cmdlets are being executed.

```powershell
SYNTAX:
    Get-CurrentUser
```

### Get-Directory

Gets all directories or a single directory by **DirectoryID**.

```powershell
SYNTAX:
    Get-Directory
    Get-Directory [-DirectoryID <int>]
```

### Get-MonitoringZone

Gets all monitoring zones or a single monitoring zone by **MonitoringZoneID**.

```powershell
SYNTAX:
    Get-MonitoringZone
    Get-MonitoringZone [-MonitoringZoneID <int>]
```

### Get-Panel

Gets all panels or a single panel by **PanelID**.

```powershell
SYNTAX:
    Get-Panel
    Get-Panel [-PanelID <int>]
```

### Get-PanelHardwareStatus

Get the panel hardware status for the given **PanelID**.

```powershell
SYNTAX:
    Get-PanelHardwareStatus [-PanelID <int>]
```

### Get-ReaderMode

Gets the current reader mode for the given **PanelID** and **ReaderID**.

```powershell
SYNTAX:
    Get-ReaderMode [-PanelID <int>] [-ReaderID <int>]
```

### Get-Segment

Gets all segments or a single segment by **SegmentID**.

```powershell
SYNTAX:
    Get-Segment
    Get-Segment [-SegmentID <int>]
```

### Get-SegmentGroup

Gets all segment groups or a single segment group by **SegmentGroupID**.

```powershell
SYNTAX:
    Get-SegmentGroup
    Get-SegmentGroup [-SegmentGroupID <int>]
```

### Get-SegmentUnit

Gets all segment units or a single segment unit by **SegmentUnitID**.

```powershell
SYNTAX:
    Get-SegmentUnit
    Get-SegmentUnit [-SegmentUnitID <int>]
```

### Get-Timezone

Gets all timezones or a single timezone by **TimezoneID**.

```powershell
SYNTAX:
    Get-Timezone
    Get-Timezone [-TimezoneID <int>]
```

### Get-TimezoneInterval

Gets all timezone intervals or a single timezone interval by **TimezoneIntervalID**.

```powershell
SYNTAX:
    Get-TimezoneInterval
    Get-TimezoneInterval [-TimezoneIntervalID <int>]
```

### Get-User

Gets all users or a single user by **UserID**.

```powershell
SYNTAX:
    Get-User
    Get-User [-UserID <int>]
```

### Get-UserAccount

Gets all user accounts or a single user account by **UserAccountID**.

```powershell
SYNTAX:
    Get-UserAccount
    Get-UserAccount [-UserAccountID <int>]
```

### Get-Visit

Gets all visits or a single visit by **VisitID**.

```powershell
SYNTAX:
    Get-Visit
    Get-Visit [-VisitID <int>]
```

### Get-Visitor

Gets all visitors or a single visitor by **VisitorID**.

```powershell
SYNTAX:
    Get-Visitor
    Get-Visitor [-VisitorID <int>]
```

### Invoke-DownloadDatabase

Initiates a download database to the panel specified by the given **PanelID**.

```powershell
SYNTAX:
    Invoke-DownloadDatabase [-PanelID <int>]
```

### Invoke-DownloadFirmware

Initiates a download firmware to the panel specified by the given **PanelID**.

```powershell
SYNTAX:
    Invoke-DownloadFirmware [-PanelID <int>]
```

### Invoke-OpenDoor

Opens a given door by issuing a strike on a reader specified by the given **PanelID** and **ReaderID**.

```powershell
SYNTAX:
    Invoke-OpenDoor [-PanelID <int>] [-ReaderID <int>]
```

### Invoke-RefreshCache

Refeshes the DataConduIT Manager cache.

```powershell
SYNTAX:
    Invoke-OpenDoor
```

### Invoke-UpdateHardwareStatus

Forces a specific panel specified by the given **PanelID** to update its hardware status.

```powershell
SYNTAX:
    Invoke-UpdateHardwareStatus [-PanelID <int>]
```

### Set-ReaderMode

Allows you to set a specific reader mode on a reader specified by the given **PanelID** and **ReaderID**.

```powershell
SYNTAX:
    Set-ReaderMode [-PanelID <int>] [-ReaderID <int>] [-Mode {Locked | CardOnly | PinOrCard | PinAndCard | Unlocked | FacilityCodeOnly | CypherLock | Automatic} ]
```

## Additional Examples

### Pipelining Cmdlets

Various cmdlets can be used together to get the data you need.

#### Get the Badge Type for a Specific Badge

To get the badge type for a specific badge you can use the `Get-Badge` and `Get-BadgeType` cmdlets together:

```powershell
    Get-Badge -BadgeID 1 | Get-BadgeType
```

#### Get the Hardware Status for a Specific Panel

To get the hardware status for a specific panel you can use the `Get-Panel` and `Get-PanelHardwareStatus` cmdlets together:

```powershell
    Get-Panel -PanelID 1 | Get-PanelHardwareStatus
```

#### Get the Reader Mode for a Specific Reader

To get the current reader mode for a specific reader you can use the `Get-Reader` and `Get-ReaderMode` cmdlets together:

```powershell
    Get-Reader -PanelID 1 -ReaderID 1 | Get-ReaderMode
```

#### Opening a Specific Door

To open a specific door you can use the `Get-Reader` and `Invoke-OpenDoor` cmdlets together:

```powershell
    Get-Reader -PanelID 1 -ReaderID 1 | Invoke-OpenDoor
```

#### Restarting the DataConduIT Service

The `Stop-DataConduITService` and `Start-DataConduITService` cmdlets can be used together to restart the DataConduIT service.

```powershell
SYNTAX:
    Stop-DataConduITService | Start-DataConduITService
```

## Additional information:

* Lenel, http://www.lenel.com/
* DataConduIT Manual, http://www.lenel.com/assets/images/solutions/open-integration/DataConduIT.pdf

## Trademark Acknowledgements

* Lenel and OnGuard are registered trademarks of Lenel Systems.

## Donation

[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://paypal.me/erwindevreugd)