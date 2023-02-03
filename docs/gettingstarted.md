# Getting Started

This page walks you through the most common first steps.

Before continuing, make sure prerequisites and installation are complete:

- [Prerequisites](prerequisites.md)
- [Installation](installation.md)

## 1. Display your first tree

```powershell
Show-PSChristmasTree
```

## 2. Play the carol

```powershell
Show-PSChristmasTree -PlayCarol 1
```

## 3. Tune animation speed and duration

```powershell
Show-PSChristmasTree -AnimationLoopNumber 30 -AnimationSpeed 250
```

- `AnimationLoopNumber`: number of animation loops
- `AnimationSpeed`: frame delay in milliseconds

## 4. Customize colors

Use the shorthand `-Colors` for a quick palette override:

```powershell
Show-PSChristmasTree -Colors @('Blue', 'White', 'Red')
```

> **Note:** `-Colors` automatically sets `ColorMode` to `Palette`. If you want a different color mode, use `-ColorMode` explicitly.

Or use the explicit color model:

```powershell
Show-PSChristmasTree -ColorMode Palette -Palette @('Blue', 'White', 'Red')
```

For a single color:

```powershell
Show-PSChristmasTree -ColorMode Single -SingleColor Cyan
```

Available console colors are documented in [.NET ConsoleColor](https://learn.microsoft.com/dotnet/api/system.consolecolor). Invalid color names are silently filtered out.

## 5. Customize ornament-pattern colors

```powershell
Show-PSChristmasTree -DecorationMode Custom -Decorations @{ 'i' = 'Yellow'; '*' = 'Red' }
```

This maps colors to ornament symbols already present in the ASCII tree text.

## 5b. Change the trunk color

The trunk is automatically rendered in red by default. Override it at runtime:

```powershell
Show-PSChristmasTree -TrunkColor DarkYellow
```

This works with all built-in styles and custom trees alike, regardless of the trunk's exact ASCII pattern.

## 6. Change message language

```powershell
Show-PSChristmasTree -UICulture fr-FR
```

## 7. Save your preferences

```powershell
Set-PSChristmasTreeConfig
```

Run the command with no parameters to open the interactive wizard, then run `Show-PSChristmasTree` with your saved defaults.

```powershell
# Hide the cursor while the tree is displayed
Set-PSChristmasTreeConfig -HideCursor $true
```

```powershell
# Save a color palette persistently
Set-PSChristmasTreeConfig -ColorMode Palette -Palette @('Green', 'Yellow', 'White')
```
