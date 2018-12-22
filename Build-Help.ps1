[CmdletBinding()]
param
(
    [Parameter(
        Mandatory = $true
    )]
    [string]
    $WorkspaceRoot
)

Import-Module platyPS
Get-Module PSDataConduIT | Remove-Module -Force -ErrorAction SilentlyContinue
Import-Module $WorkspaceRoot/PSDataConduIT -ErrorAction SilentlyContinue
New-MarkdownHelp -Module PSDataConduIT -OutputFolder $WorkspaceRoot/Docs/en-US -Force
Get-Module PSDataConduIT | Remove-Module -Force -ErrorAction SilentlyContinue
New-ExternalHelp -Path $WorkspaceRoot/Docs/en-US -OutputPath $WorkspaceRoot/PSDataConduIT/en-US -Force