function Invoke-PSChristmasTreeConfigWizard() {
    [CmdletBinding()]
    [OutputType([hashtable])]
    Param (
        [Parameter(Mandatory = $false)]
        [hashtable]$CurrentConfig
    )

    $allColors = @([Enum]::GetNames([System.ConsoleColor]))
    $defaultConfig = Get-PSChristmasTreeDefaultConfig
    $workingConfig = if ($CurrentConfig) {
        ConvertTo-PSChristmasTreeConfig -PartialConfig $CurrentConfig
    }
    else {
        ConvertTo-PSChristmasTreeConfig
    }

    function Read-WizardChoice {
        Param (
            [string]$Prompt,
            [string[]]$AllowedValues = @(),
            [hashtable]$Aliases = @{},
            [string]$DefaultValue = ''
        )

        $rawInput = Read-Host $Prompt
        if ([string]::IsNullOrWhiteSpace($rawInput)) {
            return $DefaultValue
        }

        $candidate = $rawInput.Trim()
        foreach ($key in $Aliases.Keys) {
            if ($candidate -ieq $key) {
                return [string]$Aliases[$key]
            }
        }

        foreach ($value in $AllowedValues) {
            if ($candidate -ieq $value) {
                return $value
            }
        }

        return $candidate
    }

    function Read-WizardYesNo {
        Param (
            [string]$Prompt,
            [Nullable[bool]]$CurrentValue = $null,
            [bool]$DefaultValue = $true
        )

        $defaultLabel = if ($null -ne $CurrentValue) {
            if ($CurrentValue) { 'y' } else { 'n' }
        }
        elseif ($DefaultValue) {
            'y'
        }
        else {
            'n'
        }

        $rawInput = Read-Host "$Prompt [${defaultLabel}]"
        if ([string]::IsNullOrWhiteSpace($rawInput)) {
            if ($null -ne $CurrentValue) {
                return [bool]$CurrentValue
            }

            return $DefaultValue
        }

        switch -Regex ($rawInput.Trim()) {
            '^(y|yes)$' { return $true }
            '^(n|no)$' { return $false }
            default {
                Write-Warning 'Please answer with y or n. Keeping the current choice.'
                if ($null -ne $CurrentValue) {
                    return [bool]$CurrentValue
                }

                return $DefaultValue
            }
        }
    }

    function Read-WizardNumber {
        Param (
            [string]$Prompt,
            [int]$CurrentValue,
            [int]$Minimum = 0
        )

        $parsedValue = 0
        $rawInput = Read-Host "$Prompt [$CurrentValue]"
        if ([string]::IsNullOrWhiteSpace($rawInput)) {
            return $CurrentValue
        }

        if ([int]::TryParse($rawInput.Trim(), [ref]$parsedValue) -and $parsedValue -ge $Minimum) {
            return $parsedValue
        }

        Write-Warning "Please enter a number greater than or equal to $Minimum. Keeping the current value."
        return $CurrentValue
    }

    function Get-ColorModeLabel {
        Param ([hashtable]$Config)

        switch ($Config['Colors']['Mode']) {
            'Single' { return "Single color ($($Config['Colors']['SingleColor']))" }
            'Palette' { return "Custom palette ($($Config['Colors']['Palette'] -join ', '))" }
            default { return 'Multicolor' }
        }
    }

    function Get-DecorationLabel {
        Param ([hashtable]$Config)

        if ($Config['Decorations']['Mode'] -eq 'Custom') {
            $defaultLabel = if ($Config['Decorations']['IncludeDefaults']) { 'custom ornament-pattern colors + built-in pattern colors' } else { 'custom ornament-pattern colors only' }
            return $defaultLabel
        }

        return 'Built-in ornament-pattern colors'
    }

    function Get-MusicLabel {
        Param ([hashtable]$Config)

        if ($Config['Audio']['PlayCarol'] -le 0) {
            return 'Off'
        }

        if ($Config['Audio']['PlayCarol'] -eq 1) {
            return 'Play once'
        }

        return "Play $($Config['Audio']['PlayCarol']) times"
    }

    function Get-AnimationLabel {
        Param ([hashtable]$Config)

        return "$($Config['Display']['AnimationLoopNumber']) loops at $($Config['Display']['AnimationSpeed']) ms per frame"
    }

    function Get-LanguageLabel {
        Param ([string]$UICulture)

        if ($UICulture -match '^fr(-|$)') {
            return 'French'
        }

        if ($UICulture -match '^en(-|$)') {
            return 'English'
        }

        if ([string]::IsNullOrWhiteSpace($UICulture)) {
            return 'Custom'
        }

        return "Custom ($UICulture)"
    }

    Write-Host ''
    Write-Host '=== Configure Your PSChristmasTree ===' -ForegroundColor Green
    Write-Host 'Let us set up your tree step by step.' -ForegroundColor DarkGray
    Write-Host 'Press Enter at any prompt to keep the current choice.' -ForegroundColor DarkGray
    Write-Host ''

    Write-Host 'Step 1/8 - Choose your setup style' -ForegroundColor Cyan
    Write-Host '  1) Quick setup (recommended)' -ForegroundColor DarkGray
    Write-Host '     Good for most people. We will guide you through the main choices.' -ForegroundColor DarkGray
    Write-Host '  2) Full guided setup' -ForegroundColor DarkGray
    Write-Host '     Includes the same friendly flow, plus optional advanced fine-tuning.' -ForegroundColor DarkGray
    $setupMode = Read-WizardChoice -Prompt '  How would you like to set up your tree? [1]' -AllowedValues @('Quick', 'Guided') -Aliases @{
        '1'                 = 'Quick'
        '2'                 = 'Guided'
        'Full'              = 'Guided'
        'Full guided setup' = 'Guided'
        'Quick setup'       = 'Quick'
    } -DefaultValue 'Quick'
    if ($setupMode -notin @('Quick', 'Guided')) {
        Write-Warning 'Invalid choice. Starting the recommended quick setup.'
        $setupMode = 'Quick'
    }
    Write-Host ''

    Write-Host 'Step 2/8 - Language' -ForegroundColor Cyan
    Write-Host '  This changes the greeting text shown under the tree.' -ForegroundColor DarkGray
    Write-Host "  Current: $(Get-LanguageLabel -UICulture $workingConfig['Language']['UICulture'])" -ForegroundColor DarkGray
    Write-Host '  1) Keep current language' -ForegroundColor DarkGray
    Write-Host '  2) English' -ForegroundColor DarkGray
    Write-Host '  3) French' -ForegroundColor DarkGray
    Write-Host '  4) Other language (enter locale code)' -ForegroundColor DarkGray
    Write-Host '  Tip: Advanced users can also type a locale code directly here (example: en-US).' -ForegroundColor DarkGray

    $languageChoice = Read-WizardChoice -Prompt '  Language choice [1]' -AllowedValues @('Keep', 'English', 'French', 'Custom') -Aliases @{
        '1'  = 'Keep'
        '2'  = 'English'
        '3'  = 'French'
        '4'  = 'Custom'
        'en' = 'English'
        'fr' = 'French'
    } -DefaultValue 'Keep'

    switch ($languageChoice) {
        'Keep' { }
        'English' { $workingConfig['Language']['UICulture'] = 'en-US' }
        'French' { $workingConfig['Language']['UICulture'] = 'fr-FR' }
        'Custom' {
            $rawInput = Read-Host "  Locale code [$($workingConfig['Language']['UICulture'])]"
            if (-not [string]::IsNullOrWhiteSpace($rawInput)) {
                $workingConfig['Language']['UICulture'] = $rawInput.Trim()
            }
        }
        default {
            # Treat unknown input as a direct locale code for advanced users.
            $workingConfig['Language']['UICulture'] = $languageChoice.Trim()
        }
    }
    Write-Host ''

    Write-Host 'Step 3/8 - Tree style' -ForegroundColor Cyan
    Write-Host '  Pick the look of your tree.' -ForegroundColor DarkGray
    Write-Host '  1) Classic - the familiar balanced tree' -ForegroundColor DarkGray
    Write-Host '  2) Minimal - a simpler, lighter look' -ForegroundColor DarkGray
    Write-Host '  3) Wide - a fuller tree shape' -ForegroundColor DarkGray
    Write-Host '  4) Use my own ASCII tree file' -ForegroundColor DarkGray
    $treeChoice = Read-WizardChoice -Prompt "  Tree style [current: $($workingConfig['Tree']['Style'])]" -AllowedValues @('Classic', 'Minimal', 'Wide', 'Custom') -Aliases @{
        '1'                      = 'Classic'
        '2'                      = 'Minimal'
        '3'                      = 'Wide'
        '4'                      = 'Custom'
        'My own ASCII tree file' = 'Custom'
    }
    switch ($treeChoice) {
        'Classic' {
            $workingConfig['Tree']['Style'] = 'Classic'
            $workingConfig['Tree']['CustomPath'] = ''
        }
        'Minimal' {
            $workingConfig['Tree']['Style'] = 'Minimal'
            $workingConfig['Tree']['CustomPath'] = ''
        }
        'Wide' {
            $workingConfig['Tree']['Style'] = 'Wide'
            $workingConfig['Tree']['CustomPath'] = ''
        }
        'Custom' {
            $currentPath = $workingConfig['Tree']['CustomPath']
            $rawInput = Read-Host "  Path to your tree text file [$currentPath]"
            if (-not [string]::IsNullOrWhiteSpace($rawInput)) {
                $candidatePath = $rawInput.Trim()
                if (Test-Path -Path $candidatePath) {
                    $workingConfig['Tree']['Style'] = 'Custom'
                    $workingConfig['Tree']['CustomPath'] = $candidatePath
                }
                else {
                    Write-Warning 'That file was not found. Keeping the current tree style.'
                }
            }
            elseif (-not [string]::IsNullOrWhiteSpace($currentPath)) {
                $workingConfig['Tree']['Style'] = 'Custom'
            }
        }
        '' { }
        default { Write-Warning 'Invalid choice. Keeping the current tree style.' }
    }
    Write-Host ''

    Write-Host 'Step 4/8 - Ornament pattern lighting' -ForegroundColor Cyan
    Write-Host '  The ASCII tree already contains ornament symbols (like O, *, |___|).' -ForegroundColor DarkGray
    Write-Host '  Here you choose how those existing symbols are colorized.' -ForegroundColor DarkGray
    Write-Host '  1) Use built-in ornament-pattern colors (recommended)' -ForegroundColor DarkGray
    Write-Host '  2) Choose my own ornament-pattern colors' -ForegroundColor DarkGray
    $decorationChoice = Read-WizardChoice -Prompt "  Ornament pattern color style [current: $($workingConfig['Decorations']['Mode'])]" -AllowedValues @('Default', 'Custom') -Aliases @{
        '1'                                = 'Default'
        '2'                                = 'Custom'
        'Built-in'                         = 'Default'
        'Built-in ornament-pattern colors' = 'Default'
    }
    if ($decorationChoice -eq 'Custom') {
        $workingConfig['Decorations']['Mode'] = 'Custom'
        $workingConfig['Decorations']['IncludeDefaults'] = Read-WizardYesNo -Prompt '  Keep built-in ornament-pattern colors too?' -CurrentValue $workingConfig['Decorations']['IncludeDefaults']

        $currentMap = if ($workingConfig['Decorations']['Map'].Count -gt 0) {
            ($workingConfig['Decorations']['Map'].Keys | ForEach-Object { "$_=$($workingConfig['Decorations']['Map'][$_])" }) -join ', '
        }
        else {
            '(none)'
        }

        Write-Host "  Match each existing symbol pattern to a color: O=Red, *=Yellow, +=random." -ForegroundColor DarkGray
        Write-Host '  Leave this blank to keep your current custom symbol-pattern colors.' -ForegroundColor DarkGray
        $rawInput = Read-Host "  Symbol-pattern color map [$currentMap]"
        if (-not [string]::IsNullOrWhiteSpace($rawInput)) {
            $newMap = ConvertTo-PSChristmasTreeDecorationMap -InputText $rawInput -AllowedColors $allColors

            if ($newMap.Count -gt 0) {
                $workingConfig['Decorations']['Map'] = $newMap
            }
        }
    }
    elseif ($decorationChoice -in @('Default', '')) {
        $workingConfig['Decorations']['Mode'] = 'Default'
        $workingConfig['Decorations']['IncludeDefaults'] = $true
        $workingConfig['Decorations']['Map'] = @{}
    }
    else {
        Write-Warning 'Invalid choice. Keeping the current ornament-pattern lighting setup.'
    }
    Write-Host ''

    Write-Host 'Step 5/8 - Colors' -ForegroundColor Cyan
    Write-Host '  Choose how colorful you want the tree to feel.' -ForegroundColor DarkGray
    Write-Host '  1) Recommended festive colors' -ForegroundColor DarkGray
    Write-Host '  2) Multicolor' -ForegroundColor DarkGray
    Write-Host '  3) One color everywhere' -ForegroundColor DarkGray
    Write-Host '  4) My own color palette' -ForegroundColor DarkGray
    $colorChoice = Read-WizardChoice -Prompt "  Color style [current: $($workingConfig['Colors']['Mode'])]" -AllowedValues @('Recommended', 'Multicolor', 'Single', 'Palette') -Aliases @{
        '1'                    = 'Recommended'
        '2'                    = 'Multicolor'
        '3'                    = 'Single'
        '4'                    = 'Palette'
        'One color'            = 'Single'
        'My own color palette' = 'Palette'
    }
    switch ($colorChoice) {
        'Recommended' {
            $workingConfig['Colors'] = @{}
            foreach ($key in $defaultConfig['Colors'].Keys) {
                $workingConfig['Colors'][$key] = $defaultConfig['Colors'][$key]
            }
        }
        '1' {
            $workingConfig['Colors'] = @{}
            foreach ($key in $defaultConfig['Colors'].Keys) {
                $workingConfig['Colors'][$key] = $defaultConfig['Colors'][$key]
            }
        }
        'Multicolor' {
            $workingConfig['Colors']['Mode'] = 'Multicolor'
        }
        'Single' {
            $workingConfig['Colors']['Mode'] = 'Single'
            Write-Host '  Pick one console color for the whole tree.' -ForegroundColor DarkGray
            Write-Host "  Available colors: $($allColors -join ', ')" -ForegroundColor DarkGray
            $rawInput = Read-Host "  Color name [$($workingConfig['Colors']['SingleColor'])]"
            if (-not [string]::IsNullOrWhiteSpace($rawInput) -and $rawInput.Trim() -in $allColors) {
                $workingConfig['Colors']['SingleColor'] = $rawInput.Trim()
            }
            elseif (-not [string]::IsNullOrWhiteSpace($rawInput)) {
                Write-Warning 'That color is not available. Keeping the current single color.'
            }
        }
        'Palette' {
            $workingConfig['Colors']['Mode'] = 'Palette'
            Write-Host '  Enter a comma-separated list of colors in the order you want to use them.' -ForegroundColor DarkGray
            Write-Host "  Available colors: $($allColors -join ', ')" -ForegroundColor DarkGray
            $currentPalette = $workingConfig['Colors']['Palette'] -join ','
            $rawInput = Read-Host "  Color palette [$currentPalette]"
            if (-not [string]::IsNullOrWhiteSpace($rawInput)) {
                $palette = ConvertTo-PSChristmasTreeColorPalette -InputText $rawInput -AllowedColors $allColors
                if (@($palette).Count -gt 0) {
                    $workingConfig['Colors']['Palette'] = $palette
                }
                else {
                    Write-Warning 'No valid colors were provided. Keeping the current palette.'
                }
            }
        }
        '' { }
        default { Write-Warning 'Invalid choice. Keeping the current color setup.' }
    }
    Write-Host ''

    Write-Host 'Step 6/8 - Animation' -ForegroundColor Cyan
    Write-Host '  Choose how lively the tree should feel on screen.' -ForegroundColor DarkGray
    Write-Host '  1) Gentle - slower and shorter' -ForegroundColor DarkGray
    Write-Host '  2) Balanced - recommended default' -ForegroundColor DarkGray
    Write-Host '  3) Lively - faster and longer' -ForegroundColor DarkGray
    if ($setupMode -eq 'Guided') {
        Write-Host '  4) Fine-tune the animation details myself' -ForegroundColor DarkGray
    }
    $animationChoice = Read-WizardChoice -Prompt '  Animation style' -AllowedValues @('Gentle', 'Balanced', 'Lively', 'Fine') -Aliases @{
        '1'         = 'Gentle'
        '2'         = 'Balanced'
        '3'         = 'Lively'
        '4'         = 'Fine'
        'Fine-tune' = 'Fine'
    }
    switch ($animationChoice) {
        'Gentle' {
            $workingConfig['Display']['AnimationLoopNumber'] = 30
            $workingConfig['Display']['AnimationSpeed'] = 450
        }
        'Balanced' {
            $workingConfig['Display']['AnimationLoopNumber'] = 50
            $workingConfig['Display']['AnimationSpeed'] = 300
        }
        'Lively' {
            $workingConfig['Display']['AnimationLoopNumber'] = 80
            $workingConfig['Display']['AnimationSpeed'] = 150
        }
        'Fine' {
            if ($setupMode -eq 'Guided') {
                $workingConfig['Display']['AnimationLoopNumber'] = Read-WizardNumber -Prompt '  How many animation loops would you like?' -CurrentValue $workingConfig['Display']['AnimationLoopNumber'] -Minimum 1
                $workingConfig['Display']['AnimationSpeed'] = Read-WizardNumber -Prompt '  Frame delay in milliseconds (higher = slower)' -CurrentValue $workingConfig['Display']['AnimationSpeed'] -Minimum 1
            }
        }
        '' { }
        default { Write-Warning 'Invalid choice. Keeping the current animation settings.' }
    }

    $workingConfig['Display']['HideCursor'] = Read-WizardYesNo -Prompt '  Hide the blinking cursor while the tree is on screen?' -CurrentValue $workingConfig['Display']['HideCursor']
    Write-Host ''

    Write-Host 'Step 7/8 - Music and messages' -ForegroundColor Cyan
    Write-Host '  Choose whether the tree should play music and show greeting text.' -ForegroundColor DarkGray
    Write-Host '  1) No music' -ForegroundColor DarkGray
    Write-Host '  2) Play the carol once' -ForegroundColor DarkGray
    Write-Host '  3) Play the carol a few times' -ForegroundColor DarkGray
    $musicChoice = Read-WizardChoice -Prompt '  Music option' -AllowedValues @('Off', 'Once', 'Few') -Aliases @{
        '1'        = 'Off'
        '2'        = 'Once'
        '3'        = 'Few'
        'No music' = 'Off'
    }
    switch ($musicChoice) {
        'Off' { $workingConfig['Audio']['PlayCarol'] = 0 }
        'Once' { $workingConfig['Audio']['PlayCarol'] = 1 }
        'Few' { $workingConfig['Audio']['PlayCarol'] = 3 }
        '' { }
        default { Write-Warning 'Invalid choice. Keeping the current music setting.' }
    }

    $workingConfig['Messages']['Show'] = Read-WizardYesNo -Prompt '  Show greeting messages below the tree?' -CurrentValue $workingConfig['Messages']['Show']
    Write-Host ''

    Write-Host 'Step 8/8 - Review and save' -ForegroundColor Cyan
    $customizeMessages = $false
    if ($workingConfig['Messages']['Show']) {
        $customizeMessages = Read-WizardYesNo -Prompt '  Would you like to personalize the greeting text?' -CurrentValue $false -DefaultValue $false
    }

    if ($customizeMessages) {
        $custom = @{}
        $messagePrompts = @(
            @{ Key = 'MerryChristmas'; Label = 'Main holiday greeting' }
            @{ Key = 'MessageForDevelopers'; Label = 'Secondary line for developers' }
            @{ Key = 'CodeWord'; Label = 'Code word shown inside the developer line' }
            @{ Key = 'HappyNewYear'; Label = 'New Year greeting' }
        )

        foreach ($messagePrompt in $messagePrompts) {
            $key = $messagePrompt['Key']
            $currentValue = if ($workingConfig['Messages']['Custom'].ContainsKey($key)) { $workingConfig['Messages']['Custom'][$key] } else { '' }
            $text = Read-Host "  $($messagePrompt['Label']) [$currentValue]"
            if (-not [string]::IsNullOrWhiteSpace($text)) {
                $custom[$key] = $text.Trim()
            }
            elseif (-not [string]::IsNullOrWhiteSpace($currentValue)) {
                $custom[$key] = $currentValue
            }
        }

        $workingConfig['Messages']['Custom'] = $custom
    }

    Write-Host ''
    Write-Host '  Here is your setup:' -ForegroundColor DarkGray
    Write-Host "  - Language: $($workingConfig['Language']['UICulture'])" -ForegroundColor DarkGray
    if ($workingConfig['Tree']['Style'] -eq 'Custom' -and -not [string]::IsNullOrWhiteSpace($workingConfig['Tree']['CustomPath'])) {
        Write-Host "  - Tree style: Custom file ($($workingConfig['Tree']['CustomPath']))" -ForegroundColor DarkGray
    }
    else {
        Write-Host "  - Tree style: $($workingConfig['Tree']['Style'])" -ForegroundColor DarkGray
    }
    Write-Host "  - Ornament pattern lighting: $(Get-DecorationLabel -Config $workingConfig)" -ForegroundColor DarkGray
    Write-Host "  - Colors: $(Get-ColorModeLabel -Config $workingConfig)" -ForegroundColor DarkGray
    Write-Host "  - Animation: $(Get-AnimationLabel -Config $workingConfig)" -ForegroundColor DarkGray
    Write-Host "  - Hide cursor: $(if ($workingConfig['Display']['HideCursor']) { 'Yes' } else { 'No' })" -ForegroundColor DarkGray
    Write-Host "  - Music: $(Get-MusicLabel -Config $workingConfig)" -ForegroundColor DarkGray
    Write-Host "  - Messages: $(if ($workingConfig['Messages']['Show']) { 'Shown' } else { 'Hidden' })" -ForegroundColor DarkGray

    $saveChanges = Read-WizardYesNo -Prompt '  Save these settings now?' -CurrentValue $null -DefaultValue $true
    if (-not $saveChanges) {
        Write-Host ''
        Write-Host 'No changes were saved.' -ForegroundColor Yellow
        return $null
    }

    return (ConvertTo-PSChristmasTreeConfig -PartialConfig $workingConfig)
}
