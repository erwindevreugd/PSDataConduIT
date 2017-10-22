@echo off

start %windir%\System32\WindowsPowerShell\v1.0\powershell.exe -NoExit -ExecutionPolicy Bypass -Command "& Import-Module '%~dp0PSDataConduIT\PSDataConduIT.psm1'"