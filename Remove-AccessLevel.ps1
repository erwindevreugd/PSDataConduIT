function Remove-AccessLevel
{
    [CmdletBinding()]
    param
    (
        [Parameter(Position=0, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]$Server = $Script:Server,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [PSCredential]$Credential = $Script:Credential,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int]$AccessLevelID,

		[Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]$Name
    )

    process { 
        $query = "SELECT * FROM Lnl_AccessLevel WHERE __CLASS='Lnl_AccessLevel'"

        if($AccessLevelID) {
            $query += " AND ID=$AccessLevelID"
        }

		if($Name) {
            $query += " AND Name='$Name'"
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

        Get-WmiObject @parameters | Remove-WmiObject
    }
}