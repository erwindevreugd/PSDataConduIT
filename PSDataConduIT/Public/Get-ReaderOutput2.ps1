<#
    .SYNOPSIS
    Gets a reader output.

    .DESCRIPTION   
    Gets all reader output or a single reader output if a reader output id is specified. If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Get-ReaderOutput1
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-ReaderOutput2
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
        [int]$ReaderID = $null
    )

    process {
        $query = "SELECT * FROM Lnl_ReaderOutput2 WHERE __CLASS='Lnl_ReaderOutput2'"

        if($PanelID) {
            $query += " AND PANELID=$PanelID"
        }

        if($ReaderID) {
            $query += " AND READERID=$ReaderID"
        }

        LogQuery $query

        $parameters = @{
            ComputerName=$Server;
            Namespace=$Script:OnGuardNamespace;
            Query=$query
        }

        if($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

		Get-WmiObject @parameters | ForEach-Object { New-Object PSObject -Property @{
				Class=$_.__CLASS;
				SuperClass=$_.__SUPERCLASS;
				Server=$_.__SERVER;
				ComputerName=$_.__SERVER;
				Path=$_.__PATH;
				Credential=$Credential;

				PanelID=$_.PANELID;
                ReaderID=$_.READERID;
				Name=$_.NAME;

                GetHardwareStatus=$_.GetHardwareStatus;
                Activate=$_.ACTIVATE;
                Deactivate=$_.DEACTIVATE;
                Pulse=$_.PULSE;
			} | Add-ObjectType -TypeName "DataConduIT.LnlReaderOutput"
		}
    }
}