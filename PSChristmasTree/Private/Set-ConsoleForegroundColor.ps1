<#
 .Synopsis
  Set foreground color of console

 .Description
  Set foreground color of console

 .Parameter Color
  new value of console foreground color

 .Example
   # Set foreground color to gray
   Set-ConsoleForegroundColor "Gray"
#>
function Set-ConsoleForegroundColor() {
    [CmdletBinding(SupportsShouldProcess)]
    Param (
            [Parameter( Mandatory = $true, Position=0 )]
            [ValidateNotNullOrEmpty()]
            [System.ConsoleColor]$Color
    )

    BEGIN {}

    PROCESS {
        if($PSCmdlet.ShouldProcess('[Console]::ForegroundColor)')){
            [Console]::ForegroundColor = $Color
        }
    }

    END {}
}