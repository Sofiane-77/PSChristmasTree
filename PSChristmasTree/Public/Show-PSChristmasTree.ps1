<#
 .Synopsis
	Display an animated Christmas tree.

 .Description
	Displays an animated Christmas tree with configurable colors, ornament-pattern illumination, messages,
	and audio.

	Effective configuration is resolved in this order:
	1. Runtime parameters passed to this command.
	2. Saved user configuration from Set-PSChristmasTreeConfig.
	3. Built-in defaults.

 .Parameter AnimationLoopNumber
	Number of animation loops.

  .Parameter AnimationSpeed
	Time in milliseconds to show each frame.

  .Parameter Colors
	Compatibility palette override. Equivalent to setting Palette.

	.Parameter ColorMode
	Color behavior mode: Multicolor, Single, or Palette.

	.Parameter SingleColor
	Single console color used when ColorMode is Single.

	.Parameter Palette
	Color list used when ColorMode is Palette.

  .Parameter Decorations
	Hashtable mapping existing ornament symbols/patterns in the ASCII tree to their display color.

	.Parameter DecorationMode
	Ornament-pattern illumination strategy: Default or Custom.

	.Parameter IncludeDefaultDecorations
	Merge built-in ornament-pattern colors with custom symbol-pattern colors when using custom mode.

  .Parameter PlayCarol
	Number of times to loop the carol.

  .Parameter UICulture
	UI culture used to load localized messages (for example en-US, fr-FR).

	.Parameter TreeStyle
	Tree style: Classic, Minimal, Wide, or Custom.
	Built-in styles include ornament symbol patterns that can be illuminated by decoration mapping.

	.Parameter CustomTreePath
	Path to a custom ASCII tree file used with TreeStyle Custom.

	.Parameter HideCursor
	Hide cursor while rendering.

	.Parameter ShowMessages
	Enable or disable greeting messages.

	.Parameter CustomMessages
	Hashtable of message overrides.

	.Parameter TrunkColor
	Console color used to render the trunk. Useful when using a custom tree where the trunk pattern is unknown and cannot be auto-detected.

 .Example
	 # Show a Christmas tree and play the carol once
   Show-PSChristmasTree -PlayCarol 1

 .Example
	 # Override speed only for this run
	 Show-PSChristmasTree -AnimationSpeed 100

 .Example
	 # Use single-color mode at runtime
	 Show-PSChristmasTree -ColorMode Single -SingleColor Green

 .LINK
	https://github.com/Sofiane-77/PSChristmasTree
#>
function Show-PSChristmasTree() {
	[CmdletBinding()]
	[OutputType([System.void])]
	Param (
		[Parameter(Mandatory = $false, Position = 0)]
		[ValidateRange(1, [int]::MaxValue)]
		[int]$AnimationLoopNumber,

		[Parameter(Mandatory = $false, Position = 1)]
		[ValidateRange(1, [int]::MaxValue)]
		[int]$AnimationSpeed,

		[Parameter(Mandatory = $false, Position = 2)]
		[ValidateNotNullOrEmpty()]
		[array]$Colors,

		[Parameter(Mandatory = $false)]
		[ValidateSet('Multicolor', 'Single', 'Palette')]
		[string]$ColorMode,

		[Parameter(Mandatory = $false)]
		[string]$SingleColor,

		[Parameter(Mandatory = $false)]
		[array]$Palette,

		[Parameter(Mandatory = $false, Position = 3)]
		[ValidateNotNullOrEmpty()]
		[hashtable]$Decorations,

		[Parameter(Mandatory = $false)]
		[ValidateSet('Default', 'Custom')]
		[string]$DecorationMode,

		[Parameter(Mandatory = $false)]
		[bool]$IncludeDefaultDecorations,

		[Parameter(Mandatory = $false, Position = 4)]
		[ValidateRange(0, [int]::MaxValue)]
		[int]$PlayCarol,

		[Parameter(Mandatory = $false, Position = 5)]
		[ValidateNotNullOrEmpty()]
		[string]$UICulture,

		[Parameter(Mandatory = $false)]
		[ValidateSet('Classic', 'Minimal', 'Wide', 'Custom')]
		[string]$TreeStyle,

		[Parameter(Mandatory = $false)]
		[string]$CustomTreePath,

		[Parameter(Mandatory = $false)]
		[bool]$HideCursor,

		[Parameter(Mandatory = $false)]
		[bool]$ShowMessages,

		[Parameter(Mandatory = $false)]
		[hashtable]$CustomMessages,

		[Parameter(Mandatory = $false)]
		[ValidateSet('Black', 'DarkBlue', 'DarkGreen', 'DarkCyan', 'DarkRed', 'DarkMagenta', 'DarkYellow', 'Gray', 'DarkGray', 'Blue', 'Green', 'Cyan', 'Red', 'Magenta', 'Yellow', 'White', 'Random')]
		[string]$TrunkColor
	)

	if ($PSBoundParameters.ContainsKey('CustomTreePath') -and -not [string]::IsNullOrEmpty($CustomTreePath) -and -not (Test-Path -Path $CustomTreePath -PathType Leaf)) {
		Write-Error "Custom tree file not found: $CustomTreePath"
		return
	}

	try {
		$savedConfig = Read-PSChristmasTreeConfig
		$effectiveConfig = Resolve-PSChristmasTreeEffectiveConfig -SavedConfig $savedConfig -RuntimeOverrides $PSBoundParameters
		$messages = Get-PSChristmasTreeMessageCatalog -UICulture $effectiveConfig['UICulture'] -CustomMessages $effectiveConfig['CustomMessages']

		Invoke-PSChristmasTreeRenderLoop -EffectiveConfig $effectiveConfig -Messages $messages
	}
 catch {
		Write-Error "PSChristmasTree failed to render: $_"
	}
}