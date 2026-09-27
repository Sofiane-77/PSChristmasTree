function Stop-PSChristmasTreeCarolSession() {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Internal audio lifecycle operation.')]
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [hashtable]$Session
    )

    if ($Session['Disposed']) {
        return
    }

    $Session['Disposed'] = $true
    $worker = $Session['Worker']
    $runspace = $Session['Runspace']
    $result = $Session['AsyncResult']
    $Session['Worker'] = $null
    $Session['Runspace'] = $null
    $Session['AsyncResult'] = $null

    if ($null -ne $worker) {
        try {
            if ($null -ne $result -and -not $result.IsCompleted) {
                $worker.Stop()
            }
        }
        catch {
            Write-Verbose "Carol worker stop failed: $($_.Exception.Message)"
        }

        try {
            if ($null -ne $result) {
                $null = $worker.EndInvoke($result)
            }
        }
        catch {
            Write-Verbose "Carol worker finalization failed: $($_.Exception.Message)"
        }

        try {
            $worker.Dispose()
        }
        catch {
            Write-Verbose "Carol worker disposal failed: $($_.Exception.Message)"
        }
    }

    if ($null -ne $runspace) {
        try {
            if ($runspace.RunspaceStateInfo.State -ne 'Closed') {
                $runspace.Close()
            }
        }
        catch {
            Write-Verbose "Carol runspace close failed: $($_.Exception.Message)"
        }

        try {
            $runspace.Dispose()
        }
        catch {
            Write-Verbose "Carol runspace disposal failed: $($_.Exception.Message)"
        }
    }
}
