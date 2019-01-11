---
external help file: PSDataConduIT-help.xml
Module Name: PSDataConduIT
online version: https://github.com/erwindevreugd/PSDataConduIT
schema: 2.0.0
---

# Get-LoggedEvent

## SYNOPSIS
Gets a logged event.

## SYNTAX

```
Get-LoggedEvent [[-Server] <String>] [[-Credential] <PSCredential>] [-SerialNumber <Int32>]
 [-Description <String>] [-EventText <String>] [-BadgeID <Int64>] [-PersonID <Int32>] [-PanelID <Int32>]
 [-DeviceID <Int32>] [-SecondaryDeviceID <Int32>] [-ExtendedID <Int32>] [-AssetID <Int32>]
 [-AccessResult <AccessResult>] [-Duress <Boolean>] [-CardholderEntered <Boolean>] [-SegmentID <Int32>]
 [<CommonParameters>]
```

## DESCRIPTION
Gets logged events or a single logged event if a logged event serial number is specified.

If the result returns null, try the parameter "-Verbose" to get more details.

## EXAMPLES

### EXAMPLE 1
```
Get-LoggedEvent
```

## PARAMETERS

### -Server
The name of the server where the DataConduIT service is running or localhost.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $Script:Server
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Credential
The credentials used to authenticate the user to the DataConduIT service.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: $Script:Credential
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SerialNumber
Specifies the serial number of the logged event to get.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Description
Specifies the description of the logged event(s) to get.
Wildcard are permitted.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -EventText
Specifies the event text of the logged event(s) to get.
Wildcard are permitted.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -BadgeID
Specifies the badge id of the logged event(s) to get.

```yaml
Type: Int64
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PersonID
Specifies the person id of the logged event(s) to get.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: CardholderID

Required: False
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PanelID
Specifies the panel id of the logged event(s) to get.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -DeviceID
Specifies the device id of the logged event(s) to get.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SecondaryDeviceID
Specifies the secondary device id of the logged event(s) to get.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ExtendedID
Specifies the extended id of the logged event(s) to get.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -AssetID
Specifies the asset id of the logged event(s) to get.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -AccessResult
Specifies the type of access result of the logged event(s) to get.

```yaml
Type: AccessResult
Parameter Sets: (All)
Aliases:
Accepted values: Other, Unknown, Granted, Denied, NotApplicable

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Duress
Specifies wheter or not the duress field was set of the logged event(s) to get.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -CardholderEntered
Specifies wheter or not the cardholder entered field was set of the logged event(s) to get.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SegmentID
Specifies the segment id of the logged event(s) to get.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
