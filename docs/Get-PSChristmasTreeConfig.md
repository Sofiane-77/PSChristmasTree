# Get-PSChristmasTreeConfig

## SYNOPSIS
Get the saved PSChristmasTree configuration.

## SYNTAX

```
Get-PSChristmasTreeConfig
```

## DESCRIPTION
Reads and returns the saved PSChristmasTree user configuration as a hashtable.

If a configuration file exists, it is validated and normalized before being returned.
All configuration values are guaranteed to be valid for use with Show-PSChristmasTree.

If no configuration has been saved, $null is returned.

The returned hashtable follows the structured configuration schema:
ConfigVersion, Language, Tree, Decorations, Colors, Display, Audio, and Messages.

## EXAMPLES

### EXAMPLE 1
```
# Get the saved configuration
Get-PSChristmasTreeConfig
```

### EXAMPLE 2
```
# Use nested config values in a script
$Config = Get-PSChristmasTreeConfig
if ($Config) {
    $Config['Display']['AnimationSpeed']
}
```

## PARAMETERS

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/Sofiane-77/PSChristmasTree](https://github.com/Sofiane-77/PSChristmasTree)

