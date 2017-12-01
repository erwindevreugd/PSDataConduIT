<#
    .SYNOPSIS
    Gets an accesslevel reader assignment.

    .DESCRIPTION   
    Gets all accesslevel reader assignments. 
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Get-AccessLevelReaderAssignment
    
    AccessLevelID PanelID       ReaderID
    ------------- -------       --------
    2             1             1
    2             1             2
    
    .EXAMPLE
    Get-AccessLevelReaderAssignment -AccessLevelID 1
    
    AccessLevelID PanelID       ReaderID
    ------------- -------       --------
    1             1             1

    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-AccessLevelReaderAssignment
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
            HelpMessage='The accesslevel id')]
        [int]$AccessLevelID = $null,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The panel id')]
        [int]$PanelID = $null,

        [Parameter(
            Mandatory=$false, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The reader id')]
        [int]$ReaderID = $null
    )

    process { 
        $query = "SELECT * FROM Lnl_AccessLevelReaderAssignment WHERE __CLASS='Lnl_AccessLevelReaderAssignment'"

        if($AccessLevelID) {
            $query += " AND ACCESSLEVELID=$AccessLevelID"
        }

        if($PanelID) {
            $query += " AND PanelID=$PanelID"
        }

        if($ReaderID) {
            $query += " AND ReaderID=$ReaderID"
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

                AccessLevelID=$_.ACCESSLEVELID;
                PanelID=$_.PanelID;
                ReaderID=$_.ReaderID;
                TimezoneID=$_.TimezoneID;
            } | Add-ObjectType -TypeName "DataConduIT.LnlAccessLevelReaderAssignment"
        }
    }
}