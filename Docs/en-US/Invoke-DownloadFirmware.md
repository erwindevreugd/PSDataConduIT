---
external help file: PSDataConduIT-help.xml
Module Name: PSDataConduIT
online version: https://github.com/erwindevreugd/PSDataConduIT
schema: 2.0.0
---

# Invoke-DownloadFirmware

## SYNOPSIS
Downloads firmware to the specified panel(s) or reader(s).

## SYNTAX

### DownloadFirmwareToAll (Default)
```
Invoke-DownloadFirmware [[-Server] <String>] [[-Credential] <PSCredential>] [-Force] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### DownloadFirmwareToReader
```
Invoke-DownloadFirmware [[-Server] <String>] [[-Credential] <PSCredential>] -PanelID <Int32> -ReaderID <Int32>
 [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### DownloadFirmwareToPanel
```
Invoke-DownloadFirmware [[-Server] <String>] [[-Credential] <PSCredential>] -PanelID <Int32> [-Force] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Downloads firmware to the specified panel(s) or reader(s).

If the result returns null, try the parameter "-Verbose" to get more details.

## EXAMPLES

### EXAMPLE 1
```
Get-Panel | Invoke-DownloadFirmware
```

This command downloads the firmware to all panels.

### EXAMPLE 2
```
Get-Reader | Invoke-DownloadFirmware
```

This command downloads the firmware to all reader.

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
Specifies the id of the panel to which to download the firmware.

```yaml
Type: Int32
Parameter Sets: DownloadFirmwareToReader, DownloadFirmwareToPanel
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ReaderID
Specifies the id of the reader to which to download the firmware.

```yaml
Type: Int32
Parameter Sets: DownloadFirmwareToReader
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Force
Forces the download firmware with out displaying a should process.

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

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

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
