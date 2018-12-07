<#
    .SYNOPSIS
    Assigns an access group to a given badge key.

    .DESCRIPTION   
    Assigns an access group to a given badge key. 
    
    If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Invoke-AssignAccessGroup -AccessGroupID 1 -BadgeKey 1
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Invoke-AssignAccessGroup {
    [CmdletBinding()]
    param
    (
        [Parameter(
            Position = 0, 
            Mandatory = $false, 
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The name of the server where the DataConduIT service is running or localhost.')]
        [string]
        $Server = $Script:Server,

        [Parameter(
            Position = 1,
            Mandatory = $false, 
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The credentials used to authenitcate the user to the DataConduIT service.')]
        [PSCredential]
        $Credential = $Script:Credential,

        [Parameter(
            Mandatory = $true, 
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The id of the accessgroup to assign.')]
        [int]
        $AccessGroupID,

        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The badge key parameter.')]
        [int]
        $BadgeKey
    )

    process { 
        $parameters = @{
            Server = $Server;
        }

        if ($Credential -ne $null) {
            $parameters.Add("Credential", $Credential)
        }

        if (($accessGroup = Get-AccessGroup @parameters -AccessGroupID $AccessGroupID) -eq $null) {
            Write-Error -Message ("Access group id '$($AccessGroupID)' not found")
            return
        }

        if (($badge = Get-Badge @parameters -BadgeKey $BadgeKey) -eq $null) {
            Write-Error -Message ("Badge key '$($BadgeKey)' not found")
            return
        }

        $accessGroup.AssignGroup.Invoke($BadgeKey) | Out-Null

        Write-Verbose -Message ("Assigned access group '$($accessGroup.Name)' to badge key '$($badge.BadgeKey)'")
    }
}