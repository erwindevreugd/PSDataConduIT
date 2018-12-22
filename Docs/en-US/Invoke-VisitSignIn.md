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
 -AssignedBadgeID <Int64> [-PassThru] [<CommonParameters>]
```

### SignInByBadgeTypeID
```
Invoke-VisitSignIn [[-Server] <String>] [[-Credential] <PSCredential>] -VisitID <Int32> -BadgeTypeID <Int32>
 [-PrinterName <String>] [-PassThru] [<CommonParameters>]
```

## DESCRIPTION
Sign in a visit.

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

### -VisitID
Specifies the id of the visit to sign in.

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
Specifies the badge id of the badge that is used to sign in.

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
Specifies the id of the badge type that is used to sign in.

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
Specifies the name of the printer that is used to sign in.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
