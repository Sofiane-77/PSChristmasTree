# Installation

### Powershell Gallery (Recommended method)

PSChristmasTree is available on the Powershell Gallery. It can be easily installed from there with some powershell commands.

* Install the module from the gallery
``` Powershell
Install-Module PSChristmasTree -Scope CurrentUser
```

* Import the module in your powershell session
``` Powershell
Import-Module PSChristmasTree
```

* Verify that the module is available by listing all the exported commands
``` Powershell
Get-Command -Module PSChristmasTree
```

### Manual installation

Alternatively you can download the module from GitHub.

* Download the repository
* Unblock the zip
* Extract the PSChristmasTree folder to a module path (e.g. $env:USERPROFILE\Documents\WindowsPowerShell\Modules\)
* Import the module in your powershell session
``` Powershell
Import-Module PSChristmasTree
```
* Verify that the module is available by listing all the exported commands
``` Powershell
Get-Command -Module PSChristmasTree
```
