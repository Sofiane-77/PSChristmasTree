<#
 .Synopsis
  Get the saved PSChristmasTree configuration.

 .Description
  Reads and returns the saved PSChristmasTree user configuration as a hashtable.

  If a configuration file exists, it is validated and normalized before being returned.
  All configuration values are guaranteed to be valid for use with Show-PSChristmasTree.

  If no configuration has been saved, $null is returned.

  The returned hashtable follows the structured configuration schema:
  ConfigVersion, Language, Tree, Decorations, Colors, Display, Audio, and Messages.

 .Example
   # Get the saved configuration
   Get-PSChristmasTreeConfig

 .Example
   # Use nested config values in a script
   $Config = Get-PSChristmasTreeConfig
   if ($Config) {
       $Config['Display']['AnimationSpeed']
   }

 .LINK
   https://github.com/Sofiane-77/PSChristmasTree
#>
function Get-PSChristmasTreeConfig() {
  [CmdletBinding()]
  [OutputType([hashtable])]

  $Config = Read-PSChristmasTreeConfig

  if ($null -eq $Config) {
    Write-Verbose "No saved configuration found. Run 'Set-PSChristmasTreeConfig' to create one."
    return $null
  }

  return $Config
}
