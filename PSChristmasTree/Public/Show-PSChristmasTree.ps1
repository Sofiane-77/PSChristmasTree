<#
 .Synopsis
  Display a christmas tree

 .Description
  Returns a christmas tree with decorations that lights up. It has many parameters to customize it

 .Parameter AnimationLoopNumber
  Number of times to loop animation

  .Parameter AnimationSpeed
  Time in milliseconds to show each frame

  .Parameter Colors
  All foreground colors possibilities you want to use (Array)

  .Parameter Decorations
  Hashtable :
	  Key => character you want to animate
	  Value => color you want to display this character

  .Parameter PlayCarol
  Number of times to loop "we wish you a merry christmas" carol

  .Parameter UICulture
  Set the language code in order to get it in locales, if it does not exist in locales, use the default one (en-US)

 .Example
   # Show christmas tree by playing "we wish you a merry christmas" carol once
   Show-PSChristmasTree -PlayCarol 1

 .LINK
	https://github.com/Sofiane-77/PSChristmasTree
#>
function Show-PSChristmasTree() {
    [CmdletBinding()]
	[OutputType([System.void])]
    Param (
            [Parameter( Mandatory=$false, Position=0 )]
            [ValidateRange(1,[int]::MaxValue)]
            [int]$AnimationLoopNumber=50,

			[Parameter( Mandatory=$false, Position=1 )]
            [ValidateRange(1,[int]::MaxValue)]
            [int]$AnimationSpeed=300,

			[Parameter( Mandatory=$false, Position=2 )]
            [ValidateNotNullOrEmpty()]
            [array]$Colors=@('Black', 'DarkBlue', 'DarkGreen', 'DarkCyan', 'DarkRed', 'DarkMagenta', 'DarkYellow', 'Gray', 'DarkGray', 'Blue', 'Green', 'Cyan', 'Red', 'Magenta', 'Yellow', 'White'),

			[Parameter( Mandatory=$false, Position=3 )]
            [ValidateNotNullOrEmpty()]
            [hashtable]$Decorations=@{},

			[Parameter( Mandatory=$false, Position=4 )]
            [ValidateRange(0,[int]::MaxValue)]
            [int]$PlayCarol=0,

			[Parameter( Mandatory=$false, Position=5 )]
            [ValidateNotNullOrEmpty()]
            [string]$UICulture=(Get-UICulture).Name
    )

    BEGIN {
		# Save current value
		$CurrentColor = Get-ConsoleForegroundColor
		$CurrentBufferSize = Get-BufferSizeWidth
		$CurrentCursorSize = Get-CursorSize

		$ChristmasTree = Get-ChristmasTree
		$ChristmasDecorations = @{
			'O' = 'random';
			"$($ChristmasTree.trunk)" = 'red';
		} # See the comment for the decorations parameter
		$ChristmasDecorations = Merge-Hashtable $ChristmasDecorations $Decorations

		$ChristmasTree.tree = Get-CenteredText -Text $ChristmasTree.tree # Center in terminal
		$ChristmasTree.tree = Add-DecorationTag -Text $ChristmasTree.tree -Decorations $ChristmasDecorations

		$Messages = Import-LocalizedData -BaseDirectory (Join-Path -Path $PSScriptRoot -ChildPath "../locales") -FileName "Messages.psd1" -UICulture $UICulture	-ErrorAction:SilentlyContinue
		$Messages.MerryChristmas.Text = $Messages.MerryChristmas.Text.ToUpper();
		$Messages.MessageForDevelopers.Text = $Messages.MessageForDevelopers.Text.replace("{1}", (Get-NewYear));
		$Messages.HappyNewYear.Text = $Messages.HappyNewYear.Text.ToUpper();

		Hide-CursorSize
    }

    PROCESS {
		Invoke-Carol $PlayCarol

		$i = 0
		do {

			if ($CurrentBufferSize -ine (Get-BufferSizeWidth)) {

				$ChristmasTree.tree = Get-CenteredText -Text (Get-ChristmasTree).tree # Re-center the original tree

				$ChristmasTree.tree = Add-DecorationTag -Text $ChristmasTree.tree -Decorations $ChristmasDecorations

				$CurrentBufferSize = Get-BufferSizeWidth

				Hide-CursorSize
			}

			Clear-Host

			Write-Host-Colorized -DecoratedText $ChristmasTree.tree -Colors $Colors -DefaultForegroundColor 'Green' # Color of the chrismas tree

			Write-Host (Get-CenteredText -Text $Messages.MerryChristmas.Text) -ForegroundColor ($Messages.MerryChristmas.Colors | Get-Random)

			Write-Host-Colorized (Get-DecoratedFormattedText -FormattedText $Messages.MessageForDevelopers.Text -FormattedValue $Messages.MessageForDevelopers.'{0}' -Centered $true) -Colors $Colors -DefaultForegroundColor $Messages.MessageForDevelopers.Color

			Write-Host (Get-CenteredText -Text $Messages.HappyNewYear.Text) -ForegroundColor ($Messages.HappyNewYear.Colors | Get-Random)

			Start-Sleep -Milliseconds $AnimationSpeed

			$i++

		} until ($i -eq $AnimationLoopNumber)
    }

    END {
        # We dont need to set CursorSize if the value is null
		if (![string]::IsNullOrWhitespace($CurrentCursorSize)) {
			Set-CursorSize $CurrentCursorSize
		}

		Set-ConsoleForegroundColor $CurrentColor
    }
}