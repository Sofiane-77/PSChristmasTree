# PSChristmasTree pre-commit hook logic
# Called by tools/hooks/pre-commit (shell script).
# Runs Pester tests before each commit. Exits 1 if any test fails.
# Skips tests when only docs/, *.md or tools/hooks/ files are staged.

$skipPatterns = @('^docs/', '\.md$', '^tools/hooks/')

$stagedFiles = git diff --cached --name-only
$relevantFiles = $stagedFiles | Where-Object {
    $file = $_
    -not ($skipPatterns | Where-Object { $file -match $_ })
}

if ($relevantFiles.Count -eq 0) {
    Write-Host "`n[pre-commit] Only docs/config files staged — skipping tests.`n" -ForegroundColor DarkGray
    exit 0
}

$projectRoot = git rev-parse --show-toplevel
$testRunner = Join-Path $projectRoot 'tools/Invoke-PSChristmasTreeTests.ps1'

Write-Host "`n[pre-commit] Running Pester tests..." -ForegroundColor Cyan

try {
    & $testRunner -Output Minimal
}
catch {
    Write-Host "`n[pre-commit] Tests failed. Commit aborted." -ForegroundColor Red
    exit 1
}

Write-Host "[pre-commit] All tests passed.`n" -ForegroundColor Green
exit 0
