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
			}
			catch [System.PlatformNotSupportedException],[System.Management.Automation.SetValueInvocationException] {
                # Cursor size setter is not available on all platforms/hosts.
                Write-Verbose "Set-CursorSize is not supported on this platform/host."
			}
        }
    }

    END {}
}