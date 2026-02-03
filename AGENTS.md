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
- Example targeted run:
  - `swift test --filter ViewLayoutSubviewsTests.test_example`

## Commit & Pull Request Guidelines
- Commit messages use bracketed tags/scopes (one or more) followed by a short summary, e.g., `[runtime][swizzle] add InstanceMethodInterceptor` or `[test] add coverage Foo.swift`. Tags/scopes are optional for simple commits (e.g., `add AGENTS.md`). Do not use a `commit:` prefix.
- For PRs, include a concise summary, tests run (commands), and link relevant issues. Add screenshots only if UI behavior changes.

## Agent-Specific Instructions
- Prefer `rg` for search, and keep edits minimal and focused.
- When adding tests, use ChouTiTest helpers and keep assertions explicit.
