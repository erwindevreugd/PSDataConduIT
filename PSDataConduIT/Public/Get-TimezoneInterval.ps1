<#
    .SYNOPSIS
    Gets a timezone interval.

    .DESCRIPTION   
    Gets all timezone intervals or a single timezone interval if an timezone interval id is specified. If the result return null, try the parameter "-Verbose" to get more details.
    
    .EXAMPLE
    Get-TimezoneInterval
    
    Class              : Lnl_TimezoneInterval
    ComputerName       : SERVER
    TimezoneIntervalID : 0
    SuperClass         : Lnl_Element
    Credential         :
    TimezoneID         : 2
    Path               : \\SERVER\root\OnGuard:Lnl_TimezoneInterval.ID=0,TimezoneID=2
    Server             : SERVER
    
    .LINK
    https://github.com/erwindevreugd/PSDataConduIT
#>
function Get-TimezoneInterval
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
            HelpMessage='The timezone interval id parameter')]
        [int]$TimezoneIntervalID
    )

    process {
        $query = "SELECT * FROM Lnl_TimezoneInterval WHERE __CLASS='Lnl_TimezoneInterval'"

        if($TimezoneIntervalID) {
            $query += " AND ID=$TimezoneIntervalID"
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

        $timezones = Get-Timezone -Server $server -Credential $Credential

        Get-WmiObject @parameters | ForEach-Object { 
            # $item used to keep track of foreach object
            $item = $_
            New-Object PSObject -Property @{
				Class=$_.__CLASS;
				SuperClass=$_.__SUPERCLASS;
				Server=$_.__SERVER;
				ComputerName=$_.__SERVER;
				Path=$_.__PATH;
				Credential=$Credential;

				TimezoneIntervalID=$_.ID;
                TimezoneID=$_.TimezoneID;
                Timezone=($timezones | Where-Object {$_.TimezoneID -eq $item.TimezoneID}).Name;
                
                Monday=$_.MONDAY;
                Tuesday=$_.TUESDAY;
                Wednesday=$_.WEDNESDAY;
                Thursday=$_.THURSDAY;
                Friday=$_.FRIDAY;
                Saturday=$_.SATURDAY;
                Sunday=$_.SUNDAY;

                HolidayType1=$_.HOLIDAYTYPE1;
                HolidayType2=$_.HOLIDAYTYPE2;
                HolidayType3=$_.HOLIDAYTYPE3;
                HolidayType4=$_.HOLIDAYTYPE4;
                HolidayType5=$_.HOLIDAYTYPE5;
                HolidayType6=$_.HOLIDAYTYPE6;
                HolidayType7=$_.HOLIDAYTYPE7;
                HolidayType8=$_.HOLIDAYTYPE8;

                StartTime=ToDateTime $_.STARTTIME;
				EndTime=ToDateTime $_.ENDTIME;
            } | Add-Member -MemberType AliasProperty -Name Mon -Value Monday -PassThru | 
            Add-Member -MemberType AliasProperty -Name Tue -Value Tuesday -PassThru | 
            Add-Member -MemberType AliasProperty -Name Wed -Value Wednesday -PassThru | 
            Add-Member -MemberType AliasProperty -Name Thu -Value Thursday -PassThru | 
            Add-Member -MemberType AliasProperty -Name Fri -Value Friday -PassThru | 
            Add-Member -MemberType AliasProperty -Name Sat -Value Saturday -PassThru | 
            Add-Member -MemberType AliasProperty -Name Sun -Value Sunday -PassThru | 

            Add-Member -MemberType AliasProperty -Name H1 -Value HolidayType1 -PassThru | 
            Add-Member -MemberType AliasProperty -Name H2 -Value HolidayType2 -PassThru | 
            Add-Member -MemberType AliasProperty -Name H3 -Value HolidayType3 -PassThru | 
            Add-Member -MemberType AliasProperty -Name H4 -Value HolidayType4 -PassThru | 
            Add-Member -MemberType AliasProperty -Name H5 -Value HolidayType5 -PassThru | 
            Add-Member -MemberType AliasProperty -Name H6 -Value HolidayType6 -PassThru | 
            Add-Member -MemberType AliasProperty -Name H7 -Value HolidayType7 -PassThru | 
            Add-Member -MemberType AliasProperty -Name H8 -Value HolidayType8 -PassThru | 

            Add-ObjectType -TypeName "DataConduIT.LnlTimezoneInterval"
		}
    }
}