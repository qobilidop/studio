# 2026 W13 (Mar 23–29)

Z3Wire focus shift: stripped Weave codegen out to keep the core library lean, cleaned up API naming and constructors, and refined docs.

## Days

- [03-23-mon](03-23-mon/README.md): Major Z3Wire cleanup — Weave removal, API review, symbolic-offset bugfix, dual markdown formatting setup
- [03-24-tue](03-24-tue/README.md): Employer work focus day, no project activity

## Agent index

- theme: Z3Wire scope narrowing — Weave removed, library refocused on core type-safe Z3 wrapper
- decision: Weave codegen is a separate concern for a separate audience; may become its own project later
- API stabilization: `FromValue`/`FromExpr` naming, `std::span` for wide BitVec, SymBitVec constructor policy finalized
- blocker-ongoing: Getting Started docs blocked on packaging (BCR or vcpkg)
- tooling: mdformat-mkdocs + dprint dual formatting established for docs/ vs GitHub-rendered markdown
- docs: design/overview.md replaced with leaner design/philosophy.md (~414 → ~73 lines)
- new-office: first day in new office building on Monday
