function Start-PSChristmasTreeCarolSession() {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Internal audio lifecycle operation.')]
    [CmdletBinding()]
    [OutputType([hashtable])]
    Param (
        [Parameter(Mandatory = $true)]
        [int]$LoopCount
    )

    if ($LoopCount -le 0) {
        return
    }

    try {
        $platform = Get-PSChristmasTreeCarolPlatform
        if ($platform -eq 'Unsupported') {
            Write-Warning 'Christmas carol playback is unavailable on this platform.'
            return
        }

        $players = @()
        $assetPath = $null
        if ($platform -ne 'Windows') {
            $players = @(Get-PSChristmasTreeCarolPlayerCandidate -Platform $platform)
            $assetPath = Get-PSChristmasTreeCarolAssetPath
            if ($players.Count -eq 0 -or -not (Test-Path -LiteralPath $assetPath -PathType Leaf)) {
                Write-Warning 'Christmas carol playback is unavailable: no player or packaged audio asset was found.'
                return
            }
        }
    }
    catch {
        Write-Warning "Unable to prepare Christmas carol playback: $($_.Exception.Message)"
        return
    }

    $session = @{
        Runspace = $null
        Worker = $null
        AsyncResult = $null
        ProcessState = $null
        Disposed = $false
    }

    try {
        $session['Runspace'] = New-PSChristmasTreeCarolRunspace
        $session['Worker'] = New-PSChristmasTreeCarolWorker
        $session['Worker'].Runspace = $session['Runspace']
        $session['Runspace'].Open()

        if ($platform -eq 'Windows') {
            $score = @(Get-PSChristmasTreeCarol)
            $script = {
                param($repetitions, $carolScore)

                for ($repetition = 0; $repetition -lt $repetitions; $repetition++) {
                    foreach ($note in $carolScore) {
                        [Console]::Beep([int]$note['Frequency'], [int]$note['Duration'])
                        if ($note['Rest'] -gt 0) {
                            Start-Sleep -Milliseconds ([int]$note['Rest'])
                        }
                    }
                }
            }

            $null = $session['Worker'].AddScript($script.ToString()).AddArgument($LoopCount).AddArgument($score)
        }
        else {
            $session['ProcessState'] = [hashtable]::Synchronized(@{
                Sync = New-Object object
                Process = $null
                Stopping = $false
            })
            $script = Get-PSChristmasTreeCarolProcessWorker
            $null = $session['Worker'].AddScript($script.ToString()).AddArgument($LoopCount).AddArgument($assetPath).AddArgument($players).AddArgument($session['ProcessState'])
        }

        $session['AsyncResult'] = $session['Worker'].BeginInvoke()
        return $session
    }
    catch {
        Write-Warning "Unable to start Christmas carol playback: $($_.Exception.Message)"
        Stop-PSChristmasTreeCarolSession -Session $session
    }
}
