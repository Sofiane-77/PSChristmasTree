<#
 .Synopsis
  Decorate formatted text

 .Description
  Returns decorated formatted text

 .Parameter FormattedText
  Formatted Text

 .Parameter FormattedValue
  Value to put inside FormattedText

 .Parameter Centered
  Center Text

 .Example
   # Add decoration for World
   Get-DecoratedFormattedText -FormattedText "Hello {0}!" -FormattedValue "World" -Centered $false
   Result : Hello #random#World#!
#>
function Get-DecoratedFormattedText() {
    [CmdletBinding()]
	[OutputType([String])]
    Param (
            [Parameter( Mandatory = $true, Position=0 )]
            [ValidateNotNullOrEmpty()]
            [string]$FormattedText,

            [Parameter( Mandatory = $true, Position=1 )]
            [ValidateNotNullOrEmpty()]
            [string]$FormattedValue,

            [Parameter( Mandatory = $false, Position=2 )]
            [boolean]$Centered=$false
    )

    BEGIN {
        $Text = ""

        if ($Centered) {
            $FormattedText = (Get-CenteredText -Text ($FormattedText -f $FormattedValue)).Split($FormattedText[0])[0] + $FormattedText
        }
    }

    PROCESS {

        $decorations = @{
            "$FormattedValue" = 'random'
        }

        $Text = Add-DecorationTag -Text $FormattedValue -Decorations $decorations
    }

    END {
        return $FormattedText -f $Text
    }
}