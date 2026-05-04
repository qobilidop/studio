# 2026-05-02 (Saturday)

Pyret programming language overview — Brown PLT pedagogical language, test-driven by design (`where` blocks), Python-readable syntax with explicit `end`, ADTs + `cases` pattern matching, web-first execution compiling to JS, gradual typing with predicate annotations.

## Sessions

- **session-00**: Daily log (Gemini). Asked "How is Pyret the programming language?" Gemini overview: Brown University PLT (same group as Racket and *How to Design Programs* / HtDP curriculum). Sweet spot between Python readability and ML/Haskell/Racket semantics. Distinct features: (1) tests attached to functions via `where` blocks (TDD by language design); (2) Python-like syntax but explicit `end` keywords (no whitespace-only blocks); (3) native ADTs + `cases` pattern matching; (4) web-first — code.pyret.org browser IDE compiling to JS, no install; (5) gradual typing with predicate annotations (e.g., positive Number checked dynamically). Used in Bootstrap curriculum (middle/high school). Pedagogical tool, not industry workhorse. Compared to Python (mutable default, external pytest) and Racket (S-expressions, rackunit/check-expect)

## Agent index

- PYRET-LANG: Brown PLT pedagogical language (HtDP lineage, sister to Racket). Built-in TDD via `where` blocks attached to functions. Python-like syntax + explicit `end` blocks (no whitespace-only blocks). Native ADTs + `cases` pattern matching. Web-first — code.pyret.org compiles to JS, zero install. Gradual typing with predicate annotations checked dynamically. Immutable by default. Used in Bootstrap curriculum (middle/high school). Pedagogical not industrial (s00)
