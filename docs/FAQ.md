# PSChristmasTree Frequently Asked Questions (FAQ)

Welcome on the PSChristmasTree FAQ page!

This document contains frequently asked questions about PSChristmasTree.

## General questions

**Q: What is PSChristmasTree ?**
A: PSChristmasTree is a set of commands on Windows PowerShell that allows the display and modification of a Christmas tree.

**Q: What can I do with PSChristmasTree ?**
A: The ultimate goal of the module is to give the possibility to create a complete Christmas tree and have fun with it using powershell commands, but for now only the most useful commands are available.
New commands will be added in the future.. 

**Q: Is the module ready for production ?**
A: PSChristmasTree is currently a pre-release version. Although the module is tested before release, please test it yourself before using it in a production environment.
Also, always use the most recent version, as it adds new features and fixes bugs..

**Q: Where can I get the latest version of the module ?**
A: The module is available on the Powershell gallery. It means that you can simply download it with this command:

```Powershell
PS> Install-Module PSChristmasTree -Scope CurrentUser
```

Alternatively, you can download the code directly from the [GitHub repository](https://github.com/Sofiane-77/PSChristmasTree).

**Q: Which version of powershell do I need ?**
A: Powershell 5 is mandatory. The module is build around new features provided by the 5th version of Powershell (Classes...).

**Q: Where can I find help about Unity-Powershell ?**
A: Please read the [Getting Started](gettingstarted.md) page and don't hesitate to open an [issue on GitHub](https://github.com/Sofiane-77/PSChristmasTree/issues)

## Module usage

**Q: How can I use it ?**
A: Use the `Show-PSChristmasTree` command :

```Powershell
PS> Show-PSChristmasTree 
```

**Q: How can I find all available commands ?**
A: Use this powershell command:

```Powershell
PS> Get-Command -Module PSChristmasTree
```

**Q: How can I find help about a specific command ?**
A: Use his powershell command:

```Powershell
PS> Get-Help Show-PSChristmasTree
```
