---
external help file: PSDataConduIT-help.xml
Module Name: PSDataConduIT
online version: https://github.com/erwindevreugd/PSDataConduIT
schema: 2.0.0
---

# Get-Timezone

## SYNOPSIS
Gets a timezone.
Get-TimeZone \[\[-Name\] \<string\[\]\>\] \[\<CommonParameters\>\]

Get-TimeZone -Id \<string\[\]\> \[\<CommonParameters\>\]

Get-TimeZone -ListAvailable \[\<CommonParameters\>\]

## SYNTAX

```
Get-Timezone [[-Server] <String>] [[-Credential] <PSCredential>] [-TimezoneID <Int32>]
```

## DESCRIPTION
Gets all timezones or a single timezone if a timezone id is specified. 

If the result returns null, try the parameter "-Verbose" to get more details.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-Timezone
```

TimezoneID    Name
----------    ----
1             Never
2             Always
0             Not Used

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

### -TimezoneID
The timezone id parameter.

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

## INPUTS

### System.String[]


## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

[https://github.com/erwindevreugd/PSDataConduIT](https://github.com/erwindevreugd/PSDataConduIT)

[https://go.microsoft.com/fwlink/?LinkId=799468](https://go.microsoft.com/fwlink/?LinkId=799468)

