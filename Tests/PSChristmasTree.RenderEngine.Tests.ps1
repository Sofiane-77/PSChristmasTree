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

Describe 'Get-PSChristmasTreeDecoratedTree' -Tag 'RenderEngine' {
    It 'combines body and trunk before decoration tagging' {
        Mock Get-CenteredText {
            return "<$Text>"
        }
        Mock Add-DecorationTag {
            return "decorated::$Text"
        }

        $result = Get-PSChristmasTreeDecoratedTree -TreeData @{ tree = 'body'; trunk = 'trunk' } -DecorationMap @{ '*' = 'Yellow' }

        $result | Should -Be "decorated::<body>`n<trunk>"
        Assert-MockCalled Get-CenteredText -Times 2 -Exactly
        Assert-MockCalled Add-DecorationTag -Times 1 -Exactly
    }

    It 'supports trees without a body section' {
        Mock Get-CenteredText {
            return "<$Text>"
        }
        $result = Get-PSChristmasTreeDecoratedTree -TreeData @{ tree = ''; trunk = '|_|' }

        $result | Should -Be '<|_|>'
    }
}

Describe 'Get-PSChristmasTreeMessageRenderModel' -Tag 'RenderEngine' {
    It 'short-circuits when messages are disabled' {
        $model = Get-PSChristmasTreeMessageRenderModel -Messages @{} -ShowMessages:$false

        $model['Show'] | Should -BeFalse
    }

    It 'builds a precomputed message model when messages are enabled' {
        Mock Get-DecoratedFormattedText {
            return 'decorated-line'
        }

        $messages = @{
            MerryChristmas = @{ Text = 'Merry'; Colors = @('Green', 'Red') }
            MessageForDevelopers = @{ Text = 'Built with {0} in {1}'; '{0}' = 'PWSH'; Color = 'Cyan' }
            HappyNewYear = @{ Text = '2027'; Colors = @('Yellow') }
        }

        $model = Get-PSChristmasTreeMessageRenderModel -Messages $messages -ShowMessages:$true

        $model['Show'] | Should -BeTrue
        $model['MerryChristmasText'] | Should -Be 'Merry'
        $model['DeveloperLineDecoratedText'] | Should -Be 'decorated-line'
        $model['DeveloperLineDefaultColor'] | Should -Be 'Cyan'
        $model['HappyNewYearText'] | Should -Be '2027'

        Assert-MockCalled Get-DecoratedFormattedText -Times 1 -Exactly
    }
}

Describe 'Invoke-PSChristmasTreeRenderLoop internals' -Tag 'RenderEngine' {
    It 'delegates frame preparation to helper functions and restores terminal state' {
        Mock Get-ConsoleForegroundColor { return 'Gray' }
        Mock Get-BufferSizeWidth { return 120 }
        Mock Get-CursorSize { return 25 }
        Mock Get-ChristmasTree { return @{ tree = 'body'; trunk = 'trunk' } }
        Mock Get-PSChristmasTreeDecoratedTree { return 'decorated-tree' }
        Mock Get-PSChristmasTreeMessageRenderModel { return @{ Show = $false } }
        Mock Invoke-Carol {}
        Mock Clear-Host {}
        Mock Write-Host-Colorized {}
        Mock Start-Sleep {}
        Mock Set-CursorSize {}
        Mock Set-ConsoleForegroundColor {}

        $effective = @{
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

        $messages = @{
            MerryChristmas = @{ Text = 'M'; Colors = @('Green') }
            MessageForDevelopers = @{ Text = '{0}'; '{0}' = 'X'; Color = 'Green' }
            HappyNewYear = @{ Text = 'N'; Colors = @('Green') }
        }

        Invoke-PSChristmasTreeRenderLoop -EffectiveConfig $effective -Messages $messages

        Assert-MockCalled Get-PSChristmasTreeDecoratedTree -Times 1 -Exactly
        Assert-MockCalled Get-PSChristmasTreeMessageRenderModel -Times 1 -Exactly
        Assert-MockCalled Set-CursorSize -Times 1 -Exactly
        Assert-MockCalled Set-ConsoleForegroundColor -Times 1 -Exactly
    }
}
