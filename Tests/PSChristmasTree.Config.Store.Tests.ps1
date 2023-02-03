<#
  Config Store adapter tests.

  These tests validate:
    1. The in-memory store contract (Load / Save / Delete).
    2. Read-PSChristmasTreeConfig and Write-PSChristmasTreeConfig against
       an injected in-memory store — no filesystem access, no function
       overrides, no Mock-based path redirection.

  This demonstrates the ports/adapters separation: callers depend on the
  store contract (the port), not on a concrete path or file-system function.
#>
BeforeAll {
    $moduleRoot = Split-Path -Path (Resolve-Path "$PSScriptRoot\..\PSChristmasTree\PSChristmasTree.psd1")

    $privateFiles = @(Get-ChildItem -Path "$moduleRoot\Private\*.ps1" -ErrorAction SilentlyContinue)
    $publicFiles = @(Get-ChildItem -Path "$moduleRoot\Public\*.ps1"  -ErrorAction SilentlyContinue)
    foreach ($import in @($privateFiles + $publicFiles)) {
        . $import.FullName
    }

    # In-memory store - test adapter implementing the same port as Get-PSChristmasTreeConfigStore.
    # No filesystem dependency, safe for parallel runs.
    function New-PSChristmasTreeInMemoryConfigStore() {
        Param($InitialJson = $null)
        $state = @{ Json = $InitialJson }
        return @{
            Load = { return $state.Json }.GetNewClosure()
            Save = { param($Json) $state.Json = $Json }.GetNewClosure()
            Delete = {
                if ($null -ne $state.Json) { $state.Json = $null; return $true }
                return $false
            }.GetNewClosure()
        }
    }
}

Describe 'In-memory config store contract' -Tag 'ConfigStore' {
    It 'Load returns null on a fresh store' {
        $store = New-PSChristmasTreeInMemoryConfigStore
        (& $store.Load) | Should -BeNullOrEmpty
    }

    It 'Save persists data and Load retrieves it' {
        $store = New-PSChristmasTreeInMemoryConfigStore
        & $store.Save '{"ConfigVersion":3}'
        & $store.Load | Should -Be '{"ConfigVersion":3}'
    }

    It 'Delete returns false when the store is empty' {
        $store = New-PSChristmasTreeInMemoryConfigStore
        (& $store.Delete) | Should -BeFalse
    }

    It 'Delete removes persisted data and returns true' {
        $store = New-PSChristmasTreeInMemoryConfigStore -InitialJson '{"ConfigVersion":3}'
        (& $store.Delete) | Should -BeTrue
        (& $store.Load)   | Should -BeNullOrEmpty
    }
}

Describe 'Read-PSChristmasTreeConfig with injected store' -Tag 'ConfigStore' {
    It 'returns null when the store has no data' {
        $store = New-PSChristmasTreeInMemoryConfigStore
        Read-PSChristmasTreeConfig -Store $store | Should -BeNullOrEmpty
    }

    It 'parses and normalizes a v3 JSON payload from the store' {
        $store = New-PSChristmasTreeInMemoryConfigStore -InitialJson @'
{
  "Language": { "UICulture": "fr-FR" },
  "Display":  { "AnimationLoopNumber": 7, "AnimationSpeed": 42 },
  "Colors":   { "Mode": "Single", "SingleColor": "Cyan" }
}
'@
        $config = Read-PSChristmasTreeConfig -Store $store

        $config['Language']['UICulture']          | Should -Be 'fr-FR'
        $config['Display']['AnimationLoopNumber']  | Should -Be 7
        $config['Display']['AnimationSpeed']       | Should -Be 42
        $config['Colors']['Mode']                  | Should -Be 'Single'
        $config['Colors']['SingleColor']           | Should -Be 'Cyan'
    }

    It 'emits a warning and returns null when the store contains invalid JSON' {
        $store = New-PSChristmasTreeInMemoryConfigStore -InitialJson 'not-json-at-all'
        $output = Read-PSChristmasTreeConfig -Store $store 3>&1
        ($output | Where-Object { $_ -is [System.Management.Automation.WarningRecord] }) |
            Should -Not -BeNullOrEmpty
    }
}

Describe 'Write-PSChristmasTreeConfig with injected store' -Tag 'ConfigStore' {
    It 'serializes and persists the normalized config to the store' {
        $store = New-PSChristmasTreeInMemoryConfigStore

        Write-PSChristmasTreeConfig -Config @{ Display = @{ AnimationSpeed = 99 } } -Store $store

        $saved = & $store.Load
        $saved | Should -Not -BeNullOrEmpty
        ($saved | ConvertFrom-Json).Display.AnimationSpeed | Should -Be 99
    }

    It 'normalizes the config before saving (missing fields are filled with defaults)' {
        $store = New-PSChristmasTreeInMemoryConfigStore

        Write-PSChristmasTreeConfig -Config @{} -Store $store

        $saved = & $store.Load | ConvertFrom-Json
        $saved.ConfigVersion | Should -Be 3
        $saved.Display.AnimationLoopNumber | Should -BeGreaterThan 0
    }
}

Describe 'Read/Write round-trip via injected store' -Tag 'ConfigStore' {
    It 'Write followed by Read returns the same effective configuration' {
        $store = New-PSChristmasTreeInMemoryConfigStore

        Write-PSChristmasTreeConfig -Config @{
            Language = @{ UICulture = 'en-US' }
            Colors = @{ Mode = 'Palette'; Palette = @('Red', 'Green') }
        } -Store $store

        $config = Read-PSChristmasTreeConfig -Store $store

        $config['Language']['UICulture'] | Should -Be 'en-US'
        $config['Colors']['Mode']        | Should -Be 'Palette'
        $config['Colors']['Palette']     | Should -Be @('Red', 'Green')
    }
}

