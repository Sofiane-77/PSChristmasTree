BeforeDiscovery {
	$moduleName = "PSChristmasTree"
	$PSVersion = $PSVersionTable.PSVersion.Major
}

BeforeAll {
	$moduleName = "PSChristmasTree"
	$projectRoot = Resolve-Path -Path "$PSScriptRoot\.."
	$moduleRoot = Split-Path -Path (Resolve-Path "$projectRoot\*\$moduleName.psd1")

	$Private = @( Get-ChildItem -Path "$moduleRoot\Private\*.ps1" -ErrorAction SilentlyContinue )
	foreach ($import in $Private)
    {
        Try
        {
            . $import.fullname
        }
        Catch
        {
            Write-Error -Message "Failed to import function $($import.fullname): $_"
        }
    }
}

Describe "General project validation: $moduleName" -Tags Build, Unit {

    It "Can be imported cleanly (Module $moduleName)" {
        { Import-Module (Join-Path $moduleRoot "$moduleName.psm1") -Force -ErrorAction Stop } | Should -Not -Throw
    }
}

Describe "Add-DecorationTag PS$PSVersion Integrations tests" {

    Context 'Strict mode' {

        Set-StrictMode -Version latest

        It 'Should decorate text with tags' {
            $Output = Add-DecorationTag "Hello World!" @{'o'='red'}
			$Output | Should -BeOfType [System.String]
            $Output | Should -Be 'Hell#red#o# W#red#o#rld!'
        }
    }
}

Describe "Get-BufferSizeWidth PS$PSVersion Integrations tests" {

    Context 'Strict mode' {

        Set-StrictMode -Version latest

        It 'Should get width of buffer size' {
            $Output = (Get-BufferSizeWidth)
			$Output | Should -Not -BeNullOrEmpty
			$Output -ge 0
        }
    }
}

Describe "Get-CenteredText PS$PSVersion Integrations tests" {

    Context 'Strict mode' {

        Set-StrictMode -Version latest

        It 'Should get text centered' {
            $Output = (Get-CenteredText "test")
			$Output | Should -Not -BeNullOrEmpty
			$Output | Should -BeOfType [System.String]
			$Output | Should -BeLike " *"
        }
    }
}

Describe "Get-ChristmasTree PS$PSVersion Integrations tests" {

    Context 'Strict mode' {

        Set-StrictMode -Version latest

        It 'Should get christmas tree' {
            $Output = Get-ChristmasTree
			$Output | Should -Not -BeNullOrEmpty
			$Output | Should -BeOfType [System.Collections.Hashtable]
        }
    }
}

Describe "Get-ConsoleForegroundColor PS$PSVersion Integrations tests" {

    Context 'Strict mode' {

        Set-StrictMode -Version latest

        It 'Should get console foreground color' {
            $Output = (Get-ConsoleForegroundColor)
			$Output | Should -Not -BeNullOrEmpty
			$Output | Should -BeOfType [System.ConsoleColor]
        }
    }
}

Describe "Get-CursorSize PS$PSVersion Integrations tests" {

    Context 'Strict mode' {

        Set-StrictMode -Version latest

        It 'Should get cursor size' {
            $Output = Get-CursorSize
			$Output | Should -Not -BeNullOrEmpty
			$Output | Should -BeOfType [System.Int32]
			$Output -ge 0
        }
    }
}

Describe "Get-DecoratedFormattedText PS$PSVersion Integrations tests" {

    Context 'Strict mode' {

        Set-StrictMode -Version latest

        It 'Should return a decorated text with tags' {
            $Output = Get-DecoratedFormattedText -FormattedText "Hello {0}!" -FormattedValue "World" -Centered $false
			$Output | Should -Not -BeNullOrEmpty
			$Output | Should -BeOfType [System.String]
			$Output | Should -Be "Hello #random#World#!"
        }
    }
}

Describe "Get-NewYear PS$PSVersion Integrations tests" {

    Context 'Strict mode' {

        Set-StrictMode -Version latest

        It 'Should get the current year or the next one' {
            $Output = Get-NewYear
			$Output | Should -Not -BeNullOrEmpty
			$Output | Should -BeOfType [System.Int32]
			$Output -ge (Get-Date).year
        }
    }
}

Describe "Hide-CursorSize PS$PSVersion Integrations tests" {

    Context 'Strict mode' {

        Set-StrictMode -Version latest

        It 'Should change the CursorSize to 1' {
			# Get current cursor size
			$CurrentCursorSize = Get-CursorSize
			# Test Hide-CursorSize
            if (Hide-CursorSize) {
				$CursorSize = Get-CursorSize
				$CursorSize | Should -Not -BeNullOrEmpty
				$CursorSize | Should -BeOfType [System.Int32]
				$CursorSize | Should -Be 1 # 1 is the min value
				# Restore the current size of cursor
				Set-CursorSize $CurrentCursorSize
			}
        }
    }
}

Describe "Invoke-Carol PS$PSVersion Integrations tests" {

    Context 'Strict mode' {

        Set-StrictMode -Version latest

        It 'Should invoke carol' {
			try {
				Invoke-Carol 0
			}
			catch {
			  Throw $_
			}
        }
    }
}

Describe "Merge-Hashtable PS$PSVersion Integrations tests" {

    Context 'Strict mode' {

        Set-StrictMode -Version latest

        It 'Should merge hashtables into one' {
            $Output = Merge-Hashtable @{a=1; c=2} @{a=2; b=5}
			$Expected = @{a=2; b=5; c=2;}
			$Output | Should -Not -BeNullOrEmpty
			$Output | Should -BeOfType [System.Collections.Hashtable]
			$Output.Keys | Should -HaveCount $Expected.Keys.Count
			$Output.Keys | ForEach-Object {
				$Output[$_] | Should -Be $Expected[$_]
			}
        }
    }
}

Describe "Remove-DecorationTag PS$PSVersion Integrations tests" {

    Context 'Strict mode' {

        Set-StrictMode -Version latest

        It 'Should remove tags from decorated text' {
            $Output = Remove-DecorationTag "Hell#red#o# W#red#o#rld!" @{'o'='red'}
			$Output | Should -Not -BeNullOrEmpty
			$Output | Should -BeOfType [System.String]
			$Output | Should -Be "Hello World!"
        }
    }
}

Describe "Set-ConsoleForegroundColor PS$PSVersion Integrations tests" {

    Context 'Strict mode' {

        Set-StrictMode -Version latest

        It 'Should change the foreground color of console' {
			# Store the current color
            $CurrentForegroundColor = Get-ConsoleForegroundColor

			Set-ConsoleForegroundColor "Gray"

			# Test Set-ConsoleForegroundColor
			$NewForegroundColor = Get-ConsoleForegroundColor
			$NewForegroundColor | Should -Not -BeNullOrEmpty
			$NewForegroundColor | Should -BeOfType [System.ConsoleColor]
			$NewForegroundColor | Should -Be "Gray"
			# Restore the current color
			Set-ConsoleForegroundColor $CurrentForegroundColor
        }
    }
}

Describe "Set-CursorSize PS$PSVersion Integrations tests" {

    Context 'Strict mode' {

        Set-StrictMode -Version latest

        It 'Should change the cursor size' {
			# Get current cursor size
			$CurrentCursorSize = Get-CursorSize
			# Set cursor size to 5
			if (Set-CursorSize 5) {
				# Test Set-CursorSize
				$NewCursorSize = Get-CursorSize
				$NewCursorSize | Should -Not -BeNullOrEmpty
				$NewCursorSize | Should -BeOfType [System.Int32]
				$NewCursorSize | Should -Be 5

				# Restore the current size of cursor
				Set-CursorSize $CurrentCursorSize # maybe use Console.ResetColor in the futur
			}
        }
    }
}

Describe "Write-Host-Colorized PS$PSVersion Integrations tests" {

    Context 'Strict mode' {

        Set-StrictMode -Version latest

        It 'Should Write-Host with colors' {
			$Output = Write-Host-Colorized "Hell#red#o# W#red#o#rld!" @('Red') "white" 6>&1
			$Output | Should -Not -BeNullOrEmpty
			$Output | Should -BeOfType [System.Management.Automation.InformationRecord]
			[String]$Output | Should -Be 'Hell o  W o rld! '
        }
    }
}