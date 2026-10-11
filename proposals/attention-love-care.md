---
type: quarantine-proposal
status: partially-promoted
binding: false
concept: attention-love-care
created: 2026-10-03
updated: 2026-10-11
recommended_outcome: partially-promoted-in-v0.20
statement_manifest: "attention-love-care-claims.json"
formal_shadow: "../ontology/formal/AttentionLoveCare.lean"
---
# Attention, Love, Care, and Respect

## Verdict

Attention is a snapshot-local finite ratio over available perceptual, interpretive, and action channels. Every organized channel has a response comparison in the current context that changes under the focal representational Difference; historical occurrence alone cannot organize a current channel. Love, Care, and Respect remain different kinds: sustained target-directed Attention, Action organized by Attention to another Entity's State, and a scoped Constraint upon Action with a typed protection witness. The participant classifier excludes current States and Persistence records by construction; the finite other-participant witness uses distinct Boundary admission under one shared identity criterion. Canonical numerical individuation remains an explicit formalization gate, not a universal claim supplied by this witness.

The formal shadow uses explicit local channel projections where Organon's canonical Perception, Interpretation, Action, Agency, and Capability structures are not parameterized for this Body reduct. The dependency ledger records each projection. It does not promote Consciousness, benefit, consent, morality, reciprocity, understanding, possession, goodness, or moral worth.

## Proposed definitions

<!-- organon:proposal-statement AC-D3 type=proposed_definition -->
**AC-D3 — Attention:** Attention is the finite ratio of an Entity's currently available Perception, Interpretation, and Action channels causally organized by one Difference in one State of one Body, relative to a declared channel inventory and availability Specification. The inventory individuates channels independently of their kind and result. The Specification supplies the availability criterion and its Scope; the nonempty finite available enumeration covers exactly every conforming channel and counts each once. A different inventory or Specification defines a different measurement context, not a different degree within the same context. Each snapshot declares channel results and a collection of channel-specific response comparisons independently of the counted enumeration. Causal organization is evaluated at that snapshot, rather than by searching historical Causal Contributions: a qualifying comparison holds the snapshot's declared context fixed, produces the channel's current result under the focal Representation, and produces a different result under the contrast Representation. The result must belong to the indexed snapshot; neither earlier nor later States qualify. A channel is organized exactly when at least one declared comparison satisfies these conditions for the focal Difference. A selected witness must belong to that collection; selecting a nonfocal witness cannot hide a qualifying alternative. The organized enumeration covers exactly every available qualifying channel, counts each once, and supplies the numerator; the available enumeration supplies the denominator. Holding the snapshot and declared measurement data fixed fixes the ratio independently of any history. Attention alone makes no Claim about benefit, consent, morality, accuracy, Truth, or purpose.

<!-- organon:proposal-statement AC-D4 type=proposed_definition -->
**AC-D4 — Sustained Attention:** Sustained Attention is Attention organized by the same Difference under one declared channel inventory across at least two ordered changing States of one Body. At every named State, Attention is evaluated independently at that exact State and at least one available channel is currently organized by that Difference. Ordering these snapshots establishes the temporal comparison; no snapshot inherits organization merely because a channel was organized at an earlier State. Repeated encounters qualify only when indexed to such ordered States rather than inferred from resemblance.

<!-- organon:proposal-statement AC-D6 type=proposed_definition -->
**AC-D6 — Love:** Love is Sustained Attention directed toward another Entity, where the maintained focal Representation exactly Denotes that Entity across the indexed changing States. Different current States of one persistent Entity do not alone establish another Entity; distinct Entities need not have different identity criteria. Love does not imply reciprocity, understanding, consent, benefit, Care, Respect, possession, or moral approval.

<!-- organon:proposal-statement AC-D7 type=proposed_definition -->
**AC-D7 — Care:** Care is Action causally organized by Attention to another Entity's named State. The focal Representation exactly Denotes that Entity-State pair, the State belongs to the other Entity's Persistence history, and at least one available Action channel is organized by that Attention. Care may be competent or incompetent, wanted or unwanted, beneficial or harmful; it does not imply Love.

<!-- organon:proposal-statement AC-D8 type=proposed_definition -->
**AC-D8 — Respect:** Respect is a scoped Constraint upon an Entity's Action toward another Entity, where the Constraint admits the constrained Action and carries a typed witness that the Action is admitted by the other's Boundary, or that identity-preserving Agency options or at least two identity-preserving options for self-determination remain available from the Action's output. The protection concerns this exact Action rather than unrelated options. Respect does not require agreement, affection, obedience, or Love.

## Exact anti-entailments

<!-- organon:proposal-statement AC-C3 type=anti_collapse_constraint -->
**AC-C3 — Attention need not cover every available channel:** One finite Attention structure organizes its perceptual and interpretive channels while an available action channel remains unorganized: that Action's exact contribution produces its result from a different upstream Difference, not from the focal Difference.

<!-- organon:proposal-statement AC-C4 type=anti_collapse_constraint -->
**AC-C4 — Full coverage excludes focus-independent Action:** When every available channel of an Attention instance is organized, no available Action channel can remain independent of the focal Difference. This is a relative channel exclusion, not a prohibition on Action organized by the focus.

<!-- organon:proposal-statement AC-C5 type=anti_collapse_constraint -->
**AC-C5 — Attention is normatively and epistemically neutral:** Attention does not entail benefit, consent, morality, accuracy, Truth, or purpose, and none of those separately establishes Attention.

<!-- organon:proposal-statement AC-C6 type=anti_collapse_constraint -->
**AC-C6 — Love does not collapse into Care or Respect:** Love does not entail reciprocity, understanding, consent, benefit, Care, Respect, possession, or moral approval. Care or Respect does not by itself establish the sustained target-directed Attention required for Love.

<!-- organon:proposal-statement AC-C7 type=anti_collapse_constraint -->
**AC-C7 — Care is not benefit or Love:** Care may be competent or incompetent, wanted or unwanted, beneficial or harmful. Care does not entail Love, and favorable Consequence alone does not establish Care without Attention to the other Entity's State organizing an Action.

<!-- organon:proposal-statement AC-C8 type=anti_collapse_constraint -->
**AC-C8 — Respect is not agreement or affection:** Respect does not entail agreement, affection, obedience, Love, favorable Consequence, or complete noninterference. Those conditions do not establish Respect without a scoped Action Constraint and protection witness.

## Formal shadow

[AttentionLoveCare.lean](../ontology/formal/AttentionLoveCare.lean) encodes five promoted terms, the derived `Attention.fullCoverage` condition, nonbinding historical examples, and the local projection types `AttentionChannel`, `ChannelInventory`, `SnapshotCausalContribution`, `EntityIndividuation`, `FocusIndependentAction`, and `RespectProtection`. [AttentionLoveCareContracts.lean](../ontology/formal/AttentionLoveCareContracts.lean) restates every promoted definition and two Lean-supported constraints as exact promotion contracts.

The finite model witnesses a nonbinding partial bodily-selection Configuration, partial and full-coverage Attention, target-directed Love, Care indexed to the target's Persistence history, and Respect whose Constraint both admits the actor's scoped Action and carries a typed protection witness. AC-C5 through AC-C8 remain binding prose outside the current Lean boundary because their normative, interpersonal, and reverse anti-entailments lack closed-world negations in the reduct.

<!-- organon:proposal-statement AC-G1 type=open_formalization_gate -->
### AC-G1 — Open formalization gate: canonical channel parity

The present shadow represents Perception, Interpretation, and Action as typed local channels and represents Agency and Capability by explicit option and admission witnesses. Canonicalization requires Body-indexed versions of those structures and a theorem relating the finite channel ratio to them. The manifest records every such representation instead of treating name presence as parity. Channel identity is declared by an inventory's Channel type, independently of its kind or result; each State has a constructive availability Specification, and exact coverage closes the finite denominator within that declared context. The numerator has exact coverage against the channel-specific causal data, independently of list membership. Empirical completeness of those declared contribution collections and universal exhaustiveness across all possible channel decompositions are not claimed. Otherness uses a local `EntityIndividuation.participant` classifier whose only inputs are the identity Invariant and Boundary. Its `ignoresRecords` theorem excludes changes of history length, content, current State, or Direction as grounds for different classification when those two inputs are fixed. Numerical inequality is retained, but unequal identity Invariants are not required. The finite classifier distinguishes admission of one named Transformation; the positive Love, Care, and Respect witnesses share the actor's identity criterion, full recorded history, current State, and constraint count, but differ in Boundary behavior. Both Boundaries admit all recorded outputs; their difference concerns an unrecorded alternative. The classifier type also admits Boundary-insensitive classifications, so Boundary difference is not a universal entailment of otherness, and equal classification does not prove one Entity. Canonical numerical identity, including continuity across Boundary changes, remains open in the dependency ledger. Sustained snapshots are indexed and exclude future results, but do not prove uninterrupted attention between sampled States. The Agency-option and self-determination branches prove retained, identity-preserving transformations beginning at the constrained Action's output, not canonical Agency or freedom in general.

The merged framework dossier remains nonbinding: its proposed Interpretation/Understanding migration is not incorporated into the adopted registry by this promotion. These channel projections retain the current canonical Interpretation dependency; canonical parity must address that migration if it is later adopted.

`SnapshotCausalContribution` is a local counterfactual projection, not canonical temporal Causal Contribution. Its response function takes a Representation and the indexed State's context; the focal response must equal the current result and the contrast response must differ in that same context. The toy encoding represents a current channel result by the indexed State itself. No comparison paths or historical States are inputs to the organization predicate. Empirical fidelity of the response functions and their relation to canonical Causal Contribution remain open; declaring a function does not prove that a physical mechanism implements it. The same present response can occur after different histories, including through effects represented in the current State. Past-only and future results, constant responses, and mixed-context comparisons are rejected. Sustained Attention supplies the temporal ordering of independently evaluated snapshots, without proving continuity between them.

Focus-independent Action requires positive response invariance under the named attended contrast, not reversed labels or failed organization. Its nonempty declared response domain must reproduce the exact current result and leave it unchanged under that contrast in the same context, for every declared model. The finite partial Action follows a separate Boolean input while ignoring the attended input; both inputs vary independently in the proofs. Independence remains relative to the declared comparison and models, not every possible input or an empirically exhaustive mechanism inventory.

### Definition decisions: guidance and the attention limit

Intention was withdrawn on October 11 rather than renamed. Former AC-D2/D113 and AC-C2/C40 are retired, not reassigned. The [representation-mediated bodily activity example](../ontology/formal/RepresentationActivityExample.lean) proves inverse conversions between the historical record and a Causal Contribution whose downstream Transformation belongs to the Body, together with a freely assigned State referent. Changing that referent leaves the mechanism unchanged. No other registered definition needs the withdrawn distinction. Desire, endorsement, or goal pursuit are not added to rescue the name; ordinary intention remains undefined. The example retains the temporal Causal Contribution shadow and does not resolve its separate selection-ordering question.

D112/AC-D1 and C39/AC-C1 are also withdrawn. Their exact family, Scope, perspective-selection join, and Boundary Constraint remain in `NonbindingExamples.EmbodiedSelfGovernance`, without a replacement term. The partial-family witness survives; admission of every family member is not evidence of causal regulation of every member. D116/AC-D5 is withdrawn as a separate definition: `Attention.fullCoverage` expresses the same universal condition, and a general Lean equivalence relates it to the historical wrapper retained under `NonbindingExamples`. All retired identifiers remain unreassigned.

Full channel coverage chooses **entrainment**: no available activity independent of the focus remains, while focus-organized Action may continue. It does not choose a paralysis law forbidding all Action. The inhabited action-channel witness proves this distinction. The limit is relative to the declared inventory and availability Specification; claiming exhaustive coverage of every possible channel of an Entity would require a separate closure argument. Sustained nonzero Attention establishes Love in this definition without fixing its degree or intensity.

<!-- organon:proposal-statement AC-G2 type=open_evidence_gate -->
### AC-G2 — Open evidence gate: application

No observation here establishes that a biological, artificial, institutional, or other Entity instantiates any of the five terms. Application requires a separate Specification of available channels, target Denotations, Causal Contributions, Scopes, Constraints, and admissible Evidence.

## Proposal statement registry

| ID | Type | Statement | Dependencies | Evidence or gate |
| --- | --- | --- | --- | --- |
| AC-D3 | Proposed definition | Attention | Entity, Body, Difference, Representation, Perception, Interpretation, Action, Causal Contribution, State, Specification, Scope | `attentionContract`; snapshot causal parity remains open |
| AC-D4 | Proposed definition | Sustained Attention | AC-D3, Entity, Body, State, Direction, Persistence, Difference | `sustainedAttentionContract` |
| AC-D6 | Proposed definition | Love | Relation, AC-D4, Entity, Representation, Denotation, State | `loveContract` |
| AC-D7 | Proposed definition | Care | Relation, AC-D3, Entity, State, Representation, Denotation, Action, Causal Contribution, Persistence | `careContract`; canonical Action remains a boundary |
| AC-D8 | Proposed definition | Respect | Relation, Constraint, Action, Entity, Scope, Boundary, Agency, Capability, Transformation, Invariant | `respectContract` |
| AC-C3 | Anti-collapse constraint | Attention need not cover every available channel | AC-D3, Action | `partialAttentionCountermodel` |
| AC-C4 | Anti-collapse constraint | Full coverage excludes focus-independent Action | AC-D3, Action, Difference | `fullCoverageActionLimit` |
| AC-C5 | Anti-collapse constraint | Attention neutrality | AC-D3, Claim, Truth, Consequence | Outside current Lean boundary |
| AC-C6 | Anti-collapse constraint | Love/Care/Respect separation | AC-D6, AC-D7, AC-D8 | Outside current Lean boundary |
| AC-C7 | Anti-collapse constraint | Care/benefit/Love separation | AC-D7, AC-D6, Consequence | Outside current Lean boundary |
| AC-C8 | Anti-collapse constraint | Respect/agreement/affection separation | AC-D8, AC-D6, Consequence | Outside current Lean boundary |
| AC-G1 | Open formalization gate | Canonical channel parity | AC-D3, AC-D7, AC-D8, Perception, Interpretation, Action, Agency, Capability | Open |
| AC-G2 | Open evidence gate | Application | AC-D3, AC-D4, AC-D6, AC-D7, AC-D8, Specification, Evidence | Open |

## Promotion boundary

Organon v0.20 promotes five terms and six anti-collapse constraints. Two constraints have Lean proofs; four state explicit binding limits outside the reduct. Intention and the bodily-selection composite survive only as nonbinding examples; full channel coverage is a derived condition of Attention. Consciousness and the proposed revision of Authority remain outside this dossier and unchanged.

## Configuration repair and source preservation

The earlier Capability/Agency wording is preserved in the [pre-repair baseline](../reviews/local/pre-promotion-baseline/proposals--attention-love-care.md). Before withdrawal, D112 was repaired to an admitted internal Configuration: canonical Capability requires Agent/Action, which internal-only selection need not supply. The retained nonbinding example preserves that repair and its explicit complete-Control boundary.
