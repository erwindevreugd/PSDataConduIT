---
external help file: PSDataConduIT-help.xml
Module Name: PSDataConduIT
online version: https://github.com/erwindevreugd/PSDataConduIT
schema: 2.0.0
---

# Get-Directory

## SYNOPSIS
Gets a directory.

## SYNTAX

```
Get-Directory [[-Server] <String>] [[-Credential] <PSCredential>] [-DirectoryID <Int32>]
```

## DESCRIPTION
Gets all directories or a single directory if a directory id is specified. 

If the result returns null, try the parameter "-Verbose" to get more details.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-Directory
```

DirectoryID   Name                 Type                           Hostname             StartNode
-----------   ----                 ----                           --------             ---------
1             DOMAIN.local         MicrosoftActiveDirectory       DOMAIN.local         dc=DOAMIN, dc=local

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

### -DirectoryID
The directory id parameter.

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

