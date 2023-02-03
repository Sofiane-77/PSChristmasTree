function ConvertTo-PSChristmasTreeHashtable() {
    [CmdletBinding()]
    [OutputType([hashtable], [array], [object])]
    Param (
        [Parameter(Mandatory = $false)]
        [AllowNull()]
        [object]$Value
    )

    if ($null -eq $Value) {
        return $null
    }

    if ($Value -is [hashtable]) {
        $output = @{}
        foreach ($key in $Value.Keys) {
            $output[$key] = ConvertTo-PSChristmasTreeHashtable -Value $Value[$key]
        }

        return $output
    }

    if ($Value -is [System.Management.Automation.PSCustomObject]) {
        $output = @{}
        foreach ($property in $Value.PSObject.Properties) {
            $output[$property.Name] = ConvertTo-PSChristmasTreeHashtable -Value $property.Value
        }

        return $output
    }

    if ($Value -is [System.Collections.IEnumerable] -and $Value -isnot [string]) {
        $items = @()
        foreach ($item in $Value) {
            $items += ConvertTo-PSChristmasTreeHashtable -Value $item
        }

        return $items
    }

    return $Value
}
