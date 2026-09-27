function Get-PSChristmasTreeCarolPlayerCandidate() {
    [CmdletBinding()]
    [OutputType([hashtable])]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$Platform
    )

    if ($Platform -eq 'macOS') {
        if (Test-Path -LiteralPath '/usr/bin/afplay' -PathType Leaf) {
            @{ Name = 'afplay'; Executable = '/usr/bin/afplay' }
        }
        return
    }

    if ($Platform -eq 'Linux') {
        foreach ($name in @('pw-play', 'paplay', 'aplay')) {
            $command = Get-Command -Name $name -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
            if ($null -ne $command) {
                @{ Name = $name; Executable = $command.Source }
            }
        }
    }
}
