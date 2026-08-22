<#
 .Synopsis
  Center a text in console

 .Description
  Returns the text with amount of space needed to be centered on each line

 .Parameter Text
  Text to center

 .Example
   # Center "Hello World!".
   Center-Text "Hello World!"
#>
function Get-CenteredText() {
    [CmdletBinding()]
    [OutputType([String])]
    Param (
        [Parameter( Mandatory = $true, Position = 0, ValueFromPipeline = $true )]
        [ValidateNotNullOrEmpty()]
        [string]$Text
    )

    BEGIN {
        $CenteredString = [System.Collections.ArrayList]::new() # Array will contains each line centered
    }

    PROCESS {
        # Split on any line ending style (CRLF, LF or CR) since here-string source line endings may not match [System.Environment]::NewLine on the current OS
        foreach ($line in $Text -split "`r`n|`r|`n") {
            $line = $line.Trim()
            $bufferWidth = [int]$Host.UI.RawUI.BufferSize.Width
            $leftPadding = [Math]::Max(0, [Math]::Floor(($bufferWidth - $line.Length) / 2))
            [void]$CenteredString.Add(("{0}{1}" -f (' ' * $leftPadding), $line))
        }
    }

    END {
        return $CenteredString -Join "`n" # Join each line to return a string
    }
}