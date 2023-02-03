<#
 .Synopsis
  Remove the saved PSChristmasTree configuration.

 .Description
  Deletes the PSChristmasTree user configuration file.
  After this, Show-PSChristmasTree will fall back to its built-in defaults.

  This command supports WhatIf and Confirm.

 .Example
   Reset-PSChristmasTreeConfig

 .Example
   # Skip the confirmation prompt
   Reset-PSChristmasTreeConfig -Confirm:$false

 .LINK
   https://github.com/Sofiane-77/PSChristmasTree
#>
function Reset-PSChristmasTreeConfig() {
  [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
  [OutputType([System.Void])]
  Param ()

  $ConfigPath = Get-PSChristmasTreeConfigPath

  if (Test-Path -Path $ConfigPath) {
    if ($PSCmdlet.ShouldProcess($ConfigPath, 'Remove PSChristmasTree configuration')) {
      Remove-Item -Path $ConfigPath -Force
      Write-Verbose 'PSChristmasTree configuration has been reset. Built-in defaults will be used.'
    }
  }
  else {
    Write-Verbose 'No saved configuration found. Nothing to reset.'
  }
}
