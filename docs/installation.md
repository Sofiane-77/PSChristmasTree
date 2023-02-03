# Installation

## From PowerShell Gallery (recommended)

```powershell
Install-Module -Name PSChristmasTree -Scope CurrentUser
Import-Module PSChristmasTree
Get-Command -Module PSChristmasTree
```

## Manual installation

1. Download or clone the repository.
2. Extract the `PSChristmasTree` module folder to one of your module paths.
3. Import the module and verify exports:

```powershell
Import-Module PSChristmasTree
Get-Command -Module PSChristmasTree
```

## Notes

- PowerShell 5.0 or newer is required.
- On first install from Gallery, `Set-PSRepository PSGallery -InstallationPolicy Trusted` may be needed depending on your environment policy.
