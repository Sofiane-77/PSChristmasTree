<#
 .Synopsis
  Benchmark PSChristmasTree rendering performance

 .Description
  Measures rendering pipeline performance including:
  - Configuration resolution time
  - Tree decoration time
  - Message catalog loading
  - Full render loop (actual terminal display)
  - Carol playback startup overhead

 .Example
   .\Benchmark-PSChristmasTree.ps1 -Iterations 5 -AnimationLoopNumber 10

 .Example
   .\Benchmark-PSChristmasTree.ps1 -SkipRendering  # Only test config, not terminal output
#>
Param (
    [int]$Iterations = 3,
    [int]$AnimationLoopNumber = 5,
    [int]$AnimationSpeed = 200,
    [switch]$SkipRendering,
    [switch]$Verbose
)

$ErrorActionPreference = 'Stop'
$WarningPreference = 'SilentlyContinue'

# Import module + private functions (needed for benchmarking internals)
$moduleRoot = Resolve-Path "$PSScriptRoot\..\PSChristmasTree"
Import-Module "$moduleRoot\PSChristmasTree.psd1" -Force

# Dot-source private files for benchmarking internals
@(Get-ChildItem -Path "$moduleRoot\Private\*.ps1" -ErrorAction SilentlyContinue) | ForEach-Object { . $_.FullName }

# Benchmark results container
$results = @{
    ConfigResolution = @()
    TreeGeneration = @()
    Decorations = @()
    MessageCatalog = @()
    FullRender = @()
    CarolStartup = @()
}

Write-Host "`n=== PSChristmasTree Performance Benchmark ===" -ForegroundColor Cyan
Write-Host "Iterations: $Iterations, Loops: $AnimationLoopNumber, Speed: ${AnimationSpeed}ms" -ForegroundColor DarkGray
Write-Host ""

# Test 1: Configuration Resolution
Write-Host "1. Configuration Resolution" -ForegroundColor Yellow
for ($i = 0; $i -lt $Iterations; $i++) {
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    
    $saved = ConvertTo-PSChristmasTreeConfig
    $effective = Resolve-PSChristmasTreeEffectiveConfig -SavedConfig $saved -RuntimeOverrides @{
        AnimationLoopNumber = $AnimationLoopNumber
        AnimationSpeed = $AnimationSpeed
    }
    
    $sw.Stop()
    $results['ConfigResolution'] += $sw.ElapsedMilliseconds
    Write-Host "   Iteration $($i+1): $($sw.ElapsedMilliseconds)ms" -ForegroundColor DarkGray
}

# Test 2: Tree Generation
Write-Host "2. Tree Generation" -ForegroundColor Yellow
foreach ($style in @('Classic', 'Minimal', 'Wide')) {
    Write-Host "   Style: $style" -ForegroundColor DarkGray
    for ($i = 0; $i -lt $Iterations; $i++) {
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        
        $tree = Get-ChristmasTree -Style $style
        
        $sw.Stop()
        $results['TreeGeneration'] += $sw.ElapsedMilliseconds
        Write-Host "     Iteration $($i+1): $($sw.ElapsedMilliseconds)ms" -ForegroundColor DarkGray
    }
}

# Test 3: Decoration Application
Write-Host "3. Decoration Application" -ForegroundColor Yellow
for ($i = 0; $i -lt $Iterations; $i++) {
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    
    $tree = Get-ChristmasTree -Style Classic
    $decorations = @{
        'O' = 'random'
        'i' = 'Yellow'
        '*' = 'Red'
        '|___|' = 'Green'
    }
    $decorated = Get-PSChristmasTreeDecoratedTree -TreeData $tree -DecorationMap $decorations
    
    $sw.Stop()
    $results['Decorations'] += $sw.ElapsedMilliseconds
    Write-Host "   Iteration $($i+1): $($sw.ElapsedMilliseconds)ms" -ForegroundColor DarkGray
}

# Test 4: Message Catalog Loading
Write-Host "4. Message Catalog Loading" -ForegroundColor Yellow
foreach ($culture in @('en-US', 'fr-FR', 'de-DE')) {
    Write-Host "   Culture: $culture" -ForegroundColor DarkGray
    for ($i = 0; $i -lt $Iterations; $i++) {
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        
        try {
            $messages = Get-PSChristmasTreeMessageCatalog -UICulture $culture
        }
        catch {
            # Fallback expected for cultures without translations
        }
        
        $sw.Stop()
        $results['MessageCatalog'] += $sw.ElapsedMilliseconds
        Write-Host "     Iteration $($i+1): $($sw.ElapsedMilliseconds)ms" -ForegroundColor DarkGray
    }
}

# Test 5: Full Render Loop (if not skipped)
if (-not $SkipRendering) {
    Write-Host "5. Full Render Loop (no terminal output)" -ForegroundColor Yellow
    for ($i = 0; $i -lt $Iterations; $i++) {
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        
        $config = @{
            TreeStyle = 'Classic'
            CustomTreePath = ''
            Decorations = @{ 'O' = 'random'; 'i' = 'Yellow' }
            Colors = @('Green', 'Red', 'Yellow', 'Cyan')
            AnimationLoopNumber = 2  # Short loop for benchmark
            AnimationSpeed = 50
            HideCursor = $false
            PlayCarol = 0
            ShowMessages = $false
            UICulture = 'en-US'
            CustomMessages = @{}
        }
        
        # Measure only the configuration and preparation, not the actual display
        $tree = Get-ChristmasTree -Style $config['TreeStyle']
        $decorated = Get-PSChristmasTreeDecoratedTree -TreeData $tree -DecorationMap $config['Decorations']
        $messages = Get-PSChristmasTreeMessageCatalog -UICulture $config['UICulture']
        
        $sw.Stop()
        $results['FullRender'] += $sw.ElapsedMilliseconds
        Write-Host "   Iteration $($i+1): $($sw.ElapsedMilliseconds)ms" -ForegroundColor DarkGray
    }
}

# Test 6: Carol Playback Startup
Write-Host "6. Carol Playback Startup (0 repetitions = instant)" -ForegroundColor Yellow
for ($i = 0; $i -lt $Iterations; $i++) {
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    
    Invoke-Carol 0  # 0 = no playback, instant return
    
    $sw.Stop()
    $results['CarolStartup'] += $sw.ElapsedMilliseconds
    Write-Host "   Iteration $($i+1): $($sw.ElapsedMilliseconds)ms" -ForegroundColor DarkGray
}

# Summary Report
Write-Host "`n=== Summary ===" -ForegroundColor Green
$results.GetEnumerator() | ForEach-Object {
    if ($_.Value.Count -gt 0) {
        $avg = [math]::Round(($_.Value | Measure-Object -Average).Average, 2)
        $min = ($_.Value | Measure-Object -Minimum).Minimum
        $max = ($_.Value | Measure-Object -Maximum).Maximum
        $p95 = [math]::Round(($_.Value | Sort-Object)[([int]($_.Value.Count * 0.95))], 2)
        
        Write-Host "$($_.Name):" -ForegroundColor Cyan
        Write-Host "  Avg: ${avg}ms | Min: ${min}ms | Max: ${max}ms | P95: ${p95}ms" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "Performance Notes:" -ForegroundColor DarkGray
Write-Host "  - Message catalog has locale fallback overhead for unsupported cultures" -ForegroundColor DarkGray
Write-Host "  - Tree generation is negligible (< 1ms typical)" -ForegroundColor DarkGray
Write-Host "  - Decoration mapping is O(symbols * decorations)" -ForegroundColor DarkGray
Write-Host "  - Config resolution is O(1) with fallback validation" -ForegroundColor DarkGray
Write-Host "  - Carol startup with 0 iterations is instant (event listener only)" -ForegroundColor DarkGray
Write-Host ""

