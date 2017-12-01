<#
    .SYNOPSIS
    Gets a visit email recipient.

    .DESCRIPTION   
    Gets a visit email recipient. 
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Get-VisitEmailRecipient
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-VisitEmailRecipient
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
            Mandatory=$true, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The visit id parameter')]
        [int]$VisitID
    )

    process { 
        $query = "SELECT * FROM Lnl_VisitEmailRecipient WHERE __CLASS='Lnl_VisitEmailRecipient'"

        if($VisitID) {
            $query += " AND VISITID=$VisitID"
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

                VisitID=$_.VISITID;
                PersonID=$_.PERSONID;
                EmailAddress=$_.EMAILADDRESS;

                IncludeDefaultRecipients=$_.INCLUDEDEFAULTRECIPIENTS;
                IncludeHost=$_.INCLUDEHOST;
                IncludeVisitor=$_.INCLUDEVISITOR;
                RecipientNumber=$_.RECIPIENTNUMBER;

                SegmentID=$_.SEGMENTID;
            } | Add-ObjectType -TypeName "DataConduIT.LnlVisitRecipient"
        }
    }
}