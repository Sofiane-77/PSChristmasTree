BeforeAll {
    $moduleName = 'PSChristmasTree'
    $projectRoot = Resolve-Path -Path "$PSScriptRoot\.."
    $moduleRoot = Split-Path -Path (Resolve-Path "$projectRoot\*\$moduleName.psd1")

    $privateFiles = @(Get-ChildItem -Path "$moduleRoot\Private\*.ps1" -ErrorAction SilentlyContinue)
    $publicFiles = @(Get-ChildItem -Path "$moduleRoot\Public\*.ps1" -ErrorAction SilentlyContinue)

    foreach ($import in @($privateFiles + $publicFiles)) {
        . $import.FullName
    }
}

Describe 'ConvertTo-PSChristmasTreeConfig' -Tag 'Config' {
    It 'returns a complete v3 structured configuration by default' {
        $config = ConvertTo-PSChristmasTreeConfig

        $config['ConfigVersion'] | Should -Be 3
        $config['Language']['UICulture'] | Should -Not -BeNullOrEmpty
        $config['Tree']['Style'] | Should -Be 'Classic'
        $config['Decorations']['Mode'] | Should -Be 'Default'
        $config['Colors']['Mode'] | Should -Be 'Multicolor'
        $config['Display']['AnimationLoopNumber'] | Should -Be 50
        $config['Audio']['PlayCarol'] | Should -Be 0
        $config['Messages']['Show'] | Should -BeTrue
    }

    It 'falls back to a usable UI culture when Get-UICulture returns an empty name' {
        Mock Get-UICulture { [System.Globalization.CultureInfo]::InvariantCulture }

        $config = ConvertTo-PSChristmasTreeConfig
        $expectedCulture = [System.Globalization.CultureInfo]::CurrentUICulture.Name
        if ([string]::IsNullOrWhiteSpace($expectedCulture)) {
            $expectedCulture = 'en-US'
        }

        $config['Language']['UICulture'] | Should -Be $expectedCulture
    }

    It 'migrates legacy flat config into v3 structure' {
        $legacy = @{
            AnimationLoopNumber = 10
            AnimationSpeed = 120
            UICulture = 'fr-FR'
            TreeStyle = 'Wide'
            DecorationMode = 'Custom'
            Decorations = @{ '*' = 'Yellow' }
            ColorMode = 'Single'
            SingleColor = 'Green'
            ShowMessages = $false
        }

        $config = ConvertTo-PSChristmasTreeConfig -PartialConfig $legacy

        $config['Language']['UICulture'] | Should -Be 'fr-FR'
        $config['Tree']['Style'] | Should -Be 'Wide'
        $config['Display']['AnimationLoopNumber'] | Should -Be 10
        $config['Display']['AnimationSpeed'] | Should -Be 120
        $config['Decorations']['Mode'] | Should -Be 'Custom'
        $config['Decorations']['Map']['*'] | Should -Be 'Yellow'
        $config['Colors']['Mode'] | Should -Be 'Single'
        $config['Colors']['SingleColor'] | Should -Be 'Green'
        $config['Messages']['Show'] | Should -BeFalse
    }

    It 'sanitizes invalid colors and invalid numbers gracefully' {
        $partial = @{
            Colors = @{ Mode = 'Palette'; Palette = @('Green', 'NotAColor') }
            Display = @{ AnimationLoopNumber = -3; AnimationSpeed = 0 }
            Decorations = @{ Mode = 'Custom'; Map = @{ 'o' = 'NotAColor'; '*' = 'Red' } }
        }

        $config = ConvertTo-PSChristmasTreeConfig -PartialConfig $partial

        $config['Colors']['Palette'] | Should -Contain 'Green'
        $config['Colors']['Palette'] | Should -Not -Contain 'NotAColor'
        $config['Display']['AnimationLoopNumber'] | Should -Be 50
        $config['Display']['AnimationSpeed'] | Should -Be 300
        $config['Decorations']['Map'].ContainsKey('*') | Should -BeTrue
        $config['Decorations']['Map'].ContainsKey('o') | Should -BeFalse
    }
}

Describe 'ConvertTo-PSChristmasTreeDecorationMap' -Tag 'Config' {
    It 'keeps valid symbol-pattern color entries and supports random colors' {
        $allColors = @([Enum]::GetNames([System.ConsoleColor]))

        $map = ConvertTo-PSChristmasTreeDecorationMap -InputText 'O=Red, *=random, invalid, +=Nope' -AllowedColors $allColors 3>$null

        $map['O'] | Should -Be 'Red'
        $map['*'] | Should -Be 'random'
        $map.ContainsKey('+') | Should -BeFalse
    }
}

Describe 'ConvertTo-PSChristmasTreeColorPalette' -Tag 'Config' {
    It 'returns only valid console colors from user input' {
        $allColors = @([Enum]::GetNames([System.ConsoleColor]))

        $palette = ConvertTo-PSChristmasTreeColorPalette -InputText 'Green, Nope, Yellow,  , Blue' -AllowedColors $allColors

        $palette | Should -Be @('Green', 'Yellow', 'Blue')
    }
}

Describe 'Resolve-PSChristmasTreeEffectiveConfig' -Tag 'Config' {
    It 'applies runtime overrides over saved configuration' {
        $saved = ConvertTo-PSChristmasTreeConfig -PartialConfig @{
            Display = @{ AnimationSpeed = 400 }
            Colors = @{ Mode = 'Single'; SingleColor = 'Red' }
        }

        $effective = Resolve-PSChristmasTreeEffectiveConfig -SavedConfig $saved -RuntimeOverrides @{
            AnimationSpeed = 100
            ColorMode = 'Palette'
            Palette = @('Green', 'Yellow')
        }

        $effective['AnimationSpeed'] | Should -Be 100
        $effective['Colors'] | Should -Be @('Green', 'Yellow')
    }

    It 'builds effective decorations from defaults plus custom map' {
        $saved = ConvertTo-PSChristmasTreeConfig -PartialConfig @{
            Decorations = @{
                Mode = 'Custom'
                IncludeDefaults = $true
                Map = @{ '*' = 'Yellow' }
            }
        }

        $effective = Resolve-PSChristmasTreeEffectiveConfig -SavedConfig $saved

        $effective['Decorations'].ContainsKey('O') | Should -BeTrue
        $effective['Decorations']['*'] | Should -Be 'Yellow'
    }

    It 'keeps the same ornament-pattern illumination behavior in custom mode without defaults' {
        $saved = ConvertTo-PSChristmasTreeConfig -PartialConfig @{
            Decorations = @{
                Mode = 'Custom'
                IncludeDefaults = $false
                Map = @{ '*' = 'Yellow'; 'i' = 'random' }
            }
        }

        $effective = Resolve-PSChristmasTreeEffectiveConfig -SavedConfig $saved

        $effective['Decorations'].ContainsKey('O') | Should -BeFalse
        $effective['Decorations'].ContainsKey('|___|') | Should -BeFalse
        $effective['Decorations']['*'] | Should -Be 'Yellow'
        $effective['Decorations']['i'] | Should -Be 'random'
    }
}

Describe 'Read-PSChristmasTreeConfig' -Tag 'Config' {
    BeforeEach {
        function Get-PSChristmasTreeConfigPath { return (Join-Path $TestDrive 'config.json') }
    }

    It 'returns null when config does not exist' {
        Read-PSChristmasTreeConfig | Should -BeNullOrEmpty
    }

    It 'reads and normalizes a v3 config file' {
        @'
{
  "Language": { "UICulture": "fr-FR" },
  "Display": { "AnimationLoopNumber": 12, "AnimationSpeed": 90 },
  "Colors": { "Mode": "Single", "SingleColor": "Green" }
}
'@ | Set-Content -Path (Join-Path $TestDrive 'config.json')

        $config = Read-PSChristmasTreeConfig

        $config['Language']['UICulture'] | Should -Be 'fr-FR'
        $config['Display']['AnimationLoopNumber'] | Should -Be 12
        $config['Display']['AnimationSpeed'] | Should -Be 90
        $config['Colors']['Mode'] | Should -Be 'Single'
    }

    It 'warns and returns null for invalid json' {
        'not-json' | Set-Content -Path (Join-Path $TestDrive 'config.json')

        $output = Read-PSChristmasTreeConfig 3>&1
        ($output | Where-Object { $_ -is [System.Management.Automation.WarningRecord] }) | Should -Not -BeNullOrEmpty
    }
}

Describe 'Set-PSChristmasTreeConfig' -Tag 'Config' {
    BeforeEach {
        $testConfigPath = Join-Path $TestDrive 'config.json'
        function Get-PSChristmasTreeConfigPath { return $testConfigPath }
    }

    It 'saves scripted settings to the v3 schema' {
        Set-PSChristmasTreeConfig -UICulture 'fr-FR' -TreeStyle 'Wide' -ColorMode 'Single' -SingleColor 'Green' -AnimationSpeed 111
        $config = Read-PSChristmasTreeConfig

        $config['Language']['UICulture'] | Should -Be 'fr-FR'
        $config['Tree']['Style'] | Should -Be 'Wide'
        $config['Colors']['Mode'] | Should -Be 'Single'
        $config['Colors']['SingleColor'] | Should -Be 'Green'
        $config['Display']['AnimationSpeed'] | Should -Be 111
    }

    It 'preserves existing values when only one setting is updated' {
        Set-PSChristmasTreeConfig -AnimationLoopNumber 20 -AnimationSpeed 200
        Set-PSChristmasTreeConfig -AnimationLoopNumber 99

        $config = Read-PSChristmasTreeConfig
        $config['Display']['AnimationLoopNumber'] | Should -Be 99
        $config['Display']['AnimationSpeed'] | Should -Be 200
    }

    It 'supports WhatIf and does not write configuration when previewing changes' {
        if (Test-Path -Path $testConfigPath) {
            Remove-Item -Path $testConfigPath -Force
        }

        Set-PSChristmasTreeConfig -AnimationSpeed 111 -WhatIf

        Test-Path -Path $testConfigPath | Should -BeFalse
    }

    It 'does not write configuration when the interactive wizard is cancelled at the final review step' {
        $script:readHostResponses = [System.Collections.Generic.Queue[string]]::new()

        foreach ($response in @('', '', '', '', '', '', '', '', '', '', 'n', 'n')) {
            $script:readHostResponses.Enqueue($response)
        }

        Mock Write-Host {}
        Mock Read-Host {
            if ($script:readHostResponses.Count -eq 0) {
                throw 'Unexpected Read-Host prompt.'
            }

            return $script:readHostResponses.Dequeue()
        }
        Mock Write-PSChristmasTreeConfig {}

        Set-PSChristmasTreeConfig -Confirm:$false

        Assert-MockCalled Write-PSChristmasTreeConfig -Times 0 -Exactly
        Test-Path -Path $testConfigPath | Should -BeFalse
    }
}

Describe 'Invoke-PSChristmasTreeConfigWizard' -Tag 'Config' {
    BeforeEach {
        $script:readHostResponses = [System.Collections.Generic.Queue[string]]::new()

        Mock Write-Host {}
        Mock Read-Host {
            if ($script:readHostResponses.Count -eq 0) {
                throw 'Unexpected Read-Host prompt.'
            }

            return $script:readHostResponses.Dequeue()
        }
    }

    It 'keeps the current configuration when the user accepts the current choices in quick setup' {
        $currentConfig = ConvertTo-PSChristmasTreeConfig -PartialConfig @{
            Language = @{ UICulture = 'fr-FR' }
            Tree = @{ Style = 'Wide' }
            Display = @{ AnimationLoopNumber = 12; AnimationSpeed = 150; HideCursor = $false }
            Audio = @{ PlayCarol = 2 }
            Messages = @{ Show = $false }
        }

        foreach ($response in @('', '', '', '', '', '', '', '', '', '')) {
            $script:readHostResponses.Enqueue($response)
        }

        $result = Invoke-PSChristmasTreeConfigWizard -CurrentConfig $currentConfig

        $result['Language']['UICulture'] | Should -Be 'fr-FR'
        $result['Tree']['Style'] | Should -Be 'Wide'
        $result['Display']['AnimationLoopNumber'] | Should -Be 12
        $result['Display']['AnimationSpeed'] | Should -Be 150
        $result['Display']['HideCursor'] | Should -BeFalse
        $result['Audio']['PlayCarol'] | Should -Be 2
        $result['Messages']['Show'] | Should -BeFalse
    }

    It 'warns and falls back cleanly when invalid values are entered in guided setup' {
        $currentConfig = ConvertTo-PSChristmasTreeConfig -PartialConfig @{
            Tree = @{ Style = 'Classic'; CustomPath = '' }
            Decorations = @{ Mode = 'Custom'; IncludeDefaults = $true; Map = @{ '*' = 'Yellow' } }
            Colors = @{ Mode = 'Palette'; Palette = @('Green', 'Red') }
        }

        foreach ($response in @(
                '2',
                '',
                '4',
                'Z:\missing-tree.txt',
                '2',
                'y',
                'invalid-entry, *=NotAColor',
                '4',
                'Invisible, AlsoNotAColor',
                '4',
                '0',
                '0',
                '',
                '9',
                '',
                'n',
                'y'
            )) {
            $script:readHostResponses.Enqueue($response)
        }

        $output = Invoke-PSChristmasTreeConfigWizard -CurrentConfig $currentConfig 3>&1
        $result = $output | Where-Object { $_ -isnot [System.Management.Automation.WarningRecord] } | Select-Object -Last 1
        $warnings = $output | Where-Object { $_ -is [System.Management.Automation.WarningRecord] }

        $warnings.Count | Should -BeGreaterThan 0
        $result['Tree']['Style'] | Should -Be 'Classic'
        $result['Tree']['CustomPath'] | Should -Be ''
        $result['Decorations']['Map']['*'] | Should -Be 'Yellow'
        $result['Colors']['Palette'] | Should -Be @('Green', 'Red')
        $result['Display']['AnimationLoopNumber'] | Should -Be 50
        $result['Display']['AnimationSpeed'] | Should -Be 300
    }

    It 'applies valid guided setup inputs across tree, colors, animation, and messages' {
        $customTreePath = Join-Path -Path $TestDrive -ChildPath 'tree.txt'
        @"
   *
  /_\\
  | |
"@ | Set-Content -Path $customTreePath

        foreach ($response in @(
                '2',
                '3',
                '4',
                $customTreePath,
                '1',
                '4',
                'Green, Yellow',
                '4',
                '25',
                '80',
                'n',
                '2',
                'y',
                'y',
                'Joyeux Noel',
                'Built with {0} in {1}',
                'PWSH',
                'Bonne annee',
                'y'
            )) {
            $script:readHostResponses.Enqueue($response)
        }

        $result = Invoke-PSChristmasTreeConfigWizard

        $result['Language']['UICulture'] | Should -Be 'fr-FR'
        $result['Tree']['Style'] | Should -Be 'Custom'
        $result['Tree']['CustomPath'] | Should -Be $customTreePath
        $result['Colors']['Mode'] | Should -Be 'Palette'
        $result['Colors']['Palette'] | Should -Be @('Green', 'Yellow')
        $result['Display']['AnimationLoopNumber'] | Should -Be 25
        $result['Display']['AnimationSpeed'] | Should -Be 80
        $result['Display']['HideCursor'] | Should -BeFalse
        $result['Audio']['PlayCarol'] | Should -Be 1
        $result['Messages']['Show'] | Should -BeTrue
        $result['Messages']['Custom']['MerryChristmas'] | Should -Be 'Joyeux Noel'
        $result['Messages']['Custom']['CodeWord'] | Should -Be 'PWSH'
    }

    It 'returns null when the user cancels at the final review step' {
        foreach ($response in @('', '', '', '', '', '', '', '', '', '', 'n', 'n')) {
            $script:readHostResponses.Enqueue($response)
        }

        $result = Invoke-PSChristmasTreeConfigWizard

        $result | Should -BeNullOrEmpty
    }
}

Describe 'Get-ChristmasTree built-in styles' {
    It 'keeps built-in style identities while exposing ornament symbol patterns for illumination' {
        $classic = Get-ChristmasTree -Style Classic
        $minimal = Get-ChristmasTree -Style Minimal
        $wide = Get-ChristmasTree -Style Wide

        $classic['tree'] | Should -Match 'O|\*|i'
        $minimal['tree'] | Should -Match 'O|\*|i'
        $wide['tree'] | Should -Match 'O|\*|i'

        $minimal['tree'] | Should -Match '/ i \\|/ O O \\'
        $wide['tree'] | Should -Match 'i/'
        $wide['tree'] | Should -Match 'O i O'
    }

    It 'keeps trunk separate from tree body in all built-in styles' {
        $expectedTrunks = @{
            Classic = '|___|'
            Minimal = '|_|'
            Wide = '|_____|'
        }

        foreach ($style in @('Classic', 'Minimal', 'Wide')) {
            $tree = Get-ChristmasTree -Style $style
            $expectedTrunk = [string]$expectedTrunks[$style]

            $tree['trunk'] | Should -Be $expectedTrunk
            $tree['tree'] | Should -Not -Match ([regex]::Escape($expectedTrunk))
        }
    }

    It 'extracts trunk as last non-empty line for custom trees' {
        $customTreePath = Join-Path -Path $TestDrive -ChildPath 'custom-tree.txt'
        @"
   *
  /O\
 /_i_\
  |___|
"@ | Set-Content -Path $customTreePath

        $tree = Get-ChristmasTree -Style Custom -CustomTreePath $customTreePath

        $tree['trunk'] | Should -Be '|___|'
        $tree['tree'] | Should -Match '/_i_'
        $tree['tree'] | Should -Not -Match '\|___\|'
    }
}

Describe 'Reset-PSChristmasTreeConfig' {
    BeforeEach {
        $testConfigPath = Join-Path $TestDrive 'config.json'
        function Get-PSChristmasTreeConfigPath { return $testConfigPath }
    }

    It 'supports WhatIf and does not delete configuration file when previewing changes' {
        '{}' | Set-Content -Path $testConfigPath

        Reset-PSChristmasTreeConfig -WhatIf

        Test-Path -Path $testConfigPath | Should -BeTrue
    }
}

Describe 'Module packaging contract' {
    It 'imports successfully and exports exactly the four public commands' {
        $manifestPath = Resolve-Path -Path "$PSScriptRoot\..\PSChristmasTree\PSChristmasTree.psd1"

        Remove-Module -Name PSChristmasTree -Force -ErrorAction SilentlyContinue
        Import-Module -Name $manifestPath -Force

        $exported = (Get-Module -Name PSChristmasTree).ExportedFunctions.Keys | Sort-Object
        $exported | Should -Be @('Get-PSChristmasTreeConfig', 'Reset-PSChristmasTreeConfig', 'Set-PSChristmasTreeConfig', 'Show-PSChristmasTree')

        Remove-Module -Name PSChristmasTree -Force
    }
}

Describe 'Show-PSChristmasTree orchestration' {
    It 'delegates to resolver, message builder and render loop' {
        Mock Read-PSChristmasTreeConfig { return ConvertTo-PSChristmasTreeConfig }
        Mock Resolve-PSChristmasTreeEffectiveConfig {
            return @{
                UICulture = 'en-US'
                CustomMessages = @{}
                TreeStyle = 'Classic'
                CustomTreePath = ''
                Decorations = @{}
                HideCursor = $false
                PlayCarol = 0
                Colors = @('Green')
                ShowMessages = $false
                AnimationSpeed = 1
                AnimationLoopNumber = 1
            }
        }
        Mock Get-PSChristmasTreeMessageCatalog { return @{ MerryChristmas = @{ Text = ''; Colors = @('Green') }; MessageForDevelopers = @{ Text = '{0}'; '{0}' = 'CODE'; Color = 'Green' }; HappyNewYear = @{ Text = ''; Colors = @('Green') } } }
        Mock Invoke-PSChristmasTreeRenderLoop {}

        Show-PSChristmasTree -AnimationSpeed 123

        Assert-MockCalled Resolve-PSChristmasTreeEffectiveConfig -Times 1 -Exactly
        Assert-MockCalled Get-PSChristmasTreeMessageCatalog -Times 1 -Exactly
        Assert-MockCalled Invoke-PSChristmasTreeRenderLoop -Times 1 -Exactly
    }
}

Describe 'ConvertTo-PSChristmasTreeConfig edge cases' {
    It 'handles null input gracefully' {
        $config = ConvertTo-PSChristmasTreeConfig -PartialConfig $null
        $config | Should -Not -BeNullOrEmpty
        $config['ConfigVersion'] | Should -Be 3
    }

    It 'rejects invalid tree style and defaults to Classic' {
        $config = ConvertTo-PSChristmasTreeConfig -PartialConfig @{ Tree = @{ Style = 'InvalidStyle' } }
        $config['Tree']['Style'] | Should -Be 'Classic'
    }

    It 'rejects all-invalid palette and falls back to full color set' {
        $config = ConvertTo-PSChristmasTreeConfig -PartialConfig @{ Colors = @{ Mode = 'Palette'; Palette = @('NotColor1', 'NotColor2') } }
        $config['Colors']['Palette'].Count | Should -BeGreaterThan 2
    }

    It 'clamps PlayCarol to zero for negative values' {
        $config = ConvertTo-PSChristmasTreeConfig -PartialConfig @{ Audio = @{ PlayCarol = -5 } }
        $config['Audio']['PlayCarol'] | Should -Be 0
    }

    It 'preserves valid decoration map entries, invalid colors are dropped at resolution time' {
        $config = ConvertTo-PSChristmasTreeConfig -PartialConfig @{
            Decorations = @{ Mode = 'Custom'; Map = @{ 'O' = 'Red'; '*' = 'InvalidColor'; 'i' = 'Blue' } }
        }
        # ConvertTo-PSChristmasTreeConfig stores the Map verbatim; validation happens at Resolve time
        $config['Decorations']['Map'].ContainsKey('O') | Should -BeTrue
        $config['Decorations']['Map']['O'] | Should -Be 'Red'
        $config['Decorations']['Map'].ContainsKey('i') | Should -BeTrue
        $config['Decorations']['Map']['i'] | Should -Be 'Blue'
    }

    It 'accepts PlayCarol of zero' {
        $config = ConvertTo-PSChristmasTreeConfig -PartialConfig @{ Audio = @{ PlayCarol = 0 } }
        $config['Audio']['PlayCarol'] | Should -Be 0
    }

    It 'preserves large valid AnimationLoopNumber' {
        $config = ConvertTo-PSChristmasTreeConfig -PartialConfig @{ Display = @{ AnimationLoopNumber = 99999 } }
        $config['Display']['AnimationLoopNumber'] | Should -Be 99999
    }
}

Describe 'Resolve-PSChristmasTreeEffectiveConfig edge cases' {
    It 'handles null saved config gracefully' {
        $effective = Resolve-PSChristmasTreeEffectiveConfig -SavedConfig $null
        $effective | Should -Not -BeNullOrEmpty
        $effective['AnimationLoopNumber'] | Should -BeGreaterThan 0
    }

    It 'handles empty runtime overrides' {
        $saved = ConvertTo-PSChristmasTreeConfig
        $effective = Resolve-PSChristmasTreeEffectiveConfig -SavedConfig $saved -RuntimeOverrides @{}
        $effective | Should -Not -BeNullOrEmpty
    }

    It 'applies only valid parts of mixed valid/invalid overrides' {
        $saved = ConvertTo-PSChristmasTreeConfig -PartialConfig @{ Display = @{ AnimationSpeed = 250 } }
        $effective = Resolve-PSChristmasTreeEffectiveConfig -SavedConfig $saved -RuntimeOverrides @{
            AnimationSpeed = 100
            AnimationLoopNumber = -5
        }
        $effective['AnimationSpeed'] | Should -Be 100
        $effective['AnimationLoopNumber'] | Should -Be 50
    }
}

Describe 'ConvertTo-PSChristmasTreeColorPalette edge cases' {
    It 'filters out empty strings from palette' {
        $palette = ConvertTo-PSChristmasTreeColorPalette -InputText '  , Red , , Green ,  ' -AllowedColors @([Enum]::GetNames([System.ConsoleColor]))
        $palette | Should -Contain 'Red'
        $palette | Should -Contain 'Green'
        $palette.Count | Should -Be 2
    }

    It 'returns empty array when all colors are invalid' {
        $palette = ConvertTo-PSChristmasTreeColorPalette -InputText 'Nope,AlsoNope' -AllowedColors @([Enum]::GetNames([System.ConsoleColor]))
        @($palette).Count | Should -Be 0
    }
}

Describe 'ConvertTo-PSChristmasTreeDecorationMap edge cases' {
    It 'handles whitespace-only input as empty' {
        $map = ConvertTo-PSChristmasTreeDecorationMap -InputText '   ' -AllowedColors @([Enum]::GetNames([System.ConsoleColor]))
        $map | Should -BeOfType [hashtable]
        $map.Count | Should -Be 0
    }

    It 'filters out malformed entries and keeps valid ones' {
        $output = ConvertTo-PSChristmasTreeDecorationMap -InputText 'O=Red,InvalidEntry,*=Green' -AllowedColors @([Enum]::GetNames([System.ConsoleColor])) 3>&1
        $map = $output | Where-Object { $_ -is [hashtable] }
        $map['O'] | Should -Be 'Red'
        $map['*'] | Should -Be 'Green'
        $map.Count | Should -Be 2
    }
}

