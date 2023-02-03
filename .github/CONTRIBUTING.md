# Contributing to PSChristmasTree

:+1::tada: First off, thanks for taking the time to contribute and to make PSChristmasTree even better than it is today! :tada::+1:

The following is a set of guidelines for contributing to PSChristmasTree which is hosted on GitHub. 

> **Note:** These are mostly guidelines, not rules. Use your best judgment, and feel free to propose changes to this document in a pull request.

#### Table Of Contents

[Code of Conduct](#coc)

[Got a Question or Problem?](#question-problem)

[How Can I Contribute?](#how-can-i-contribute)

  * [Reporting Bugs](#reporting-bugs)
  * [Suggesting Enhancements](#suggesting-enhancements)
  * [How Do I Submit An Issue?](#submit-issue)
  * [How Do I Submit A Pull Request (PR)?](#submit-pr)
  * [Your First Code Contribution](#your-first-code-contribution)
  * [Pull Requests](#pull-requests)

[Styleguides](#styleguides)

  * [Git Commit Messages](#git-commit-messages)
  * [PowerShell Styleguide](#powershell-styleguide)

## <a name="coc"></a> Code of Conduct

This project and everyone participating in it is governed by the [PSChristmasTree Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior to [PSChristmasTree@caramail.com](mailto:PSChristmasTree@caramail.com).

## <a name="question-problem"></a> Got a Question or Problem?

> **Note:** Please don't file an issue to ask a question as we want to keep GitHub issues for bug reports and feature requests. You'll get faster results by using the resources below.

We have an official message board with a detailed FAQ and where the community chimes in with helpful advice if you have questions.

* [Github Discussions](https://github.com/Sofiane-77/PSChristmasTree/discussions)
* [PSChristmasTree FAQ](https://pschristmastree.readthedocs.io/en/latest/FAQ/)

## How Can I Contribute?

### Reporting Bugs

This section guides you through submitting a bug report for PSChristmasTree. Following these guidelines helps maintainers and the community understand your report :pencil:, reproduce the behavior :computer: :computer:, and find related reports :mag_right:.

Before creating bug reports, please check [this list](#before-submitting-a-bug-report) as you might find out that you don't need to create one. When you are creating a bug report, please [include as many details as possible](#how-do-i-submit-a-good-bug-report). Fill out [the required template](https://github.com/Sofiane-77/PSChristmasTree/blob/main/.github/ISSUE_TEMPLATE/bug_report.md), the information it asks for helps us resolve issues faster.

> **Note:** If you find a **Closed** issue that seems like it is the same thing that you're experiencing, open a new issue and include a link to the original issue in the body of your new one.

#### Before Submitting A Bug Report

* **Check the [faq](https://pschristmastree.readthedocs.io/en/latest/FAQ/) and the [discussions](https://github.com/Sofiane-77/PSChristmasTree/discussions)** for a list of common questions and problems.
* **Perform a [cursory search](https://github.com/Sofiane-77/PSChristmasTree/labels/bug)** to see if the problem has already been reported. If it has **and the issue is still open**, add a comment to the existing issue instead of opening a new one.

#### How Do I Submit A (Good) Bug Report?

Bugs are tracked as [GitHub issues](https://guides.github.com/features/issues/). After you find a bug in the source code, create an issue and provide the following information by filling in [the template](https://github.com/Sofiane-77/PSChristmasTree/blob/main/.github/ISSUE_TEMPLATE/bug_report.md).

Explain the problem and include additional details to help maintainers reproduce the problem:

* **Use a clear and descriptive title** for the issue to identify the problem.
* **Describe the exact steps which reproduce the problem** in as many details as possible. For example, which command exactly you used in the terminal, or how you used PSChristmasTree otherwise. When listing steps, **don't just say what you did, but explain how you did it**.
* **Provide specific examples to demonstrate the steps**. Include links to files or GitHub projects, or copy/pasteable snippets, which you use in those examples. If you're providing snippets in the issue, use [Markdown code blocks](https://help.github.com/articles/markdown-basics/#multiple-lines).
* **Describe the behavior you observed after following the steps** and point out what exactly is the problem with that behavior.
* **Explain which behavior you expected to see instead and why.**
* **Include screenshots and animated GIFs** which show you following the described steps and clearly demonstrate the problem.
* **If you're reporting that PSChristmasTree crashed**, include a crash report with a stack trace from the operating system. On macOS, the crash report will be available in `Console.app` under "Diagnostic and usage information" > "User diagnostic reports". Include the crash report in the issue in a [code block](https://help.github.com/articles/markdown-basics/#multiple-lines), a [file attachment](https://help.github.com/articles/file-attachments-on-issues-and-pull-requests/), or put it in a [gist](https://gist.github.com/) and provide link to that gist.
* **If the problem wasn't triggered by a specific action**, describe what you were doing before the problem happened and share more information using the guidelines below.

Provide more context by answering these questions:

* **Did the problem start happening recently** (e.g. after updating to a new version of PSChristmasTree) or was this always a problem?
* If the problem started happening recently, **can you reproduce the problem in an older version of PSChristmasTree?** What's the most recent version in which the problem doesn't happen? You can download older versions of PSChristmasTree from [the releases page](https://github.com/Sofiane-77/PSChristmasTree/releases).
* **Can you reliably reproduce the issue?** If not, provide details about how often the problem happens and under which conditions it normally happens.

Include details about your configuration and environment:

* **Which version of PSChristmasTree are you using?** You can get the exact version by running `Get-InstalledModule -Name "PSChristmasTree"` in your terminal.
* **What's the name and version of the OS you're using**?
* **Are you running PSChristmasTree in a virtual machine?** If so, which VM software are you using and which operating systems and versions are used for the host and the guest?
* **Which keyboard layout are you using?** Are you using a US layout or some other layout?

### Suggesting Enhancements

This section guides you through submitting an enhancement suggestion for PSChristmasTree, including completely new features and minor improvements to existing functionality. Following these guidelines helps maintainers and the community understand your suggestion :pencil: and find related suggestions :mag_right:.

Before creating enhancement suggestions, please check [this list](#before-submitting-an-enhancement-suggestion) as you might find out that you don't need to create one. When you are creating an enhancement suggestion, please [include as many details as possible](#how-do-i-submit-a-good-enhancement-suggestion). Fill in [the template](https://github.com/Sofiane-77/PSChristmasTree/blob/main/.github/ISSUE_TEMPLATE/feature_request.md), including the steps that you imagine you would take if the feature you're requesting existed.

#### Before Submitting An Enhancement Suggestion

* **Perform a [cursory search](https://github.com/Sofiane-77/PSChristmasTree/labels/enhancement)** to see if the enhancement has already been suggested. If it has, add a comment to the existing issue instead of opening a new one.

#### How Do I Submit A (Good) Enhancement Suggestion?

Enhancement suggestions are tracked as [GitHub issues](https://guides.github.com/features/issues/). You can request a new feature by creating an issue and provide the following information:

* **Use a clear and descriptive title** for the issue to identify the suggestion.
* **Provide a step-by-step description of the suggested enhancement** in as many details as possible.
* **Provide specific examples to demonstrate the steps**. Include copy/pasteable snippets which you use in those examples, as [Markdown code blocks](https://help.github.com/articles/markdown-basics/#multiple-lines).
* **Describe the current behavior** and **explain which behavior you expected to see instead** and why.
* **Include screenshots and animated GIFs** which help you demonstrate the steps or point out the part of PSChristmasTree which the suggestion is related to.
* **Specify which version of PSChristmasTree you're using.** You can get the exact version by running `Get-InstalledModule -Name "PSChristmasTree"` in your terminal.
* **Specify the name and version of the OS you're using.**

### <a name="submit-issue"></a>How Do I Submit An Issue?

Before you submit an issue, please search the issue  tracker. An issue for your problem might already exist and the  discussion might inform you of workarounds readily available.

We want to fix all the issues as soon as possible, but  before fixing a bug, we need to reproduce and confirm it. In order to reproduce bugs, we require that you provide a minimal  reproduction. Having a minimal reproducible scenario gives us a wealth of important  information without going back and forth to you with additional  questions.

A minimal reproduction allows us to quickly confirm a bug  (or point out a coding problem) as well as confirm that we are fixing  the right problem.

We require a minimal reproduction to save maintainers'  time and ultimately be able to fix more bugs. Often, developers find coding problems themselves while preparing a  minimal reproduction. We understand that sometimes it might be hard to extract essential bits  of code from a larger codebase but we really need to isolate the problem before we can fix it.

Unfortunately, we are not able to investigate / fix bugs  without a minimal reproduction, so if we don't hear back from you, we  are going to close an issue that doesn't have enough info to be  reproduced.

You can file new issues by selecting from our [new issue templates](https://github.com/angular/angular/issues/new/choose) and filling out the issue template.

### 

### <a name="submit-pr"></a>How Do I Submit A Pull Request (PR)?

Before you submit your Pull Request (PR) consider the following guidelines:

1. Search [GitHub](https://github.com/Sofiane-77/PSChristmasTree/pulls) for an open or closed PR that relates to your submission. You don't want to duplicate existing efforts.

2. Be sure that an issue describes the problem you're fixing, or documents the design for the feature you'd like to add. Discussing the design upfront helps to ensure that we're ready to accept your work.

3. [Fork](https://docs.github.com/en/github/getting-started-with-github/fork-a-repo) the repo.

4. In your forked repository, make your changes in a new git branch:

   ```
   git checkout -b my-fix-branch main
   ```

5. Create your patch, **including appropriate test cases**.

6. Follow our [Styleguides](#powershell-styleguide).

7. Run the full test suite and ensure that all tests pass.

8. Commit your changes using a descriptive commit message that follows our [commit message conventions](#git-commit-messages). Adherence to these conventions is necessary because release notes are automatically generated from these messages.

   ```
   git commit --all
   ```

   Note: the optional commit `-a` command line option will automatically "add" and "rm" edited files.

9. Push your branch to GitHub:

   ```
   git push origin my-fix-branch
   ```

10. In GitHub, send a pull request to `PSChristmasTree:main`.

### 

### Reviewing a Pull Request

The PSChristmasTree team reserves the right not to accept pull  requests from community members who haven't been good citizens of the community. Such behavior includes not following the [code of conduct](CODE_OF_CONDUCT.md) and applies within or outside of PSChristmasTree managed channels.

#### 

#### Addressing review feedback

If we ask for changes via code reviews then:

1. Make the required updates to the code.

2. Re-run the test suites to ensure tests are still passing.

3. Create a fixup commit and push to your GitHub repository (this will update your Pull Request):

   ```
   git commit --all --fixup HEAD
   git push
   ```

That's it! Thank you for your contribution!

##### 

##### Updating the commit message

A reviewer might often suggest changes to a commit message (for example, to add more context for a change or adhere to our [commit message guidelines](#git-commit-messages)). In order to update the commit message of the last commit on your branch:

1. Check out your branch:

   ```
   git checkout my-fix-branch
   ```

2. Amend the last commit and modify the commit message:

   ```
   git commit --amend
   ```

3. Push to your GitHub repository:

   ```
   git push --force-with-lease
   ```

> NOTE:
>  If you need to update the commit message of an earlier commit, you can use `git rebase` in interactive mode. See the [git docs](https://git-scm.com/docs/git-rebase#_interactive_mode) for more details.

#### 

#### After your pull request is merged

After your pull request is merged, you can safely delete your branch and pull the changes from the main (upstream) repository:

- Delete the remote branch on GitHub either through the GitHub web UI or your local shell as follows:

  ```
  git push origin --delete my-fix-branch
  ```

- Check out the main branch:

  ```
  git checkout main -f
  ```

- Delete the local branch:

  ```
  git branch -D my-fix-branch
  ```

- Update your main with the latest upstream version:

  ```
  git pull --ff upstream main
  ```

### Your First Code Contribution

Unsure where to begin contributing to PSChristmasTree? You can start by looking through these `beginner` and `help-wanted` issues:

* [Beginner issues](https://github.com/Sofiane-77/PSChristmasTree/labels/good%20first%20issue) - issues which should only require a few lines of code, and a test or two.
* [Help wanted issues](https://github.com/Sofiane-77/PSChristmasTree/labels/help%20wanted) - issues which should be a bit more involved than `beginner` issues.

Both issue lists are sorted by total number of comments. While not perfect, number of comments is a reasonable proxy for impact a given change will have.

If you want to read about using PSChristmasTree, the [documentation](https://pschristmastree.readthedocs.io/en/latest/) is free and available online. You can find the source to the manual in [docs folder](https://github.com/Sofiane-77/PSChristmasTree/tree/main/docs).

### Pull Requests

The process described here has several goals:

- Maintain PSChristmasTree's quality
- Fix problems that are important to users
- Engage the community in working toward the best possible PSChristmasTree
- Enable a sustainable system for PSChristmasTree's maintainers to review contributions

Please follow these steps to have your contribution considered by the maintainers:

1. Follow all instructions in [the template](https://github.com/Sofiane-77/PSChristmasTree/tree/main/.github/PULL_REQUEST_TEMPLATE.md)
2. Follow the [styleguides](#styleguides)
3. After you submit your pull request, verify that all [status checks](https://help.github.com/articles/about-status-checks/) are passing <details><summary>What if the status checks are failing?</summary>If a status check is failing, and you believe that the failure is unrelated to your change, please leave a comment on the pull request explaining why you believe the failure is unrelated. A maintainer will re-run the status check for you. If we conclude that the failure was a false positive, then we will open an issue to track that problem with our status check suite.</details>

While the prerequisites above must be satisfied prior to having your pull request reviewed, the reviewer(s) may ask you to complete additional design work, tests, or other changes before your pull request can be ultimately accepted.

## Styleguides

### Git Commit Messages

* Use the present tense ("Add feature" not "Added feature")

* Use the imperative mood ("Add new language" not "Adds new language")

* When only changing documentation, include `[ci skip]` in the commit title

* Consider starting the commit message with an applicable emoji:
    * :art: `:art:` when improving the format/structure of the code
    * :zap: `:zap:` when improving performance
    * :non-potable_water: `:non-potable_water:` when plugging memory leaks
    * :memo: `:memo:` when writing docs
    * :penguin: `:penguin:` when fixing something on Linux
    * :apple: `:apple:` when fixing something on macOS
    * :checkered_flag: `:checkered_flag:` when fixing something on Windows
    * :bug: `:bug:` when fixing a bug
    * :fire: `:fire:` when removing code or files
    * :green_heart: `:green_heart:` when fixing the CI build
    * :white_check_mark: `:white_check_mark:` when adding tests
    * :lock: `:lock:` when dealing with security
    * :arrow_up: `:arrow_up:` when upgrading dependencies
    * :arrow_down: `:arrow_down:` when downgrading dependencies
    * :rotating_light: `:rotating_light:` when removing linter warnings
    
    More examples can be found on [gitmoji.dev](https://gitmoji.dev/)

### PowerShell Styleguide

- First, you should consult this [repository](https://github.com/PoshCode/PowerShellPracticeAndStyle) which contains a set of best practices that will help you with all your powershell projects and your use of it in general.

- Avoid platform-dependent code :

  - Use `Environment` class properties.

  - Use the same case with environment variables because they are case-sensitive on MacOS and Linux.

  - Use the same case for hashtable keys because on linux, they are case-sensitive. On Windows and MacOS, they aren’t.

  - Use `[IO.Path]::PathSeparator` for the correct separator of the current operating system.

  - No CIM (Common Information Model)

  - Don’t Use Aliases.

  - Filenames

    - *Reserved filenames* on Windows are `com1`-`com9`, `lpt1`-`lpt9`, `con`, `nul`, `aux` and `prn` (regardless of extension, e.g. `prn.txt` is disallowed)
    - *Reserved characters* on Windows are ? \ / < > ? % | : "  *so avoid where possible*
    - Windows requires you *surround the path with double quotes* e.g. `"c:\my test"` when macOS and Linux require *a backslash before each space* e.g. `/my\ test`

  - File paths

    - Windows uses `\` when macOS and Linux use `/` but PowerShell allow `/` too .

      You can dynamically find out what your platform uses with `[IO.Path]::DirectorySeparatorChar` only when you can’t use `Join-Path`.

  - Line endings

    - Windows uses `CRLF`
    - macOS and Linux use `LF`
    - Git on Windows often has `autocrlf` set which automatically converts between the two
