---
external help file: PSDataConduIT-help.xml
Module Name: PSDataConduIT
online version: https://github.com/erwindevreugd/PSDataConduIT
schema: 2.0.0
---

# Set-Context

## SYNOPSIS
Sets the context server and credentials used to connect to DataConduIT.

## SYNTAX

```
Set-Context [-Server] <String> [[-Credential] <PSCredential>] [[-EventSource] <String>] [<CommonParameters>]
```

## DESCRIPTION
Sets the context server and credentials used to connect to DataConduIT.
When you use this command to set the Server and Credential values these will be stored within the Script scope.
All cmdlets that are run within the same script will use these stored values as their Server and Credential parameters.

If the result returns null, try the parameter "-Verbose" to get more details.

## EXAMPLES

### EXAMPLE 1
```
Set-Context -Server localhost
```

### EXAMPLE 2
```
Set-Context -Server SERVER -Credentials (Get-Credential)
```

## PARAMETERS

### -Server
The name of the server where the DataConduIT service is running or localhost.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
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
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -EventSource
The default event source used to send events to DataConduIT.
When specified this value must match a configured "Logical Source" exactly.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: [String]::Empty
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
