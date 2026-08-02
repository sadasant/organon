# Kenogram Review

## Review boundary

- Project: [idolum-ai/kenogram](https://github.com/idolum-ai/kenogram)
- Revision: [`4cd6551971a7dd6ba0d65d10d5d5a6133ec9c59f`](https://github.com/idolum-ai/kenogram/tree/4cd6551971a7dd6ba0d65d10d5d5a6133ec9c59f)
- Date inspected: 2026-08-02
- Evidence inspected: README; declaration, security, network, operations, lifecycle, history, and evidence-index requirements; design and kenogrammatics notes
- Organon version: v0.9.0 candidate; agent, evidence, and governance profiles
- Method: read-only documentation audit; implementation and runtime evidence were not replayed

## Verdict

Kenogram is a strong first adoption target because its documentation already practices most of Organon's distinctions. It separates speech from authority, contracts from evidence, provenance from ontology, and runtime possibility from host decision. The dogfood exercise found three real semantic seams: Kenogram's lowercase *absence* is Missingness rather than Organon's absolute Absence; *authoritative generation* means operational precedence rather than Authority; and the host-authored declaration produces both institutional authorization and mechanical Capability, which should remain two effects even when one operation creates them.

The [candidate adoption manifest](./kenogram-adoption.json) validates against the inspected checkout. It is an Organon-side proposal, not a claim that Kenogram has adopted Organon.

## Correspondence table

| Project term | Project mechanism | Organon candidate | Relation | Evidence inspected | Documentation change | Organon change |
| --- | --- | --- | --- | --- | --- | --- |
| runtime capability | What a world process can affect in one materialized environment | `organon:Capability` | refinement | [README lines 16-21](https://github.com/idolum-ai/kenogram/blob/4cd6551971a7dd6ba0d65d10d5d5a6133ec9c59f/README.md#L16-L21), [security lines 23-38](https://github.com/idolum-ai/kenogram/blob/4cd6551971a7dd6ba0d65d10d5d5a6133ec9c59f/requirements/security.md#L23-L38) | Name the world/runtime as Capability Context when Organon terminology is invoked. | None. The review exercises the v0.9 contextual Capability repair. |
| host-authored declaration | Parsed Specification whose application changes admitted host resources | `organon:Declaration` | refinement | [design lines 6-14](https://github.com/idolum-ai/kenogram/blob/4cd6551971a7dd6ba0d65d10d5d5a6133ec9c59f/docs/design.md#L6-L14), [declaration contract](https://github.com/idolum-ai/kenogram/blob/4cd6551971a7dd6ba0d65d10d5d5a6133ec9c59f/requirements/declaration.md) | If adopted, state that the operator acts as Principal under the local Order and that the file is also a Specification and Record. | None; multiple Organon types may describe different aspects of one project artifact. |
| durable declaration admission | Applying a reviewed declaration makes resources and destinations available | `organon:Grant` plus `organon:Permission` | refinement | [README lines 18-21](https://github.com/idolum-ai/kenogram/blob/4cd6551971a7dd6ba0d65d10d5d5a6133ec9c59f/README.md#L18-L21), [operations lines 69-87](https://github.com/idolum-ai/kenogram/blob/4cd6551971a7dd6ba0d65d10d5d5a6133ec9c59f/requirements/operations.md#L69-L87) | Keep authorization distinct from the Capability the resulting runtime exposes. | None. |
| `allow --for` | Time-bounded permission for an exact outbound destination | `organon:Permission` and `organon:PermissionExercise` | refinement | [operations lines 13-23](https://github.com/idolum-ai/kenogram/blob/4cd6551971a7dd6ba0d65d10d5d5a6133ec9c59f/requirements/operations.md#L13-L23), [network lines 19-25](https://github.com/idolum-ai/kenogram/blob/4cd6551971a7dd6ba0d65d10d5d5a6133ec9c59f/requirements/network.md#L19-L25) | Optionally call the live proxy path an exercise surface, not the Permission itself. | None. |
| `revoke` | Removes live destination access and closes admitted connections | `organon:Revocation` | refinement | [network lines 19-25](https://github.com/idolum-ai/kenogram/blob/4cd6551971a7dd6ba0d65d10d5d5a6133ec9c59f/requirements/network.md#L19-L25) | State which Order and prior Permission the revocation addresses if adopting the governance profile. | None. |
| runtime inspection | Host-side observations checked before services start or a successor is applied | `organon:Observation` | refinement | [README lines 29-39](https://github.com/idolum-ai/kenogram/blob/4cd6551971a7dd6ba0d65d10d5d5a6133ec9c59f/README.md#L29-L39), [design lines 23-26](https://github.com/idolum-ai/kenogram/blob/4cd6551971a7dd6ba0d65d10d5d5a6133ec9c59f/docs/design.md#L23-L26) | Preserve the current wording that observations precede acceptance. | None. |
| test and runtime evidence | Observations admitted by binding requirements and CI gates | `organon:Evidence` | refinement | [requirements index lines 3-7](https://github.com/idolum-ai/kenogram/blob/4cd6551971a7dd6ba0d65d10d5d5a6133ec9c59f/requirements/INDEX.md#L3-L7), [evidence table](https://github.com/idolum-ai/kenogram/blob/4cd6551971a7dd6ba0d65d10d5d5a6133ec9c59f/requirements/INDEX.md#evidence-and-known-limits) | Name the admissibility rule and independence limit when making an Organon Evidence claim; same-system checks may still be valuable without being fully independent. | Organon should retain scoped, non-absolute independence rather than demand a metaphysically external observer. |
| history record and digests | Append-only provenance and tamper observations that do not become authority | `organon:Record`; sometimes input to `organon:Evidence` | refinement | [history lines 3-20](https://github.com/idolum-ai/kenogram/blob/4cd6551971a7dd6ba0d65d10d5d5a6133ec9c59f/requirements/history.md#L3-L20), [kenogrammatics lines 65-75](https://github.com/idolum-ai/kenogram/blob/4cd6551971a7dd6ba0d65d10d5d5a6133ec9c59f/docs/kenogrammatics.md#L65-L75) | No change; this is already an unusually clean anti-collapse boundary. | None. |
| authoritative generation | Generation selected by durable transition state for recovery and operator actions | no direct adoption | unmapped | [lifecycle lines 18-32](https://github.com/idolum-ai/kenogram/blob/4cd6551971a7dd6ba0d65d10d5d5a6133ec9c59f/requirements/lifecycle.md#L18-L32) | Keep as a project-local operational term or map to a future refinement of canonical operational state; do not map it to `organon:Authority`. | Consider a future term only after another project needs the same distinction. |
| world | Rootless Linux execution environment delimited by the declaration and runtime boundary | composite of Entity, Boundary, Environment, State, and Context | unmapped | [README lines 10-14](https://github.com/idolum-ai/kenogram/blob/4cd6551971a7dd6ba0d65d10d5d5a6133ec9c59f/README.md#L10-L14), [design lines 6-9](https://github.com/idolum-ai/kenogram/blob/4cd6551971a7dd6ba0d65d10d5d5a6133ec9c59f/docs/design.md#L6-L9) | Keep the local term. A forced one-term mapping would erase useful structure. | Do not promote quarantined `World` merely to accommodate one repository. |
| generation | One material inscription of a declared world-pattern | State or Configuration under identity-preserving replacement | refinement | [lifecycle lines 43-45](https://github.com/idolum-ai/kenogram/blob/4cd6551971a7dd6ba0d65d10d5d5a6133ec9c59f/requirements/lifecycle.md#L43-L45), [kenogrammatics lines 46-58](https://github.com/idolum-ai/kenogram/blob/4cd6551971a7dd6ba0d65d10d5d5a6133ec9c59f/docs/kenogrammatics.md#L46-L58) | If mapped later, identify the persistent Entity and its identity Invariant explicitly. | The nontrivial Boundary model is sufficient for this review; no new term is needed. |
| absence | An undeclared capability unavailable in the world's observable structure | `organon:Missingness`, not `organon:Absence` | conflict if capitalized; ordinary local use otherwise | [kenogrammatics lines 86-90](https://github.com/idolum-ai/kenogram/blob/4cd6551971a7dd6ba0d65d10d5d5a6133ec9c59f/docs/kenogrammatics.md#L86-L90) | Record an ordinary-language exception in any adoption manifest. Do not rewrite Kenogram's established lowercase security phrase unless it claims Organon Absence. | The manifest exception proves stable IDs are preferable to capitalization. |

## Findings

### Kenogram documentation

No blocking semantic defect was found. The most useful improvement would be a short terminology note making explicit that one declaration application can both authorize an action and alter the runtime so the action becomes technically possible. The existing prose usually preserves this distinction, but “grants durable authority” and “admits durable capabilities” make the dual effect easy to compress into one verb.

### Organon

The adoption machinery survived its first realistic target without requiring a new binding term. The review confirms why adoption must be explicit: Kenogram's *World*, *absence*, and *authoritative generation* are disciplined local terms that should not be normalized by spelling alone.

The remaining weakness is evidentiary. A manifest can prove that mappings are declared and dependency-closed; it cannot prove that the inspected implementation earns those mappings. The review table and pinned evidence links remain necessary.

### Mapping

The strongest mappings are Capability, Permission, Revocation, Record, and Observation. Declaration and Evidence are valid refinements only when their Order, Authority, Rule, and independence conditions are made explicit. World and authoritative generation should remain local.
