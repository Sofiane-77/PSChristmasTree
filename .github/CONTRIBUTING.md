# Contributing to PSChristmasTree

Thanks for taking the time to contribute.

This document explains how to contribute changes, report bugs, suggest ideas, and work effectively with the project.

## Code of Conduct

This project is governed by the [Code of Conduct](.github/CODE_OF_CONDUCT.md). By participating, you agree to follow it.

## Questions and Ideas

Use GitHub Discussions for anything that is not a confirmed bug:

* Questions and troubleshooting: [Q&A Discussions](https://github.com/Sofiane-77/PSChristmasTree/discussions/categories/q-a)
* Ideas and suggestions: [Ideas and Suggestions](https://github.com/Sofiane-77/PSChristmasTree/discussions/categories/ideas-suggestions)
* General discussion: [GitHub Discussions](https://github.com/Sofiane-77/PSChristmasTree/discussions)
* FAQ: [PSChristmasTree FAQ](https://sofiane-77.github.io/PSChristmasTree/FAQ/)

Please do not open GitHub issues for general questions or feature requests.

## Reporting Bugs

Before opening an issue:

* Confirm the problem on the latest released version.
* Search existing issues and discussions.
* Reduce the problem to a minimal, reproducible example.

When reporting a bug, include:

* A clear and descriptive title.
* Exact reproduction steps.
* Expected behavior.
* Actual behavior.
* Full error output when relevant.
* Your environment details, including PSChristmasTree version, PowerShell version, operating system, and terminal.

Open bug reports here:
[New issue chooser](https://github.com/Sofiane-77/PSChristmasTree/issues/new/choose)

## Suggesting Enhancements

Enhancement ideas are handled through GitHub Discussions, not GitHub Issues.

Before posting an idea:

* Search existing discussions first.
* Explain the problem you want to solve.
* Describe the proposed solution from a user perspective.
* Mention alternatives you considered, if any.

Open idea discussions here:
[Ideas and Suggestions discussion category](https://github.com/Sofiane-77/PSChristmasTree/discussions/categories/ideas-suggestions)

## Submitting Pull Requests

Before opening a pull request:

1. Search existing issues, discussions, and pull requests to avoid duplicate work.
1. Make sure the change has the right prior context:
   Bug fixes should be linked to a bug report.
   Feature changes should be linked to a maintainer-endorsed discussion.
1. Fork the repository.
1. Create a branch for your change.

```bash
git checkout -b my-change-branch main
```

1. Implement the change and add or update tests where appropriate.
1. Run local validation before opening or updating the pull request.

```powershell
./tools/Invoke-PSChristmasTreeBuild.ps1 -Task Init,FormatCheck,Analyze,Test,DocsCheck
```

If you are working on Windows and want to validate the Windows PowerShell compatibility claim explicitly, also run:

```powershell
./tools/Invoke-PSChristmasTreeBuild.ps1 -Task TestWindowsPowerShell
```

1. Use the pull request template that matches your change.
1. Push your branch and open the pull request against `main`.

```bash
git push origin my-change-branch
```

## Review Feedback

If a maintainer requests changes:

1. Make the requested updates.
2. Re-run validation.
3. Push the updated branch.

If you need to update the most recent commit message:

```bash
git commit --amend
git push --force-with-lease
```

## After Merge

After your pull request is merged, you can clean up your branch.

```bash
git push origin --delete my-change-branch
git checkout main
git pull --ff-only upstream main
git branch -D my-change-branch
```

## Commit Guidance

* Use the imperative mood, for example: Add test coverage for wizard defaults.
* Keep the subject concise and descriptive.
* When changing only documentation, including `[ci skip]` in the commit title is acceptable when appropriate.

## PowerShell Guidance

* Prefer cross-platform PowerShell patterns.
* Avoid aliases in committed scripts.
* Use consistent casing for environment variables and hashtable keys.
* Use `Join-Path` and platform-neutral path handling where practical.
* Prefer explicit error handling and predictable command output.
* Use `Invoke-Build Format` to apply the repository formatting profile before pushing larger script changes.

## First Contributions

If you are looking for a smaller place to start, check these labels:

* Good first issue: [good first issue label](https://github.com/Sofiane-77/PSChristmasTree/labels/good%20first%20issue)
* Help wanted: [help wanted label](https://github.com/Sofiane-77/PSChristmasTree/labels/help%20wanted)

Project documentation is available here:
[PSChristmasTree documentation](https://sofiane-77.github.io/PSChristmasTree/)
