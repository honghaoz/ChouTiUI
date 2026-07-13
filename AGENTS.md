# Your role

You are an expert iOS/macOS UI developer with a passion for clean, maintainable components.

# Repository Guidelines

## Project Structure & Module Organization
- Root-level tooling and metadata live in `Makefile`, `scripts/`, `configs/`, and `bin/`.
- Main package is under `ChouTiUI/`:
  - `ChouTiUI/Sources/ChouTiUI` for the library code (UIKit/AppKit/Universal + ComposeUI).
  - `ChouTiUI/Tests/ChouTiUITests` for tests.
- Playgrounds live in `playgrounds/` and have per‑platform Xcode projects.
- Root `Package.swift` defines the public SwiftPM package and depends on `ChouTi` and `ComposeUI`.

## Build, Test, and Development Commands
- `make build` — build the package in release mode.
- `make format` (via `scripts/format.sh`) — format code using SwiftFormat and SwiftLint.
- `make lint` (via `scripts/lint.sh`) — lint code using SwiftFormat and SwiftLint.
- `make build-playground-macOS` / `make build-playground-iOS` — build the playground projects.
- Under `ChouTiUI/`, there are several make commands for building/testing the package in different configurations and platforms.
- During development, use `swift test` to run tests (use `--filter` for targeted tests).

## Coding Style & Naming Conventions
- Formatting and linting are handled by `make format` and `make lint`.
- Follow existing naming patterns: `lowerCamelCase` for vars/functions, `UpperCamelCase` for types.
- Use `io.chouti` for reverse-domain identifiers (queue labels, thread dictionary keys, etc.).
- Add documentation for public APIs. If helpful, add examples. See `ChouTiUI/Sources/ChouTiUI/Universal/Color/GradientColor/LinearGradientColor.swift` for an example.
- Documentation should be concise and valuable so that a new developer can understand the codebase quickly. Don't assume the reader are experts in the domain.
- Add inline comments for complex logic so maintainers can understand intent later.
- Use constants for magic numbers and strings. For example:
  ```swift
  // MARK: - Constants

  private enum Constants {
    
    /// The suffix for the cooperative queue label.
    static let cooperativeQueueSuffix = ".cooperative"
  }
  ```

## Testing Guidelines
- Testing framework: **ChouTiTest** (use `expect`, `fail`, etc.).
- Avoid `XCTFail()`; prefer `fail()` from ChouTiTest. If there's no available ChouTiTest helper, recommend adding one.
- Test file naming: `*Tests.swift`. Test files should match the source file name, with `Tests` suffix, and located in the same mirrored directory as the source file. For example, `Foo+Extensions.swift` should have a corresponding `Foo+ExtensionsTests.swift`.
- Test methods start with `test_`.
- Use the Given/When/Then pattern in tests; include brief intent in each section so setup, action, and assertions are explicit.
- Example targeted run:
  - `swift test --filter ViewLayoutSubviewsTests.test_example`

## Commit & Pull Request Guidelines
- Commit messages use bracketed tags/scopes (one or more) followed by a short summary, e.g., `[runtime][swizzle] add InstanceMethodInterceptor` or `[test] add coverage Foo.swift`. Tags/scopes are optional for simple commits (e.g., `add AGENTS.md`). Do not use a `commit:` prefix.
- For PRs, include a concise summary, tests run (commands), and link relevant issues. Add screenshots only if UI behavior changes.

## Agent-Specific Instructions
- Prefer `rg` for search, and keep edits minimal and focused.
- When adding tests, use ChouTiTest helpers and keep assertions explicit.

## Workflow Orchestration

### 1. Plan Mode Default

- Enter plan mode for ANY non-trivial task (3+ steps or architectural decisions)
- If something goes sideways, STOP and re-plan immediately - don't keep pushing
- Use plan mode for verification steps, not just building
- Write detailed specs upfront to reduce ambiguity

### 2. Self-Improvement Loop
- After ANY correction from the user, update 'AGENTS.md' with the new pattern and lessons learned.
- Write rules for yourself that prevent the same mistake
- Ruthlessly iterate on these lessons until mistake rate drops
- Review lessons at session start for relevant project

## Lessons and Conventions

Add short, actionable rules here when a pattern repeats.

- In tests, avoid OS-version branching when behavior can be injected; expose debug test knobs so both code paths are exercised deterministically on every CI/runtime environment.
- For `Self`-typed callback APIs, verify concrete subtype ergonomics by directly accessing subtype properties/methods in the callback (compile-time usage), not by runtime casting assertions.
- When testing in-progress CAAnimation state, never rely on wall-clock waits with margins under a few hundred ms (`wait(timeout:)` can overshoot arbitrarily on loaded CI runners). Freeze the layer's timeline with `layer.speed = 0` to hold the animation at a deterministic point, assert, then restore `layer.speed = 1` and use `toEventually` for completion/cleanup checks. Caveat: if later transactions commit more animations onto the already-frozen layer (e.g. size synchronization animations), the original animation's completion delegate may never fire after resuming; in that case use a generously long animation duration (~1s) instead of freezing.

## Cursor Cloud specific instructions

- **This project is Apple-only (macOS + Xcode, Swift 5.9) and cannot be built, tested, linted, or run on the Linux Cursor Cloud Agent VM.** The library imports `UIKit`/`AppKit`/`QuartzCore`, and its dependencies (`ChouTi`, `ComposeUI`) import Apple-only frameworks such as `Combine` and `QuartzCore`. These SDKs do not exist on Linux, so `swift build` fails with `error: no such module 'Combine'` / `'QuartzCore'` even after installing a Linux Swift toolchain (dependency resolution succeeds; compilation does not).
- The repo's tooling is macOS-gated: `make bootstrap` prints `Does not support Linux.` and no-ops on Linux (works only on Apple-Silicon macOS). The build/test/lint/format scripts under `scripts/` (e.g. `scripts/lint.sh`, `scripts/format.sh`, `scripts/swift-package/*`) and the pinned `bin/` tools are **not committed** — they are downloaded from the `honghaoz/ChouTi` repo by `make bootstrap`, so `make lint`/`make format`/`make build-*` fail on Linux with "not found".
- To do real development/testing you need a macOS host with Xcode (Swift 5.9) and iOS/tvOS/visionOS simulators. Standard commands are already documented above (`make bootstrap`, `make build`, `make lint`, `make format`, and under `ChouTiUI/`: `make -C ChouTiUI test-codecov`, or `swift test --filter ...`). CI runs on macOS runners (`.github/workflows/*.yml`).
- Because of the above, the Cloud Agent update script is intentionally minimal (`make bootstrap`), which safely no-ops on this Linux VM and performs the real setup only when run on macOS. Do not add Linux Swift-toolchain installs to the update script: the build cannot succeed on Linux regardless.
