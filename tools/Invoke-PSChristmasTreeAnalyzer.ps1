[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$projectRoot = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..')
$settingsPath = Join-Path -Path $projectRoot -ChildPath 'PSChristmasTree/PSScriptAnalyzerSettings.psd1'
$paths = @(
    (Join-Path -Path $projectRoot -ChildPath 'PSChristmasTree/Public'),
    (Join-Path -Path $projectRoot -ChildPath 'PSChristmasTree/Private')
)
$formattingRules = @(
    'PSPlaceOpenBrace',
    'PSPlaceCloseBrace',
    'PSUseConsistentWhitespace',
    'PSUseConsistentIndentation',
    'PSUseConsistentCase'
)

$issues = @(
    foreach ($path in $paths) {
        Invoke-ScriptAnalyzer -Path $path -Recurse -Settings $settingsPath -ErrorAction Stop |
        Where-Object { $_.RuleName -notin $formattingRules }
    }
)

if ($issues.Count -gt 0) {
    $issues | Sort-Object Severity, ScriptName, Line | Format-Table -AutoSize

    $errors = @($issues | Where-Object Severity -eq 'Error')
    $warnings = @($issues | Where-Object Severity -eq 'Warning')
    $summary = "ScriptAnalyzer found $($errors.Count) error(s) and $($warnings.Count) warning(s)."

    if ($errors.Count -gt 0) {
        $summary += " Error rules: $((($errors | Select-Object -ExpandProperty RuleName -Unique) -join ', '))"
    }

    if ($warnings.Count -gt 0) {
        $summary += " Warning rules: $((($warnings | Select-Object -ExpandProperty RuleName -Unique) -join ', '))"
    }

    throw $summary
}
