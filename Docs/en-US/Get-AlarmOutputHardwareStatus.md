---
external help file: PSDataConduIT-help.xml
Module Name: PSDataConduIT
online version: https://github.com/erwindevreugd/PSDataConduIT
schema: 2.0.0
---

# Get-AlarmOutputHardwareStatus

## SYNOPSIS
Gets the alarm output hardware status.

## SYNTAX

```
Get-AlarmOutputHardwareStatus [[-Server] <String>] [[-Credential] <PSCredential>] [-PanelID <Int32>]
 [-AlarmPanelID <Int32>] [-OutputID <Int32>] [-AlarmOutputID <Int32>]
```

## DESCRIPTION
Gets the alarm output hardware status for all alarm output or the hardware status for a single alarm output if an alarm panel id is specified. 

If the result return null, try the parameter "-Verbose" to get more details.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-AlarmOutputHardwareStatus
```

Name                           Status               Panel
----                           ------               -----
Alarm Output 1                 Secure               AccessPanel 1

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

### -PanelID
The panel id parameter.

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

### -AlarmPanelID
The alarm panel id parameter.

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

### -OutputID
The output id parameter.

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

### -AlarmOutputID
The alarm output id parameter.

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
