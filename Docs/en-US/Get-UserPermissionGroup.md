---
external help file: PSDataConduIT-help.xml
Module Name: PSDataConduIT
online version: https://github.com/erwindevreugd/PSDataConduIT
schema: 2.0.0
---

# Get-UserPermissionGroup

## SYNOPSIS
Gets an user permission groups.

## SYNTAX

### UserPermissionGroupsByUserPermissionGroupID (Default)
```
Get-UserPermissionGroup [[-Server] <String>] [[-Credential] <PSCredential>] [-UserPermissionGroupID <Int32>]
 [<CommonParameters>]
```

### UserPermissionGroupsByUserID
```
Get-UserPermissionGroup [[-Server] <String>] [[-Credential] <PSCredential>] [-UserID <Int32>]
 [<CommonParameters>]
```

## DESCRIPTION
Gets all user permission groups or a single user permission group if an user permission group id is specified.

If the result returns null, try the parameter "-Verbose" to get more details.

## EXAMPLES

### EXAMPLE 1
```
Get-UserPermissionGroup
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

### -UserPermissionGroupID
Specifies the id of the user permission group to get.

```yaml
Type: Int32
Parameter Sets: UserPermissionGroupsByUserPermissionGroupID
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -UserID
Specifies the user id for which to get the assigned permission groups.

```yaml
Type: Int32
Parameter Sets: UserPermissionGroupsByUserID
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
