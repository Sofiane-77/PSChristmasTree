# PSChristmasTree Configuration Contract

## Overview

This document specifies the **configuration schema** and **contract** that all configuration sources must adhere to. Understanding this contract is essential for:
- Extending the module
- Building custom configuration stores
- Debugging configuration-related issues
- Maintaining backward compatibility

---

## Configuration Schema (v3)

### Root Structure

```powershell
@{
    ConfigVersion  = [int]      # Currently 3 (required)
    Language       = [hashtable]
    Tree           = [hashtable]
    Decorations    = [hashtable]
    Colors         = [hashtable]
    Display        = [hashtable]
    Audio          = [hashtable]
    Messages       = [hashtable]
}
```

### Language Section

```powershell
Language = @{
    UICulture = [string]  # e.g., "en-US", "fr-FR"
                          # Default: Current system culture
                          # Used for message localization
}
```

**Contract:**
- Must be a non-null hashtable
- `UICulture` must be a valid culture identifier or empty string
- Empty string falls back to system default

### Tree Section

```powershell
Tree = @{
    Style      = [string]  # One of: 'Classic', 'Minimal', 'Wide', 'Custom'
                           # Default: 'Classic'
    CustomPath = [string]  # Path to custom tree ASCII file
                           # Empty if Style != 'Custom'
                           # File must exist and contain ASCII art
}
```

**Contract:**
- `Style` must be one of the four valid styles or falls back to 'Classic'
- `CustomPath` is only meaningful when `Style` is 'Custom'
- Path validation happens at runtime in `Get-ChristmasTree`
- Invalid paths revert to Classic style

### Decorations Section

```powershell
Decorations = @{
    Mode            = [string]     # One of: 'Default', 'Custom'
                                   # Default: 'Default'
    IncludeDefaults = [bool]       # Include built-in decorations with custom ones?
                                   # Default: $true
    Defaults        = [hashtable]  # Symbol => Color mappings (built-in reference)
                                   # @{ 'O' = 'random'; '|___|' = 'Red' }
    Map             = [hashtable]  # User custom symbol => Color mappings
                                   # Example: @{ '*' = 'Yellow'; 'i' = 'Blue' }
}
```

**Contract:**
- `Mode` must be 'Default' or 'Custom'
- `Defaults` is **read-only** reference, never modified by user config
- `Map` contains only valid symbol patterns and valid colors
- Colors can be any valid `[System.ConsoleColor]` name or the keyword `'random'`
- Invalid colors are silently dropped with warnings
- Empty map when `Mode` is 'Default'

### Colors Section

```powershell
Colors = @{
    Mode        = [string]  # One of: 'Multicolor', 'Single', 'Palette'
                            # Default: 'Multicolor'
    SingleColor = [string]  # Console color name (only used in Single mode)
                            # Default: 'Green'
    Palette     = [array]   # Array of valid console colors
                            # Default: All console colors
}
```

**Contract:**
- `Mode` determines which color property is active
- When `Mode` is 'Multicolor': `Palette` = all console colors
- When `Mode` is 'Single': `Palette` = `@(SingleColor)`
- When `Mode` is 'Palette': `Palette` = user-specified colors
- Invalid colors are filtered out
- Empty Palette falls back to all colors
- `SingleColor` must be a valid console color or falls back to 'Green'

### Display Section

```powershell
Display = @{
    AnimationLoopNumber = [int]   # How many frames to render
                                  # Range: 1 to 2147483647
                                  # Default: 50
    AnimationSpeed      = [int]   # Milliseconds per frame
                                  # Range: 1 to 2147483647
                                  # Default: 300
    HideCursor          = [bool]  # Hide blinking cursor during display?
                                  # Default: $true
}
```

**Contract:**
- All values must be positive integers >= 1
- Values < 1 fall back to defaults
- Very large values are accepted (up to int.MaxValue)
- `HideCursor` is boolean (coerced from any input)

### Audio Section

```powershell
Audio = @{
    PlayCarol = [int]  # Number of times to play Christmas carol
                       # 0 = no music
                       # 1+ = repeat count
                       # Default: 0
}
```

**Contract:**
- Must be non-negative integer
- Negative values fall back to 0
- Zero means no music is played
- Positive integers repeat the carol N times

### Messages Section

```powershell
Messages = @{
    Show   = [bool]       # Display greeting messages below tree?
                          # Default: $true
    Custom = [hashtable]  # Custom message overrides
                          # Keys: 'MerryChristmas', 'MessageForDevelopers', 'HappyNewYear', 'CodeWord'
                          # Values: [string]
}
```

**Contract:**
- `Show` is boolean (coerced)
- `Custom` contains only recognized keys (unknown keys ignored)
- Custom message values must be non-empty strings
- Empty strings in Custom are ignored
- Default messages loaded from `locales/Messages.psd1` per UICulture

---

## Configuration Sources & Precedence

Configuration is resolved from three sources in order of precedence:

1. **Runtime Overrides** (highest priority)  
   Parameters passed to `Show-PSChristmasTree`  
   Example: `-AnimationSpeed 100`

2. **Saved Configuration**  
   User configuration file (`$PROFILE\PSChristmasTree\config.json`)  
   Persisted by `Set-PSChristmasTreeConfig`

3. **Built-in Defaults** (lowest priority)  
   From `Get-PSChristmasTreeDefaultConfig`

### Resolution Function

```powershell
$effective = Resolve-PSChristmasTreeEffectiveConfig -SavedConfig $saved -RuntimeOverrides $PSBoundParameters
```

Returns effective configuration with all three levels merged, with runtime overrides taking precedence.

---

## Key Contract Guarantees

### 1. **Complete Structure**  
`ConvertTo-PSChristmasTreeConfig` always returns a **complete, valid v3 structure** with all required sections present.

### 2. **Type Safety**  
Every value is coerced to its declared type:
- Strings are trimmed and validated
- Numbers are validated as integers with range checking
- Booleans are coerced from any type

### 3. **Fallback Behavior**  
Invalid values never cause exceptions; they silently fall back to defaults with optional warnings.

### 4. **Immutability of Defaults**  
`Decorations.Defaults` is read-only reference data never modified by config normalization.

### 5. **Flat Legacy Keys**  
For backward compatibility, `Resolve-PSChristmasTreeEffectiveConfig` also exposes flat keys:
```powershell
$effective['AnimationSpeed']       # Flat key (int)
$effective['Display']['AnimationSpeed']  # Nested key (hashtable)
```

Both always point to the same value (kept in sync).

---

## Configuration File Format (JSON)

The configuration file stored on disk uses v3 nested structure:

```json
{
  "ConfigVersion": 3,
  "Language": {
    "UICulture": "en-US"
  },
  "Tree": {
    "Style": "Classic",
    "CustomPath": ""
  },
  "Decorations": {
    "Mode": "Default",
    "IncludeDefaults": true,
    "Defaults": {
      "O": "random",
      "|___|": "Red"
    },
    "Map": {}
  },
  "Colors": {
    "Mode": "Multicolor",
    "SingleColor": "Green",
    "Palette": [
      "Black", "DarkBlue", "DarkGreen", "DarkCyan", "DarkRed", "DarkMagenta"
    ]
  },
  "Display": {
    "AnimationLoopNumber": 50,
    "AnimationSpeed": 300,
    "HideCursor": true
  },
  "Audio": {
    "PlayCarol": 0
  },
  "Messages": {
    "Show": true,
    "Custom": {}
  }
}
```

**Contract:**
- Must be valid JSON (enforced with error handling)
- Unknown keys are ignored
- Missing keys use defaults
- File corrupted → warning + null return

---

## Extension Points

### Custom Configuration Stores

Implement the config store port (adapter pattern):

```powershell
$store = @{
    Load   = { return $jsonString }
    Save   = { param($jsonString); ... }
    Delete = { return [bool] }
}

Read-PSChristmasTreeConfig -Store $store
```

### Custom Tree Styles

```powershell
$customTree = Get-ChristmasTree -Style Custom -CustomTreePath 'C:\my-tree.txt'
```

### Custom Decoration Maps

```powershell
$config = @{ Decorations = @{ Map = @{ 'O' = 'Red'; '*' = 'Yellow' } } }
```

---

## Migration from Legacy (v1/v2)

Legacy flat format:
```powershell
@{
    AnimationLoopNumber = 10
    TreeStyle           = 'Wide'
    ColorMode           = 'Single'
}
```

**Automatically migrated to v3:**
```powershell
@{
    Display = @{ AnimationLoopNumber = 10 }
    Tree    = @{ Style = 'Wide' }
    Colors  = @{ Mode = 'Single' }
}
```

Migration happens transparently in `ConvertTo-PSChristmasTreeConfig`.

---

## Testing the Contract

### Recommended Test Coverage

1. **Null/Empty Inputs** → All sections handle gracefully
2. **Invalid Values** → Fallback to defaults with warnings
3. **Mixed Valid/Invalid** → Valid parts apply, invalid parts ignored
4. **Boundary Values** → Min/max integers, empty collections
5. **Incomplete Structures** → Missing keys filled with defaults
6. **Round-trip** → Write → Read returns same effective config

### Example Test

```powershell
# Invalid values should be sanitized
$config = ConvertTo-PSChristmasTreeConfig -PartialConfig @{
    Display = @{ AnimationLoopNumber = -5 }
    Colors  = @{ SingleColor = 'NotAColor' }
}

$config['Display']['AnimationLoopNumber'] | Should -Be 50  # Fallback
$config['Colors']['SingleColor'] | Should -Be 'Green'      # Fallback
```

---

## Version History

- **v3** (current): Nested structure with full normalization
- **v2**: Legacy flat structure (auto-migrated)
- **v1**: Initial format (auto-migrated)
