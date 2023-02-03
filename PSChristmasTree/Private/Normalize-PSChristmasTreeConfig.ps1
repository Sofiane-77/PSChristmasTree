<#
 .Synopsis
  Convert and validate PSChristmasTree configuration

 .Description
  Takes a config hashtable (possibly partial) and returns a complete, validated
  configuration with all required keys present and values normalized to proper types.
  Missing or invalid values are replaced with built-in defaults.

 .Parameter PartialConfig
  A hashtable containing zero or more config keys. Any missing keys are populated
  with defaults. Invalid values are replaced with defaults.

 .Example
   $Config = @{ AnimationLoopNumber = 10 }
    $Normalized = ConvertTo-PSChristmasTreeConfig -PartialConfig $Config
   # Returns a complete hashtable with all keys, using defaults for missing ones

 .Example
    $Normalized = ConvertTo-PSChristmasTreeConfig
   # Returns full default configuration
#>
function ConvertTo-PSChristmasTreeConfig() {
    [CmdletBinding()]
    [OutputType([hashtable])]
    Param (
        [Parameter(Mandatory = $false)]
        [hashtable]$PartialConfig
    )

    $defaults = Get-PSChristmasTreeDefaultConfig
    $allColors = @([Enum]::GetNames([System.ConsoleColor]))
    $validTreeStyles = @('Classic', 'Minimal', 'Wide', 'Custom')
    $validDecorationModes = @('Default', 'Custom')
    $validColorModes = @('Multicolor', 'Single', 'Palette')

    function ConvertTo-BooleanValue {
        Param (
            [Parameter(Mandatory = $false)]
            [AllowNull()]
            [object]$Value,

            [Parameter(Mandatory = $true)]
            [bool]$Fallback
        )

        if ($Value -is [bool]) {
            return $Value
        }

        if ($null -eq $Value) {
            return $Fallback
        }

        $parsed = $false
        if ([bool]::TryParse([string]$Value, [ref]$parsed)) {
            return $parsed
        }

        return $Fallback
    }

    function ConvertTo-PositiveInt {
        Param (
            [Parameter(Mandatory = $false)]
            [AllowNull()]
            [object]$Value,

            [Parameter(Mandatory = $true)]
            [int]$Fallback,

            [Parameter(Mandatory = $true)]
            [int]$Minimum
        )

        $parsed = 0
        if ($null -ne $Value -and [int]::TryParse([string]$Value, [ref]$parsed) -and $parsed -ge $Minimum) {
            return $parsed
        }

        return $Fallback
    }

    function ConvertTo-LegacyV3Shape {
        Param (
            [Parameter(Mandatory = $false)]
            [AllowNull()]
            [hashtable]$InputObject
        )

        if ($null -eq $InputObject) {
            return @{}
        }

        $hasV3Sections = $InputObject.ContainsKey('Language') -or
        $InputObject.ContainsKey('Tree') -or
        $InputObject.ContainsKey('Display') -or
        $InputObject.ContainsKey('Audio') -or
        $InputObject.ContainsKey('Messages')

        $isLegacy = $false
        if (-not $hasV3Sections) {
            $legacyKeys = @('AnimationLoopNumber', 'AnimationSpeed', 'UICulture', 'TreeStyle', 'CustomTreePath', 'ColorMode', 'SingleColor', 'DecorationMode', 'PlayCarol', 'ShowMessages', 'CustomMessages')
            foreach ($legacyKey in $legacyKeys) {
                if ($InputObject.ContainsKey($legacyKey)) {
                    $isLegacy = $true
                    break
                }
            }

            if (-not $isLegacy -and $InputObject.ContainsKey('Colors') -and $InputObject['Colors'] -isnot [hashtable]) {
                $isLegacy = $true
            }

            if (-not $isLegacy -and $InputObject.ContainsKey('Decorations') -and $InputObject['Decorations'] -is [hashtable]) {
                $decorationsCandidate = $InputObject['Decorations']
                if (-not $decorationsCandidate.ContainsKey('Mode') -and -not $decorationsCandidate.ContainsKey('Map') -and -not $decorationsCandidate.ContainsKey('Defaults')) {
                    $isLegacy = $true
                }
            }
        }

        if (-not $isLegacy) {
            return $InputObject
        }

        $migrated = @{
            ConfigVersion = 3
            Language      = @{}
            Tree          = @{}
            Decorations   = @{}
            Colors        = @{}
            Display       = @{}
            Audio         = @{}
            Messages      = @{}
        }

        if ($InputObject.ContainsKey('ConfigVersion')) { $migrated['ConfigVersion'] = $InputObject['ConfigVersion'] }
        if ($InputObject.ContainsKey('UICulture')) { $migrated['Language']['UICulture'] = $InputObject['UICulture'] }
        if ($InputObject.ContainsKey('TreeStyle')) { $migrated['Tree']['Style'] = $InputObject['TreeStyle'] }
        if ($InputObject.ContainsKey('CustomTreePath')) { $migrated['Tree']['CustomPath'] = $InputObject['CustomTreePath'] }
        if ($InputObject.ContainsKey('DecorationMode')) { $migrated['Decorations']['Mode'] = $InputObject['DecorationMode'] }
        if ($InputObject.ContainsKey('Decorations')) { $migrated['Decorations']['Map'] = $InputObject['Decorations'] }
        if ($InputObject.ContainsKey('ColorMode')) { $migrated['Colors']['Mode'] = $InputObject['ColorMode'] }
        if ($InputObject.ContainsKey('SingleColor')) { $migrated['Colors']['SingleColor'] = $InputObject['SingleColor'] }
        if ($InputObject.ContainsKey('Colors')) { $migrated['Colors']['Palette'] = $InputObject['Colors'] }
        if ($InputObject.ContainsKey('AnimationLoopNumber')) { $migrated['Display']['AnimationLoopNumber'] = $InputObject['AnimationLoopNumber'] }
        if ($InputObject.ContainsKey('AnimationSpeed')) { $migrated['Display']['AnimationSpeed'] = $InputObject['AnimationSpeed'] }
        if ($InputObject.ContainsKey('PlayCarol')) { $migrated['Audio']['PlayCarol'] = $InputObject['PlayCarol'] }
        if ($InputObject.ContainsKey('ShowMessages')) { $migrated['Messages']['Show'] = $InputObject['ShowMessages'] }
        if ($InputObject.ContainsKey('CustomMessages')) { $migrated['Messages']['Custom'] = $InputObject['CustomMessages'] }

        return $migrated
    }

    $inputConfig = ConvertTo-PSChristmasTreeHashtable -Value $PartialConfig
    if ($inputConfig -isnot [hashtable]) {
        $inputConfig = @{}
    }

    $inputConfig = ConvertTo-LegacyV3Shape -InputObject $inputConfig
    $candidateConfig = Merge-Hashtable $defaults $inputConfig

    $normalized = Get-PSChristmasTreeDefaultConfig

    $normalized['ConfigVersion'] = ConvertTo-PositiveInt -Value $candidateConfig['ConfigVersion'] -Fallback 3 -Minimum 1

    $uiCulture = [string]$candidateConfig['Language']['UICulture']
    if (-not [string]::IsNullOrWhiteSpace($uiCulture)) {
        $normalized['Language']['UICulture'] = $uiCulture
    }

    $treeStyle = [string]$candidateConfig['Tree']['Style']
    if ($treeStyle -in $validTreeStyles) {
        $normalized['Tree']['Style'] = $treeStyle
    }

    $customPath = $candidateConfig['Tree']['CustomPath']
    if ($customPath -is [string]) {
        $normalized['Tree']['CustomPath'] = $customPath
    }

    $decorationMode = [string]$candidateConfig['Decorations']['Mode']
    if ($decorationMode -in $validDecorationModes) {
        $normalized['Decorations']['Mode'] = $decorationMode
    }

    $normalized['Decorations']['IncludeDefaults'] = ConvertTo-BooleanValue -Value $candidateConfig['Decorations']['IncludeDefaults'] -Fallback $defaults['Decorations']['IncludeDefaults']

    $validatedDefaults = @{}
    $inputDefaults = $candidateConfig['Decorations']['Defaults']
    if ($inputDefaults -is [hashtable]) {
        foreach ($key in $inputDefaults.Keys) {
            $color = [string]$inputDefaults[$key]
            if (-not [string]::IsNullOrWhiteSpace($key) -and ($color -ieq 'random' -or $color -in $allColors)) {
                $validatedDefaults[[string]$key] = $color
            }
        }
    }
    if ($validatedDefaults.Count -gt 0) {
        $normalized['Decorations']['Defaults'] = $validatedDefaults
    }

    $validatedMap = @{}
    $inputDecorationMap = $candidateConfig['Decorations']['Map']
    if ($inputDecorationMap -is [hashtable]) {
        foreach ($key in $inputDecorationMap.Keys) {
            $color = [string]$inputDecorationMap[$key]
            if (-not [string]::IsNullOrWhiteSpace($key) -and ($color -ieq 'random' -or $color -in $allColors)) {
                $validatedMap[[string]$key] = $color
            }
        }
    }
    $normalized['Decorations']['Map'] = $validatedMap

    $colorMode = [string]$candidateConfig['Colors']['Mode']
    if ($colorMode -eq 'Default') {
        $colorMode = 'Multicolor'
    }
    if ($colorMode -in $validColorModes) {
        $normalized['Colors']['Mode'] = $colorMode
    }

    $singleColor = [string]$candidateConfig['Colors']['SingleColor']
    if ($singleColor -in $allColors) {
        $normalized['Colors']['SingleColor'] = $singleColor
    }

    $validatedPalette = @()
    $inputPalette = $candidateConfig['Colors']['Palette']
    if ($inputPalette -is [System.Collections.IEnumerable] -and $inputPalette -isnot [string]) {
        foreach ($item in $inputPalette) {
            if ($item -in $allColors -and $item -notin $validatedPalette) {
                $validatedPalette += [string]$item
            }
        }
    }
    if ($validatedPalette.Count -gt 0) {
        $normalized['Colors']['Palette'] = $validatedPalette
    }

    if ($normalized['Colors']['Mode'] -eq 'Single') {
        $normalized['Colors']['Palette'] = @($normalized['Colors']['SingleColor'])
    }
    elseif ($normalized['Colors']['Mode'] -eq 'Multicolor') {
        $normalized['Colors']['Palette'] = $allColors
    }
    elseif ($normalized['Colors']['Mode'] -eq 'Palette' -and $normalized['Colors']['Palette'].Count -eq 0) {
        $normalized['Colors']['Palette'] = $allColors
    }

    $normalized['Display']['AnimationLoopNumber'] = ConvertTo-PositiveInt -Value $candidateConfig['Display']['AnimationLoopNumber'] -Fallback $defaults['Display']['AnimationLoopNumber'] -Minimum 1
    $normalized['Display']['AnimationSpeed'] = ConvertTo-PositiveInt -Value $candidateConfig['Display']['AnimationSpeed'] -Fallback $defaults['Display']['AnimationSpeed'] -Minimum 1
    $normalized['Display']['HideCursor'] = ConvertTo-BooleanValue -Value $candidateConfig['Display']['HideCursor'] -Fallback $defaults['Display']['HideCursor']

    $normalized['Audio']['PlayCarol'] = ConvertTo-PositiveInt -Value $candidateConfig['Audio']['PlayCarol'] -Fallback $defaults['Audio']['PlayCarol'] -Minimum 0

    $normalized['Messages']['Show'] = ConvertTo-BooleanValue -Value $candidateConfig['Messages']['Show'] -Fallback $defaults['Messages']['Show']

    $normalized['Messages']['Custom'] = @{}
    $inputMessages = $candidateConfig['Messages']['Custom']
    if ($inputMessages -is [hashtable]) {
        foreach ($key in @('MerryChristmas', 'MessageForDevelopers', 'HappyNewYear', 'CodeWord')) {
            if ($inputMessages.ContainsKey($key)) {
                $value = [string]$inputMessages[$key]
                if (-not [string]::IsNullOrWhiteSpace($value)) {
                    $normalized['Messages']['Custom'][$key] = $value
                }
            }
        }
    }

    if ($normalized['Decorations']['Mode'] -eq 'Default') {
        $normalized['Decorations']['Map'] = @{}
    }

    return $normalized
}
