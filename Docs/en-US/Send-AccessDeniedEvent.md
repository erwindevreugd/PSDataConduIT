---
external help file: PSDataConduIT-help.xml
Module Name: PSDataConduIT
online version: https://github.com/erwindevreugd/PSDataConduIT
schema: 2.0.0
---

# Send-AccessDeniedEvent

## SYNOPSIS
Sends an access denied event to DataConduIT.

## SYNTAX

```
Send-AccessDeniedEvent [[-Server] <String>] [[-Credential] <PSCredential>] -Source <String> [-Device <String>]
 [-SubDevice <String>] -BadgeID <Int64> [-Time <DateTime>] [<CommonParameters>]
```

## DESCRIPTION
Sends an access denied event to DataConduIT.

If the result returns null, try the parameter "-Verbose" to get more details.

## EXAMPLES

### EXAMPLE 1
```
Send-AccessDeniedEvent
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

### -Source
Specifies the source used to send the event.
This must match a configured "Logical Source" exactly.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: $Script:EventSource
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Device
Specifies the device used to send the event.
When specified this must match a configured "Logical Device" exactly.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: [String]::Empty
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SubDevice
Specifies the sub device used to send the event.
When specified this must match a configured "Logical Sub-Device" exactly.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: [String]::Empty
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -BadgeID
Specifies the badge id parameter of the event.

```yaml
Type: Int64
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Time
Specifies the time parameter of the event.
The default value is the current date time.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: [DateTime]::UtcNow
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
