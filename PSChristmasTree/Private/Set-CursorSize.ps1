<#
 .Synopsis
  Set cursor size of terminal

 .Description
  Set cursor size of terminal

 .Parameter Size
  new value of cursor size

 .Example
   # Set cursor size to 10
   Set-CursorSize 10
#>
function Set-CursorSize() {
    [CmdletBinding(SupportsShouldProcess)]
	[OutputType([Bool])]
    Param (
            [Parameter( Mandatory = $true, Position=0 )]
            [ValidateRange(1,100)]
            [int]$Size
    )

    BEGIN {}

    PROCESS {
        if($PSCmdlet.ShouldProcess('[Console]::CursorSize')){
			try{
				[Console]::CursorSize = $Size
				return $true
			}
			catch [System.PlatformNotSupportedException],[System.Management.Automation.SetValueInvocationException] {
				# The cursor size don't have setter on linux and macos
				return $false
			}
        }
    }

    END {}
}