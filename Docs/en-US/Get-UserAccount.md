---
external help file: PSDataConduIT-help.xml
Module Name: PSDataConduIT
online version: https://github.com/erwindevreugd/PSDataConduIT
schema: 2.0.0
---

# Get-UserAccount

## SYNOPSIS
Gets an user account.

## SYNTAX

```
Get-UserAccount [[-Server] <String>] [[-Credential] <PSCredential>] [-UserAccountID <Int32>]
```

## DESCRIPTION
Gets all user accounts or a single user account if an user account id is specified. 

If the result return null, try the parameter "-Verbose" to get more details.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-UserAccount
```

ComputerName  : SERVER
Path          : \\\\SERVER\root\OnGuard:Lnl_UserAccount.ID=1,UserID=-1
Server        : SERVER
SuperClass    : Lnl_Element
DirectoryID   : 1
UserAccountID : 1
UserID        : -1
Credential    :
Class         : Lnl_UserAccount
AccountID     : S-1-5-21-0000000000-0000000000-000000000-0000

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

### -UserAccountID
The user account id parameter.

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

