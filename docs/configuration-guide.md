# PSChristmasTree Configuration Guide

## Overview

PSChristmasTree now uses a structured configuration model (v3) with explicit domains:

- `Language`
- `Tree`
- `Decorations`
- `Colors`
- `Display`
- `Audio`
- `Messages`

The configuration system is designed for both interactive and scripted usage:

- Interactive users can run a full setup wizard.
- Scripted users can patch specific sections with parameters.
- Runtime parameters in `Show-PSChristmasTree` still override saved values.

## Quick Start

### Interactive Setup Wizard

```powershell
Set-PSChristmasTreeConfig
```

Wizard flow:

1. Language
2. Built-in tree style
3. Optional custom ASCII tree import
4. Ornament-pattern illumination (default or custom)
5. Color behavior (multicolor, single, palette, sensible defaults)
6. Animation and display behavior
7. Sound and message toggles
8. Optional custom messages

Built-in style note:
`Classic`, `Minimal`, and `Wide` all include ornament symbol patterns in their ASCII text so decoration mapping has visible targets.

### Run with Saved Config

```powershell
Show-PSChristmasTree
```

### Inspect Saved Config

```powershell
Get-PSChristmasTreeConfig
```

### Reset Saved Config

```powershell
Reset-PSChristmasTreeConfig -Confirm:$false
```

## Config Schema (v3)

Example persisted JSON:

```json
{
    "ConfigVersion": 3,
    "Language": {
        "UICulture": "fr-FR"
    },
    "Tree": {
        "Style": "Classic",
        "CustomPath": ""
    },
    "Decorations": {
        "Mode": "Default",
        "IncludeDefaults": true,
        "Defaults": {
            "O": "random"
        },
        "Map": {}
    },
    "Colors": {
        "Mode": "Multicolor",
        "SingleColor": "Green",
        "Palette": ["Green", "Red", "Yellow"]
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

### Decorations sub-fields

| Field | Type | Description |
|---|---|---|
| `Mode` | `Default` \| `Custom` | `Default` uses the built-in `Defaults` map only (and always clears `Map`). `Custom` uses `Map`, optionally merged with `Defaults` when `IncludeDefaults` is `true`. |
| `Defaults` | hashtable | Built-in symbol-to-color map applied in both modes. Default: `{ 'O': 'random' }`. The trunk is automatically colored `Red` at render time regardless of its exact pattern — no need to declare it here. |
| `Map` | hashtable | User-defined symbol-to-color map. Only active when `Mode` is `Custom`. Always empty when `Mode` is `Default`. |
| `IncludeDefaults` | boolean | When `true` and `Mode` is `Custom`, `Defaults` is merged into `Map`. |

> **Note:** Decorations do not add new symbols to the tree. They map colors to ornament patterns already present in the ASCII art.

> **Trunk color:** The trunk is automatically colored `Red` by default for all built-in styles and custom trees alike. Override it at runtime with `-TrunkColor`, or add the exact trunk pattern to your custom `Map` to override it persistently.

### Color mode palette behavior

The effective `Palette` used for rendering is derived from `Mode`:

| `Mode` | Effective palette |
|---|---|
| `Multicolor` | All 16 .NET `ConsoleColor` values |
| `Single` | `[ SingleColor ]` only |
| `Palette` | Provided values; falls back to all 16 colors if the list is empty |

### CustomMessages valid keys

The `Custom` object inside `Messages` accepts only these four keys:

| Key | Description |
|---|---|
| `MerryChristmas` | Main greeting displayed under the tree |
| `HappyNewYear` | Secondary message |
| `MessageForDevelopers` | Developer-targeted message |
| `CodeWord` | Short code word / tagline |

Any other keys are silently ignored during normalization.

Example:

```powershell
Set-PSChristmasTreeConfig -CustomMessages @{
    MerryChristmas = 'Happy Holidays!'
    HappyNewYear   = 'See you in the new year!'
}
```

## Command Usage

### Scripted Updates

```powershell
Set-PSChristmasTreeConfig -UICulture fr-FR -TreeStyle Wide -AnimationSpeed 120
```

```powershell
Set-PSChristmasTreeConfig -ColorMode Single -SingleColor Green
```

```powershell
Set-PSChristmasTreeConfig -ColorMode Palette -Palette @('Green','Yellow','Red')
```

```powershell
Set-PSChristmasTreeConfig -DecorationMode Custom -Decorations @{ '*' = 'Yellow'; 'i' = 'random' }
```

```powershell
Set-PSChristmasTreeConfig -Config @{
        Display = @{ AnimationLoopNumber = 30; AnimationSpeed = 200 }
        Audio = @{ PlayCarol = 1 }
}
```

### Runtime Overrides

```powershell
Show-PSChristmasTree -AnimationSpeed 80 -ColorMode Single -SingleColor Cyan
```

## Precedence Rules

Resolution order:

1. Explicit runtime parameters (`Show-PSChristmasTree ...`)
2. Saved user config (`Set-PSChristmasTreeConfig`)
3. Built-in defaults (`Get-PSChristmasTreeDefaultConfig`)

## Validation and Recovery

Validation is strict and centralized:

- **Invalid colors are silently filtered.** Any color name that is not a valid `[System.ConsoleColor]` value (or the special keyword `random`) is removed from `Palette`, `Map`, and `Defaults` without a warning. The rest of the list is kept.
- **Invalid ranges fall back to defaults.** `AnimationLoopNumber` and `AnimationSpeed` must be ≥ 1; `PlayCarol` must be ≥ 0.
- **Invalid booleans are normalized.** String values such as `"true"` / `"false"` are parsed; anything unrecognised falls back to the default.
- **Legacy flat schema is auto-migrated.** A config file saved before v3 is detected and remapped in memory — no manual migration required.
- **`DecorationMode: Default` always clears `Map`.** Even if you write values into `Map`, they are discarded at normalize time when `Mode` is `Default`.

If JSON is corrupted or unreadable, config load gracefully warns and runtime falls back to defaults.

## File Location

- Windows: `%APPDATA%\PSChristmasTree\config.json`
- Linux/macOS: `$HOME/.config/PSChristmasTree/config.json`
