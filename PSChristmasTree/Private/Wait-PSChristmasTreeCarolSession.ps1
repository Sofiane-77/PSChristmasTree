function Wait-PSChristmasTreeCarolSession() {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [hashtable]$Session
    )

    if ($Session['Disposed']) {
        return
    }

    try {
        if ($null -ne $Session['AsyncResult'] -and $null -ne $Session['Worker']) {
            $result = $Session['AsyncResult']
            $Session['AsyncResult'] = $null
            $null = $Session['Worker'].EndInvoke($result)
            if ($null -ne $Session['ProcessState']) {
                $warnings = $Session['Worker'].Streams.Warning
                if ($warnings.Count -gt 0) {
                    Write-Warning $warnings[0].Message
                }
            }
        }
    }
    catch {
        Write-Warning "Christmas carol playback failed: $($_.Exception.Message)"
    }
    finally {
        Stop-PSChristmasTreeCarolSession -Session $Session
    }
}
