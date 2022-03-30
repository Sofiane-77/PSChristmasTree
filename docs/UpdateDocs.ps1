if (Get-Module -ListAvailable -Name platyPS) {
    # platyPS exists so we can continue
    Import-Module PSChristmasTree -Force # re-import module with latest changes
    New-MarkdownHelp -Module PSChristmasTree -OutputFolder "$PSScriptRoot" -Force -NoMetadata
} else {
    Write-Output "platyPS is not installed"
}
