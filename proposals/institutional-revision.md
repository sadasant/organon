---
type: quarantine-proposal
status: ready-for-review
binding: false
concept: institutional-revision
created: 2026-10-12
updated: 2026-10-12
statement_manifest: "institutional-revision-claims.json"
formal_shadow: "../ontology/formal/InstitutionalRevision.lean"
---
# Standing, Authority, Power, Institution, and Succession

## Approved wording, pending canonical migration

This dossier preserves Daniel's approved candidates and qualifications from the
[PR18 discussion](https://ampcode.com/threads/T-01a12b1e-60b5-77bc-8215-5fcd15da8088).
Approval of these formulations is recorded here; promotion into the binding
[ontology](../ontology/ontology.md) is not claimed. The registry remains unchanged.
The existing institutional Authority cannot silently acquire the broader physical
meaning below while its Grant, Permission, and sovereignty consumers stay unchanged.

The [Lean module](../ontology/formal/InstitutionalRevision.lean) preserves bounded
tests of the distinctions. It is included in the default build. It does not prove
complete canonical parity, an astronomical model, a universal theory of Power,
or the empirical continuity of any Institution. The schema-v1 manifest inventories
discussion statements; declaration references are not schema-v2 promotion contracts.

## Candidate definitions

<!-- organon:proposal-statement IR-D1 type=proposed_definition -->
### Standing

**Standing** is a Relation between an Entity and specified Actions within an Order
and Scope, obtaining when the Entity satisfies the conditions that a Rule of that
Order specifies for participation in those Actions. Standing does not by itself
establish that any such Action has occurred.

This replaces unexplained institutional eligibility with the particular Rule's
conditions. It does not add a Governance or Contract primitive. A Rule may require
recording, but recording is not a universal prerequisite. In the local Lean test,
placement must join the exact Order's supplied Specification, its Scope, and the
Entity/Action conformity result. The Order-to-Rule assignment is still supplied,
not derived from a canonical adoption process. Positive Standing without occurrence,
wrong-Entity and wrong-Action rejection, and rejection of an unrelated Rule are checked.

<!-- organon:proposal-statement IR-D2 type=proposed_definition -->
### Authority

**Authority** is a scoped Relation in which an Entity's State or activity establishes
conditions governing the available Transformations of other Entities.

This supersedes the earlier discussion candidate, "recognized Standing to establish,
interpret, or revise Rules and Specifications." The broader candidate requires no
mind and no explicit Recognition premise. The Sun example motivates distinguishing
downstream dependence on a source's State from the source's own degrees of freedom.
The Lean example changes every recipient's available-operation domain by changing
the source State, although the source has only one available operation at each State.
It does not show that the source can select between those States, or measure the Sun.

Whether this relation differs from existing Constraint and Causal Contribution is
unresolved. Whether recognized rule-setting is a restricted instance, and whether
Recognition must broaden beyond recording, are also unresolved. Physical dependence
must not automatically become a Grant, Permission, or authority to revise an Order.

<!-- organon:proposal-statement IR-D3 type=proposed_definition -->
### Power

**Power** concerns available Actions distinguished through their represented
Consequences, where that distinction conditions Action and the Actions causally
differentiate which Consequences obtain under stated Constraints.

The represented distinction participates in producing Action; an observer's account
afterward is insufficient. Conscious understanding and direct influence over every
event in the causal path are not required. Range, reliability, resource costs, and
dependence on intermediaries may describe a profile, but no scalar measure is introduced.
The example of exploiting foreknown lightning concerns changing an opponent's response,
not producing the strike. The checked local model distinguishes those two effects.

Model-mediated Interpretation and Causal Contribution are existing vocabulary for
investigating the joins; "prediction" and "causal inference" are not promoted as new
primitives. A changing input must change both the chosen operation and its effect in
the local operative-contrast test. That Boolean test does not yet establish canonical
Representation/Denotation, Entity-owned Interpretation, Action, or Consequence parity.

<!-- organon:proposal-statement IR-D4 type=proposed_definition -->
### Institution

**An Institution** is a persistent Configuration that maintains and transmits the
Rules and role distinctions through which an Order coordinates Action across changes
in participants.

Maintaining and transmitting these distinctions is operative, not merely possessing
a document representing them. This is approved wording, not a claim that a charter
alone constitutes an Institution. A complete witness must still connect that
maintenance and transmission to actual coordination and participant change.

<!-- organon:proposal-statement IR-D5 type=proposed_definition -->
### Successful Succession

**Successful Succession** reconstitutes an Institution through successor participants
who subsequently bring about a further Succession preserving the Institution under
its declared continuity criterion.

This supersedes the capacity-only draft. A local succession occurrence means an
actual participant transition preserving the named Institution under the same
criterion. Success requires a further such occurrence, not merely a possible next
successor. Its epistemic concern is the reproduction of how the Institution can be
reconstituted, rather than the transfer of Rules and Roles alone. Neither operative
knowledge nor necessary material resources may be inferred from copying a Record.

The Lean history test requires two adjacent handoffs, different participants within
each handoff, one Institution index, and one continuity relation. The supplied history
is assumed occurrence evidence, not proof of real events. The continuity predicate
does not yet implement canonical institutional identity or epistemic reconstruction.

## Approved qualifications and remaining hypotheses

<!-- organon:proposal-statement IR-H1 type=hypothesis -->
### Recognition-dependent Authority has maintenance requirements

**Authority depends on maintaining its required Recognition. Additional recognition
requirements can increase that maintenance burden without reducing the domain of
Actions over which Authority obtains.**

Under the broader IR-D2 candidate, this applies where Authority depends on Recognition,
not universally to every physical conditioning relation. Required recognitions are
not the same as the number of recognizers or affected subjects. With maintenance methods
fixed, adding requirements cannot add feasible plans; it can exclude a formerly
adequate plan. Shared maintenance may satisfy several requirements together, so no
strict per-recognizer cost law follows. Lean proves those conditional statements;
their application to actual Recognition maintenance remains a hypothesis.

<!-- organon:proposal-statement IR-C1 type=anti_collapse_constraint -->
### Capacity, records, and replacement do not establish further succession

A completed handoff and an available next successor do not establish the required
further occurrence. Nor does a further replacement establish preservation of the same
Institution. The history tests accept `[0, 1, 2]`, reject the incomplete `[0, 1]` even
with a possible next successor, and reject `[0, 1, 9]` under the same declared criterion.

<!-- organon:proposal-statement IR-C2 type=anti_collapse_constraint -->
### A finite continuation is not enduring institutional success

**A witnessed further Succession establishes continuation through that stage, not
the enduring success of the Institution's succession process. A subsequent failure
to reproduce the Institution remains a failure of that process.**

Later failure does not erase earlier transitions. No finite history alone certifies
unending continuity: the Lean test gives a matching finite history with a terminal
extension. Failure to persist is distinct from failure to fulfil a declared purpose;
an Institution's intended dissolution is not excluded by the candidate definition.
The absence of a recorded next event by itself is not evidence that future succession
is impossible. The finite classifier states what is witnessed in a supplied history.

<!-- organon:proposal-statement IR-H2 type=hypothesis -->
### Power spending and prediction maintenance remain conditional research claims

Daniel proposed that Power or certainty spends, that predictive relevance requires
renewal, and that seized resources may be spent more liberally than resources whose
depletion one must answer for. These are retained as hypotheses, not universal laws.
The discussion did not settle a definition of certainty or its cost. A fixed-law Lean
model forecasts one component indefinitely despite arbitrary changes to an unobserved
component; its stable law is an assumption, not empirical proof that a real observer
can know the law will persist. A separate model shows that Actions can differentiate
effects while an unobserved context prevents an exact context-free forecast. Neither
test establishes universal predictive decay, total knowledge, or a numerical Power score.

## Termhood, inheritance, and migration gates

<!-- organon:proposal-statement IR-G1 type=open_formalization_gate -->
### Approved candidates are not yet dependency-closed replacements

- **Standing:** the strongest reduction is conformity to an Order-indexed Rule. Its
  downstream use may justify a stable name, but the Actions-only candidate must still
  account for Principal and Person's existing status-based uses and Orders with multiple
  applicable Rules. The local test fixes one relevant Rule per Order, not one Rule in total.
- **Authority:** distinguish the broader relation from Constraint, Causal Contribution,
  and the former institutional Authority. Audit CountsAs, Declaration, Grant, Permission,
  Role, IndependentFor, and sovereignty profiles before migration. Resolve the Recognition
  question without inferring human-like representation from physical dependence.
- **Power:** test reduction to Capability plus operative Interpretation and causal
  comparison. Full source/target joins and its relation to Control remain open. The
  earlier independence examples concerned recognized rule-setting and a named downstream
  effect; they do not prove independence of the newly broadened Authority and Power.
- **Institution:** preserve actual maintenance, transmission, and continuity, not a
  renamed Record. Specify how Role's institutional dependencies migrate without circularity.
- **Succession:** justify a stable term rather than an example Configuration; provide
  canonical identity and epistemic reconstruction witnesses. Keep finite occurrence,
  possible continuation, and unending survival separate.

The institutional region inherits the status-function and constitutive-rule comparison
with Searle already recorded in the canonical ontology; the broad Authority candidate
deliberately exceeds that institutional reading. The system/boundary comparison with
Luhmann likewise remains a reference, not an equivalence proof. No claim is made that
Machiavelli's political observations prove the spending hypotheses or that these local
Lean models establish a political, biological, or astrophysical theory. Contract,
Governance, generic Recognition revision, and numerical measures remain unpromoted.

## Statement registry

| ID | Type | Statement | Checked evidence or boundary |
| --- | --- | --- | --- |
| IR-D1 | proposed_definition | Standing | `standingIffConformity`; exact index and finite rejection tests; Order adoption gated |
| IR-D2 | proposed_definition | Authority | `conditioningWithoutSourceChoice`; generic termhood and Recognition relation gated |
| IR-D3 | proposed_definition | Power | `operativeContrast`; positive, dormant-input, and indirect-effect cases; canonical parity gated |
| IR-D4 | proposed_definition | Institution | Approved wording; full operative maintenance/transmission witness open |
| IR-D5 | proposed_definition | Successful Succession | `successfulSuccessionAt`; actual adjacent histories; institutional identity and epistemics gated |
| IR-H1 | hypothesis | Recognition maintenance | `moreRequirementsCannotAddPlans`; strict exclusion and shared-maintenance examples |
| IR-C1 | anti_collapse_constraint | Further occurrence, not mere capacity or replacement | `capacityAndHandoffDoNotSupplyFurtherOccurrence`; broken-continuity rejection |
| IR-C2 | anti_collapse_constraint | Finite continuity is not unending survival | `finiteHistoryDoesNotCertifyUnendingContinuity`; real occurrence evidence remains external |
| IR-H2 | hypothesis | Power spending and predictive renewal | `fixedForecastCanRemainAdequate`; no universal depletion claim |
| IR-G1 | open_formalization_gate | Termhood and canonical migration | No binding promotion or exact-source promotion-readiness attestation |

## Resume the PR review

Standing and Recognition have been discussed; Authority, Power, Institution, and
Succession arose from that discussion. The earlier termhood sweep already addressed
the withdrawn composites. Internal Activity Selection was discussed earlier; its
temporal selection-ordering boundary remains open and is not settled by this dossier.
The next unvisited surviving introduction is **Attention (D114)**, followed by
Sustained Attention, Love, Care, and Respect.
