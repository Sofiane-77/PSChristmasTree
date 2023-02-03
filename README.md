<h1 align="center">
  <br />
  <a href="#">
    <img src="https://raw.githubusercontent.com/Sofiane-77/PSChristmasTree/main/logo.svg" alt="PSChristmasTree" width="250" />
    </a>
  <br />
  PSChristmasTree
  <br />
</h1>

<h4 align="center">🎄 Just a animated Christmas tree on Powershell 🎄</h4>

<div align="center">
  <a href="https://github.com/Sofiane-77/PSChristmasTree/blob/main/LICENSE">
    <img src="https://img.shields.io/github/license/Sofiane-77/PSChristmasTree?style=flat-square" />
  </a>
  <a href="https://github.com/Sofiane-77/PSChristmasTree/releases/latest">
    <img src="https://img.shields.io/github/downloads/Sofiane-77/PSChristmasTree/total.svg?style=flat-square&color=green" />
  </a>
  <a href="https://www.powershellgallery.com/packages/PSChristmasTree/">
   <img alt="PowerShell Gallery" src="https://img.shields.io/powershellgallery/dt/PSChristmasTree?label=PowerShell%20Gallery&style=flat-square" />
  </a>
  <a href="#">
    <img src="https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat-square" />
  </a>
  <a href="https://github.com/Sofiane-77/PSChristmasTree/graphs/commit-activity">
    <img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg?style=flat-square" />
  </a>
  <a href="https://pschristmastree.readthedocs.io/en/latest/">
    <img src="https://img.shields.io/website.svg?down_color=red&down_message=down&up_color=green&up_message=up&url=https://pschristmastree.readthedocs.io" />
  </a>
</div>

<p align="center">
   <a href="https://pschristmastree.readthedocs.io/en/latest/"><strong>Explore the docs »</strong></a>
</p>

<div align="center">
  <a href="#getting-started">Getting Started</a> •
  <a href="#installation">Installation</a> •
  <a href="https://github.com/Sofiane-77/PSChristmasTree/releases/latest">Download</a>
</div>

<div align="center">
  <a href="https://github.com/Sofiane-77/PSChristmasTree/issues/new?assignees=&labels=bug&template=bug_report.md&title=bug%3A+">Report a Bug</a>
  ·
  <a href="https://github.com/Sofiane-77/PSChristmasTree/issues/new?assignees=&labels=enhancement&template=feature_request.md&title=feat%3A+">Request a Feature</a>
  .
  <a href="https://github.com/Sofiane-77/PSChristmasTree/discussions">Ask a Question</a>
</div>
<br />
<div align="center">
  <a href="https://github.com/Sofiane-77/PSChristmasTree/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22">
   <img src="https://img.shields.io/badge/PRs-welcome-ff69b4.svg?style=flat-square" />
  </a> 
  <a href="https://github.com/Sofiane-77">
   <img src="https://img.shields.io/static/v1?label=made%20with%20%E2%9D%A4%20by&message=Sofiane-77&color=ff0000" />
  </a> 
</div>


<details open="open">
  <summary><h2>🗃️ Table of Contents</h2></summary>
  <ol>
    <li>
      <a href="#-why-pschristmastree">Why PSChristmasTree?</a>
    </li>
    <li>
      <a href="#-what-is-pschristmastree">What is PSChristmasTree?</a>
    </li>
    <li>
      <a href="#-getting-started">Getting Started</a>
      <ul>
        <li>
          <a href="#-installation">Installation</a>
          <ul>
            <li><a href="#from-powershell-gallery">From PowerShell Gallery</a></li>
            <li><a href="#from-release">From Release</a></li>
            <li><a href="#from-source">From Source</a></li>
            <li><a href="#from-docker">From Docker</a></li>
          </ul>
        </li>
      </ul>
    </li>
    <li>
      <a href="#-usage">Usage</a>
      <ul>
        <li><a href="#basic">Basic</a></li>
        <li><a href="#advanced">Advanced</a></li>
      </ul>
    </li>
    <li><a href="#-contributing-and-community">Contributing and Community</a></li>
    <li><a href="#%EF%B8%8F-code-of-conduct">Code of Conduct</a></li>
    <li><a href="#-getting-help">Getting Help</a></li>
    <li><a href="#-license">License</a></li>
  </ol>
</details>


---

<br/>

# 🔥 Why PSChristmasTree?

🧐 Are you a Powershell user who does not have a Christmas tree? PSChristmasTree is here to solve this problem.

Everyone loves a Christmas tree, but few people can have one, and even fewer have a real one.

It all started in December, when I wanted to learn Powershell. I needed to come up with an idea for a project and I came across a [streamer](https://www.twitch.tv/topklean)  who was writing a script to display a Christmas tree in Bash. I thought that doing one in Powershell would be fun so here we go 🙌

<p align="right">[<a href="#%EF%B8%8F-table-of-contents">Back to ToC</a>]</p>

# 💡 What is PSChristmasTree?

PSChristmasTree is a customizable and open-source powershell module designed for those who love command lines.

It displays an animated Christmas tree with decorations that light up in all colors (by default).

<div align="center">
    <img src="https://raw.githubusercontent.com/Sofiane-77/PSChristmasTree/main/docs/img/preview.gif">
</div>

PSChristmasTree has many parameters to customize it in addition to being cross-platform, including the "We Wish You a Merry Christmas" song that can be played during the display.

<p align="right">[<a href="#%EF%B8%8F-table-of-contents">Back to ToC</a>]</p>

# 🤸 Getting Started

## 💾 Installation

### From PowerShell Gallery

* Install PSChristmasTree via [PowerShell Gallery](https://www.powershellgallery.com/packages/PSChristmasTree/):

    ```powershell
    Install-Module -Name PSChristmasTree
    ```
    > **Note** - PSChristmasTree supports PowerShell 5.0 and more

### From Release

#### Steps

* Obtain the release
    - Download the [latest release](https://github.com/Sofiane-77/PSChristmasTree/releases/latest)

* Navigate to the extracted directory
    ```powershell
    cd path/to/PSChristmasTree
    ```

* Import the module
    ```powershell
    Import-Module **/PSChristmasTree.psd1
    ```
    > **Note** - If this doesn't work, you have to replace * with the exact folder name, in this case it is the release version.

### From Source

#### Steps
* Obtain the source
    - Clone the repository (needs git)
    ```powershell
    git clone https://github.com/Sofiane-77/PSChristmasTree
    ```
    > **Warning** - Repository ahead. Proceed at your own risk!

* Navigate to the source directory
    ```powershell
    cd path/to/PSChristmasTree
    ```

* Import the module
    ```powershell
    Import-Module **/PSChristmasTree.psd1
    ```

### From Docker

* Run directly via a Docker image hosted publicly on [DockerHub](https://hub.docker.com/r/sofiane77/pschristmastree):

    ```shell
    docker run -it --rm sofiane77/pschristmastree
    ```

Read full installation instructions in the [docs](https://docs.zenml.io/getting-started/installation).

## 🏗️ Build

#### Requirements

* [InvokeBuild module, available on PowerShell Gallery](https://github.com/nightroman/Invoke-Build)
* PowerShell Core 7.0 or greater on Windows/Linux/macOS

#### Tests
Pester Tests are located in `path/to/PSChristmasTree/Tests` folder.

* In the root folder of your local repository, run:

    ```powershell
    Invoke-Build Init, Test
    ```

<p align="right">[<a href="#%EF%B8%8F-table-of-contents">Back to ToC</a>]</p>

# 🏇 Usage

If you're here for the first time, we recommend running:

#### Basic

```powershell
Show-PSChristmasTree
```
#### Advanced

```powershell
Show-PSChristmasTree [[-AnimationLoopNumber] <Int32>] [[-AnimationSpeed] <Int32>] [[-Colors] <Array>]
 [[-Decorations] <Hashtable>] [[-PlayCarol] <Int32>] [[-UICulture] <String>] [<CommonParameters>]
```

<p align="right">[<a href="#%EF%B8%8F-table-of-contents">Back to ToC</a>]</p>

# 🙌 Contributing and Community

There are many ways to contribute:

1. Star this repository.
2. Improving documentation.
3. Recommending the project to others (Spreading the word).
4. Open a new bug report, feature request or just ask a question by opening a new issue [here]( https://github.com/Sofiane-77/PSChristmasTree/issues/new/choose).
5. Participate in the discussions of [issues](https://github.com/Sofiane-77/PSChristmasTree/issues), [pull requests](https://github.com/Sofiane-77/PSChristmasTree/pulls) and verify/test fixes or new features.
6. Submit your own fixes or features as a pull request but please discuss it beforehand in an issue if the change is substantial.
7. Submit test cases.

Read through our [contributing guidelines](https://github.com/Sofiane-77/PSChristmasTree/blob/main/.github/CONTRIBUTING.md) to learn about our submission process, coding rules and more.

<br/>

![Alt](https://repobeats.axiom.co/api/embed/871207cc75d4af650937b71716aa8be08c0607e1.svg "Repobeats analytics image")

<p align="right">[<a href="#%EF%B8%8F-table-of-contents">Back to ToC</a>]</p>

# ⚖️ Code of Conduct

Help us keep PSChristmasTree open and inclusive. Please read and follow our [Code of Conduct](https://github.com/Sofiane-77/PSChristmasTree/blob/main/.github/CODE_OF_CONDUCT.md). For more information, contact [PSChristmasTree@caramail.com](mailto:PSChristmasTree@caramail.com) with any additional questions or comments.

<p align="right">[<a href="#%EF%B8%8F-table-of-contents">Back to ToC</a>]</p>

# 🆘 Getting Help

See [Support](https://github.com/Sofiane-77/PSChristmasTree/blob/main/.github/SUPPORT.md) for more information.

<p align="right">[<a href="#%EF%B8%8F-table-of-contents">Back to ToC</a>]</p>

# 📃 License

This project is licensed under the **MIT license**. A complete version of the license is available in the [LICENSE](https://github.com/Sofiane-77/PSChristmasTree/blob/main/LICENSE) file in this repository.

<p align="right">[<a href="#%EF%B8%8F-table-of-contents">Back to ToC</a>]</p>



Installation
============

### From PowerShell Gallery
```powershell
Install-Module -Name PSChristmasTree
```

#### Supported PowerShell Versions and Platforms

- Windows PowerShell 5.0 or greater
- PowerShell Core 7.0.3 or greater on Windows/Linux/macOS

### From Source

#### Steps
* Obtain the source
    - Download the [latest release](https://github.com/Sofiane-77/PSChristmasTree/releases/latest) OR
    - Clone the repository (needs git)
    ```powershell
    git clone https://github.com/Sofiane-77/PSChristmasTree
    ```
    
* Navigate to the source directory
    ```powershell
    cd path/to/PSChristmasTree
    ```
    
* Import the module

    ```powershell
    Import-Module ./PSChristmasTree/PSChristmasTree.psd1
    ```
    
* Building

    You will need `PowerShell Core 7.0 or greater on Windows/Linux/macOS` to build the module:
    * The default build is for the currently used version of PowerShell
    ```powershell
    Invoke-Build Build
    ```
    
* Rebuild documentation since it gets built automatically only the first time
    ```powershell
    .\build.ps1 -Documentation
    ```
    
* Build all versions (PowerShell v3, v4, v5, and v6) and documentation
    ```powershell
    .\build.ps1 -All
    ```
    
* Import the module
    ```powershell
    Import-Module (Get-ChildItem -Path .\Build\* -Recurse -Include PSChristmasTree.psd1)
    ```

To confirm installation: run `Get-Help Show-PSChristmasTree -Full` in the PowerShell console to get the list of all parameters.



Creating a Release
================

- Update changelog (`changelog.md`) with the new version number and change set. When updating the changelog please follow the same pattern as that of previous change sets (otherwise this may break the next step).
- Import the ReleaseMaker module and execute `New-Release` cmdlet to perform the following actions.
  - Update module manifest (engine/PSScriptAnalyzer.psd1) with the new version number and change set
  - Update the version number in `Engine/Engine.csproj` and `Rules/Rules.csproj`
  - Create a release build in `out/`

```powershell
    PS> Import-Module .\Utils\ReleaseMaker.psm1
    PS> New-Release
```

- Sign the binaries and PowerShell files in the release build and publish the module to [PowerShell Gallery](www.powershellgallery.com).
- Draft a new release on github and tag `main` with the new version number.

[Back to ToC](#table-of-contents)
