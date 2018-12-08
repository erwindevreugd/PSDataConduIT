---
external help file: PSDataConduIT-help.xml
Module Name: PSDataConduIT
online version: https://github.com/erwindevreugd/PSDataConduIT
schema: 2.0.0
---

# Add-AccessLevelAssignment

## SYNOPSIS
Adds an accesslevel assignment to a badge.

## SYNTAX

```
Add-AccessLevelAssignment [[-Server] <String>] [[-Credential] <PSCredential>] -BadgeKey <Int32>
 -AccessLevelID <Int32> [-Activate <DateTime>] [-Deactivate <DateTime>]
```

## DESCRIPTION
Adds an accesslevel assignment to a badge.
Optionally you can provide an activation and deactivation date for the accesslevel assignment. 

If the result returns null, try the parameter "-Verbose" to get more details.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Add-AccessLevelAssignment -BadgeKey 1 -AccessLevelID 1
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

### -BadgeKey
The badgekey to which the accesslevel will be assigned.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: True
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -AccessLevelID
The accesslevel id to add to the accesslevel assignment.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: True
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Activate
The activation date of the accesslevel assignment.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Deactivate
The deactivation date of the accesslevel assignment.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/erwindevreugd/PSDataConduIT](https://github.com/erwindevreugd/PSDataConduIT)

