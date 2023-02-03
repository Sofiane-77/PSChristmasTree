<#
 .Synopsis
  Buffer size width of terminal

 .Description
  Return BufferSize of terminal
#>
function Get-BufferSizeWidth() {
    return $Host.UI.RawUI.BufferSize.Width
}