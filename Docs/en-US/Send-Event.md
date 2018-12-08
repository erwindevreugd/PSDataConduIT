---
external help file: PSDataConduIT-help.xml
Module Name: PSDataConduIT
online version: https://github.com/erwindevreugd/PSDataConduIT
schema: 2.0.0
---

# Send-Event

## SYNOPSIS
Sends an event to DataConduIT.

## SYNTAX

```
Send-Event [[-Server] <String>] [[-Credential] <PSCredential>] -Source <String> [-Device <String>]
 [-SubDevice <String>] -Message <String> [-BadgeID <Int64>] [-IsAccessGrant <Boolean>]
 [-IsAccessDeny <Boolean>] [-Time <DateTime>]
```

## DESCRIPTION
Sends an event to DataConduIT. 

If the result returns null, try the parameter "-Verbose" to get more details.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Send-Event
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
The source parameter.

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
The device parameter.

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
The sub device parameter.

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

### -Message
The message parameter.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: Named
Default value: [String]::Empty
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -BadgeID
The badge id parameter.

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

### -IsAccessGrant
Indicates if this is an access granted event.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -IsAccessDeny
Indicates if this is an access denied event.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Time
The time parameter.

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

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/erwindevreugd/PSDataConduIT](https://github.com/erwindevreugd/PSDataConduIT)

