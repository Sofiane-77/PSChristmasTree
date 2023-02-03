# PSChristmasTree FAQ

## General

**Q: What is PSChristmasTree?**  
A: A PowerShell module that renders an animated Christmas tree and lets you customize and persist display behavior.

**Q: Where can I install it?**  
A: From [PowerShell Gallery](https://www.powershellgallery.com/packages/PSChristmasTree/) with:

```powershell
Install-Module -Name PSChristmasTree -Scope CurrentUser
```

You can also use the [GitHub repository](https://github.com/Sofiane-77/PSChristmasTree).

**Q: Which PowerShell version is required?**  
A: PowerShell 5.0 or newer.

## Usage

**Q: How do I show the tree?**  
A: Run:

```powershell
Show-PSChristmasTree
```

**Q: How do I list available commands?**  
A: Run:

```powershell
Get-Command -Module PSChristmasTree
```

**Q: How do I persist settings?**  
A: Use:

```powershell
Set-PSChristmasTreeConfig
```

**Q: Where can I learn the configuration model?**  
A: Read the [Configuration Guide](configuration-guide.md).

## Support

- Questions and ideas: [GitHub Discussions](https://github.com/Sofiane-77/PSChristmasTree/discussions)
- Confirmed bugs: [GitHub Issues](https://github.com/Sofiane-77/PSChristmasTree/issues)
