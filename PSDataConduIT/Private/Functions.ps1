function LogQuery($query) {
    Write-Verbose -Message $query
}

function ToDateTime($wmiDateTime) {
    if ($null -eq $wmiDateTime) {
        return $null
    }

    return [System.Management.ManagementDateTimeConverter]::ToDateTime($wmiDateTime)
}

function ToWmiDateTime($dateTime) {
    if ($null -eq $dateTime) {
        return $null
    }

    return [System.Management.ManagementDateTimeConverter]::ToDmtfDateTime($dateTime)
}

function MapEnum($enum, $value, $default = $null) {
    try {
        [Enum]::GetValues($enum) | Where-Object { $_ -eq $value }
    }
    catch {
        Write-Error $_
        return $default
    }
}

function IntToIPAddress($i) {
    return [IPAddress][BitConverter]::GetBytes($i)
}

function ToWmiWildcard([string]$query) {
    return $query.Replace("*", "%").Replace("?", "_")
}