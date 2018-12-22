---
external help file: PSDataConduIT-help.xml
Module Name: PSDataConduIT
online version: https://github.com/erwindevreugd/PSDataConduIT
schema: 2.0.0
---

# Get-Location

## SYNOPSIS
Gets a location.

## SYNTAX

```
Get-Location [[-Server] <String>] [[-Credential] <PSCredential>] [-LocationID <Int32>] [-Name <String>]
 [-SegmentID <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Gets all locations or a single location if a location id is specified.

If the result returns null, try the parameter "-Verbose" to get more details.

## EXAMPLES

### EXAMPLE 1
```
Get-Location
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

### -LocationID
Specifies the id of the location to get.

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

### -Name
Specifies the name of the location to get.
Wildcards are permitted.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SegmentID
Specifies the segment id of the location(s) to get.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: -1
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String[]
### System.String[]
### System.String[]

## OUTPUTS

### System.Management.Automation.PathInfo
### System.Management.Automation.PathInfoStack
### System.Management.Automation.PathInfo
### System.Management.Automation.PathInfoStack
### System.Management.Automation.PathInfo

### System.Management.Automation.PathInfoStack

## NOTES

## RELATED LINKS

[https://go.microsoft.com/fwlink/?LinkID=113321](https://go.microsoft.com/fwlink/?LinkID=113321)

[https://go.microsoft.com/fwlink/?LinkID=113321](https://go.microsoft.com/fwlink/?LinkID=113321)

[https://go.microsoft.com/fwlink/?LinkID=113321](https://go.microsoft.com/fwlink/?LinkID=113321)

