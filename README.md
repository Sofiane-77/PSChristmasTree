<!-- markdownlint-disable MD033 MD045 MD009 MD012 -->
<h1 align="center">
  <br />
  <a href="#">
    <img src="https://raw.githubusercontent.com/Sofiane-77/PSChristmasTree/main/logo.svg" alt="PSChristmasTree" width="250" />
    </a>
  <br />
  PSChristmasTree
  <br />
</h1>

<h4 align="center">🎄 An animated Christmas tree for PowerShell 🎄</h4>

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
  <a href="https://github.com/Sofiane-77/PSChristmasTree/actions/workflows/Test.yaml">
    <img alt="Tests" src="https://img.shields.io/github/actions/workflow/status/Sofiane-77/PSChristmasTree/Test.yaml?branch=main&label=tests&style=flat-square" />
  </a>
  <a href="#">
    <img src="https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat-square" />
  </a>
  <a href="https://github.com/Sofiane-77/PSChristmasTree/graphs/commit-activity">
    <img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg?style=flat-square" />
  </a>
  <a href="https://sofiane-77.github.io/PSChristmasTree/">
    <img src="https://img.shields.io/website.svg?down_color=red&down_message=down&up_color=green&up_message=up&url=https://sofiane-77.github.io/PSChristmasTree/" />
  </a>
</div>

<p align="center">
   <a href="https://sofiane-77.github.io/PSChristmasTree/"><strong>Explore the docs »</strong></a>
</p>

<div align="center">
  <a href="#getting-started">Getting Started</a> •
  <a href="#installation">Installation</a> •
  <a href="https://github.com/Sofiane-77/PSChristmasTree/releases/latest">Download</a>
</div>

<div align="center">
  <a href="https://github.com/Sofiane-77/PSChristmasTree/issues/new?assignees=&labels=bug&template=bug_report.md&title=bug%3A+">Report a Bug</a>
  ·
  <a href="https://github.com/Sofiane-77/PSChristmasTree/discussions/categories/ideas-suggestions">Request a Feature</a>
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

<!-- markdownlint-enable MD033 MD045 MD009 MD012 -->


---

<br/>

# 🔥 Why PSChristmasTree?

🧐 Are you a PowerShell user without a Christmas tree? PSChristmasTree is here to solve that problem.

Everyone loves a Christmas tree, but few people can have one and even fewer have a real one.

It all started in December when I wanted to learn PowerShell. I needed a project idea and came across a [streamer](https://www.twitch.tv/topklean) who was writing a Bash script to display a Christmas tree. Building one in PowerShell sounded fun so here we go 🙌

<p align="right">[<a href="#%EF%B8%8F-table-of-contents">Back to ToC</a>]</p>

# 💡 What is PSChristmasTree?

PSChristmasTree is a customizable open-source PowerShell module designed for terminal enthusiasts.

It displays an animated Christmas tree with decorations that light up in all colors (by default).

<div align="center">
    <img src="https://raw.githubusercontent.com/Sofiane-77/PSChristmasTree/main/docs/img/preview.gif">
</div>

PSChristmasTree provides many parameters for customization and is cross-platform including optional playback of "We Wish You a Merry Christmas" during rendering.

<p align="right">[<a href="#%EF%B8%8F-table-of-contents">Back to ToC</a>]</p>

## 🚀 Getting Started

## 💾 Installation

For detailed instructions, see the [Documentation](https://sofiane-77.github.io/PSChristmasTree/installation/).

### From [PowerShell Gallery](https://www.powershellgallery.com/packages/PSChristmasTree/)

```powershell
Install-Module -Name PSChristmasTree
```
> **Note** - PSChristmasTree supports PowerShell 5.0 or newer.

### From Release

Download the [latest release](https://github.com/Sofiane-77/PSChristmasTree/releases/latest), extract it and run:
```powershell
cd path/to/PSChristmasTree
Import-Module (Get-ChildItem -Path . -Filter PSChristmasTree.psd1 -Recurse | Select-Object -First 1 -ExpandProperty FullName)
```
> **Note** - This command finds the extracted manifest and imports it directly.

### From Source

```powershell
git clone https://github.com/Sofiane-77/PSChristmasTree
cd PSChristmasTree
Import-Module ./PSChristmasTree.psd1
```

### From Docker

* Run directly via a Docker image hosted publicly on [DockerHub](https://hub.docker.com/r/sofiane77/pschristmastree):
```shell
docker run -it --rm sofiane77/pschristmastree
```

## 🏗️ Build

All development workflows are consolidated via [InvokeBuild](https://github.com/nightroman/Invoke-Build) (requires PowerShell Core 7.0+). For full guidelines, see our [Contributing Guide](.github/CONTRIBUTING.md).

#### Tests
Pester tests are located in `Tests/`. Run them locally:

```powershell
./tools/Invoke-PSChristmasTreeBuild.ps1 -Task Init,Test
```

#### Formatting and validation

Formatting relies on PSScriptAnalyzer. Check everything before a PR:

```powershell
./tools/Invoke-PSChristmasTreeBuild.ps1 -Task FormatCheck,Analyze,Test,DocsCheck
```

#### Coverage and benchmark

```powershell
./tools/Invoke-PSChristmasTreeBuild.ps1 -Task Coverage,Benchmark
```

#### Docs

Command references are generated via [platyPS](https://github.com/PowerShell/platyPS).

```powershell
./docs/UpdateDocs.ps1 -Verbose
```

## 🔁 Compatibility

| Edition | Minimum Version | Tested Versions | Status |
|---|---|---|---|
| Windows PowerShell | 5.0 | 5.0, 5.1 | ✅ |
| PowerShell Core | 7.0 | 7.2, 7.4, 7.5 | ✅ |

> **Note** - Audio playback (`-PlayCarol`) requires Windows. All other features are cross-platform (Windows, Linux, macOS).

<p align="right">[<a href="#%EF%B8%8F-table-of-contents">Back to ToC</a>]</p>

# 🏇 Usage

If you're here for the first time, we recommend running:

#### Basic

```powershell
Show-PSChristmasTree
```
#### Advanced

```powershell
Show-PSChristmasTree -TreeStyle Wide -ColorMode Palette -Palette Green,Yellow -AnimationSpeed 120

# For the full, always up-to-date parameter list:
Get-Help Show-PSChristmasTree -Full
```

<p align="right">[<a href="#%EF%B8%8F-table-of-contents">Back to ToC</a>]</p>

## 🤝 Contributing and Community

There are many ways you can contribute to PSChristmasTree:

1. Star this repository.
2. Improve the documentation.
3. Recommend the project to others.
4. [Report a confirmed bug](https://github.com/Sofiane-77/PSChristmasTree/issues/new/choose) by opening an issue.
5. [Ask a question, suggest a feature or share your setup](https://github.com/Sofiane-77/PSChristmasTree/discussions) via Discussions.
6. Participate in discussions, review pull requests and verify fixes or new features.
7. Submit your own fixes or features as a pull request.
8. Submit new test cases.

Please read through our [Contributing Guidelines](.github/CONTRIBUTING.md) to learn about our submission process, coding rules and more!

<br/>

![Alt](https://repobeats.axiom.co/api/embed/871207cc75d4af650937b71716aa8be08c0607e1.svg "Repobeats analytics image")

<p align="right">[<a href="#%EF%B8%8F-table-of-contents">Back to ToC</a>]</p>

# ⚖️ Code of Conduct

Help us keep PSChristmasTree open and inclusive. Please read and follow our [Code of Conduct](https://github.com/Sofiane-77/PSChristmasTree/blob/main/.github/CODE_OF_CONDUCT.md). For more information, open a [Discussion](https://github.com/Sofiane-77/PSChristmasTree/discussions) with any additional questions or comments.

<p align="right">[<a href="#%EF%B8%8F-table-of-contents">Back to ToC</a>]</p>

## ❓ Getting Help

See [Support](https://github.com/Sofiane-77/PSChristmasTree/blob/main/.github/SUPPORT.md) for more information.

<p align="right">[<a href="#%EF%B8%8F-table-of-contents">Back to ToC</a>]</p>

## 📜 License

This project is licensed under the **MIT license**. A complete version of the license is available in the [LICENSE](https://github.com/Sofiane-77/PSChristmasTree/blob/main/LICENSE) file in this repository.

<p align="right">[<a href="#%EF%B8%8F-table-of-contents">Back to ToC</a>]</p>
