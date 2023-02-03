<#
 .Synopsis
  Generate code coverage report for PSChristmasTree module

 .Description
  Uses Pester code coverage feature to analyze test coverage across:
  - Private functions (implementation)
  - Public commands (user-facing API)
  - Returns coverage metrics and identifies untested code paths

 .Example
   .\Test-Coverage.ps1

 .Example
   .\Test-Coverage.ps1 -Detailed | Out-File coverage-report.txt
#>
Param (
    [switch]$Detailed,
    [switch]$ExcludeInternals
)

$ErrorActionPreference = 'Stop'

$projectRoot = Resolve-Path "$PSScriptRoot\.."
$moduleRoot = "$projectRoot\PSChristmasTree"
$testsPath = "$projectRoot\Tests"

Write-Host "`n=== PSChristmasTree Code Coverage Analysis ===" -ForegroundColor Cyan
Write-Host "Module Root: $moduleRoot" -ForegroundColor DarkGray
Write-Host "Tests Path: $testsPath" -ForegroundColor DarkGray
Write-Host ""

# Collect coverage from all PowerShell files
$privateFiles = @(Get-ChildItem -Path "$moduleRoot\Private\*.ps1" -ErrorAction SilentlyContinue)
$publicFiles = @(Get-ChildItem -Path "$moduleRoot\Public\*.ps1" -ErrorAction SilentlyContinue)

$codeCoverageFiles = if ($ExcludeInternals) {
    @($publicFiles)
}
else {
    @($privateFiles + $publicFiles)
}

Write-Host "Analyzing $($codeCoverageFiles.Count) files for coverage..." -ForegroundColor Yellow
Write-Host "  Public files: $($publicFiles.Count)" -ForegroundColor DarkGray
Write-Host "  Private files: $($privateFiles.Count)" -ForegroundColor DarkGray
Write-Host ""

# NOTE: Pester 5 cannot instrument code that is dot-sourced inside BeforeAll{}.
# This is the case in PSChristmasTree.Tests.ps1. We therefore create a temporary
# test script that imports the module and re-runs the same Pester configuration
# with code-coverage instrumentation using the module loader instead.

# Build a temporary test file that overrides the module loader to use Import-Module
$tempTestBootstrap = Join-Path $env:TEMP 'PSChristmasTree_CoverageBootstrap.ps1'
@'
BeforeAll {
    Remove-Module PSChristmasTree -Force -ErrorAction SilentlyContinue
    Import-Module "$moduleRoot\PSChristmasTree.psd1" -Force
    # Re-dot-source all private functions so they are in scope for tests that call them directly
    Get-ChildItem "$moduleRoot\Private\*.ps1" | ForEach-Object { . $_.FullName }
    Get-ChildItem "$moduleRoot\Public\*.ps1"  | ForEach-Object { . $_.FullName }
}
'@ -replace '\$moduleRoot', $moduleRoot | Set-Content -Path $tempTestBootstrap

# Run Pester with code coverage via the standard config
$config = New-PesterConfiguration
$config.Run.Path = $testsPath
$config.Run.PassThru = $true
$config.CodeCoverage.Enabled = $true
$config.CodeCoverage.Path = ($codeCoverageFiles | ForEach-Object { [string]$_.FullName })
$config.CodeCoverage.CoveragePercentTarget = 80
$config.Output.Verbosity = 'None'
$config.TestResult.Enabled = $false

Write-Host "Running tests with code coverage (this may take a moment)..." -ForegroundColor Yellow
$result = Invoke-Pester -Configuration $config

if (Test-Path $tempTestBootstrap) { Remove-Item $tempTestBootstrap -Force }

# Analyze results
$cc = $result.CodeCoverage
$hitCount = @($cc.HitCommands).Count
$missCount = @($cc.MissedCommands).Count

if (($hitCount + $missCount) -gt 2) {
    $totalCommands = $hitCount + $missCount
    $coveredCommands = $hitCount

    # File-level statistics
    $fileStats = @()
    $allFiles = @($cc.HitCommands | Select-Object -ExpandProperty Path -Unique) + @($cc.MissedCommands | Select-Object -ExpandProperty Path -Unique) | Sort-Object -Unique
    foreach ($filePath in $allFiles) {
        $hits = @($cc.HitCommands | Where-Object Path -eq $filePath).Count
        $misses = @($cc.MissedCommands | Where-Object Path -eq $filePath).Count
        $total = $hits + $misses
        $fileCoverage = if ($total -gt 0) { [math]::Round(($hits / $total) * 100, 1) } else { 100 }

        $fileStats += [PSCustomObject]@{
            File = Split-Path -Leaf $filePath
            Hit = $hits
            Missed = $misses
            Total = $total
            Coverage = "$fileCoverage%"
        }
    }

    $overallCoverage = if ($totalCommands -gt 0) { [math]::Round(($coveredCommands / $totalCommands) * 100, 1) } else { 100 }

    Write-Host "`n=== Overall Coverage ===" -ForegroundColor Green
    Write-Host "Total Commands: $totalCommands" -ForegroundColor Yellow
    Write-Host "Covered: $coveredCommands | Missed: $($totalCommands - $coveredCommands)" -ForegroundColor Yellow
    Write-Host "Coverage: $overallCoverage%" -ForegroundColor $(if ($overallCoverage -ge 90) { 'Green' } elseif ($overallCoverage -ge 70) { 'Yellow' } else { 'Red' })

    if ($Detailed) {
        Write-Host "`n=== File-by-File Coverage ===" -ForegroundColor Green
        $fileStats | Sort-Object { [double]($_.Coverage -replace '%') } -Descending | Format-Table -AutoSize

        Write-Host "`n=== Missed Commands ===" -ForegroundColor Yellow
        foreach ($filePath in $allFiles) {
            $missed = @($cc.MissedCommands | Where-Object Path -eq $filePath)
            if ($missed.Count -gt 0) {
                Write-Host ("`n" + (Split-Path -Leaf $filePath) + ":") -ForegroundColor Cyan
                $missed | ForEach-Object {
                    Write-Host "  Line $($_.Extent.StartLineNumber): $($_.Extent.Text)" -ForegroundColor DarkGray
                }
            }
        }
    }
    else {
        Write-Host "`nTop 10 files by coverage:" -ForegroundColor Green
        $fileStats | Sort-Object { [double]($_.Coverage -replace '%') } -Descending | Select-Object -First 10 | Format-Table -AutoSize
    }
    
    # Summary recommendations
    Write-Host "`n=== Coverage Assessment ===" -ForegroundColor Cyan
    if ($overallCoverage -ge 90) {
        Write-Host "✓ Excellent coverage (90%+)" -ForegroundColor Green
        Write-Host "  Focus: Edge cases and error paths" -ForegroundColor DarkGray
    }
    elseif ($overallCoverage -ge 80) {
        Write-Host "✓ Good coverage (80-90%)" -ForegroundColor Green
        Write-Host "  Focus: Complex code paths and boundary conditions" -ForegroundColor DarkGray
    }
    elseif ($overallCoverage -ge 70) {
        Write-Host "⚠ Acceptable coverage (70-80%)" -ForegroundColor Yellow
        Write-Host "  Recommended: Add tests for untested functions" -ForegroundColor DarkGray
    }
    else {
        Write-Host "✗ Low coverage (< 70%)" -ForegroundColor Red
        Write-Host "  Required: Significantly improve test coverage" -ForegroundColor DarkGray
    }

}
else {
    # Pester could not instrument dot-sourced code - fall back to a line-count estimate
    Write-Host "" -ForegroundColor Yellow
    Write-Host "NOTE: Pester code coverage requires 'Import-Module' to instrument private functions." -ForegroundColor Yellow
    Write-Host "      The test suite uses dot-source loading which Pester 5 cannot instrument." -ForegroundColor DarkGray
    Write-Host ""
    Write-Host "=== Static Coverage Estimate ===" -ForegroundColor Green

    $fileStats = @()
    foreach ($file in $codeCoverageFiles) {
        $lines = @(Get-Content $file.FullName | Where-Object { $_ -match '\S' } | Where-Object { $_ -notmatch '^\s*#' } | Where-Object { $_ -notmatch '^\s*<#' } | Where-Object { $_ -notmatch '^\s*\[' })
        $fileStats += [PSCustomObject]@{
            File = $file.Name
            NonBlank = $lines.Count
            Type = if ($file.DirectoryName -match 'Public') { 'Public' } else { 'Private' }
        }
    }

    $totalLines = ($fileStats | Measure-Object NonBlank -Sum).Sum
    Write-Host "Total non-blank, non-comment source lines: $totalLines" -ForegroundColor Yellow
    Write-Host "Tests directory: $((Get-ChildItem $testsPath -Filter '*.ps1').Count) test files" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Files by type:" -ForegroundColor Cyan
    $fileStats | Group-Object Type | ForEach-Object {
        $lines = ($_.Group | Measure-Object NonBlank -Sum).Sum
        Write-Host "  $($_.Name): $($_.Count) files, $lines lines" -ForegroundColor DarkGray
    }
    Write-Host ""
    Write-Host "To get real coverage metrics, run: Invoke-Pester -CodeCoverage (Get-ChildItem .\PSChristmasTree\Private\*.ps1, .\PSChristmasTree\Public\*.ps1)" -ForegroundColor DarkGray
}

Write-Host ""

