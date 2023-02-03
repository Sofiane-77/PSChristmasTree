<#
 .Synopsis
  Play "we wish you a merry christmas"

 .Description
  Play the carol in antoher thread

 .Parameter CarolLoopNumber
  Number of carol repetitions

 .Example
   # Play the carol 1 time
   Invoke-Carol 1
#>
function Invoke-Carol() {
	[CmdletBinding()]
	[OutputType([System.Void])]
	Param (
		[Parameter( Mandatory = $false, Position = 0 )]
		[ValidateRange(0, [int]::MaxValue)]
		[int]$CarolLoopNumber = 1
	)

	BEGIN {
		# We created another thread to be able to play the song AND display the tree
		$Runspace = [runspacefactory]::CreateRunspace()
		$PowerShell = [powershell]::Create()
		$PowerShell.Runspace = $Runspace
		$Runspace.Open()
		$Runspace.SessionStateProxy.SetVariable('CarolLoopNumber', $CarolLoopNumber) # Share parameter to other powershell
	}

	PROCESS {
		if ($CarolLoopNumber -le 0) {
			return
		}

		$PowerShell.AddScript({

				For ($i = 0; $i -lt $CarolLoopNumber; $i++) {
					$Duration = @{
						WHOLE = 1600;
					}
					$Duration.HALF = $Duration.WHOLE / 2;
					$Duration.QUARTER = $Duration.HALF / 2;
					$Duration.EIGHTH = $Duration.QUARTER / 2;
					$Duration.SIXTEENTH = $Duration.EIGHTH / 2;

					# Hashtable where key = note and value = frequency
					$Notes = @{
						A4 = 440;
						B4 = 493.883301256124;
						C5 = 523.251130601197;
						D5 = 587.329535834815;
						E5 = 659.25511382574;
						F5 = 698.456462866008;
						G4 = 391.995435981749;
					}


					[console]::beep($Notes.G4, $Duration.EIGHTH)

					Start-Sleep -m $Duration.SIXTEENTH

					[console]::beep($Notes.C5, $Duration.EIGHTH)

					Start-Sleep -m $Duration.SIXTEENTH

					[console]::beep($Notes.C5, $Duration.EIGHTH)

					[console]::beep($Notes.D5, $Duration.EIGHTH)

					[console]::beep($Notes.C5, $Duration.EIGHTH)

					[console]::beep($Notes.B4, $Duration.EIGHTH)

					[console]::beep($Notes.A4, $Duration.EIGHTH)

					Start-Sleep -m $Duration.SIXTEENTH

					[console]::beep($Notes.A4, $Duration.EIGHTH)

					Start-Sleep -m $Duration.SIXTEENTH

					[console]::beep($Notes.A4, $Duration.EIGHTH)

					Start-Sleep -m $Duration.SIXTEENTH

					[console]::beep($Notes.D5, $Duration.EIGHTH)

					Start-Sleep -m $Duration.SIXTEENTH

					[console]::beep($Notes.D5, $Duration.EIGHTH)

					[console]::beep($Notes.E5, $Duration.EIGHTH)

					[console]::beep($Notes.D5, $Duration.EIGHTH)

					[console]::beep($Notes.C5, $Duration.EIGHTH)

					[console]::beep($Notes.B4, $Duration.EIGHTH)

					Start-Sleep -m $Duration.SIXTEENTH

					[console]::beep($Notes.G4, $Duration.EIGHTH)

					Start-Sleep -m $Duration.SIXTEENTH

					[console]::beep($Notes.G4, $Duration.EIGHTH)

					Start-Sleep -m $Duration.SIXTEENTH

					[console]::beep($Notes.E5, $Duration.EIGHTH)

					Start-Sleep -m $Duration.SIXTEENTH

					[console]::beep($Notes.E5, $Duration.EIGHTH)

					[console]::beep($Notes.F5, $Duration.EIGHTH)

					[console]::beep($Notes.E5, $Duration.EIGHTH)

					[console]::beep($Notes.D5, $Duration.EIGHTH)

					[console]::beep($Notes.C5, $Duration.EIGHTH)

					Start-Sleep -m $Duration.SIXTEENTH

					[console]::beep($Notes.A4, $Duration.EIGHTH)

					Start-Sleep -m $Duration.SIXTEENTH

					[console]::beep($Notes.G4, $Duration.EIGHTH)

					Start-Sleep -m $Duration.SIXTEENTH

					[console]::beep($Notes.A4, $Duration.EIGHTH)

					Start-Sleep -m $Duration.SIXTEENTH

					[console]::beep($Notes.D5, $Duration.EIGHTH)

					Start-Sleep -m $Duration.SIXTEENTH

					[console]::beep($Notes.B4, $Duration.EIGHTH)

					Start-Sleep -m $Duration.SIXTEENTH

					[console]::beep($Notes.C5, $Duration.EIGHTH)
				}
			}) | Out-Null

		try {
			$asyncResult = $PowerShell.BeginInvoke()
			$sourceIdentifier = "PSChristmasTree.Carol.$([guid]::NewGuid().ToString('N'))"

			Register-ObjectEvent -InputObject $PowerShell -EventName InvocationStateChanged -SourceIdentifier $sourceIdentifier -MessageData @{
				Runspace         = $Runspace
				AsyncResult      = $asyncResult
				SourceIdentifier = $sourceIdentifier
			} -Action {
				$state = [string]$event.SourceEventArgs.InvocationStateInfo.State
				if ($state -notin @('Completed', 'Failed', 'Stopped')) {
					return
				}

				$jobData = $event.MessageData
				$psInstance = $event.Sender
				$runspaceInstance = $jobData['Runspace']
				$invocationHandle = $jobData['AsyncResult']

				try {
					if ($null -ne $invocationHandle) {
						$null = $psInstance.EndInvoke($invocationHandle)
					}
				}
				catch {
					Write-Verbose "Invoke-Carol cleanup EndInvoke failed: $($_.Exception.Message)"
				}
				finally {
					try {
						$psInstance.Dispose()
					}
					catch {
						Write-Verbose "Invoke-Carol cleanup PowerShell dispose failed: $($_.Exception.Message)"
					}

					try {
						if ($null -ne $runspaceInstance) {
							if ($runspaceInstance.RunspaceStateInfo.State -ne 'Closed') {
								$runspaceInstance.Close()
							}

							$runspaceInstance.Dispose()
						}
					}
					catch {
						Write-Verbose "Invoke-Carol cleanup runspace dispose failed: $($_.Exception.Message)"
					}

					try {
						Unregister-Event -SourceIdentifier $jobData['SourceIdentifier'] -ErrorAction SilentlyContinue
					}
					catch {
						Write-Verbose "Invoke-Carol cleanup unregister event failed: $($_.Exception.Message)"
					}

					try {
						Remove-Job -Id $eventSubscriber.Id -Force -ErrorAction SilentlyContinue
					}
					catch {
						Write-Verbose "Invoke-Carol cleanup remove event job failed: $($_.Exception.Message)"
					}
				}
			} | Out-Null
		}
		catch {
			try {
				$PowerShell.Dispose()
			}
			catch {
				Write-Verbose "Invoke-Carol startup cleanup PowerShell dispose failed: $($_.Exception.Message)"
			}

			try {
				if ($Runspace.RunspaceStateInfo.State -ne 'Closed') {
					$Runspace.Close()
				}

				$Runspace.Dispose()
			}
			catch {
				Write-Verbose "Invoke-Carol startup cleanup runspace dispose failed: $($_.Exception.Message)"
			}

			Write-Warning "Unable to start Christmas carol playback: $_"
		}
	}

	END {}
}