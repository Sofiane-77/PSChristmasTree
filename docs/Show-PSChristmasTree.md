# Show-PSChristmasTree

## SYNOPSIS
Display an animated Christmas tree.

## SYNTAX

```
Show-PSChristmasTree [[-AnimationLoopNumber] <Int32>] [[-AnimationSpeed] <Int32>] [[-Colors] <Array>]
 [-ColorMode <String>] [-SingleColor <String>] [-Palette <Array>] [[-Decorations] <Hashtable>]
 [-DecorationMode <String>] [-IncludeDefaultDecorations <Boolean>] [[-PlayCarol] <Int32>]
 [[-UICulture] <String>] [-TreeStyle <String>] [-CustomTreePath <String>] [-HideCursor <Boolean>]
 [-ShowMessages <Boolean>] [-CustomMessages <Hashtable>] [-TrunkColor <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Displays an animated Christmas tree with configurable colors, ornament-pattern illumination, messages,
and audio.

Effective configuration is resolved in this order:
1.
Runtime parameters passed to this command.
2.
Saved user configuration from Set-PSChristmasTreeConfig.
3.
Built-in defaults.

## EXAMPLES

### EXAMPLE 1
```
# Show a Christmas tree and play the carol once
 Show-PSChristmasTree -PlayCarol 1
```

### EXAMPLE 2
```
# Override speed only for this run
Show-PSChristmasTree -AnimationSpeed 100
```

### EXAMPLE 3
```
# Use single-color mode at runtime
Show-PSChristmasTree -ColorMode Single -SingleColor Green
```

## PARAMETERS

### -AnimationLoopNumber
Number of animation loops.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -AnimationSpeed
Time in milliseconds to show each frame.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Colors
Compatibility palette override.
Equivalent to setting Palette.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ColorMode
Color behavior mode: Multicolor, Single, or Palette.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SingleColor
Single console color used when ColorMode is Single.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Palette
Color list used when ColorMode is Palette.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Decorations
Hashtable mapping existing ornament symbols/patterns in the ASCII tree to their display color.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DecorationMode
Ornament-pattern illumination strategy: Default or Custom.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeDefaultDecorations
Merge built-in ornament-pattern colors with custom symbol-pattern colors when using custom mode.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -PlayCarol
Number of times to loop the carol.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -UICulture
UI culture used to load localized messages (for example en-US, fr-FR).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TreeStyle
Tree style: Classic, Minimal, Wide, or Custom.
Built-in styles include ornament symbol patterns that can be illuminated by decoration mapping.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CustomTreePath
Path to a custom ASCII tree file used with TreeStyle Custom.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HideCursor
Hide cursor while rendering.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ShowMessages
Enable or disable greeting messages.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -CustomMessages
Hashtable of message overrides.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TrunkColor
Console color used to render the trunk.
Useful when using a custom tree where the trunk pattern is unknown and cannot be auto-detected.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Void
## NOTES

## RELATED LINKS

[https://github.com/Sofiane-77/PSChristmasTree](https://github.com/Sofiane-77/PSChristmasTree)

