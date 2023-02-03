[CmdletBinding()]
param(
    [string[]]$Task = @('.'),
    [ValidateSet('Release', 'Debug', '', IgnoreCase = $true)]
    [string]$Configuration = 'Debug',
    [ValidateSet('Major', 'Minor', 'Build', 'Revision', IgnoreCase = $true)]
    [string]$Type = 'Revision',
    [string]$NugetApiKey,
    [switch]$ExportAlias,
    [string]$BuildFile = (Join-Path -Path (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..')) -ChildPath 'PSChristmasTree.build.ps1')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$minimumInvokeBuildVersion = [version]'5.14.23'
$matchingInvokeBuild = Get-Module -ListAvailable -Name InvokeBuild |
    Where-Object { $_.Version -ge $minimumInvokeBuildVersion } |
    Sort-Object Version -Descending |
    Select-Object -First 1

if ($null -eq $matchingInvokeBuild) {
    throw @"
Unsupported InvokeBuild version for local build execution.
PSChristmasTree requires InvokeBuild >= $minimumInvokeBuildVersion.

Install and load the required version:
  Install-Module InvokeBuild -RequiredVersion $minimumInvokeBuildVersion -Scope CurrentUser -Force
  Import-Module InvokeBuild -RequiredVersion $minimumInvokeBuildVersion -Force
"@
}

if (Get-Module -Name InvokeBuild) {
    Remove-Module -Name InvokeBuild -Force
}

Import-Module -Name $matchingInvokeBuild.Path -Force

$invokeBuildParameters = @{
    File          = $BuildFile
    Configuration = $Configuration
    Type          = $Type
    ExportAlias   = $ExportAlias
}

if (-not [string]::IsNullOrWhiteSpace($NugetApiKey)) {
    $invokeBuildParameters.NugetApiKey = $NugetApiKey
}

Invoke-Build $Task @invokeBuildParameters
