[CmdletBinding()]
param(
    [string]$OutputFolder = $PSScriptRoot,
    [string]$ModuleManifestPath = (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'PSChristmasTree/PSChristmasTree.psd1')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not (Get-Module -ListAvailable -Name platyPS)) {
    throw 'platyPS is not installed. Install it with: Install-Module platyPS -Scope CurrentUser'
}

$resolvedOutputFolder = Resolve-Path -Path (New-Item -Path $OutputFolder -ItemType Directory -Force)
Import-Module -Name $ModuleManifestPath -Force

New-MarkdownHelp -Module PSChristmasTree -OutputFolder $resolvedOutputFolder -Force -NoMetadata
Write-Verbose "Markdown help regenerated in '$resolvedOutputFolder'."
