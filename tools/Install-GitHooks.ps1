<#
 .Synopsis
  Install git hooks for PSChristmasTree

 .Description
  Copies the pre-commit hook from tools/hooks/ into .git/hooks/.
  Run this once after cloning the repository.

 .Example
  .\tools\Install-GitHooks.ps1
#>

$ErrorActionPreference = 'Stop'

$projectRoot = Resolve-Path "$PSScriptRoot\.."
$hooksSource = "$PSScriptRoot\hooks"
$hooksTarget = "$projectRoot\.git\hooks"

if (-not (Test-Path $hooksTarget)) {
    Write-Error "No .git/hooks directory found. Are you in a git repository?"
    return
}

foreach ($hook in Get-ChildItem -Path $hooksSource) {
    $dest = Join-Path $hooksTarget $hook.Name
    Copy-Item -Path $hook.FullName -Destination $dest -Force
    Write-Host "Installed hook: $($hook.Name)" -ForegroundColor Green
}

Write-Host "`nGit hooks installed successfully." -ForegroundColor Cyan
