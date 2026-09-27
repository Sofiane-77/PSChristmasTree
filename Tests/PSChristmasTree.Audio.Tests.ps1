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
    function New-TestCarolProcess {
        param($Attempts, $Outcomes)
        $object = [pscustomobject]@{
            Attempts = $Attempts
            Outcomes = $Outcomes
            Calls = [System.Collections.ArrayList]::new()
            StartInfo = $null
            HasExited = $false
            ExitCode = 0
        }
        $object | Add-Member ScriptMethod Start {
            $null = $this.Attempts.Add($this.StartInfo.FileName)
            $null = $this.Calls.Add('Start')
            $this.ExitCode = [int]$this.Outcomes[$this.StartInfo.FileName]
            $this.HasExited = $true
            return $true
        }
        $object | Add-Member ScriptMethod BeginOutputReadLine {}
        $object | Add-Member ScriptMethod BeginErrorReadLine {}
        $object | Add-Member ScriptMethod WaitForExit {
            param($timeout)
            return $true
        }
        $object | Add-Member ScriptMethod Kill {
            $null = $this.Calls.Add('Kill')
            $this.HasExited = $true
        }
        $object | Add-Member ScriptMethod Close { $null = $this.Calls.Add('Close') }
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

Describe 'Native carol player selection' -Tag 'Audio' {
    It 'returns the built-in macOS player' {
        Mock Test-Path { $true } -ParameterFilter { $LiteralPath -eq '/usr/bin/afplay' }
        $players = @(Get-PSChristmasTreeCarolPlayerCandidate -Platform macOS)
        $players.Count | Should -Be 1
        $players[0]['Executable'] | Should -Be '/usr/bin/afplay'
    }

    It 'discovers Linux candidates in priority order' {
        Mock Get-Command {
            [pscustomobject]@{ Source = "/fake/$Name" }
        }
        $players = @(Get-PSChristmasTreeCarolPlayerCandidate -Platform Linux)
        @($players | ForEach-Object { $_['Name'] }) | Should -Be @('pw-play', 'paplay', 'aplay')
    }
}

Describe 'Native carol process worker' -Tag 'Audio' {
    BeforeEach {
        $script:attempts = [System.Collections.ArrayList]::new()
        $script:outcomes = @{ 'pw-play' = 1; 'paplay' = 0; 'aplay' = 1 }
        $script:processes = [System.Collections.ArrayList]::new()
        Mock New-Object {
            $process = New-TestCarolProcess -Attempts $script:attempts -Outcomes $script:outcomes
            $null = $script:processes.Add($process)
            return $process
        } -ParameterFilter { $TypeName -eq 'System.Diagnostics.Process' }
        Mock New-Object {
            [pscustomobject]@{
                FileName = ''
                Arguments = ''
                UseShellExecute = $true
                CreateNoWindow = $false
                RedirectStandardOutput = $false
                RedirectStandardError = $false
            }
        } -ParameterFilter { $TypeName -eq 'System.Diagnostics.ProcessStartInfo' }
        $script:shared = [hashtable]::Synchronized(@{
            Sync = [object]::new()
            Process = $null
            Stopping = $false
        })
        $script:players = @(
            @{ Name = 'pw-play'; Executable = 'pw-play' },
            @{ Name = 'paplay'; Executable = 'paplay' },
            @{ Name = 'aplay'; Executable = 'aplay' }
        )
    }

    It 'falls back after an execution failure and reuses the successful player' {
        & (Get-PSChristmasTreeCarolProcessWorker) 3 'carol.wav' $script:players $script:shared
        @($script:attempts) | Should -Be @('pw-play', 'paplay', 'paplay', 'paplay')
        foreach ($process in $script:processes) {
            $process.Calls | Should -Contain 'Close'
            $process.Calls | Should -Contain 'Dispose'
        }
        $script:shared['Process'] | Should -BeNullOrEmpty
    }

    It 'stops after all available players fail and warns once' {
        $script:outcomes['paplay'] = 1
        $warnings = @(& (Get-PSChristmasTreeCarolProcessWorker) 3 'carol.wav' $script:players $script:shared 3>&1 | Where-Object { $_ -is [System.Management.Automation.WarningRecord] })
        @($script:attempts) | Should -Be @('pw-play', 'paplay', 'aplay')
        $warnings.Count | Should -Be 1
        $script:shared['Process'] | Should -BeNullOrEmpty
    }

    It 'kills the owned active process on Stop' {
        $process = New-TestCarolProcess -Attempts $script:attempts -Outcomes $script:outcomes
        $script:shared['Process'] = $process
        $session = @{
            Runspace = New-TestCarolRunspace
            Worker = New-TestCarolWorker
            AsyncResult = $null
            ProcessState = $script:shared
            Disposed = $false
        }
        Stop-PSChristmasTreeCarolSession -Session $session
        $process.Calls | Should -Contain 'Kill'
        $process.Calls | Should -Contain 'Close'
        $process.Calls | Should -Contain 'Dispose'
        $session['Disposed'] | Should -BeTrue
        $session['Worker'] | Should -BeNullOrEmpty
    }
}

Describe 'Packaged carol WAV' -Tag 'Audio' {
    It 'is deterministic PCM mono 16-bit at 16000 Hz with score-matched duration' {
        $asset = Get-PSChristmasTreeCarolAssetPath
        Test-Path -LiteralPath $asset -PathType Leaf | Should -BeTrue
        $first = Join-Path $TestDrive 'first.wav'
        $second = Join-Path $TestDrive 'second.wav'
        & "$PSScriptRoot/../tools/New-PSChristmasTreeCarolAsset.ps1" -OutputPath $first
        & "$PSScriptRoot/../tools/New-PSChristmasTreeCarolAsset.ps1" -OutputPath $second
        (Get-FileHash $first).Hash | Should -Be (Get-FileHash $second).Hash
        (Get-FileHash $asset).Hash | Should -Be (Get-FileHash $first).Hash

        $stream = [IO.File]::OpenRead($asset)
        $reader = New-Object IO.BinaryReader($stream)
        try {
            [Text.Encoding]::ASCII.GetString($reader.ReadBytes(4)) | Should -Be 'RIFF'
            $riffLength = $reader.ReadInt32()
            $riffLength + 8 | Should -Be $stream.Length
            [Text.Encoding]::ASCII.GetString($reader.ReadBytes(4)) | Should -Be 'WAVE'
            [Text.Encoding]::ASCII.GetString($reader.ReadBytes(4)) | Should -Be 'fmt '
            $reader.ReadInt32() | Should -Be 16
            $reader.ReadInt16() | Should -Be 1
            $reader.ReadInt16() | Should -Be 1
            $reader.ReadInt32() | Should -Be 16000
            $reader.ReadInt32() | Should -Be 32000
            $reader.ReadInt16() | Should -Be 2
            $reader.ReadInt16() | Should -Be 16
            [Text.Encoding]::ASCII.GetString($reader.ReadBytes(4)) | Should -Be 'data'
            $dataLength = $reader.ReadInt32()
            $dataLength + 44 | Should -Be $stream.Length
            $dataLength / 32000 | Should -Be 7.4
        }
        finally {
            $reader.Dispose()
        }
    }

    It 'resolves an asset inside a built module layout' {
        $root = Join-Path $TestDrive 'module'
        $null = New-Item -Path (Join-Path $root 'assets') -ItemType Directory -Force
        Copy-Item (Get-PSChristmasTreeCarolAssetPath) (Join-Path $root 'assets/carol.wav')
        $resolved = Get-PSChristmasTreeCarolAssetPath -ModuleRoot $root
        Test-Path -LiteralPath $resolved -PathType Leaf | Should -BeTrue
    }
}

Describe 'Native carol session startup' -Tag 'Audio' {
    It 'skips audio infrastructure when no player is available' {
        Mock Get-PSChristmasTreeCarolPlatform { 'Linux' }
        Mock Get-PSChristmasTreeCarolPlayerCandidate {}
        Mock New-PSChristmasTreeCarolRunspace { throw 'runspace must not be created' }
        $session = Start-PSChristmasTreeCarolSession -LoopCount 1 -WarningAction SilentlyContinue
        $session | Should -BeNullOrEmpty
        Assert-MockCalled New-PSChristmasTreeCarolRunspace -Times 0 -Exactly
    }

    It 'reports one failure from an isolated worker and releases its resources' {
        Mock Get-PSChristmasTreeCarolPlatform { 'Linux' }
        Mock Get-PSChristmasTreeCarolPlayerCandidate {
            @{ Name = 'missing'; Executable = 'pschristmastree-player-that-does-not-exist' }
        }
        $session = Start-PSChristmasTreeCarolSession -LoopCount 2
        $session | Should -Not -BeNullOrEmpty
        $warnings = @(Wait-PSChristmasTreeCarolSession -Session $session 3>&1 | Where-Object { $_ -is [System.Management.Automation.WarningRecord] })
        $warnings.Count | Should -Be 1
        $session['Disposed'] | Should -BeTrue
        $session['Worker'] | Should -BeNullOrEmpty
        $session['Runspace'] | Should -BeNullOrEmpty
    }
}
