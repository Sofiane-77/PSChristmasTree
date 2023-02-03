[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-NormalizedText {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Text
    )

    return (($Text -replace "`r`n", "`n") -replace "`r", "`n").TrimEnd("`r", "`n")
}

$projectRoot = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..')
$docsRoot = Join-Path -Path $projectRoot -ChildPath 'docs'
$publicPath = Join-Path -Path $projectRoot -ChildPath 'PSChristmasTree/Public'
$tempRoot = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath ("PSChristmasTree-docs-" + [guid]::NewGuid().ToString('N'))

try {
    New-Item -Path $tempRoot -ItemType Directory -Force | Out-Null

    & (Join-Path -Path $docsRoot -ChildPath 'UpdateDocs.ps1') -OutputFolder $tempRoot | Out-Null

    $expectedFiles = @(
        Get-ChildItem -Path $publicPath -Filter '*.ps1' -File |
        ForEach-Object { '{0}.md' -f [System.IO.Path]::GetFileNameWithoutExtension($_.Name) }
    ) | Sort-Object -Unique

    $generatedFiles = @(
        Get-ChildItem -Path $tempRoot -Filter '*.md' -File |
        Select-Object -ExpandProperty Name
    ) | Sort-Object -Unique

    $repositoryFiles = @(
        Get-ChildItem -Path $docsRoot -Filter '*.md' -File |
        Where-Object { $_.Name -in $expectedFiles } |
        Select-Object -ExpandProperty Name
    ) | Sort-Object -Unique

    $missingGeneratedFiles = @($expectedFiles | Where-Object { $_ -notin $generatedFiles })
    if ($missingGeneratedFiles.Count -gt 0) {
        throw "platyPS did not generate expected help files: $($missingGeneratedFiles -join ', ')"
    }

    $missingRepositoryFiles = @($expectedFiles | Where-Object { $_ -notin $repositoryFiles })
    $staleRepositoryFiles = @($repositoryFiles | Where-Object { $_ -notin $expectedFiles })
    $driftedFiles = New-Object System.Collections.Generic.List[string]

    foreach ($fileName in $expectedFiles) {
        if ($fileName -notin $repositoryFiles) {
            continue
        }

        $generatedContent = Get-Content -Path (Join-Path -Path $tempRoot -ChildPath $fileName) -Raw
        $repositoryContent = Get-Content -Path (Join-Path -Path $docsRoot -ChildPath $fileName) -Raw

        $normalizedGeneratedContent = Get-NormalizedText -Text $generatedContent
        $normalizedRepositoryContent = Get-NormalizedText -Text $repositoryContent

        if ($normalizedGeneratedContent -cne $normalizedRepositoryContent) {
            [void]$driftedFiles.Add($fileName)
        }
    }

    if ($missingRepositoryFiles.Count -gt 0 -or $staleRepositoryFiles.Count -gt 0 -or $driftedFiles.Count -gt 0) {
        if ($missingRepositoryFiles.Count -gt 0) {
            Write-Host "Missing generated docs in docs/: $($missingRepositoryFiles -join ', ')" -ForegroundColor Yellow
        }

        if ($staleRepositoryFiles.Count -gt 0) {
            Write-Host "Stale generated docs in docs/: $($staleRepositoryFiles -join ', ')" -ForegroundColor Yellow
        }

        if ($driftedFiles.Count -gt 0) {
            Write-Host "Out-of-date generated docs: $($driftedFiles -join ', ')" -ForegroundColor Yellow
        }

        throw 'Generated markdown help is stale. Run ./docs/UpdateDocs.ps1 and commit the updated files.'
    }

    Write-Host 'Generated markdown help is in sync.'
}
finally {
    if (Test-Path -Path $tempRoot) {
        Remove-Item -Path $tempRoot -Recurse -Force
    }
}

