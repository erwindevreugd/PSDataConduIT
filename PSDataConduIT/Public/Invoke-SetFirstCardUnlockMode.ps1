<#
    .SYNOPSIS
    Enables or disables first card unlock mode for a reader.

    .DESCRIPTION   
    Enables or disables first card unlock mode for a reader. 
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Invoke-SetFirstCardUnlockMode {
    [CmdletBinding()]
    param
    (
        [Parameter(
            Position = 0, 
            Mandatory = $false, 
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The name of the server where the DataConduIT service is running or localhost.')]
        [string]
        $Server = $Script:Server,
        
        [Parameter(
            Position = 1,
            Mandatory = $false, 
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The credentials used to authenticate the user to the DataConduIT service.')]
        [PSCredential]
        $Credential = $Script:Credential,

        [Parameter(
            Mandatory = $true, 
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The panel id parameter.')]
        [int]
        $PanelID,

        [Parameter(
            Mandatory = $true, 
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The reader id parameter.')]
        [int]
        $ReaderID,
        
        [Parameter(
            Mandatory = $false,
            ParameterSetName = 'Enable',
            HelpMessage = 'Enables first card unlock mode.')]
        [switch]
        $Enable,

        [Parameter(
            Mandatory = $false,
            ParameterSetName = 'Disable',
            HelpMessage = 'Disables first card unlock mode.')]
        [switch]
        $Disable,

        [Parameter(
            Mandatory = $false, 
            ValueFromPipelineByPropertyName = $false,
            HelpMessage = 'Returns an object that represents the reader. By default, this cmdlet does not generate any output.')]
        [switch]
        $PassThru
    )

    process {
        $parameters = @{
            Server = $Server;
        }

        if ($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        if (($reader = Get-Reader @parameters -PanelID $PanelID -ReaderID $ReaderID) -eq $null) {
            Write-Error -Message ("Reader id '$($ReaderID)' on panel id '$($PanelID)' not found")
            return
        }

        if ($Enable) {
            $reader.SetFirstCardUnlockMode.Invoke($true) | Out-Null
            Write-Verbose -Message ("Set first card unlock mode 'true' on reader '$($reader.Name)'")
        }

        if ($Disable) {
            $reader.SetFirstCardUnlockMode.Invoke($false) | Out-Null
            Write-Verbose -Message ("Set first card unlock mode 'false' on reader '$($reader.Name)'")
        }

        if ($PassThru) {
            Write-Output $reader
        }
    }
}