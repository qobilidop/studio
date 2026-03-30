# Session 04 — tor.p4 Slices 1–4 Implementation

Repo: https://github.com/qobilidop/p4py (branch: main, local only — 30 commits ahead of origin)

## Goal
Add tor.p4 support — the second sai_p4 instantiation (after wbb.p4). Full TOR switch program decomposed into 6 incremental slices.

## Completed Slices

### Slice 1: Parser + Deparser + Checksum
- 15-state parser (full protocol parsing: ethernet, IPv4/6, TCP, UDP, ICMP, ARP, hop-by-hop, inner headers)
- 21-emit deparser, IPv4 checksum verify/compute
- New features: `p4.cast()`, `ir.Cast`, `ir.ConstRef`, parser assignments
- Python match/case constraint: bare names are capture patterns, must use dotted `_c.ETHERTYPE_IPV4` for value matching. Compiler handles `ast.Attribute` → `ConstRef`.
- Protocol constants in `tests/e2e/sai_p4/fixed/ids.py`

### Slice 2: Packet IO + VLAN (5 sub-controls)
- `packet_out_decap`, `vlan_untag`, `ingress_vlan_checks`, `egress_vlan_checks`, `vlan_tag`
- New IR: `UnaryOp`, `CompareOp`, `LogicalOp`
- New features: `setValid()`/`setInvalid()`, bool local vars (`p4.bool_(True)`), literal table keys (`p4.literal(1, width=1)`), `p4.cast(p4.bit(W), expr)`, operator precedence parenthesization
- Macros (IS_RESERVED_VLAN_ID, IS_PACKET_IN_COPY, IS_MIRROR_COPY) expanded inline

### Slice 3: L3 Admit (2 sub-controls)
- `admit_google_system_mac` (bitwise AND + equality), `l3_admit` (table + if/else)
- New feature: bitwise AND (`&`) via extended `ArithOp`, with precedence parens

### Slice 4: ACL Pre-ingress + Ingress (2 sub-controls)
- `acl_pre_ingress`: 3 tables, 4 actions, 3 direct counters
- `acl_ingress`: 3 tables (TOR variant), 17 actions, 2 direct meters, 4 direct counters
- New features: named-type action params (`ActionParam.type_name`), expression table keys (`isValid() || isValid()`), `BitSlice` IR node (`field[127:64]`)
- Conditional compilation hardcoded for SAI_INSTANTIATION_TOR throughout

## Key Decisions
- Annotations deferred — no `@id`, `@entry_restriction`, etc.
- Conditional compilation → hardcode TOR choices in Python
- Table sizes omitted (upstream uses constants from minimum_guaranteed_sizes.h)
- `no_action` defined locally inside each control that needs it (no shared common_actions.py)
- `egress_vlan_checks.port` uses `p4.bit(9)` — typed locals with expression init deferred
- Rescoped original Slice 3 (L3 admit + routing) → slim Slice 3 (L3 admit only) + combined Slice 5 (routing lookup + resolution)

## Remaining
- **Slice 5 (Routing):** Hardest slice. Needs `.apply().hit`, action direction params (`inout` in action), partial action application in tables, `action_selector`/`selector` match kind, shared file-scope `set_nexthop_id` action, macro expansions (IS_MULTICAST_IPV4, IS_UNICAST_MAC using bitwise AND + masks).
- **Slice 6 (Egress):** mirror_session_lookup, ingress_cloning, drop_martians, packet_in_encap, packet_rewrites, mirror_encap, acl_egress. Needs `clone_preserving_field_list`, header struct literal init, TTL logic, multicast rewrites.

## Stats
- 30 commits this session
- 53 tests passing
- 1069-line golden file (`tests/e2e/sai_p4/tor.p4`)
- 14 controls wired into pipeline

## Files Created/Modified (key ones)
- `tests/e2e/sai_p4/fixed/ids.py` — protocol/port/instance-type constants
- `tests/e2e/sai_p4/fixed/packet_io.py` — packet_out_decap
- `tests/e2e/sai_p4/fixed/vlan.py` — 4 VLAN controls
- `tests/e2e/sai_p4/fixed/l3_admit.py` — admit_google_system_mac, l3_admit
- `tests/e2e/sai_p4/instantiations/google/acl_pre_ingress.py` — ACL pre-ingress
- `tests/e2e/sai_p4/instantiations/google/acl_ingress.py` — ACL ingress (TOR)
- `tests/e2e/sai_p4/instantiations/google/tor.py` — top-level pipeline
- `src/p4py/ir.py` — Cast, ConstRef, UnaryOp, CompareOp, LogicalOp, BitSlice; extended LocalVarDecl, ActionParam, TableKey
- `src/p4py/compiler.py` — all new expression types, cast variants, expression keys
- `src/p4py/emitter/p4.py` — all new expressions, precedence parens, named-type params
- `src/p4py/sim/engine.py` — all new expressions, setValid/setInvalid, ConstRef select

## Process
- Used superpowers:brainstorming for initial design, then superpowers:subagent-driven-development for execution
- Batched simple tasks (IR nodes) into single agent dispatches for speed
- Skipped spec/code review stages for mechanical tasks to maintain momentum
- User feedback: always use `./dev.sh` for commands (saved to memory)
