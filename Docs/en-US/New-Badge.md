---
external help file: PSDataConduIT-help.xml
Module Name: PSDataConduIT
online version: https://github.com/erwindevreugd/PSDataConduIT
schema: 2.0.0
---

# New-Badge

## SYNOPSIS
Creates a new badge.

## SYNTAX

```
New-Badge [[-Server] <String>] [[-Credential] <PSCredential>] -PersonID <Int32> -BadgeID <Int64>
 -BadgeTypeID <Int64> [-Activate <DateTime>] [-Deactivate <DateTime>] [-APBExempt] [-DestinationExempt]
 [-DeadboltOverride] [-ExtendedStrikeHeldTime] [-PassageMode] [-Pin <String>] [-UseLimit <Int32>]
 [<CommonParameters>]
```

## DESCRIPTION
Creates a new badge.

If the result returns null, try the parameter "-Verbose" to get more details.

## EXAMPLES

### EXAMPLE 1
```

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

### -PersonID
Specifies the id of the person/cardholder to which to add the new badge.

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

### -BadgeID
Specifies the id of the new badge.

```yaml
Type: Int64
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -BadgeTypeID
Specifies the badge type id of the new badge.

```yaml
Type: Int64
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Activate
Specifies activation date of the badge.
The default value is the current date time.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: ([DateTime]::Now)
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Deactivate
Specifies deactivation date of the badge.
The default value is the current date time + 5 years.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: ([DateTime]::Now).AddYears(5)
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -APBExempt
Specifies whether the badge is exempted from anti-passback.
When omitted the new badge will not be exempted from anti-passback.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -DestinationExempt
Specifies whether the badge is exempted from destination assurance.
When omitted the new badge will not be exempted.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -DeadboltOverride
Specifies whether the badge is allowed to override deadbolt.
When omitted the new badge will not be allowed to override deadbolt.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ExtendedStrikeHeldTime
Specifies whether the badge is using extended strike and held times.
When omitted the new badge will not use extened strik and held times.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PassageMode
Specifies whether the badge is allowed to use passage mode.
When omitted the new badge will not be allowed to use passage mode.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Pin
Specifies pin code for the new badge.

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

### -UseLimit
Specifies use limit for the new badge.

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
