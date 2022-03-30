<#
 .Synopsis
  Write-Host with color

 .Description
  Display Text with color on host

 .Parameter DecoratedText
  Decorated Text with Add-DecorationTags

 .Parameter Colors
  List of all desired colors

 .Parameter DefaultForegroundColor
  Default text color when no color or decoration is specified

 .Example
   # Display "Hello World!" in white with red o
   Write-Host-Colorized "Hell#red#o# W#red#o#rld!" @('Red') "white"
#>
function Write-Host-Colorized() {
    [CmdletBinding()]
	[OutputType([System.Void])]
    Param (
            [Parameter( Mandatory = $true, Position=0 )]
            [ValidateNotNullOrEmpty()]
            [string]$DecoratedText,

            [Parameter( Mandatory = $true, Position=1 )]
            [ValidateNotNullOrEmpty()]
            [Array]$Colors,

            [Parameter( Mandatory = $true, Position=2)]
            [ValidateNotNullOrEmpty()]
            [string]$DefaultForegroundColor
    )

    BEGIN {
        $currentColor = $DefaultForegroundColor
        $allColors = $Colors + 'Random' # Add random to the list of possible colors
    }

    PROCESS {
        # Iterate through splitted Messages
	    foreach ( $string in $DecoratedText.split('#') ){
		    # If a string between #-Tags is equal to any predefined color, and is equal to the defaultcolor: set current color
		    if ( $allColors -contains $string -and $currentColor -eq $DefaultForegroundColor ){
                # if random chosen, we need to set a real color
                if ($string -ieq 'random') {
                    $string = ($Colors | Get-Random)
                }
			    $currentColor = $string
		    }else{
			    # If string is a output message, than write string with current color (with no line break)
			    Write-Host -nonewline -f $currentColor "$string"
			    # Reset current color
			    $currentColor = $DefaultForegroundColor
		    }
	    }
    }

    END {
    	# Single write-host for the final line break
	    Write-Host
    }
}