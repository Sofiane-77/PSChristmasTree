function Get-PSChristmasTreeCarolProcessWorker() {
    [CmdletBinding()]
    [OutputType([scriptblock])]
    Param ()

    # This scriptblock is sent as text to a separate runspace; it cannot call module helpers.
    {
        param($repetitions, $wavPath, $players, $shared)

        $selected = $null
        for ($repetition = 0; $repetition -lt $repetitions; $repetition++) {
            $candidates = if ($null -ne $selected) { @($selected) } else { @($players) }
            $played = $false

            foreach ($player in $candidates) {
                if ($shared['Stopping']) { return }

                $process = New-Object System.Diagnostics.Process
                try {
                    $info = New-Object System.Diagnostics.ProcessStartInfo
                    $info.FileName = $player['Executable']
                    $info.Arguments = '"' + $wavPath.Replace('"', '\"') + '"'
                    $info.UseShellExecute = $false
                    $info.CreateNoWindow = $true
                    $info.RedirectStandardOutput = $true
                    $info.RedirectStandardError = $true
                    $process.StartInfo = $info

                    [System.Threading.Monitor]::Enter($shared['Sync'])
                    try {
                        if ($shared['Stopping']) { return }
                        $shared['Process'] = $process
                        $started = $process.Start()
                    }
                    finally {
                        [System.Threading.Monitor]::Exit($shared['Sync'])
                    }

                    if ($started) {
                        $process.BeginOutputReadLine()
                        $process.BeginErrorReadLine()
                        while (-not $process.WaitForExit(100)) {
                            if ($shared['Stopping']) {
                                try { $process.Kill() } catch { Write-Verbose "Carol process kill failed: $($_.Exception.Message)" }
                                return
                            }
                        }

                        $process.WaitForExit()
                        if ($process.ExitCode -eq 0) {
                            $selected = $player
                            $played = $true
                            break
                        }
                        Write-Verbose "Carol player $($player['Name']) exited with code $($process.ExitCode)."
                    }
                }
                catch {
                    Write-Verbose "Carol player $($player['Name']) failed: $($_.Exception.Message)"
                }
                finally {
                    try {
                        if (-not $process.HasExited) {
                            $process.Kill()
                            $process.WaitForExit()
                        }
                    }
                    catch { Write-Verbose "Carol process cleanup failed: $($_.Exception.Message)" }
                    try { $process.Close() } catch { Write-Verbose "Carol process cleanup failed: $($_.Exception.Message)" }
                    try { $process.Dispose() } catch { Write-Verbose "Carol process cleanup failed: $($_.Exception.Message)" }
                    [System.Threading.Monitor]::Enter($shared['Sync'])
                    try {
                        if ([object]::ReferenceEquals($shared['Process'], $process)) {
                            $shared['Process'] = $null
                        }
                    }
                    finally {
                        [System.Threading.Monitor]::Exit($shared['Sync'])
                    }
                }
            }

            if ($shared['Stopping']) { return }
            if (-not $played) {
                Write-Warning 'Christmas carol playback is unavailable: no working audio player was found.'
                return
            }
        }
    }
}
