function Add-AccessLevelReaderAssignment
{
    [CmdletBinding()]
    param
    (
        # [Parameter(Position=0, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        # [string]$Server = $Script:Server,

        # [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        # [PSCredential]$Credential = $Script:Credential,

		# [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        # [int]$AccessLevelID,

        # [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        # [int]$PanelID,

        # [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        # [int]$ReaderID,
        
        # [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        # [int]$TimezoneID
    )

    process {

        # $parameters = @{
        #     ComputerName=$Server;
        #     Namespace=$Script:OnGuardNamespace;
        #     Class="Lnl_AccessLevelReaderAssignment";
        # }

        throw $STR_NOT_SUPPORTED

        # if($Credential -ne $null) {
        #     $parameters.Add("Credential", $Credential)
        # }

		# if((Get-AccessLevel -AccessLevelID $AccessLevelID) -eq $null) {
		# 	throw $STR_ACCESSLEVEL_DOESNT_EXIST -f $AccessLevelID
        # }
        
        # if((Get-Reader -PanelID $PanelID -ReaderID $ReaderID) -eq $null) {
		# 	throw $STR_READER_DOESNT_EXIST -f $PanelID, $ReaderID
		# }

        # if((Get-Timezone -TimezoneID $TimezoneID) -eq $null) {
		# 	throw $STR_TIMZONE_DOESNT_EXIST -f $TimezoneID
        # }
        
		# Set-WmiInstance @parameters -Arguments @{
		# 	ACCESSLEVELID=$AccessLevelID; 
		# 	PANELID=$PanelID;
        #     READERID=$ReaderID;
        #     TIMEZONEID=$TimezoneID} |
		# 	Get-AccessLevelReaderAssignment
	}
}