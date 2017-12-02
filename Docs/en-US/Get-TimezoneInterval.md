---
external help file: PSDataConduIT-help.xml
Module Name: PSDataConduIT
online version: https://github.com/erwindevreugd/PSDataConduIT
schema: 2.0.0
---

# Get-TimezoneInterval

## SYNOPSIS
Gets a timezone interval.

## SYNTAX

```
Get-TimezoneInterval [[-Server] <String>] [[-Credential] <PSCredential>] [-TimezoneIntervalID <Int32>]
```

## DESCRIPTION
Gets all timezone intervals or a single timezone interval if an timezone interval id is specified. 

If the result return null, try the parameter "-Verbose" to get more details.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-TimezoneInterval
```

Timezone                                 Mon   Tue   Wed   Thu   Fri   Sat   Sun   H1    H2    H3    H4    H5    H6    H7    H8
--------                                 ---   ---   ---   ---   ---   ---   ---   --    --    --    --    --    --    --    --
Always                                   \[X\]   \[X\]   \[X\]   \[X\]   \[X\]   \[X\]   \[X\]   \[X\]   \[X\]   \[X\]   \[X\]   \[X\]   \[X\]   \[X\]   \[X\]

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

### -TimezoneIntervalID
The timezone interval id parameter.

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

## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/erwindevreugd/PSDataConduIT](https://github.com/erwindevreugd/PSDataConduIT)

