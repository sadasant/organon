# Term Provenance

This ledger records why each stable Organon term is present. It establishes lineage, not truth. A term may be recoverable from Daniel's essays, adopted through direct review, repaired after formalization, or sharpened by an external critique; none of those facts makes its definition correct by itself.

The machine-readable coverage ledger is [terms.json](./terms.json). Every `organon:*` identifier in the binding [term registry](../ontology/terms.yaml) must occur exactly once in that ledger. The semantic checker rejects missing, duplicated, or unknown terms and unknown source identifiers.

## Provenance bases

- `corpus-extraction`: the recurring distinction was extracted from one or more published essays indexed by [Essay Corpus](./essays.md).
- `adopted-commitment`: Daniel directly selected or corrected the binding distinction during ontology review.
- `formalization-finding`: Lean exposed a commitment, collapse, or missing dependency that the prose then adopted.
- `review-repair`: adversarial review exposed a local ambiguity, collision, or incompleteness that the binding system repaired.

The sources are deliberately coarse. This is not a claim that each article contains the current definition verbatim. It is a falsifiable record of the intellectual and review surfaces from which the current term was consolidated.

## Maintenance

When a term changes meaning, update its definition, registry dependencies, provenance entry, and changelog together. When a new term has no honest source, label its basis as a new adopted commitment rather than manufacturing ancestry.

## October 7 PR18 repair and proposal preservation

D111's exact alternative occurrences and constructive availability, and D112's Configuration typing, come from the preserved local formalization and independent review findings recorded in [formal decisions](../ontology/formal/decisions.md). Existing adopted lineage remains intact. [Self/Auto](../proposals/self-auto.md) remains a nonbinding proposal and introduces no adopted registry/provenance identifiers.

## October 11 Intention withdrawal

Daniel withdrew `organon:Intention` (D113) and its dependent C40 after a general Lean reduction exposed no distinct mechanism beyond an existing Causal Contribution, bodily membership, and a freely assigned referent. No other registered term depends on it. The name does not establish desire, endorsement, or goal pursuit; those premises were not added to rescue it. The [nonbinding example](../ontology/formal/RepresentationActivityExample.lean) preserves the old record, inverse conversions, and achieved/unachieved referents. D113 and C40 are retired, not reassigned; historical snapshots retain their original identifiers. There is no replacement canonical term.

## October 11 Fully Exercisable Permission withdrawal

Daniel withdrew `organon:FullyExercisablePermission` (D061) as a named universal condition over Exercisability, without a replacement term or identifier reassignment. Its earlier v0.9 review-repair lineage remains in history. The [nonbinding example](../ontology/formal/Model.lean) fixes one Permission, time, and resource Configuration and distinguishes individual coverage from jointly funding two operations. No registered term, commitment, or profile root depends on the retired term. Permission and Exercisability remain binding; authorization still does not supply Capability.

## October 11 completed termhood sweep

Daniel authorized withdrawing Constituted Exercise (D077), Embodied Self-Governance (D112), Absolute Attention (D116), and C39 after the recommendation pass. The first remains an example of an actual Authority-backed Action; the bodily-selection record survives unchanged under `NonbindingExamples` in [AttentionLoveCare.lean](../ontology/formal/AttentionLoveCare.lean). Full coverage is a derived condition of Attention, with a general equivalence to the historical wrapper; C41/C42 retain their partiality and Action-limit meanings without D116. Proposal statements AC-D1, AC-D5, and AC-C1 are retired too. None of these identifiers is reassigned and no replacement term is introduced.

Standing and Recognition retain their institutional lineage. Their formal separation now matches placement versus recording: [BridgeRelations.lean](../ontology/formal/BridgeRelations.lean) witnesses unrecorded Standing and a record that supplies neither Standing nor Recognition. Constituent Exercise and Constituent Sovereignty remain binding under their existing names and scopes; the latter is a derived institutional profile, not an additional primitive.
