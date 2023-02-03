# Show-PSChristmasTree

## SYNOPSIS
Display a christmas tree

## SYNTAX

```
Show-PSChristmasTree [[-AnimationLoopNumber] <Int32>] [[-AnimationSpeed] <Int32>] [[-Colors] <Array>]
 [[-Decorations] <Hashtable>] [[-PlayCarol] <Int32>] [[-UICulture] <String>] [<CommonParameters>]
```

## DESCRIPTION
Returns a christmas tree with decorations that lights up.
It has many parameters to customize it

## EXAMPLES

### EXAMPLE 1
```
# Show christmas tree by playing "we wish you a merry christmas" carol once
Show-PSChristmasTree -PlayCarol 1
```

## PARAMETERS

### -AnimationLoopNumber
Number of times to loop animation

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 50
Accept pipeline input: False
Accept wildcard characters: False
```

### -AnimationSpeed
Time in milliseconds to show each frame

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 300
Accept pipeline input: False
Accept wildcard characters: False
```

### -Colors
All foreground colors possibilities you want to use (Array)

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: @('Black', 'DarkBlue', 'DarkGreen', 'DarkCyan', 'DarkRed', 'DarkMagenta', 'DarkYellow', 'Gray', 'DarkGray', 'Blue', 'Green', 'Cyan', 'Red', 'Magenta', 'Yellow', 'White')
Accept pipeline input: False
Accept wildcard characters: False
```

### -Decorations
Hashtable :
 Key =\> character you want to animate
 Value =\> color you want to display this character

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: @{}
Accept pipeline input: False
Accept wildcard characters: False
```

### -PlayCarol
Number of times to loop "we wish you a merry christmas" carol

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
Set the language code in order to get it in locales, if it does not exist in locales, use the default one (en-US)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: (Get-UICulture).Name
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

