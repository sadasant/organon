---
type: quarantine-proposal
status: partially-promoted
binding: false
concept: attention-love-care
created: 2026-10-03
updated: 2026-10-12
recommended_outcome: partially-promoted-in-v0.20
statement_manifest: "attention-love-care-claims.json"
formal_shadow: "../ontology/formal/AttentionLoveCare.lean"
---
# Attention, Care, and Respect; Love withdrawn

## Current disposition

The [binding ontology](../ontology/ontology.md) retains Attention, Care, and Respect.
Daniel approved directed, persistent Attention and withdrawal of Sustained Attention
and Love in the [PR18 discussion](https://ampcode.com/threads/T-01a12b1e-60b5-77bc-8215-5fcd15da8088).
This dossier records those decisions; it does not replace the binding artifact.

Love is withdrawn, not renamed or equated with Attention. Its ordinary meanings
may be described by different Configurations of Attention, Care, Meaning, or Ritual.
No universal conjunction, exhaustive taxonomy, or necessary-and-sufficient reduction
of ordinary love is asserted. No psychological or normative premise is invented
to preserve its former registered name. The old exact-Denotation construction
remains a nonbinding historical example, not a definition of love.

## Definitions

<!-- organon:proposal-statement AC-D3 type=proposed_definition -->
**AC-D3 — Attention:** Attention is a directed Relation in which an Entity's
Perception or Interpretation remains causally organized by Differences in another
Entity across changes in that target's State, within a Scope.

The target remains the same Entity; the attended Differences and their Representations
need not remain unchanged. Directedness neither requires nor excludes reciprocity.
Attention may concern only some Differences and may cease; it does not require
exhaustive Perception, a finite channel inventory, or a numerical degree. Its causal
organization requires Causal Contribution, not mere co-occurrence or resemblance.
Attention alone makes no Claim about benefit, consent, morality, accuracy, Truth,
or purpose. Persistence is intrinsic, so Sustained Attention is no longer a term.

<!-- organon:proposal-statement AC-D7 type=proposed_definition -->
**AC-D7 — Care:** Care is Action causally organized by Attention to another Entity's
named State. The focal Representation exactly Denotes that Entity-State pair, and
the State belongs to the other Entity's Persistence history. The Action must be
causally organized by that Attention, not merely occur alongside it. Care may be
competent or incompetent, wanted or unwanted, beneficial or harmful.

<!-- organon:proposal-statement AC-D8 type=proposed_definition -->
**AC-D8 — Respect:** Respect is a scoped Constraint upon an Entity's Action toward
another Entity, where the Constraint admits the constrained Action and carries a
typed witness that the Action is admitted by the other's Boundary, or that
identity-preserving Agency options or at least two identity-preserving options
for self-determination remain available from the Action's output. The protection
concerns this exact Action rather than unrelated options. Respect does not require
agreement, affection, or obedience.

## Remaining constraints

<!-- organon:proposal-statement AC-C3 type=anti_collapse_constraint -->
**AC-C3 — Attention need not be exhaustive:** Attention may concern only some
Differences in the target Entity within its Scope. Perception, Interpretation,
Action, salience, exposure, or repeated occurrence alone does not establish
Attention without causal organization persisting across changes in that target's State.

<!-- organon:proposal-statement AC-C5 type=anti_collapse_constraint -->
**AC-C5 — Attention is normatively and epistemically neutral:** Attention does not
entail benefit, consent, morality, accuracy, Truth, purpose, or favorable Consequence,
and none of those separately establishes Attention.

<!-- organon:proposal-statement AC-C7 type=anti_collapse_constraint -->
**AC-C7 — Care is not benefit:** Care may be competent or incompetent, wanted or
unwanted, beneficial or harmful. Favorable Consequence does not establish Care
without Attention to the other Entity's State organizing an Action.

<!-- organon:proposal-statement AC-C8 type=anti_collapse_constraint -->
**AC-C8 — Respect is not agreement or affection:** Respect does not entail
agreement, affection, obedience, favorable Consequence, or complete noninterference.
None establishes Respect without a scoped Constraint upon Action and a typed
Boundary, Agency-option, or self-determination protection witness.

## Formal evidence and limits

[AttentionRevision.lean](../ontology/formal/AttentionRevision.lean) is included in
the default build. Its eight theorems check target-sensitive response across changing
States, unilateral and reciprocal cases, cessation outside an episode, rejection of
mere contextual covariation, rejection of one sample as persistence, and narrow
tracking that ignores another Difference. Its natural-number indices are local
trace positions, not an ontology of Time. Every tested response contrast holds the
context fixed. Participant identity and response functions remain supplied projections.
Sampled sensitivity does not prove uninterrupted physical fixation or canonical
Perception, Interpretation, or Causal Contribution. The tests do not prove the full
new Attention definition, and do not establish equivalence to the old ratio.

[AttentionLoveCare.lean](../ontology/formal/AttentionLoveCare.lean) retains the old
finite Attention, Sustained Attention, Love, and Care records under `NonbindingExamples`.
They preserve finite counting, same-context response comparisons, exact target
Denotation, partial/full coverage, and the historical countermodels. The old ratio
theorem is no longer an Attention contract. Care's partial contract retains the
exact target joins but explicitly leaves revised Attention and canonical Action
and Causal Contribution outside its formal boundary. The old full-coverage exclusion remains a theorem
about that optional measurement, not a general condition imposed on Attention.

The Respect contract retains its exact-action protection and local participant
classifier. That classifier receives only identity Invariant and Boundary, not
current State or history length. The finite participants share an identity criterion
and recorded history but differ in Boundary admission of an unrecorded alternative.
Equal classes do not prove one Entity; different Boundaries do not necessarily
force different classes. The option branches retain identity-preserving operations
beginning at the constrained Action's output, not canonical Agency or freedom in general.

<!-- organon:proposal-statement AC-G1 type=open_formalization_gate -->
**AC-G1 — Canonical causal and participant parity:** Full canonical joins for
revised Attention and Attention-organized Action in Care remain open. Respect's
local participant and option projections retain their parity limits. AC-D3 and
AC-D7 have `proved_with_boundaries` contracts with explicit unproved dependencies;
the four prose constraints are outside the complete formal boundary. Historical
ratio theorems cannot discharge these obligations.

<!-- organon:proposal-statement AC-G2 type=open_evidence_gate -->
**AC-G2 — Application:** No formal witness establishes that a biological,
artificial, institutional, or other Entity instantiates these definitions.
Application requires a separate Specification and admissible Evidence.

## Proposal statement registry

| ID | Type | Statement | Evidence or gate |
| --- | --- | --- | --- |
| AC-D3 | Proposed definition | Directed persistent Attention | `directedAttentionContract`; canonical causal/perceptual parity open |
| AC-D7 | Proposed definition | Care | `careContract`; target joins only, revised Attention and Action parity open |
| AC-D8 | Proposed definition | Respect | `respectContract`; local participant and option projections |
| AC-C3 | Anti-collapse constraint | Nonexhaustive Attention | Narrow-response countermodel; canonical parity open |
| AC-C5 | Anti-collapse constraint | Attention neutrality | Outside current formal boundary |
| AC-C7 | Anti-collapse constraint | Care is not benefit | Outside current formal boundary |
| AC-C8 | Anti-collapse constraint | Respect is not agreement or affection | Outside current formal boundary |
| AC-G1 | Open formalization gate | Canonical causal and participant parity | Open |
| AC-G2 | Open evidence gate | Application | Open |

## Retired identifiers and migration

- D115/AC-D4 (Sustained Attention) is withdrawn: persistence belongs to revised
  Attention. The old fixed focal/contrast pair and finite inventory are not silently
  retained as necessary conditions. This is an approved semantic revision, not a
  claimed full-Scope isomorphism between the two historical encodings.
- D117/AC-D6 (Love) and C44/AC-C6 are withdrawn. C45 and C46 retain their remaining
  limits without making formal claims about undefined ordinary love. There is no
  replacement `loves` relation or adopted profile root.
- C42/AC-C4 is retired with the mandatory finite measurement. Its full-coverage
  theorem survives in the nonbinding example. C41 now states nonexhaustiveness
  without a finite denominator. Care keeps its Attention-to-Action requirement
  without requiring an enumerated Action channel.
- D112/AC-D1, C39/AC-C1, D113/AC-D2, C40/AC-C2, and D116/AC-D5 remain retired.
  The bodily-selection composite remains under `NonbindingExamples`; the
  [representation-activity example](../ontology/formal/RepresentationActivityExample.lean)
  preserves the former Intention construction. Ordinary intention and Consciousness
  remain undefined. The separate temporal selection-ordering question is unresolved.

No retired identifier is reassigned. Historical snapshots, the
[formal decision record](../ontology/formal/decisions.md), and Git history retain
earlier formulations. Exact-source promotion reviews remain stale rather than
being silently refreshed; passing compilation does not renew adversarial review.
