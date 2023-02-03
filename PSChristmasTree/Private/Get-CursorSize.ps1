<#
 .Synopsis
  Cursor size

 .Description
  Return cursor size of terminal
#>
function Get-CursorSize() {
	# we tried [Console]::CursorSize but it make exception
    return $HOST.UI.RawUI.CursorSize
}