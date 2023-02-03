<#
 .Synopsis
    Save PSChristmasTree display settings.

 .Description
  Saves PSChristmasTree display settings to a local user configuration file.
  Settings stored here are automatically applied by Show-PSChristmasTree.
  Parameters passed explicitly to Show-PSChristmasTree always take precedence over saved settings.

    When called with no parameters, starts a guided interactive setup wizard.
    The wizard offers beginner-friendly language choices (for example English/French),
    with an optional custom locale input for advanced users.
  When called with one or more parameters, only those values are updated; all other saved
  settings are preserved.

    This command supports WhatIf and Confirm.

 .Parameter AnimationLoopNumber
  Number of times to loop the animation

 .Parameter AnimationSpeed
  Time in milliseconds to show each animation frame

 .Parameter ColorMode
  Color behavior mode. Valid values: Multicolor, Single, Palette.

 .Parameter SingleColor
  Single console color used when ColorMode is Single.

 .Parameter Palette
  Color palette used when ColorMode is Palette.

 .Parameter Colors
  Compatibility alias for palette-style updates.

 .Parameter Decorations
    Hashtable mapping existing ornament symbols/patterns in the ASCII tree to display colors.

 .Parameter DecorationMode
    Ornament-pattern illumination strategy. Valid values: Default, Custom.

 .Parameter IncludeDefaultDecorations
    Controls whether built-in ornament-pattern colors are merged with custom symbol-pattern colors.

 .Parameter PlayCarol
  Number of times to loop the "We Wish You a Merry Christmas" carol (0 = disabled)

 .Parameter UICulture
  Language code for localized messages (e.g. en-US, fr-FR)

 .Parameter TreeStyle
  Tree style. Valid values: Classic, Minimal, Wide, Custom.
    Built-in styles already include ornament symbol patterns that can be illuminated.

 .Parameter CustomTreePath
  Path to a custom ASCII tree file when TreeStyle is Custom.

 .Parameter HideCursor
  Hides the cursor while rendering when true.

 .Parameter ShowMessages
  Enables or disables greeting messages under the tree.

 .Parameter CustomMessages
  Hashtable of custom message overrides.

 .Parameter Config
  Hashtable patch using the structured v3 schema.

 .Example
    # Start the guided setup wizard
   Set-PSChristmasTreeConfig

 .Example
   # Save specific settings without a wizard
   Set-PSChristmasTreeConfig -AnimationLoopNumber 10 -PlayCarol 1

 .Example
   # Save custom colors
   Set-PSChristmasTreeConfig -Colors @('Green', 'Red', 'Yellow')

 .Example
     # Save custom ornament-pattern colors
   Set-PSChristmasTreeConfig -Decorations @{ 'O' = 'Red'; '*' = 'Yellow' }

 .LINK
   https://github.com/Sofiane-77/PSChristmasTree
#>
function Set-PSChristmasTreeConfig() {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType([System.Void])]
    Param (
        [Parameter(Mandatory = $false)]
        [ValidateRange(1, [int]::MaxValue)]
        [int]$AnimationLoopNumber,

        [Parameter(Mandatory = $false)]
        [ValidateRange(1, [int]::MaxValue)]
        [int]$AnimationSpeed,

        [Parameter(Mandatory = $false)]
        [ValidateSet('Multicolor', 'Single', 'Palette')]
        [string]$ColorMode,

        [Parameter(Mandatory = $false)]
        [string]$SingleColor,

        [Parameter(Mandatory = $false)]
        [array]$Palette,

        [Parameter(Mandatory = $false)]
        [array]$Colors,

        [Parameter(Mandatory = $false)]
        [hashtable]$Decorations,

        [Parameter(Mandatory = $false)]
        [ValidateSet('Default', 'Custom')]
        [string]$DecorationMode,

        [Parameter(Mandatory = $false)]
        [bool]$IncludeDefaultDecorations,

        [Parameter(Mandatory = $false)]
        [ValidateRange(0, [int]::MaxValue)]
        [int]$PlayCarol,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$UICulture,

        [Parameter(Mandatory = $false)]
        [ValidateSet('Classic', 'Minimal', 'Wide', 'Custom')]
        [string]$TreeStyle,

        [Parameter(Mandatory = $false)]
        [string]$CustomTreePath,

        [Parameter(Mandatory = $false)]
        [bool]$HideCursor,

        [Parameter(Mandatory = $false)]
        [bool]$ShowMessages,

        [Parameter(Mandatory = $false)]
        [hashtable]$CustomMessages,

        [Parameter(Mandatory = $false)]
        [hashtable]$Config
    )

    $existingConfig = Read-PSChristmasTreeConfig
    if ($null -eq $existingConfig) {
        $existingConfig = ConvertTo-PSChristmasTreeConfig
    }

    $configParameterNames = @(
        'AnimationLoopNumber',
        'AnimationSpeed',
        'ColorMode',
        'SingleColor',
        'Palette',
        'Colors',
        'Decorations',
        'DecorationMode',
        'IncludeDefaultDecorations',
        'PlayCarol',
        'UICulture',
        'TreeStyle',
        'CustomTreePath',
        'HideCursor',
        'ShowMessages',
        'CustomMessages',
        'Config'
    )
    $boundConfigKeys = @($PSBoundParameters.Keys | Where-Object { $_ -in $configParameterNames })
    $isInteractiveWizard = $boundConfigKeys.Count -eq 0
    $configPath = Get-PSChristmasTreeConfigPath

    if ($isInteractiveWizard) {
        if (-not $PSCmdlet.ShouldProcess($configPath, 'Save PSChristmasTree configuration')) {
            return
        }

        $newConfig = Invoke-PSChristmasTreeConfigWizard -CurrentConfig $existingConfig
        if ($null -eq $newConfig) {
            Write-Verbose 'Interactive setup was cancelled. Configuration was not changed.'
            return
        }

        Write-PSChristmasTreeConfig -Config $newConfig
        return
    }

    $patch = @{}
    if ($PSBoundParameters.ContainsKey('Config')) {
        $patch = Merge-Hashtable $patch $Config
    }

    if ($PSBoundParameters.ContainsKey('UICulture')) {
        $patch['Language'] = @{ UICulture = $UICulture }
    }

    if ($PSBoundParameters.ContainsKey('TreeStyle') -or $PSBoundParameters.ContainsKey('CustomTreePath')) {
        $patch['Tree'] = @{}
        if ($PSBoundParameters.ContainsKey('TreeStyle')) {
            $patch['Tree']['Style'] = $TreeStyle
            if ($TreeStyle -ne 'Custom' -and -not $PSBoundParameters.ContainsKey('CustomTreePath')) {
                $patch['Tree']['CustomPath'] = ''
            }
        }
        if ($PSBoundParameters.ContainsKey('CustomTreePath')) {
            $patch['Tree']['CustomPath'] = $CustomTreePath
        }
    }

    if ($PSBoundParameters.ContainsKey('DecorationMode') -or $PSBoundParameters.ContainsKey('Decorations') -or $PSBoundParameters.ContainsKey('IncludeDefaultDecorations')) {
        $patch['Decorations'] = @{}
        if ($PSBoundParameters.ContainsKey('DecorationMode')) { $patch['Decorations']['Mode'] = $DecorationMode }
        if ($PSBoundParameters.ContainsKey('Decorations')) { $patch['Decorations']['Map'] = $Decorations }
        if ($PSBoundParameters.ContainsKey('IncludeDefaultDecorations')) { $patch['Decorations']['IncludeDefaults'] = $IncludeDefaultDecorations }
    }

    if ($PSBoundParameters.ContainsKey('ColorMode') -or $PSBoundParameters.ContainsKey('SingleColor') -or $PSBoundParameters.ContainsKey('Palette') -or $PSBoundParameters.ContainsKey('Colors')) {
        $patch['Colors'] = @{}
        if ($PSBoundParameters.ContainsKey('ColorMode')) { $patch['Colors']['Mode'] = $ColorMode }
        if ($PSBoundParameters.ContainsKey('SingleColor')) { $patch['Colors']['SingleColor'] = $SingleColor }
        if ($PSBoundParameters.ContainsKey('Palette')) { $patch['Colors']['Palette'] = $Palette }
        if ($PSBoundParameters.ContainsKey('Colors')) {
            $patch['Colors']['Palette'] = $Colors
            if (-not $PSBoundParameters.ContainsKey('ColorMode')) {
                $patch['Colors']['Mode'] = 'Palette'
            }
        }
    }

    if ($PSBoundParameters.ContainsKey('AnimationLoopNumber') -or $PSBoundParameters.ContainsKey('AnimationSpeed') -or $PSBoundParameters.ContainsKey('HideCursor')) {
        $patch['Display'] = @{}
        if ($PSBoundParameters.ContainsKey('AnimationLoopNumber')) { $patch['Display']['AnimationLoopNumber'] = $AnimationLoopNumber }
        if ($PSBoundParameters.ContainsKey('AnimationSpeed')) { $patch['Display']['AnimationSpeed'] = $AnimationSpeed }
        if ($PSBoundParameters.ContainsKey('HideCursor')) { $patch['Display']['HideCursor'] = $HideCursor }
    }

    if ($PSBoundParameters.ContainsKey('PlayCarol')) {
        $patch['Audio'] = @{ PlayCarol = $PlayCarol }
    }

    if ($PSBoundParameters.ContainsKey('ShowMessages') -or $PSBoundParameters.ContainsKey('CustomMessages')) {
        $patch['Messages'] = @{}
        if ($PSBoundParameters.ContainsKey('ShowMessages')) { $patch['Messages']['Show'] = $ShowMessages }
        if ($PSBoundParameters.ContainsKey('CustomMessages')) { $patch['Messages']['Custom'] = $CustomMessages }
    }

    $newConfig = ConvertTo-PSChristmasTreeConfig -PartialConfig (Merge-Hashtable $existingConfig $patch)

    if ($PSCmdlet.ShouldProcess($configPath, 'Save PSChristmasTree configuration')) {
        Write-PSChristmasTreeConfig -Config $newConfig
    }
}
