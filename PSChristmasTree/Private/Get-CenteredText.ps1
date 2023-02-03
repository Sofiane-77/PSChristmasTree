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
            [Parameter( Mandatory = $true, Position=0, ValueFromPipeline=$true )]
            [ValidateNotNullOrEmpty()]
            [string]$Text
    )

    BEGIN {
        $CenteredString = [System.Collections.ArrayList]::new() # Array will contains each line centered
    }

    PROCESS {
        foreach ($line in $Text -split [System.Environment]::NewLine) {
            $line = $line.Trim()
            [void]$CenteredString.Add(("{0}{1}" -f (' ' * (([Math]::Max(0, $Host.UI.RawUI.BufferSize.Width / 2) - [Math]::Floor($line.Length / 2)))), $line))
        }
    }

    END {
        return $CenteredString -Join [System.Environment]::NewLine # Join each line to return a string
    }
}