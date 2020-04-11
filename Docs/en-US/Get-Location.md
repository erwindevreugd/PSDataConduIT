---
external help file: PSDataConduIT-help.xml
Module Name: PSDataConduIT
online version: https://github.com/erwindevreugd/PSDataConduIT
schema: 2.0.0
---

# Get-Location

## SYNOPSIS
Gets a location.

Gets information about the current working location or a location stack.

## SYNTAX

```
Get-Location [[-Server] <String>] [[-Credential] <PSCredential>] [-LocationID <Int32>] [-Name <String>]
 [-SegmentID <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Gets all locations or a single location if a location id is specified.

If the result returns null, try the parameter "-Verbose" to get more details.

The Get-Location cmdlet gets an object that represents the current directory, much like the pwd (print working directory) command.

When you move between Windows PowerShell drives, Windows PowerShell retains your location in each drive.
You can use Get-Location to find your location in each drive.

You can use Get-Location to get the current directory at run time and use it in functions and scripts, such as in a function that displays the current directory in the Windows PowerShell prompt.

You can also use the Get-Location cmdlet to display the locations in a location stack.
For more information, see the Notes and the descriptions of the Stack and StackName parameters.

## EXAMPLES

### EXAMPLE 1
```
Get-Location
```

### EXAMPLE 1
```
PS C:\>get-location
Path
----
C:\WINDOWS
```

This command displays your location in the current Windows PowerShell drive.

For example, if you are in the Windows directory of the C: drive, it displays the path to that directory.

### EXAMPLE 2
```
The first command uses the Set-Location cmdlet to set the current location to the Windows subdirectory of the C: drive.
PS C:\>set-location C:\Windows

The second command uses the Set-Location cmdlet to change the location to the HKLM:\Software\Microsoft registry key. When you change to a location in the HKLM: drive, Windows PowerShell retains your location in the C: drive.
PS C:\WINDOWS> set-location HKLM:\Software\Microsoft
PS HKLM:\Software\Microsoft>

The third command uses the Set-Location cmdlet to change the location to the "HKCU:\Control Panel\Input Method" registry key.
PS C:\>PS HKLM:\Software\Microsoft> set-location 'HKCU:\Control Panel\Input Method'
PS HKCU:\Control Panel\Input Method>

The fourth command uses the Get-Location cmdlet to find the current location on the C: drive. It uses the PSDrive parameter to specify the drive.
PS C:\>PS HKCU:\Control Panel\Input Method> get-location -psdrive c
Path
----
C:\WINDOWS

The fifth command uses the Set-Location cmdlet to return to the C: drive. Even though the command does not specify a subdirectory, Windows PowerShell returns you to the saved location.
PS C:\>PS HKCU:\Control Panel\Input Method> set-location C:
PS C:\WINDOWS>

The sixth command uses the Get-Location cmdlet to find the current location in the drives supported by the Windows PowerShell registry provider. Get-Location returns the location of the most recently accessed registry drive, HKCU.
PS C:\WINDOWS> get-location -psprovider registry
Path
----
HKCU:\Control Panel\Input Method


To see the current location in the HKLM: drive, you need to use the PSDrive parameter to specify the drive. The seventh command does just this:
PS C:\WINDOWS> get-location -psdrive HKLM
Path
----
HKLM:\Software\Microsoft
```

These commands demonstrate the use of Get-Location to display your current location in different Windows PowerShell drives.

### EXAMPLE 3
```
The first command sets the current location to the Windows directory on the C: drive.
PS C:\>set-location C:\Windows

The second command uses the Push-Location cmdlet to push the current location (C:\Windows) onto the current location stack and change to the System32 subdirectory. Because no stack is specified, the current location is pushed onto the current location stack. By default, the current location stack is the unnamed default location stack.
C:\WINDOWS>push-location System32

The third command uses the StackName parameter of the Push-Location cmdlet to push the current location (C:\Windows\System32) onto the Stack2 stack and to change the current location to the WindowsPowerShell subirectory. If the Stack2 stack does not exist, Push-Location creates it.
C:\Windows\System32>push-location WindowsPowerShell -StackName Stack2

The fourth command uses the Stack parameter of the Get-Location cmdlet to get the locations in the current location stack. By default, the current stack is the unnamed default location stack.
C:\WINDOWS\system32\WindowsPowerShell>get-location -stack
Path
----
C:\WINDOWS

The fifth command uses the StackName parameter of the Get-Location cmdlet to get the locations in the Stack2 stack.
C:\WINDOWS\system32\WindowsPowerShell>get-location -stackname Stack2
Path
----
C:\WINDOWS\system32
```

These commands show how to use the Stack and StackName parameters of Get-Location to list the locations in the current location stack and alternate location stacks.
For more information about location stacks, see the Notes.

### EXAMPLE 4
```
PS C:\>function prompt { 'PowerShell: ' + (get-location) + '> '}
PowerShell: C:\WINDOWS>
```

This example shows how to customize the Windows PowerShell prompt.
The function that defines the prompt includes a Get-Location command, which is run whenever the prompt appears in the console.

The format of the default Windows PowerShell prompt is defined by a special function called "prompt".
You can change the prompt in your console by creating a new function called "prompt".

To see the current prompt function, type the following command:

get-content function:prompt

The command begins with the "function" keyword followed by the function name, "prompt".
The function body appears within braces ( {} ).

This command defines a new prompt that begins with the string "PowerShell: ".
To append the current location, it uses a Get-Location command, which runs when the prompt function is called.
The prompt ends with the string "\> ".

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
### None
You cannot pipe input to this cmdlet.

## OUTPUTS

### System.Management.Automation.PathInfo
### System.Management.Automation.PathInfoStack
### System.Management.Automation.PathInfo
### System.Management.Automation.PathInfoStack
### System.Management.Automation.PathInfo
### System.Management.Automation.PathInfoStack
### System.Management.Automation.PathInfo or System.Management.Automation.PathInfoStack
If you use the Stack or StackName parameters, Get-Location returns a StackInfo object.
Otherwise, it returns a PathInfo object.

## NOTES
The Get-Location cmdlet is designed to work with the data exposed by any provider.
To list the providers in your session, type "Get-PSProvider".
For more information, see about_Providers.

The ways that the PSProvider, PSDrive, Stack, and StackName parameters interact depends on the provider.
Some combinations will result in errors, such as specifying both a drive and a provider that does not expose that drive.
If no parameters are specified, Get-Location returns the PathInfo object for the provider that contains the current working location.

A "stack" is a last-in, first-out list in which only the most recently added item is accessible.
You add items to a stack in the order that you use them, and then retrieve them for use in the reverse order. 
Windows PowerShell lets you store provider locations in location stacks.
Windows PowerShell creates an unnamed default location stack and you can create multiple named location stacks.
If you do not specify a stack name, Windows PowerShell uses the current location stack.
By default, the unnamed default location is the current location stack, but you can use the Set-Location cmdlet to change the current location stack.

To manage location stacks, use the Windows PowerShell Location cmdlets, as follows.

-- To add a location to a location stack, use the Push-Location cmdlet.
-- To get a location from a location stack, use the Pop-Location cmdlet.
-- To display the locations in the current location stack, use the Stack parameter of the Get-Location cmdlet. To display the locations in a named location stack, use the StackName parameter of the Get-Location cmdlet.
-- To create a new location stack, use the StackName parameter of the Push-Location cmdlet. If you specify a stack that does not exist, Push-Location creates the stack.
-- To make a location stack the current location stack, use the StackName parameter of the Set-Location cmdlet.

The unnamed default location stack is fully accessible only when it is the current location stack.
If you make a named location stack the current location stack, you cannot no longer use Push-Location or Pop-Location cmdlets add or get items from the default stack or use Get-Location command to display the locations in the unnamed stack.
To make the unnamed stack the current stack, use the StackName parameter of the Set-Location cmdlet with a value of $null or an empty string ("").

## RELATED LINKS

[https://go.microsoft.com/fwlink/?LinkID=113321](https://go.microsoft.com/fwlink/?LinkID=113321)

[https://go.microsoft.com/fwlink/?LinkID=113321](https://go.microsoft.com/fwlink/?LinkID=113321)

[https://go.microsoft.com/fwlink/?LinkID=113321](https://go.microsoft.com/fwlink/?LinkID=113321)

[Online Version:](http://go.microsoft.com/fwlink/p/?linkid=290497)

[Pop-Location]()

[Push-Location]()

[Set-Location]()

[about_Providers]()

