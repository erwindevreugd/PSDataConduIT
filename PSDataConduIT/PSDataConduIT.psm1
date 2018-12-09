if (($PSVersionTable.PSVersion).Major -lt 3) {
    Write-Warning ("PSDataConduIT is not supported on PowerShell $($psv) and requires at least PowerShell 3.0`n" +
    "To download version 3.0, please visit https://www.microsoft.com/en-us/download/details.aspx?id=34595`n")

    return
}

Foreach($import in @(Get-ChildItem -Path $PSScriptRoot\Private\*.ps1))
{
    Try
    {
        . $import.fullname
    }
    Catch
    {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

$functions = New-Object System.Collections.ArrayList

Foreach($import in @(Get-ChildItem -Path $PSScriptRoot\Public\*.ps1))
{
    Try
    {
        . $import.fullname
        $functions.Add($import.Basename)
    }
    Catch
    {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

Export-ModuleMember -Function $functions -Alias *

# Set default context to localhost with no credentials
Set-Context -Server 'localhost'