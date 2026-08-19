name: Bug report 🐛
description: Report an error, regression, or unexpected behavior in PSChristmasTree
title: "[Bug]: "
labels: ["bug"]
body:
  - type: markdown
    attributes:
      value: |
        Thanks for taking the time to report a bug in **PSChristmasTree** 🎄

        Before submitting:
        - make sure you can reproduce the issue on the latest released version
        - search existing issues and discussions
        - include enough detail for someone else to reproduce the problem

  - type: checkboxes
    id: checks
    attributes:
      label: Before submitting
      options:
        - label: I confirmed this issue still happens on the latest released version
          required: true
        - label: I searched existing issues and discussions
          required: true
        - label: I included enough detail to reproduce the problem
          required: true

  - type: textarea
    id: summary
    attributes:
      label: What happened?
      description: Describe the bug clearly and briefly.
      placeholder: |
        Example: Show-PSChristmasTree crashes when I use custom decorations in PowerShell 7 on Linux.
    validations:
      required: true

  - type: textarea
    id: steps
    attributes:
      label: Steps to reproduce
      description: List the exact steps, command, or script needed to reproduce the issue.
      render: powershell
      placeholder: |
        1. Import-Module PSChristmasTree
        2. Run:
           Show-PSChristmasTree -AnimationLoopNumber 5
        3. Observe the output
    validations:
      required: true

  - type: textarea
    id: expected
    attributes:
      label: Expected behavior
      description: What did you expect to happen?
      placeholder: |
        Example: The tree should animate 5 times without errors.
    validations:
      required: true

  - type: textarea
    id: actual
    attributes:
      label: Actual behavior
      description: What happened instead?
      placeholder: |
        Example: The command stops early and throws an exception.
    validations:
      required: true

  - type: textarea
    id: error_output
    attributes:
      label: Error details or console output
      description: Paste the full error message or relevant output, if any.
      render: powershell
      placeholder: |
        Paste the full output here.

  - type: textarea
    id: environment
    attributes:
      label: Environment
      description: Share the environment details needed to understand the issue.
      placeholder: |
        PowerShell version:
        OS:
        Terminal:
        PSChristmasTree version:
    validations:
      required: true

  - type: textarea
    id: additional_context
    attributes:
      label: Additional context
      description: Add screenshots, GIFs, links, or any extra details that may help.