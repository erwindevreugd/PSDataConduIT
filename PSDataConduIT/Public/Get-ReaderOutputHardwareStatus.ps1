<#
    .SYNOPSIS
    Get the hardware status for a reader output.

    .DESCRIPTION   
    Get the hardware status for a reader output. 
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE

    Get-ReaderOutputHardwareStatus

    Name                           Status               Panel
    ----                           ------               -----
                                Secure               AccessPanel 1
                                Secure               AccessPanel 1
                                Secure               AccessPanel 1
                                Secure               AccessPanel 1
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-ReaderOutputHardwareStatus
{
    [CmdletBinding()]
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
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The panel id parameter')]
        [int]$PanelID = $null,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The reader id parameter')]
        [int]$ReaderID = $null,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The reader output id parameter')]
        [ValidateSet(0,1,2)]
        [int]$ReaderOutputID
    )

    process {
        $parameters = @{
            Server=$Server;
        }

        if($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        if(($readerOutputs = Get-ReaderOutput @parameters -PanelID $PanelID -ReaderID $ReaderID -ReaderOutputID $ReaderOutputID) -eq $null) {
            Write-Error -Message ("Reader output id '$($ReaderOutputID)' on reader id '$($ReaderID)' on panel id '$($PanelID)' not found")
            return
        }

        foreach($readerOutput in $readerOutputs) {
            if(($panel = Get-Panel @parameters -PanelID ($readerOutput.PanelID)) -eq $null) {
                continue
            }

            try {
                Write-Verbose -Message "Updating hardware status for panel '$($panel.Name)'"
                $panel.UpdateHardwareStatus.Invoke() | Out-Null
            }
            catch {
                Write-Warning -Message ("Failed to update hardware status for panel '$($panel.Name)'")
            }

            try {
                $s = [int]($readerOutput.GetHardwareStatus.Invoke().Status)
                $status = MapEnum ([OutputStatus].AsType()) $s

                Write-Verbose -Message ("Reader output '$($readerOutput.Name)' status is '$($status)'")
            } 
            catch {
                Write-Warning -Message ("Failed to get hardware status for reader output '$($readerOutput.Name)'")
            }

            New-Object PSObject -Property @{
                Name=$readerOutput.Name;
                Status=$status;
                Panel=$panel.Name;
            } | Add-ObjectType -TypeName "DataConduIT.LnlReaderOutputHardwareStatus"
        }
    }
}