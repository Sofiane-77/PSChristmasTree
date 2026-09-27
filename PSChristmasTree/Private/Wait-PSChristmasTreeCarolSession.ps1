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
        }
    }
    catch {
        Write-Warning "Christmas carol playback failed: $($_.Exception.Message)"
    }
    finally {
        Stop-PSChristmasTreeCarolSession -Session $Session
    }
}
