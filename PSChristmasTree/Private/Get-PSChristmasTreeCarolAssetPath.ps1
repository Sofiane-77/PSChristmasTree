function Get-PSChristmasTreeCarolAssetPath() {
    [CmdletBinding()]
    [OutputType([string])]
    Param ([string]$ModuleRoot = $PSScriptRoot)

    $moduleRoot = $ModuleRoot
    if ((Split-Path -Path $moduleRoot -Leaf) -eq 'Private') {
        $moduleRoot = Split-Path -Path $moduleRoot -Parent
    }

    Join-Path -Path $moduleRoot -ChildPath 'assets/carol.wav'
}
