function Resolve-PSChristmasTreeEffectiveConfig() {
    [CmdletBinding()]
    [OutputType([hashtable])]
    Param (
        [Parameter(Mandatory = $false)]
        [hashtable]$SavedConfig,

        [Parameter(Mandatory = $false)]
        [hashtable]$RuntimeOverrides
    )

    $allColors = @([Enum]::GetNames([System.ConsoleColor]))
    $baseConfig = if ($null -ne $SavedConfig) {
        ConvertTo-PSChristmasTreeConfig -PartialConfig $SavedConfig
    }
    else {
        ConvertTo-PSChristmasTreeConfig
    }

    $patch = @{}
    if ($RuntimeOverrides) {
        if ($RuntimeOverrides.ContainsKey('UICulture')) {
            $patch['Language'] = @{ UICulture = $RuntimeOverrides['UICulture'] }
        }

        if ($RuntimeOverrides.ContainsKey('TreeStyle') -or $RuntimeOverrides.ContainsKey('CustomTreePath')) {
            $patch['Tree'] = @{}
            if ($RuntimeOverrides.ContainsKey('TreeStyle')) {
                $patch['Tree']['Style'] = $RuntimeOverrides['TreeStyle']
            }
            if ($RuntimeOverrides.ContainsKey('CustomTreePath')) {
                $patch['Tree']['CustomPath'] = $RuntimeOverrides['CustomTreePath']
            }
        }

        if ($RuntimeOverrides.ContainsKey('DecorationMode') -or $RuntimeOverrides.ContainsKey('Decorations') -or $RuntimeOverrides.ContainsKey('IncludeDefaultDecorations')) {
            $patch['Decorations'] = @{}
            if ($RuntimeOverrides.ContainsKey('DecorationMode')) {
                $patch['Decorations']['Mode'] = $RuntimeOverrides['DecorationMode']
            }
            if ($RuntimeOverrides.ContainsKey('Decorations')) {
                $patch['Decorations']['Map'] = $RuntimeOverrides['Decorations']
            }
            if ($RuntimeOverrides.ContainsKey('IncludeDefaultDecorations')) {
                $patch['Decorations']['IncludeDefaults'] = [bool]$RuntimeOverrides['IncludeDefaultDecorations']
            }
        }

        if ($RuntimeOverrides.ContainsKey('ColorMode') -or $RuntimeOverrides.ContainsKey('SingleColor') -or $RuntimeOverrides.ContainsKey('Palette') -or $RuntimeOverrides.ContainsKey('Colors')) {
            $patch['Colors'] = @{}
            if ($RuntimeOverrides.ContainsKey('ColorMode')) {
                $patch['Colors']['Mode'] = $RuntimeOverrides['ColorMode']
            }
            if ($RuntimeOverrides.ContainsKey('SingleColor')) {
                $patch['Colors']['SingleColor'] = $RuntimeOverrides['SingleColor']
            }
            if ($RuntimeOverrides.ContainsKey('Palette')) {
                $patch['Colors']['Palette'] = $RuntimeOverrides['Palette']
            }
            if ($RuntimeOverrides.ContainsKey('Colors')) {
                $patch['Colors']['Palette'] = $RuntimeOverrides['Colors']
                if (-not $RuntimeOverrides.ContainsKey('ColorMode')) {
                    $patch['Colors']['Mode'] = 'Palette'
                }
            }
        }

        if ($RuntimeOverrides.ContainsKey('AnimationLoopNumber') -or $RuntimeOverrides.ContainsKey('AnimationSpeed') -or $RuntimeOverrides.ContainsKey('HideCursor')) {
            $patch['Display'] = @{}
            if ($RuntimeOverrides.ContainsKey('AnimationLoopNumber')) {
                $patch['Display']['AnimationLoopNumber'] = $RuntimeOverrides['AnimationLoopNumber']
            }
            if ($RuntimeOverrides.ContainsKey('AnimationSpeed')) {
                $patch['Display']['AnimationSpeed'] = $RuntimeOverrides['AnimationSpeed']
            }
            if ($RuntimeOverrides.ContainsKey('HideCursor')) {
                $patch['Display']['HideCursor'] = [bool]$RuntimeOverrides['HideCursor']
            }
        }

        if ($RuntimeOverrides.ContainsKey('PlayCarol')) {
            $patch['Audio'] = @{ PlayCarol = $RuntimeOverrides['PlayCarol'] }
        }

        if ($RuntimeOverrides.ContainsKey('ShowMessages') -or $RuntimeOverrides.ContainsKey('CustomMessages')) {
            $patch['Messages'] = @{}
            if ($RuntimeOverrides.ContainsKey('ShowMessages')) {
                $patch['Messages']['Show'] = [bool]$RuntimeOverrides['ShowMessages']
            }
            if ($RuntimeOverrides.ContainsKey('CustomMessages')) {
                $patch['Messages']['Custom'] = $RuntimeOverrides['CustomMessages']
            }
        }
    }

    $trunkColor = if ($RuntimeOverrides -and $RuntimeOverrides.ContainsKey('TrunkColor')) {
        $RuntimeOverrides['TrunkColor']
    } else {
        ''
    }

    $resolvedConfig = if ($patch.Count -gt 0) {
        ConvertTo-PSChristmasTreeConfig -PartialConfig (Merge-Hashtable $baseConfig $patch)
    }
    else {
        $baseConfig
    }

    $effectiveColors = @()
    switch ($resolvedConfig['Colors']['Mode']) {
        'Single' {
            $effectiveColors = @($resolvedConfig['Colors']['SingleColor'])
        }
        'Palette' {
            $effectiveColors = @($resolvedConfig['Colors']['Palette'])
        }
        default {
            $effectiveColors = $allColors
        }
    }

    if (-not $effectiveColors -or $effectiveColors.Count -eq 0) {
        $effectiveColors = $allColors
    }

    $effectiveDecorations = @{}
    if ($resolvedConfig['Decorations']['IncludeDefaults']) {
        $effectiveDecorations = Merge-Hashtable $effectiveDecorations $resolvedConfig['Decorations']['Defaults']
    }
    if ($resolvedConfig['Decorations']['Mode'] -eq 'Custom') {
        $effectiveDecorations = Merge-Hashtable $effectiveDecorations $resolvedConfig['Decorations']['Map']
    }

    return @{
        # v3 nested structure (for internal use)
        Language     = $resolvedConfig['Language']
        Tree         = $resolvedConfig['Tree']
        Decorations  = $effectiveDecorations
        Colors       = $effectiveColors
        Display      = $resolvedConfig['Display']
        Audio        = $resolvedConfig['Audio']
        Messages     = $resolvedConfig['Messages']
        # Flat legacy-compatible keys (for existing code)
        Config              = $resolvedConfig
        AnimationLoopNumber = [int]$resolvedConfig['Display']['AnimationLoopNumber']
        AnimationSpeed      = [int]$resolvedConfig['Display']['AnimationSpeed']
        HideCursor          = [bool]$resolvedConfig['Display']['HideCursor']
        PlayCarol           = [int]$resolvedConfig['Audio']['PlayCarol']
        UICulture           = [string]$resolvedConfig['Language']['UICulture']
        TreeStyle           = [string]$resolvedConfig['Tree']['Style']
        CustomTreePath      = [string]$resolvedConfig['Tree']['CustomPath']
        ShowMessages        = [bool]$resolvedConfig['Messages']['Show']
        CustomMessages      = $resolvedConfig['Messages']['Custom']
        TrunkColor          = $trunkColor
    }
}
