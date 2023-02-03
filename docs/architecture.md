# Architecture

## Goals

PSChristmasTree keeps a simple product scope (animated terminal tree) while applying production-grade engineering practices:

- deterministic configuration normalization
- clear separation of concerns between orchestration, domain logic, and terminal I/O
- testable logic in pure or near-pure helpers
- predictable release and CI quality gates

## Runtime Layers

### 1. Public command layer

Public commands in the module surface a stable API:

- `Show-PSChristmasTree`
- `Set-PSChristmasTreeConfig`
- `Get-PSChristmasTreeConfig`
- `Reset-PSChristmasTreeConfig`

These functions are orchestration-only entry points and should avoid embedding deep business logic.

### 2. Configuration domain layer

Configuration is represented as a structured v3 schema:

- `Language`
- `Tree`
- `Decorations`
- `Colors`
- `Display`
- `Audio`
- `Messages`

Core responsibilities:

- `ConvertTo-PSChristmasTreeConfig`: schema defaults + validation + migration from legacy flat shape
- `Resolve-PSChristmasTreeEffectiveConfig`: precedence merge (runtime > saved > defaults)
- `Read-PSChristmasTreeConfig` / `Write-PSChristmasTreeConfig`: persistence boundary

This layer defines invariants for downstream rendering.

### 3. Render preparation layer

Render data preparation is intentionally separated from terminal side effects:

- `Get-PSChristmasTreeDecoratedTree`
- `Get-PSChristmasTreeMessageRenderModel`

These helpers transform domain objects into display-ready payloads and are unit-tested directly.

### 4. Terminal I/O layer

`Invoke-PSChristmasTreeRenderLoop` is the side-effect boundary:

- cursor and foreground color lifecycle
- terminal clear/write calls
- resize-aware re-centering
- optional asynchronous carol playback

The render loop delegates preparation logic to the render helpers to keep I/O code focused and reviewable.

## Key Invariants

- Invalid colors are filtered during normalization.
- `Decorations.Mode = Default` always clears custom `Map`.
- `Colors` effective list is always non-empty at runtime.
- Runtime arguments always override saved configuration.
- Terminal state is restored in `finally` blocks.

## Testing Strategy

The test suite combines:

- configuration and migration tests
- command orchestration tests with mocks
- render-engine helper tests
- module packaging/export contract checks

CI runs Pester across the entire `Tests` folder and fails fast on any failed block.

## Release and CI Posture

- deterministic dependency versions for build tooling
- explicit validation of tag/version consistency before release and publish
- static analysis as a required quality gate
- GitHub Pages documentation deployment via workflow artifacts

## Why This Matters

This architecture keeps the project approachable while making engineering quality visible:

- each layer has a clear reason to change
- core behavior is testable without a real terminal
- regressions are easier to isolate
- contributors can extend features without rewriting orchestration