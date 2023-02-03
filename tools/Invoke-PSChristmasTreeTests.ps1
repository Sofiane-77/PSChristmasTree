[CmdletBinding()]
param(
    [string[]]$Tag,
    [string[]]$ExcludeTag,
    [ValidateSet('None', 'Normal', 'Detailed', 'Diagnostic', 'Minimal')]
    [string]$Output = 'Detailed',
    [string]$ResultFile,
    [ValidateSet('NUnitXml', 'JUnitXml')]
    [string]$ResultFormat = 'NUnitXml'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$projectRoot = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..')
$testsPath = Join-Path -Path $projectRoot -ChildPath 'Tests'

if (-not (Test-Path -Path $testsPath)) {
    throw "Pester test folder not found: $testsPath"
}

$configuration = New-PesterConfiguration
$configuration.Run.Path = $testsPath
$configuration.Run.PassThru = $true
$configuration.Output.Verbosity = $Output

if ($PSBoundParameters.ContainsKey('Tag') -and $Tag.Count -gt 0) {
    $configuration.Filter.Tag = $Tag
}

if ($PSBoundParameters.ContainsKey('ExcludeTag') -and $ExcludeTag.Count -gt 0) {
    $configuration.Filter.ExcludeTag = $ExcludeTag
}

if ($PSBoundParameters.ContainsKey('ResultFile') -and -not [string]::IsNullOrWhiteSpace($ResultFile)) {
    $resultDirectory = Split-Path -Path $ResultFile -Parent
    if (-not [string]::IsNullOrWhiteSpace($resultDirectory) -and -not (Test-Path -Path $resultDirectory)) {
        New-Item -Path $resultDirectory -ItemType Directory -Force | Out-Null
    }

    $configuration.TestResult.Enabled = $true
    $configuration.TestResult.OutputPath = $ResultFile
    $configuration.TestResult.OutputFormat = $ResultFormat
}

$result = Invoke-Pester -Configuration $configuration

if ($result.FailedCount -gt 0 -or $result.FailedBlocksCount -gt 0 -or $result.Result -ne 'Passed') {
    throw "Pester failed: $($result.FailedCount) test(s) failed across $($result.FailedBlocksCount) failed block(s)."
}

Write-Host "Pester passed: $($result.PassedCount) test(s) across $($result.TotalCount) total."
