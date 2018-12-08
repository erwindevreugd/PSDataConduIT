---
external help file: PSDataConduIT-help.xml
Module Name: PSDataConduIT
online version: https://github.com/erwindevreugd/PSDataConduIT
schema: 2.0.0
---

# New-Visit

## SYNOPSIS
Adds a new visit.

## SYNTAX

```
New-Visit [[-Server] <String>] [[-Credential] <PSCredential>] -VisitorID <Int32> -CardholderID <Int32>
 [-Hours <Int32>] [-ScheduledTimeIn <DateTime>] [-ScheduledTimeOut <DateTime>] [-Purpose <String>]
 [-EmailList <String>]
```

## DESCRIPTION
Adds a new visit to the database. 

If the result returns null, try the parameter "-Verbose" to get more details.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
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

### -VisitorID
The id of the visitor to assign to the new visit.

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

### -CardholderID
The id of the cardholder that will host the new visit.

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

### -Hours
The duration of the new visit.
If the ScheduledTimeout parameter is specified this parameter is ignored.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: 4
Accept pipeline input: False
Accept wildcard characters: False
```

### -ScheduledTimeIn
The scheduled starting time of the new visit.
The default value is now.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: ([DateTime]::Now)
Accept pipeline input: False
Accept wildcard characters: False
```

### -ScheduledTimeOut
The scheduled ending time of the new visit.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: ([DateTime]::Now).AddHours($Hours)
Accept pipeline input: False
Accept wildcard characters: False
```

### -Purpose
The purpose of the visit.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmailList
List of email addresses to add to the new visit.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/erwindevreugd/PSDataConduIT](https://github.com/erwindevreugd/PSDataConduIT)

