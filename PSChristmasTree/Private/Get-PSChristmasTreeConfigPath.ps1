<#
 .Synopsis
  Get the PSChristmasTree configuration file path

 .Description
  Returns the full path to the PSChristmasTree user configuration file.
  On Windows the file is located at %APPDATA%\PSChristmasTree\config.json.
  On Linux and macOS it is located at $HOME/.config/PSChristmasTree/config.json.

 .Example
   Get-PSChristmasTreeConfigPath
#>
function Get-PSChristmasTreeConfigPath() {
    if ($env:APPDATA) {
        $ConfigDir = Join-Path -Path $env:APPDATA -ChildPath 'PSChristmasTree'
    }
    else {
        $ConfigDir = Join-Path -Path (Join-Path -Path $HOME -ChildPath '.config') -ChildPath 'PSChristmasTree'
    }

    return Join-Path -Path $ConfigDir -ChildPath 'config.json'
}
