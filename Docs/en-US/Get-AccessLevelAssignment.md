---
external help file: PSDataConduIT-help.xml
Module Name: PSDataConduIT
online version: https://github.com/erwindevreugd/PSDataConduIT
schema: 2.0.0
---

# Get-AccessLevelAssignment

## SYNOPSIS
Gets an accesslevel assignment.

## SYNTAX

```
Get-AccessLevelAssignment [[-Server] <String>] [[-Credential] <PSCredential>] [-AccessLevelID <Int32>]
 [-BadgeKey <Int32>]
```

## DESCRIPTION
Gets all accesslevel assignments. 

If the result returns null, try the parameter "-Verbose" to get more details.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-AccessLevelAssignment
```

AccessLevelID BadgeKey      Activate               Deactivate
------------- --------      --------               ----------
1             1

### -------------------------- EXAMPLE 2 --------------------------
```
Get-AccessLevelAssignment -BadgeKey 1
```

AccessLevelID BadgeKey      Activate               Deactivate
------------- --------      --------               ----------
1             1

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

### -AccessLevelID
The accesslevel id.

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

### -BadgeKey
The badge key.

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

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/erwindevreugd/PSDataConduIT](https://github.com/erwindevreugd/PSDataConduIT)

