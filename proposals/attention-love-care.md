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
**AC-D7 — Care:** Care is a Relation in which Attention to another Entity's changing
State conditions the selection or adjustment of Action according to a Specification
of Consequences concerning that Entity, within a Scope.

Both Attention and the Specification must causally condition Action; an attached
description or after-the-fact classification is insufficient. The Specification
concerns the same Entity attended to. Actual conformity, benefit, consent, and
agreement with the subject's own assessment are not required. No verbal statement
or conscious deliberation is required. Competent nursing and careful interrogation
can both qualify; their criteria, beneficiaries, and actual effects remain distinct.

Daniel retained Care as a term rather than the proposed nonbinding label
“Attention-organized Action.” The distinction retained is consequence-sensitive
selection or adjustment under an operative criterion, not responsiveness alone.
This is an approved revision, not an equivalence proof for the historical record.

<!-- organon:proposal-statement AC-D8 type=proposed_definition -->
**AC-D8 — Respect:** Respect is a Relation in which an Entity constrains its Action
toward another Entity according to conditions expressed by that other Entity or
interpreted from their shared Configuration, within a Scope.

Conditions must operate as Constraints, not merely describe the Action. Contextual
Interpretation supplies defaults; the other's expressed conditions take precedence
for the same Action and Scope. Explicit negotiation and Ritual are unnecessary,
and contextual convention alone does not establish the other's agreement. A
bounded, accepted limitation of Agency need not violate Respect; its accepted
extent and duration still constrain the intervention. An accidental violation
fails to respect the conditions without establishing deliberate disregard.

Daniel's proximity and temporary-Agency-loss examples reject identity protection
or counting retained options as sufficient. This is a semantic revision, not an
equivalence with the old record. Constraint alone omits whose conditions govern;
agreement or a description alone omits their operative use. No elaborate contract,
uninterrupted Agency, affection, obedience, or favorable Consequence is required.

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
unwanted, beneficial or harmful. Neither favorable Consequence nor conformity to
a Specification establishes Care without Attention and that Specification
conditioning Action concerning the same Entity. Care does not entail successful
conformity or benefit to that Entity.

<!-- organon:proposal-statement AC-C8 type=anti_collapse_constraint -->
**AC-C8 — Respect is not agreement or affection:** Respect does not entail
agreement, affection, obedience, favorable Consequence, or complete noninterference.
None establishes Respect without the other's expressed conditions or contextual
Interpretation operating as Constraints upon Action within Scope. Contextual
defaults do not override expressed contrary conditions; accidental conformity
alone does not establish this organization, and accidental violation does not
establish deliberate disregard.

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
theorem is no longer an Attention contract, and the old `careContract` is no longer
a Care promotion contract. The old full-coverage exclusion remains a theorem
about that optional measurement, not a general condition imposed on Attention.

[CareRevision.lean](../ontology/formal/CareRevision.lean) supplies five bounded
theorems: opposite criteria use the same mechanism, both inputs condition selection,
a mistaken represented condition can defeat conformity, an ignored criterion is
insufficient, and success without response sensitivity is insufficient. The
`criterionCareContract` projects response and Specification sensitivity. It does
not construct canonical Attention, Action, Consequence, comparison Causal paths,
or the join between the Specification's target and the attended Entity. The finite
test uses the existing Specification type without defining benefit or harm.

[RespectRevision.lean](../ontology/formal/RespectRevision.lean) supplies seven
bounded theorems on expressed-condition priority, implicit defaults, target-specific
refusal, contextual variation without expression, Scope limits, bounded accepted
limitation, and actual versus planned intrusion. `conditionRespectContract` checks
the same participant, operation, and Scope through resolution. Neither admission
alone nor a supplied condition proves canonical Respect, consent, expression
provenance, contextual accuracy, or causal regulation of behavior. Local steps
in the limitation example are not a Time primitive or a model of Agency recovery.
The old `Respect` record and `respectContract` remain nonbinding historical
identity/option protection examples, with their existing proofs unchanged.

<!-- organon:proposal-statement AC-G1 type=open_formalization_gate -->
**AC-G1 — Canonical causal and participant parity:** Full canonical joins for
revised Attention, Care, and Respect remain open. Respect additionally needs
condition provenance, contextual Interpretation, and actual regulation joins.
AC-D3, AC-D7, and AC-D8 have `proved_with_boundaries` contracts with explicit unproved dependencies;
the four prose constraints are outside the complete formal boundary. Historical
ratio and identity/option protection theorems cannot discharge these obligations.

<!-- organon:proposal-statement AC-G2 type=open_evidence_gate -->
**AC-G2 — Application:** No formal witness establishes that a biological,
artificial, institutional, or other Entity instantiates these definitions.
Application requires a separate Specification and admissible Evidence.

## Proposal statement registry

| ID | Type | Statement | Evidence or gate |
| --- | --- | --- | --- |
| AC-D3 | Proposed definition | Directed persistent Attention | `directedAttentionContract`; canonical causal/perceptual parity open |
| AC-D7 | Proposed definition | Criterion-governed Care | `criterionCareContract`; operative sensitivity only, canonical and target joins open |
| AC-D8 | Proposed definition | Condition-governed Respect | `conditionRespectContract`; scoped condition resolution only, canonical and causal joins open |
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
  remain undefined. Canonical rejection is a contrasting possibility rather than
  a required prior event; the retained temporal selection witness and its limitations
  are documented under EC-D5 in the [embodiment dossier](./embodied-consciousness.md).

No retired identifier is reassigned. Historical snapshots, the
[formal decision record](../ontology/formal/decisions.md), and Git history retain
earlier formulations. The [current exact-source review](../reviews/promotion/attention-love-care.json)
attests AC-D3, AC-D7, and AC-D8 with their declared formal boundaries, not the
retired contracts. Model judgments have not been rerun; passing compilation alone
does not renew adversarial review or establish empirical applicability.
