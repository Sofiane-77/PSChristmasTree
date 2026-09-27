BeforeAll {
    $moduleRoot = Resolve-Path "$PSScriptRoot/../PSChristmasTree"
    foreach ($file in @(Get-ChildItem "$moduleRoot/Private/*.ps1")) {
        . $file.FullName
    }

    function New-TestCarolRunspace {
        param([string]$FailOn = '')
        $object = [pscustomobject]@{
            Calls = [System.Collections.ArrayList]::new()
            FailOn = $FailOn
            RunspaceStateInfo = [pscustomobject]@{ State = 'BeforeOpen' }
        }
        $object | Add-Member ScriptMethod Open {
            $null = $this.Calls.Add('Open')
            if ($this.FailOn -eq 'Open') { throw 'open failed' }
            $this.RunspaceStateInfo.State = 'Opened'
        }
        $object | Add-Member ScriptMethod Close {
            $null = $this.Calls.Add('Close')
            $this.RunspaceStateInfo.State = 'Closed'
        }
        $object | Add-Member ScriptMethod Dispose { $null = $this.Calls.Add('Dispose') }
        return $object
    }

    function New-TestCarolWorker {
        param([string]$FailOn = '')
        $object = [pscustomobject]@{
            Calls = [System.Collections.ArrayList]::new()
            FailOn = $FailOn
            Runspace = $null
            Result = [pscustomobject]@{ IsCompleted = $false }
        }
        $object | Add-Member ScriptMethod AddScript {
            param($script)
            $null = $this.Calls.Add('AddScript')
            return $this
        }
        $object | Add-Member ScriptMethod AddArgument {
            param($argument)
            $null = $this.Calls.Add('AddArgument')
            return $this
        }
        $object | Add-Member ScriptMethod BeginInvoke {
            $null = $this.Calls.Add('BeginInvoke')
            if ($this.FailOn -eq 'BeginInvoke') { throw 'begin failed' }
            return $this.Result
        }
        $object | Add-Member ScriptMethod EndInvoke {
            param($result)
            $null = $this.Calls.Add('EndInvoke')
            $this.Result.IsCompleted = $true
        }
        $object | Add-Member ScriptMethod Stop {
            $null = $this.Calls.Add('Stop')
            $this.Result.IsCompleted = $true
        }
        $object | Add-Member ScriptMethod Dispose { $null = $this.Calls.Add('Dispose') }
        return $object
    }
}

Describe 'Carol score' -Tag 'Audio' {
    It 'preserves the historical 29 notes and 7.4 second timing' {
        $first = @(Get-PSChristmasTreeCarol)
        $second = @(Get-PSChristmasTreeCarol)
        $first | ConvertTo-Json -Depth 3 | Should -Be ($second | ConvertTo-Json -Depth 3)
        $first.Count | Should -Be 29
        (($first | ForEach-Object { $_['Duration'] + $_['Rest'] } | Measure-Object -Sum).Sum) | Should -Be 7400
        $first[0]['Frequency'] | Should -Be 391.995435981749
        $first[-1]['Frequency'] | Should -Be 523.251130601197
        foreach ($note in $first) {
            $note['Frequency'] | Should -BeGreaterThan 0
            $note['Duration'] | Should -BeGreaterThan 0
            $note['Rest'] | Should -BeGreaterOrEqual 0
        }
    }
}

Describe 'Windows carol session' -Tag 'Audio' {
    BeforeEach {
        $script:runspace = New-TestCarolRunspace
        $script:worker = New-TestCarolWorker
        Mock Get-PSChristmasTreeCarolPlatform { 'Windows' }
        Mock New-PSChristmasTreeCarolRunspace { return $script:runspace }
        Mock New-PSChristmasTreeCarolWorker { return $script:worker }
    }

    It 'allocates nothing when playback is disabled' {
        $session = Start-PSChristmasTreeCarolSession -LoopCount 0
        $session | Should -BeNullOrEmpty
        Assert-MockCalled Get-PSChristmasTreeCarolPlatform -Times 0 -Exactly
        Assert-MockCalled New-PSChristmasTreeCarolRunspace -Times 0 -Exactly
        Assert-MockCalled New-PSChristmasTreeCarolWorker -Times 0 -Exactly
    }

    It 'finalizes and disposes a normally completed session' {
        $session = Start-PSChristmasTreeCarolSession -LoopCount 1
        $session | Should -Not -BeNullOrEmpty
        Wait-PSChristmasTreeCarolSession -Session $session
        Stop-PSChristmasTreeCarolSession -Session $session
        @($script:worker.Calls | Where-Object { $_ -eq 'EndInvoke' }).Count | Should -Be 1
        @($script:worker.Calls | Where-Object { $_ -eq 'Dispose' }).Count | Should -Be 1
        $script:runspace.Calls | Should -Contain 'Close'
        $script:runspace.Calls | Should -Contain 'Dispose'
    }

    It 'stops active playback and disposes resources' {
        $session = Start-PSChristmasTreeCarolSession -LoopCount 3
        Stop-PSChristmasTreeCarolSession -Session $session
        $script:worker.Calls | Should -Contain 'Stop'
        $script:worker.Calls | Should -Contain 'EndInvoke'
        $script:worker.Calls | Should -Contain 'Dispose'
        $script:runspace.Calls | Should -Contain 'Close'
        $script:runspace.Calls | Should -Contain 'Dispose'
    }

    It 'cleans up if runspace creation fails' {
        Mock New-PSChristmasTreeCarolRunspace { throw 'create failed' }
        Start-PSChristmasTreeCarolSession -LoopCount 1 -WarningAction SilentlyContinue | Should -BeNullOrEmpty
        Assert-MockCalled New-PSChristmasTreeCarolWorker -Times 0 -Exactly
    }

    It 'cleans up if opening the runspace fails' {
        $script:runspace.FailOn = 'Open'
        Start-PSChristmasTreeCarolSession -LoopCount 1 -WarningAction SilentlyContinue | Should -BeNullOrEmpty
        $script:worker.Calls | Should -Contain 'Dispose'
        $script:runspace.Calls | Should -Contain 'Dispose'
    }

    It 'cleans up if BeginInvoke fails' {
        $script:worker.FailOn = 'BeginInvoke'
        Start-PSChristmasTreeCarolSession -LoopCount 1 -WarningAction SilentlyContinue | Should -BeNullOrEmpty
        $script:worker.Calls | Should -Contain 'Dispose'
        $script:runspace.Calls | Should -Contain 'Dispose'
    }

    It 'does not reuse resources across sequential sessions' {
        $first = Start-PSChristmasTreeCarolSession -LoopCount 1
        Wait-PSChristmasTreeCarolSession -Session $first
        $firstWorker = $script:worker
        $script:worker = New-TestCarolWorker
        $script:runspace = New-TestCarolRunspace
        $second = Start-PSChristmasTreeCarolSession -LoopCount 1
        Wait-PSChristmasTreeCarolSession -Session $second
        [object]::ReferenceEquals($firstWorker, $script:worker) | Should -BeFalse
        $first['Disposed'] | Should -BeTrue
        $second['Disposed'] | Should -BeTrue
    }
}
