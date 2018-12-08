---
external help file: PSDataConduIT-help.xml
Module Name: PSDataConduIT
online version: https://github.com/erwindevreugd/PSDataConduIT
schema: 2.0.0
---

# Get-ReaderOutputHardwareStatus

## SYNOPSIS
Get the hardware status for a reader output.

## SYNTAX

```
Get-ReaderOutputHardwareStatus [[-Server] <String>] [[-Credential] <PSCredential>] [-PanelID <Int32>]
 [-ReaderID <Int32>] [-ReaderOutputID <Int32>]
```

## DESCRIPTION
Get the hardware status for a reader output. 

If the result returns null, try the parameter "-Verbose" to get more details.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-ReaderOutputHardwareStatus
```

Name                           Status               Panel
----                           ------               -----
                            Secure               AccessPanel 1
                            Secure               AccessPanel 1
                            Secure               AccessPanel 1
                            Secure               AccessPanel 1

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
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ReaderID
The reader id parameter.

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

### -ReaderOutputID
The reader output id parameter.

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

