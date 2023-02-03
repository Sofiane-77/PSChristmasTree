# Reset-PSChristmasTreeConfig

## SYNOPSIS
Remove the saved PSChristmasTree configuration.

## SYNTAX

```
Reset-PSChristmasTreeConfig [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Deletes the PSChristmasTree user configuration file.
After this, Show-PSChristmasTree will fall back to its built-in defaults.

This command supports WhatIf and Confirm.

## EXAMPLES

### EXAMPLE 1
```
Reset-PSChristmasTreeConfig
```

### EXAMPLE 2
```
# Skip the confirmation prompt
Reset-PSChristmasTreeConfig -Confirm:$false
```

## PARAMETERS

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

