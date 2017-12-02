<#
    .SYNOPSIS
    Gets an access group.

    .DESCRIPTION   
    Gets all access groups or a single access group if an access group id is specified. 
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Get-AccessGroup
    
    AccessGroupID Name                                     SegmentID
    ------------- ----                                     ---------
    1             All                                      0
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-AccessGroup
{
    [CmdletBinding()]
    param
    (
        [Parameter(
            Position=0, 
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The name of the server where the DataConduIT service is running or localhost.')]
        [string]$Server = $Script:Server,

        [Parameter(
            Position=1,
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The credentials used to authenitcate the user to the DataConduIT service.')]
        [PSCredential]$Credential = $Script:Credential,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The id of the accessgroup to get.')]
        [Nullable[int]]$AccessGroupID = $null
    )

    process { 
        $query = "SELECT * FROM Lnl_AccessGroup WHERE __CLASS='Lnl_AccessGroup'"

        if($AccessGroupID -ne $null) {
            $query += " AND ID=$AccessGroupID"
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

                SegmentID=$_.SegmentID;

                AccessGroupID=$_.ID;
                Name=$_.NAME;
                
                AssignGroup=$_.AssignGroup;
            } | Add-ObjectType -TypeName "DataConduIT.LnlAccessGroup"
        }
    }
}