---
external help file: PSDataConduIT-help.xml
Module Name: PSDataConduIT
online version: https://github.com/erwindevreugd/PSDataConduIT
schema: 2.0.0
---

# Get-DataConduITService

## SYNOPSIS
Gets the DataConduIT service.

## SYNTAX

```
Get-DataConduITService [[-Server] <String>] [[-Credential] <PSCredential>] [<CommonParameters>]
```

## DESCRIPTION
Gets the DataConduIT service.

If the result returns null, try the parameter "-Verbose" to get more details.

## EXAMPLES

### EXAMPLE 1
```
Get-DataConduITService
```

Name                                     Server                       IsStarted ----                                     ------                       --------- LS DataConduIT Service                   WS-084                       True

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
