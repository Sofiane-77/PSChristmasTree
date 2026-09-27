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

    if ((Get-PSChristmasTreeCarolPlatform) -ne 'Windows') {
        Write-Warning 'Christmas carol playback is unavailable on this platform.'
        return
    }

    $session = @{
        Runspace = $null
        Worker = $null
        AsyncResult = $null
        Disposed = $false
    }

    try {
        $session['Runspace'] = New-PSChristmasTreeCarolRunspace
        $session['Worker'] = New-PSChristmasTreeCarolWorker
        $session['Worker'].Runspace = $session['Runspace']
        $session['Runspace'].Open()

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
        $session['AsyncResult'] = $session['Worker'].BeginInvoke()
        return $session
    }
    catch {
        Write-Warning "Unable to start Christmas carol playback: $($_.Exception.Message)"
        Stop-PSChristmasTreeCarolSession -Session $session
    }
}
