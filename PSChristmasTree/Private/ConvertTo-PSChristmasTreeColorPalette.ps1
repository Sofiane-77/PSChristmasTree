function ConvertTo-PSChristmasTreeColorPalette() {
    [CmdletBinding()]
    [OutputType([array])]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$InputText,

        [Parameter(Mandatory = $true)]
        [string[]]$AllowedColors
    )

    $palette = @()
    foreach ($entry in ($InputText -split ',')) {
        $color = $entry.Trim()
        if ([string]::IsNullOrWhiteSpace($color)) {
            continue
        }

        if ($color -in $AllowedColors) {
            $palette += $color
        }
        else {
            Write-Warning "Ignoring palette color '$color' because it is not a valid console color."
        }
    }

    return $palette
}
