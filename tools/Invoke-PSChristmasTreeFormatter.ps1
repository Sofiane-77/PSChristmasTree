[CmdletBinding(DefaultParameterSetName = 'Write')]
param(
    [Parameter(ParameterSetName = 'Check')]
    [switch]$Check,

    [string[]]$Path = @(
        'PSChristmasTree.build.ps1',
        'Tests',
        'tools',
        'docs/UpdateDocs.ps1'
    )
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-NormalizedLineEndingsText {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Text
    )

    return (($Text -replace "`r`n", "`n") -replace "`r", "`n") -replace "`n", [System.Environment]::NewLine
}

$projectRoot = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..')
$settingsPath = Join-Path -Path $projectRoot -ChildPath 'PSChristmasTree/PSScriptAnalyzerSettings.psd1'
$targetFiles = New-Object System.Collections.Generic.List[string]

foreach ($entry in $Path) {
    $resolvedPath = Join-Path -Path $projectRoot -ChildPath $entry

    if (-not (Test-Path -Path $resolvedPath)) {
        throw "Formatting target not found: $entry"
    }

    $item = Get-Item -Path $resolvedPath
    if ($item.PSIsContainer) {
        $files = Get-ChildItem -Path $item.FullName -Recurse -File -Include '*.ps1', '*.psm1', '*.psd1'
        foreach ($file in $files) {
            if ($file.FullName -notmatch '[\\/]Build[\\/]') {
                [void]$targetFiles.Add($file.FullName)
            }
        }

        continue
    }

    [void]$targetFiles.Add($item.FullName)
}

$filesToProcess = $targetFiles | Sort-Object -Unique
$filesNeedingFormat = New-Object System.Collections.Generic.List[string]

foreach ($filePath in $filesToProcess) {
    $original = Get-Content -Path $filePath -Raw
    $normalizedOriginal = Get-NormalizedLineEndingsText -Text $original

    try {
        $formatted = Invoke-Formatter -ScriptDefinition $normalizedOriginal -Settings $settingsPath
    }
    catch {
        throw "Failed to format $(Resolve-Path -Path $filePath -Relative): $($_.Exception.Message)"
    }

    if ($formatted -ceq $normalizedOriginal) {
        continue
    }

    if ($Check) {
        [void]$filesNeedingFormat.Add((Resolve-Path -Path $filePath -Relative))
        continue
    }

    Set-Content -Path $filePath -Value $formatted -Encoding UTF8
    Write-Host "Formatted $(Resolve-Path -Path $filePath -Relative)"
}

if ($Check -and $filesNeedingFormat.Count -gt 0) {
    $filesNeedingFormat | ForEach-Object { Write-Host "Needs formatting: $_" -ForegroundColor Yellow }
    throw 'Formatting drift detected. Run ./tools/Invoke-PSChristmasTreeFormatter.ps1 to apply formatting.'

}