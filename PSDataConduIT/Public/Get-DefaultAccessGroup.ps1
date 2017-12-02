<#
    .SYNOPSIS
    Gets the default access group for the given badge type.

    .DESCRIPTION   
    Gets the default access group for the given badge type. 
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Get-DefaultAccessGroup
    
    AccessGroupID Name                                     SegmentID
    ------------- ----                                     ---------
    1             All                                      0
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-DefaultAccessGroup
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
            HelpMessage='The credentials used to authenticate the user to the DataConduIT service.')]
        [PSCredential]$Credential = $Script:Credential,

        [Parameter(
            Mandatory=$true, 
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='The badge type id parameter.')]
        [int]$BadgeTypeID = $null
    )

    process { 
        $parameters = @{
            Server=$Server;
        }

        if($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        if(($badgeType = Get-BadgeType @parameters -BadgeTypeID $BadgeTypeID) -eq $null) {
            Write-Error -Message ("Badge type id '$($BadgeTypeID)' not found")
            return
        }

        Get-AccessGroup @parameters -AccessGroupID $badgeType.DefaultAccessGroup
    }
}