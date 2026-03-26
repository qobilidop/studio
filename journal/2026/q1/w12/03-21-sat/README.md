# 2026-03-21 (Saturday)

## Rest day with explorations

- **P4buf concept**: subset of P4 as IDL (like Protobuf but P4-based). Input: single .p4 file with type/extern declarations. Output: Protobuf representations + language-native data structures with runtime library for bit<N>/int<N>. Externs → rpc services (proto) or function/class declarations (C++). Draw inspiration from P4Runtime representations.
- **Decision**: polish Z3Wire to v0.1.0 before starting P4buf
- **Khalil Fong (方大同) family history**: watched Bilibili videos about his 6th-gen Hawaiian Chinese-American roots and California Gold Rush ancestors
- **DisplayLink docking station research**: Alt Mode = native GPU signal (zero latency), DisplayLink = software-compressed USB video. Plugable = gold standard reliability, Anker Prime = premium (140W, smart display), Wavlink = budget. Decided on Alt Mode product. Synaptics DisplayLink Manager is the universal driver (Plugable just rebrands it).
- **Historical texts terminology**: primary sources, archives, chronicles, manuscripts, artifacts, canon

## Status
- No coding done — rest day
- Z3Wire v0.1.0 release is next priority

## Sessions

- **session-00**: Daily log — P4buf concept brainstorm (P4 subset as IDL, deferred until Z3Wire v0.1.0 ships), Khalil Fong family history videos, DisplayLink docking station research (decided on Alt Mode product for triple-monitor setup)
- **session-01**: Z3Wire — separated Weave module from core (4 commits: directory move, CMake gating with `Z3WIRE_BUILD_WEAVE`, lint/docs updates)
