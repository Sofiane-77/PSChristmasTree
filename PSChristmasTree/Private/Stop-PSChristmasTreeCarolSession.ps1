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
    $processState = $Session['ProcessState']
    $Session['Worker'] = $null
    $Session['Runspace'] = $null
    $Session['AsyncResult'] = $null

    if ($null -ne $processState) {
        $process = $null
        $lockTaken = $false
        try {
            [System.Threading.Monitor]::Enter($processState['Sync'])
            $lockTaken = $true
            $processState['Stopping'] = $true
            $process = $processState['Process']
        }
        catch {
            Write-Verbose "Carol process state update failed: $($_.Exception.Message)"
        }
        finally {
            if ($lockTaken) {
                [System.Threading.Monitor]::Exit($processState['Sync'])
            }
        }

        if ($null -ne $process) {
            try {
                if (-not $process.HasExited) {
                    $process.Kill()
                }
            }
            catch {
                Write-Verbose "Carol process termination failed: $($_.Exception.Message)"
            }
        }
    }

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

    if ($null -ne $processState -and $null -ne $processState['Process']) {
        $process = $processState['Process']
        try {
            if (-not $process.HasExited) {
                $process.Kill()
            }
        }
        catch {
            Write-Verbose "Carol process final termination failed: $($_.Exception.Message)"
        }
        try { $process.Close() } catch { Write-Verbose "Carol process close failed: $($_.Exception.Message)" }
        try { $process.Dispose() } catch { Write-Verbose "Carol process disposal failed: $($_.Exception.Message)" }
        $processState['Process'] = $null
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
