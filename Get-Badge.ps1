function Get-Badge
{
    [CmdletBinding()]
    param
    (
        [Parameter(Position=0, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]$Server = $Script:Server,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [PSCredential]$Credential = $Script:Credential,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [long]$BadgeID,

		[Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int]$BadgeKey
    )

    process {
        $query = "SELECT * FROM Lnl_Badge WHERE __CLASS='Lnl_Badge'"

        if($BadgeID) {
            $query += " AND ID=$BadgeID"
        }

		if($BadgeKey) {
            $query += " AND BADGEKEY=$BadgeKey"
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

				Activate=ToDateTime($_.ACTIVATE);
				Deactivate=ToDateTime($_.DEACTIVATE);
				APBExempt=$_.APBEXEMPT;
				BadgeKey=$_.BADGEKEY;
				BadgeID=$_.ID;
				PersonID=$_.PERSONID;
				Status=$_.STATUS;
				TwoManType=$_.TWO_MAN_TYPE;
				BadgeTypeID=$_.TYPE;
				UseLimit=$_.USELIMIT;
				LastChanged=ToDateTime($_.LASTCHANGED);
				LastPrint=ToDateTime($_.LASTPRINT);
			}
		}
    }
}