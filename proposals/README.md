# Quarantine Proposals

Quarantined vocabulary enters Organon through one concept-specific pull request at a time. The pull request is the review boundary; a proposal is nonbinding until Daniel explicitly accepts a dependency-closed change to the ontology and registry.

## Required shape

Each proposal must state:

1. The problem the concept would solve inside Organon.
2. The candidate's ontological type and exact dependencies.
3. Which candidate claims are definitions, hypotheses, observations, or institutional Rules.
4. What Evidence would bear on the proposal without being mistaken for the proposed concept.
5. Known collapses, contradictions, and unresolved terms.
6. The smallest promotable change, including anti-collapse constraints.
7. Evidence and formalization gates that remain open.

## Promotion outcomes

- **Promote:** the proposal supplies a dependency-closed term and passes semantic, provenance, and formal checks proportionate to its claim.
- **Partial promotion:** supporting machinery enters Organon while the headline concept remains quarantined.
- **Remain quarantined:** the proposal sharpens the problem but cannot yet define the concept without circularity or collapse.
- **Reject:** the candidate duplicates existing machinery or requires commitments Organon refuses.

A merged proposal does not itself promote a term. Promotion requires a separate explicit ontology change in the same pull request or a later one, clearly identified as binding.

Proposal manifests declare `introduced_terms`. Dependency closure is checked against the binding registry with those terms removed, so a dossier cannot validate by depending on the same-branch promotion it is meant to justify. Later statements must depend on the dossier's earlier statement IDs until promotion is independently established.

Lifecycle status is historical rather than permanently fixed at `ready-for-review`. Supported states are `draft`, `ready-for-review`, `partially-promoted`, `promoted`, `rejected`, and `superseded`. A promoted dossier remains nonbinding provenance; its status records what happened, while the ontology and registry enact the binding result.

## Current dossiers

- [Consciousness](./consciousness.md): partially promoted Attribution and Designation while the underlying condition remains quarantined.
- [World and Substrate](./world-and-substrate.md): promoted participant-scoped World and contextual Substrate, with the exact limits of their formal witnesses preserved.
- [Truth, Trust, and Alignment](./truth-trust-and-alignment.md): promoted as separate correspondence, exposure, and specified-conformity Relations, with complete semantics and profile dynamics gated.
