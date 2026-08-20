# How to contribute to the docs

PSChristmasTree uses GitHub Pages to host our documentation.  This allows us to keep our docs in the repository, without the various limitations that come with the built in GitHub repo wiki.

Contributions welcome:

* Clone the [PSChristmasTree repo](https://github.com/Sofiane-77/PSChristmasTree)
* Checkout a new branch
* Commit changes
  * Organization is described in the [mkdocs.yml](https://github.com/Sofiane-77/PSChristmasTree/blob/main/mkdocs.yml) file
  * mkdocs.yml points to markdown files in [the docs folder](https://github.com/Sofiane-77/PSChristmasTree/tree/main/docs)
  * Images are stored and accessible from [docs/img](https://github.com/Sofiane-77/PSChristmasTree/tree/main/docs/img)
* Submit a pull request to the new branch

## Release and quality checklist

For maintainers and contributors preparing larger changes, please refer to the detailed validation steps in the [CONTRIBUTING](../.github/CONTRIBUTING.md) guide.
It contains the necessary commands to run local tests, script analysis, and validation (e.g., using `Invoke-PSChristmasTreeBuild.ps1`).

### Git pre-commit hook

A pre-commit hook is available to run tests automatically before every commit.
Install it once after cloning:

```powershell
.\tools\Install-GitHooks.ps1
```

The hook blocks the commit if any Pester test fails.

### CI workflow guidance

The canonical workflows are under `.github/workflows/`.

* Keep build/test/publish logic in workflow files under this folder only.
* Avoid adding parallel experimental pipeline files at repository root.
* Prefer updating existing workflows over introducing temporary copies.
