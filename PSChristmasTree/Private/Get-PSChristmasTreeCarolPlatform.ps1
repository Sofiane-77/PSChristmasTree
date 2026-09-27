function Get-PSChristmasTreeCarolPlatform() {
    [CmdletBinding()]
    [OutputType([string])]
    Param ()

    if ([Environment]::OSVersion.Platform -eq [PlatformID]::Win32NT) {
        return 'Windows'
    }

    if ([Environment]::OSVersion.Platform -eq [PlatformID]::Unix) {
        if (Test-Path -LiteralPath '/usr/bin/afplay' -PathType Leaf) {
            return 'macOS'
        }

        return 'Linux'
    }

    return 'Unsupported'
}
