# Set-PSChristmasTreeConfig

## SYNOPSIS
Save PSChristmasTree display settings.

## SYNTAX

```
Set-PSChristmasTreeConfig [[-AnimationLoopNumber] <Int32>] [[-AnimationSpeed] <Int32>] [[-ColorMode] <String>]
 [[-SingleColor] <String>] [[-Palette] <Array>] [[-Colors] <Array>] [[-Decorations] <Hashtable>]
 [[-DecorationMode] <String>] [[-IncludeDefaultDecorations] <Boolean>] [[-PlayCarol] <Int32>]
 [[-UICulture] <String>] [[-TreeStyle] <String>] [[-CustomTreePath] <String>] [[-HideCursor] <Boolean>]
 [[-ShowMessages] <Boolean>] [[-CustomMessages] <Hashtable>] [[-Config] <Hashtable>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Saves PSChristmasTree display settings to a local user configuration file.
Settings stored here are automatically applied by Show-PSChristmasTree.
Parameters passed explicitly to Show-PSChristmasTree always take precedence over saved settings.

  When called with no parameters, starts a guided interactive setup wizard.
  The wizard offers beginner-friendly language choices (for example English/French),
  with an optional custom locale input for advanced users.
When called with one or more parameters, only those values are updated; all other saved
settings are preserved.

  This command supports WhatIf and Confirm.

## EXAMPLES

### EXAMPLE 1
```
# Start the guided setup wizard
Set-PSChristmasTreeConfig
```

### EXAMPLE 2
```
# Save specific settings without a wizard
Set-PSChristmasTreeConfig -AnimationLoopNumber 10 -PlayCarol 1
```

### EXAMPLE 3
```
# Save custom colors
Set-PSChristmasTreeConfig -Colors @('Green', 'Red', 'Yellow')
```

### EXAMPLE 4
```
# Save custom ornament-pattern colors
Set-PSChristmasTreeConfig -Decorations @{ 'O' = 'Red'; '*' = 'Yellow' }
```

## PARAMETERS

### -AnimationLoopNumber
Number of times to loop the animation

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
Time in milliseconds to show each animation frame

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

### -ColorMode
Color behavior mode.
Valid values: Multicolor, Single, Palette.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Palette
Color palette used when ColorMode is Palette.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Colors
Compatibility alias for palette-style updates.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Decorations
Hashtable mapping existing ornament symbols/patterns in the ASCII tree to display colors.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DecorationMode
Ornament-pattern illumination strategy.
Valid values: Default, Custom.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeDefaultDecorations
Controls whether built-in ornament-pattern colors are merged with custom symbol-pattern colors.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -PlayCarol
Number of times to loop the "We Wish You a Merry Christmas" carol (0 = disabled)

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -UICulture
Language code for localized messages (e.g.
en-US, fr-FR)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TreeStyle
Tree style.
Valid values: Classic, Minimal, Wide, Custom.
  Built-in styles already include ornament symbol patterns that can be illuminated.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CustomTreePath
Path to a custom ASCII tree file when TreeStyle is Custom.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HideCursor
Hides the cursor while rendering when true.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ShowMessages
Enables or disables greeting messages under the tree.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 15
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -CustomMessages
Hashtable of custom message overrides.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 16
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Config
Hashtable patch using the structured v3 schema.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 17
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

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

