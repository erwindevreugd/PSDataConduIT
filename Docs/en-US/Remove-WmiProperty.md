---
external help file: PSDataConduIT-help.xml
Module Name: PSDataConduIT
online version: https://github.com/erwindevreugd/PSDataConduIT
schema: 2.0.0
---

# Remove-WmiProperty

## SYNOPSIS
Removes common wmi properties from the input object.

## SYNTAX

```
Remove-WmiProperty [-InputObject] <PSObject>
```

## DESCRIPTION
Removes common wmi properties from the input object.

If the result return null, try the parameter "-Verbose" to get more details.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-Cardholder | Remove-WmiProperty | Export-CSV
```

## PARAMETERS

### -InputObject
The psobject parameter from which to remove the wmi properties.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/erwindevreugd/PSDataConduIT](https://github.com/erwindevreugd/PSDataConduIT)

