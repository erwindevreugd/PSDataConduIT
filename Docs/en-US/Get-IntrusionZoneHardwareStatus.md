---
external help file: PSDataConduIT-help.xml
Module Name: PSDataConduIT
online version: https://github.com/erwindevreugd/PSDataConduIT
schema: 2.0.0
---

# Get-IntrusionZoneHardwareStatus

## SYNOPSIS
Gets the intrusion zone hardware status.

## SYNTAX

```
Get-IntrusionZoneHardwareStatus [[-Server] <String>] [[-Credential] <PSCredential>] [-IntrusionZoneID <Int32>]
 [<CommonParameters>]
```

## DESCRIPTION
Gets the intrusion zone hardware status for all intrusion zone or the hardware status for a single intrusion zone if an intrusion zone id is specified.

If the result returns null, try the parameter "-Verbose" to get more details.

## EXAMPLES

### EXAMPLE 1
```
Get-IntrusionZoneHardwareStatus
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

### -IntrusionZoneID
Specifies the id of the intrusion zone for which to get the hardware status.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
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
