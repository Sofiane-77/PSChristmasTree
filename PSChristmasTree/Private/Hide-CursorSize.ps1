<#
 .Synopsis
  Hide cursor size of terminal

 .Description
  Hide cursor size of terminal

 .Example
   # Hide cursor size
   Hide-CursorSize
#>
function Hide-CursorSize() {
	return Set-CursorSize 1 # Hide the cursor before display the tree
}