<#
    .SYNOPSIS
    Reset all cardholder use limits for a given panel.

    .DESCRIPTION   
    Reset all cardholder use limits for a given panel. 
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Invoke-ResetUseLimit
{
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact="High"
    )]
    param
    (
        [Parameter(
            Position=0, 
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The name of the server where the DataConduIT service is running or localhost')]
        [string]$Server = $Script:Server,
        
        [Parameter(
            Position=1,
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The credentials used to authenticate the user to the DataConduIT service')]
        [PSCredential]$Credential = $Script:Credential,

        [Parameter(
            Mandatory=$true, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The panel id parameter')]
        [int]$PanelID,
        
        [switch]$PassThru
    )

    process {
        $parameters = @{
            Server=$Server;
            PanelID=$PanelID;
        }

        if($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        if(($panel = Get-Panel @parameters) -eq $null) {
            Write-Error -Message ("Panel id '$($PanelID)' not found")
            return
        }
        
        if($Force -or $PSCmdlet.ShouldProcess("$Server", "Reset use limits for all cardholders on panel '$($panel.Name)'")) {
            $panel.ResetUseLimit.Invoke() | Out-Null
            Write-Verbose -Message ("Reset all cardholder use limits for panel '$($panel.Name)'")
        }

        if($PassThru) {
            Write-Output $panel
        }
    }
}