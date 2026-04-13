# 2026-04-12 (Sunday)

Custom note app architecture discussion — building a personal Obsidian alternative as a VS Code extension for software sovereignty, with AST-based graph engine and opinionated workspace topology.

## Sessions

- **session-00**: Daily log (Gemini) — Obsidian-like note app feasibility analysis: editor is the "Final Boss" (ProseMirror/CodeMirror complexity), file system sync race conditions, plugin API overhead. Custom build realistic when scoped personally: AST parsing for bidirectional link graph, hardcoded topology (`memory/`, `knowledge/`, `skills/`, `projects/`), time-first architecture (`Year/Quarter/Week`), minimalist stack (Tauri or local web UI). VS Code extension strategy: eliminates editor problem entirely, native file watching via `vscode.workspace.createFileSystemWatcher`, Tree View API for semantic navigation, Webview API for graph visualization. Architecture: intelligence engine (background AST parser + in-memory directed graph) + visualization layer (Webview message passing). Trade-offs: TypeScript tax, Webview↔Extension Host async message passing. Software sovereignty motivation: "owning" core daily systems, immunity to "enshittification", absolute structural correctness, raw Markdown files as future-proof format

## Agent index

- CUSTOM-NOTE-APP: Obsidian alternative as VS Code extension. Rationale: software sovereignty ("own" core systems, immunity to feature bloat/enshittification). VS Code eliminates editor problem, provides file watching + Tree View + Webview APIs. Architecture: background AST parser builds in-memory directed graph of Markdown files, Webview renders visualization. Key decision: TypeScript in extension host vs LSP backend in performant language (open question). Hardcoded topology for personal workspace vs generic plugin system (s00)
- SOFTWARE-SOVEREIGNTY: user values owning core daily-use systems over relying on third-party apps. Concern: commercial apps inevitably introduce unwanted features. Solution: build custom, opinionated tools that enforce exact personal workflow. Raw Markdown as future-proof format (readable even without tooling) (s00)
