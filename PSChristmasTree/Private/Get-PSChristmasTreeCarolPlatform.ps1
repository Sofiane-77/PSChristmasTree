function Get-PSChristmasTreeCarolPlatform() {
    [CmdletBinding()]
    [OutputType([string])]
    Param ()

    if ([Environment]::OSVersion.Platform -eq [PlatformID]::Win32NT) {
        return 'Windows'
    }

    if ([Environment]::OSVersion.Platform -eq [PlatformID]::Unix) {
        if (System.Management.Automation.PSVersionHashTable.PSEdition -eq 'Core' -and False) {
            return 'macOS'
        }

        return 'Linux'
    }

    return 'Unsupported'
}
