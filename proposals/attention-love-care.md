---
type: quarantine-proposal
status: promoted
binding: false
concept: attention-love-care
created: 2026-10-03
updated: 2026-10-03
recommended_outcome: promoted-in-v0.20
statement_manifest: "attention-love-care-claims.json"
formal_shadow: "../ontology/formal/AttentionLoveCare.lean"
---
# Self-Governance, Intention, Attention, Love, Care, and Respect

## Verdict

The eight terms conform after making their causal and index joins explicit. Attention is a finite ratio over available perceptual, interpretive, and action channels, with every organized channel joined to the same representational Difference by an exact Causal Contribution. Love, Care, and Respect then remain different kinds: sustained target-directed Attention, Action organized by Attention to another Entity's State, and a scoped Constraint upon Action with a typed protection witness.

The formal shadow uses explicit local channel projections where Organon's canonical Perception, Interpretation, Action, Agency, and Capability structures are not parameterized for this Body reduct. The dependency ledger records each projection. It does not promote Consciousness, benefit, consent, morality, reciprocity, understanding, possession, goodness, or moral worth.

## Proposed definitions

<!-- organon:proposal-statement AC-D1 type=proposed_definition -->
**AC-D1 — Embodied Self-Governance:** Embodied Self-Governance is the scoped Capability through which an Entity's Embodied Perspective is exactly joined to Internal Activity Selection that selects, inhibits, continues, or revises Transformations of its Body under Constraints of its Boundary. The governed family is nonempty, includes the selected Transformation, occurs within that Body, and is admitted by the named Constraint. The Capability may cover only some bodily functions or Transformations.

<!-- organon:proposal-statement AC-D2 type=proposed_definition -->
**AC-D2 — Intention:** Intention is a Configuration in which a represented outcome is exactly Denoted as a target and a Difference involving that Representation is the upstream Difference of a Causal Contribution guiding the selection, continuation, inhibition, or revision of an activity within one Body. The guided activity need not produce the represented target outcome.

<!-- organon:proposal-statement AC-D3 type=proposed_definition -->
**AC-D3 — Attention:** Attention is the finite ratio of an Entity's available Perception, Interpretation, and Action channels that are causally organized by one Difference. The available channels form a nonempty finite set, each channel is counted once, and every organized channel is available. Each Attention snapshot is indexed to a State of that Body; its exact Causal Contribution carries the focal representational Difference to the channel's result, which occurs at or before the indexed State under the Entity's Direction. Attention alone makes no Claim about benefit, consent, morality, accuracy, or purpose.

<!-- organon:proposal-statement AC-D4 type=proposed_definition -->
**AC-D4 — Sustained Attention:** Sustained Attention is Attention organized by the same Difference across at least two ordered changing States of one Body. At every named State, the Attention snapshot is indexed to that exact State and at least one available channel remains organized by that Difference. Repeated encounters qualify only when they are indexed to such ordered States rather than inferred from resemblance.

<!-- organon:proposal-statement AC-D5 type=proposed_definition -->
**AC-D5 — Absolute Attention:** Absolute Attention is the limiting condition in which every available perceptual, interpretive, and action channel is organized by the same Difference. Completeness concerns membership, independent of enumeration order. It therefore leaves no available Action channel independent of that Difference; it does not entail literal immobility or the absence of organized Action.

<!-- organon:proposal-statement AC-D6 type=proposed_definition -->
**AC-D6 — Love:** Love is Sustained Attention directed toward another Entity, where the maintained focal Representation exactly Denotes that Entity across the indexed changing States. Different current States of one identity do not alone establish another Entity. Love does not imply reciprocity, understanding, consent, benefit, Care, Respect, possession, or moral approval.

<!-- organon:proposal-statement AC-D7 type=proposed_definition -->
**AC-D7 — Care:** Care is Action causally organized by Attention to another Entity's named State. The focal Representation exactly Denotes that Entity-State pair, the State belongs to the other Entity's Persistence history, and at least one available Action channel is organized by that Attention. Care may be competent or incompetent, wanted or unwanted, beneficial or harmful; it does not imply Love.

<!-- organon:proposal-statement AC-D8 type=proposed_definition -->
**AC-D8 — Respect:** Respect is a scoped Constraint upon an Entity's Action toward another Entity, where the Constraint admits the constrained Action and carries a typed witness that the Action is admitted by the other's Boundary, or that identity-preserving Agency options or at least two identity-preserving options for self-determination remain available from the Action's output. The protection concerns this exact Action rather than unrelated options. Respect does not require agreement, affection, obedience, or Love.

## Exact anti-entailments

<!-- organon:proposal-statement AC-C1 type=anti_collapse_constraint -->
**AC-C1 — Self-governance may be partial:** One inhabited Embodied Self-Governance structure governs one recurring bodily Transformation while another recurring bodily Transformation lies outside its Scope. Embodied Self-Governance therefore does not entail complete Control of the Body.

<!-- organon:proposal-statement AC-C2 type=anti_collapse_constraint -->
**AC-C2 — Intention does not entail achievement:** In the finite witness, the Denoted target outcome differs from the output of the causally guided activity. Conversely, occurrence alone does not establish Intention without the target Representation, Denotation, upstream Difference, and guiding Causal Contribution.

<!-- organon:proposal-statement AC-C3 type=anti_collapse_constraint -->
**AC-C3 — Attention does not entail Absolute Attention:** One finite Attention structure organizes its perceptual and interpretive channels while an available action channel remains unorganized.

<!-- organon:proposal-statement AC-C4 type=anti_collapse_constraint -->
**AC-C4 — Absolute Attention excludes focus-independent Action:** When every available channel is organized, no available Action channel can remain outside the focal Difference. This is a relative channel exclusion, not a prohibition on Action organized by the focus.

<!-- organon:proposal-statement AC-C5 type=anti_collapse_constraint -->
**AC-C5 — Attention is normatively and epistemically neutral:** Attention does not entail benefit, consent, morality, accuracy, Truth, or purpose, and none of those separately establishes Attention.

<!-- organon:proposal-statement AC-C6 type=anti_collapse_constraint -->
**AC-C6 — Love does not collapse into Care or Respect:** Love does not entail reciprocity, understanding, consent, benefit, Care, Respect, possession, or moral approval. Care or Respect does not by itself establish the sustained target-directed Attention required for Love.

<!-- organon:proposal-statement AC-C7 type=anti_collapse_constraint -->
**AC-C7 — Care is not benefit or Love:** Care may be competent or incompetent, wanted or unwanted, beneficial or harmful. Care does not entail Love, and favorable Consequence alone does not establish Care without Attention to the other Entity's State organizing an Action.

<!-- organon:proposal-statement AC-C8 type=anti_collapse_constraint -->
**AC-C8 — Respect is not agreement or affection:** Respect does not entail agreement, affection, obedience, Love, favorable Consequence, or complete noninterference. Those conditions do not establish Respect without a scoped Action Constraint and protection witness.

## Formal shadow

[AttentionLoveCare.lean](../ontology/formal/AttentionLoveCare.lean) defines the eight structures, four finite separations, and the local projection types `AttentionChannel`, `AttentionItem`, `ActivityGuidance`, `FocusIndependentAction`, and `RespectProtection`. [AttentionLoveCareContracts.lean](../ontology/formal/AttentionLoveCareContracts.lean) restates every promoted definition and four Lean-supported anti-entailments as exact promotion contracts.

The finite model witnesses partial self-governance, an intended target not achieved by the guided activity, partial Attention, Absolute Attention with no focus-independent available Action channel, target-directed Love, Care indexed to the target's Persistence history, and Respect whose Constraint both admits the actor's scoped Action and carries a typed protection witness. AC-C5 through AC-C8 remain binding prose outside the current Lean boundary because their normative, interpersonal, and reverse anti-entailments lack closed-world negations in the reduct.

<!-- organon:proposal-statement AC-G1 type=open_formalization_gate -->
### AC-G1 — Open formalization gate: canonical channel parity

The present shadow represents Perception, Interpretation, and Action as typed local channels and represents Agency and Capability by explicit option and admission witnesses. Canonicalization requires Body-indexed versions of those structures and a theorem relating the finite channel ratio to them. The manifest records every such representation instead of treating name presence as parity. Channel instances are individuated locally by channel kind and result, not by a universal account of physical channel identity or availability. Distinct identity Invariants supply a sufficient other-Entity witness in this finite model; this is not a complete individuation criterion for all Entities. Sustained snapshots are indexed and exclude future results, but do not prove uninterrupted attention between sampled States. The Agency-option and self-determination branches prove retained, identity-preserving transformations beginning at the constrained Action's output, not canonical Agency or freedom in general.

The merged framework dossier remains nonbinding: its proposed Interpretation/Understanding migration is not incorporated into the adopted registry by this promotion. These channel projections retain the current canonical Interpretation dependency; canonical parity must address that migration if it is later adopted.

<!-- organon:proposal-statement AC-G2 type=open_evidence_gate -->
### AC-G2 — Open evidence gate: application

No observation here establishes that a biological, artificial, institutional, or other Entity instantiates any of the eight terms. Application requires a separate Specification of available channels, target Denotations, Causal Contributions, Scopes, Constraints, and admissible Evidence.

## Proposal statement registry

| ID | Type | Statement | Dependencies | Evidence or gate |
| --- | --- | --- | --- | --- |
| AC-D1 | Proposed definition | Embodied Self-Governance | Capability, Entity, Embodied Perspective, Internal Activity Selection, Body, Transformation, Scope, Constraint, Boundary, Agency | `embodiedSelfGovernanceContract` |
| AC-D2 | Proposed definition | Intention | Configuration, Representation, Denotation, Difference, Causal Contribution, Transformation, Body, State, Action | `intentionContract` |
| AC-D3 | Proposed definition | Attention | Entity, Body, Difference, Representation, Perception, Interpretation, Action, Causal Contribution, State, Direction | `attentionContract` |
| AC-D4 | Proposed definition | Sustained Attention | AC-D3, Entity, Body, State, Direction, Persistence, Difference | `sustainedAttentionContract` |
| AC-D5 | Proposed definition | Absolute Attention | AC-D3, Difference, Action | `absoluteAttentionContract` |
| AC-D6 | Proposed definition | Love | Relation, AC-D4, Entity, Representation, Denotation, State | `loveContract` |
| AC-D7 | Proposed definition | Care | Relation, AC-D3, Entity, State, Representation, Denotation, Action, Causal Contribution, Persistence | `careContract`; canonical Action remains a boundary |
| AC-D8 | Proposed definition | Respect | Relation, Constraint, Action, Entity, Scope, Boundary, Agency, Capability, Transformation, Invariant | `respectContract` |
| AC-C1 | Anti-collapse constraint | Self-governance may be partial | AC-D1, Body, Scope, Control | `partialSelfGovernanceCountermodel` |
| AC-C2 | Anti-collapse constraint | Intention does not entail achievement | AC-D2, State, Causal Contribution | `intentionOutcomeCountermodel`; reverse direction outside boundary |
| AC-C3 | Anti-collapse constraint | Attention does not entail Absolute Attention | AC-D3, AC-D5, Action | `partialAttentionCountermodel` |
| AC-C4 | Anti-collapse constraint | Absolute Attention excludes focus-independent Action | AC-D5, Action, Difference | `absoluteAttentionActionLimit` |
| AC-C5 | Anti-collapse constraint | Attention neutrality | AC-D3, Claim, Truth, Consequence | Outside current Lean boundary |
| AC-C6 | Anti-collapse constraint | Love/Care/Respect separation | AC-D6, AC-D7, AC-D8 | Outside current Lean boundary |
| AC-C7 | Anti-collapse constraint | Care/benefit/Love separation | AC-D7, AC-D6, Consequence | Outside current Lean boundary |
| AC-C8 | Anti-collapse constraint | Respect/agreement/affection separation | AC-D8, AC-D6, Consequence | Outside current Lean boundary |
| AC-G1 | Open formalization gate | Canonical channel parity | AC-D1, AC-D3, AC-D7, AC-D8, Perception, Interpretation, Action, Agency, Capability | Open |
| AC-G2 | Open evidence gate | Application | AC-D1, AC-D2, AC-D3, AC-D4, AC-D5, AC-D6, AC-D7, AC-D8, Specification, Evidence | Open |

## Promotion boundary

Organon v0.20 promotes all eight terms and eight anti-collapse constraints. Four anti-entailments have finite Lean proofs; four state explicit binding limits outside the reduct. Consciousness and the proposed revision of Authority remain outside this dossier and unchanged.
