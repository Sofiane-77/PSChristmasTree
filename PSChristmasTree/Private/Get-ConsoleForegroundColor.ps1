<#
 .Synopsis
  Foreground color of console

 .Description
  Foreground color of console
#>
function Get-ConsoleForegroundColor() {
	return [Console]::ForegroundColor
}