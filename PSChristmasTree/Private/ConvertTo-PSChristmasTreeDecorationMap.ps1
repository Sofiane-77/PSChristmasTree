function ConvertTo-PSChristmasTreeDecorationMap() {
    [CmdletBinding()]
    [OutputType([hashtable])]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$InputText,

        [Parameter(Mandatory = $true)]
        [string[]]$AllowedColors
    )

    $newMap = @{}
    $pairs = $InputText -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' }

    foreach ($pair in $pairs) {
        if ($pair -match '^(.+)=(.+)$') {
            $symbolPattern = $Matches[1].Trim()
            $color = $Matches[2].Trim()

            if ($color -ieq 'random' -or $color -in $AllowedColors) {
                $newMap[$symbolPattern] = $color
            }
            else {
                Write-Warning "Ignoring symbol-pattern color '$color' because it is not a valid console color."
            }
        }
        else {
            Write-Warning "Ignoring symbol-pattern entry '$pair'. Use the format symbol=color."
        }
    }

    return $newMap
}
