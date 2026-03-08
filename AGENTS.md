# Repository Guidelines

## Project Structure & Module Organization
This repository is a Rust workspace for FIDE.
- `fide-app/`: main desktop application UI and editor behavior.
- `fide-core/`: core editor logic (syntax, language metadata, rope/text utilities).
- `fide-proxy/`: proxy/runtime integrations (plugins, terminal, remote helpers).
- `fide-rpc/`: shared RPC/data protocol types.
- `defaults/`: bundled themes, keymaps, and default settings.
- `icons/`, `extra/`: static assets, packaging resources, and platform-specific files.
- `docs/`: contributor and build documentation.

## Build, Test, and Development Commands
Use Cargo from the repository root.
- `cargo build --frozen`: CI-aligned workspace build.
- `cargo run --bin fide --profile fastdev`: run app with faster iterative profile.
- `cargo test --workspace`: run unit/integration tests across crates.
- `cargo test --doc --workspace`: run doctests (mirrors CI).
- `cargo fmt --all --check`: enforce formatting.
- `cargo clippy`: lint all crates before opening a PR.
- `make ubuntu-deps`: install Linux build dependencies used in CI.

## Coding Style & Naming Conventions
- Language: Rust 2024 edition.
- Formatting is mandatory via `rustfmt`; max width is `85` (`.rustfmt.toml`).
- Use idiomatic Rust naming: `snake_case` (functions/modules), `PascalCase` (types/traits), `SCREAMING_SNAKE_CASE` (constants).
- Keep modules focused; place related tests near implementation (`mod tests` in-file or crate-level test modules).

## Testing Guidelines
- Prefer deterministic tests without network or GUI assumptions.
- Name tests by behavior, e.g. `fn updates_window_scale_on_setting_change()`.
- Run at least `cargo test --workspace`, plus `cargo test --doc --workspace` when touching public APIs/docs.
- For parser/syntax/plugin changes, add regression tests in the affected crate.

## Commit & Pull Request Guidelines
- Follow concise, imperative commit subjects; optional prefixes seen in history include `fix:`, `docs:`, `ci:`.
- Keep commits scoped (one logical change per commit).
- Before PR: run `cargo fmt --all`, `cargo clippy`, and relevant tests.
- PRs should include: problem statement, change summary, test evidence, and screenshots/GIFs for UI-visible changes.
- Link related issues and note platform impact (macOS/Linux/Windows) when relevant.
