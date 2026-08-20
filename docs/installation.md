# Installation

## From PowerShell Gallery (Recommended)

```powershell
Install-Module -Name PSChristmasTree -Scope CurrentUser
Import-Module PSChristmasTree
```

## From Source / GitHub Release

1. Download the [latest release](https://github.com/Sofiane-77/PSChristmasTree/releases/latest) or clone the repository (`git clone https://github.com/Sofiane-77/PSChristmasTree.git`).
2. Extract the `PSChristmasTree` module folder to one of your module paths.
3. Import the module and verify exports:

```powershell
Import-Module ./PSChristmasTree/PSChristmasTree.psd1
Get-Command -Module PSChristmasTree
```

## From Docker

You can run PSChristmasTree completely isolated via Docker:

```shell
docker run -it --rm sofiane77/pschristmastree
```

## Notes

- PowerShell 5.1 or newer is required (PowerShell 7+ recommended).
- On first install from the Gallery, you may need to trust the repository: `Set-PSRepository PSGallery -InstallationPolicy Trusted` depending on your environment policy.
