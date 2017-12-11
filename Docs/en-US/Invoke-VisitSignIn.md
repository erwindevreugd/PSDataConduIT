---
external help file: PSDataConduIT-help.xml
Module Name: PSDataConduIT
online version: https://github.com/erwindevreugd/PSDataConduIT
schema: 2.0.0
---

# Invoke-VisitSignIn

## SYNOPSIS
Signs in a visit.

## SYNTAX

### SignInByAssignedBadgeID (Default)
```
Invoke-VisitSignIn [[-Server] <String>] [[-Credential] <PSCredential>] -VisitID <Int32>
 -AssignedBadgeID <Int64> [-PassThru]
```

### SignInByBadgeTypeID
```
Invoke-VisitSignIn [[-Server] <String>] [[-Credential] <PSCredential>] -VisitID <Int32> -BadgeTypeID <Int32>
 [-PrinterName <String>] [-PassThru]
```

## DESCRIPTION
Sign in a visit.

If the result return null, try the parameter "-Verbose" to get more details.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
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

### -VisitID
The visit id parameter.

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

### -AssignedBadgeID
The assigned badge id parameter.

```yaml
Type: Int64
Parameter Sets: SignInByAssignedBadgeID
Aliases: 

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -BadgeTypeID
The badge type id parameter.

```yaml
Type: Int32
Parameter Sets: SignInByBadgeTypeID
Aliases: 

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -PrinterName
The printer name parameter.

```yaml
Type: String
Parameter Sets: SignInByBadgeTypeID
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
Returns an object that represents the visit.
By default, this cmdlet does not generate any output.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/erwindevreugd/PSDataConduIT](https://github.com/erwindevreugd/PSDataConduIT)

