# Organon v0.9 Adversarial Review

This record preserves the actionable findings of the external review received on 2026-08-02. The private attachment is not a public repository dependency; this file records the accepted findings and their disposition.

## Accepted findings

| Finding | Disposition |
| --- | --- |
| Forward references and editorial term collisions violated Organon's own rules. | Repaired in the prose; semantic lint now checks definition order and persona-field collisions. |
| Capitalization was too ambiguous to serve as adoption syntax. | Stable `organon:*` identifiers, anchors, typed claims, and explicit mappings now form the semantic seam. |
| Permission lacked an Order-relative derivation. | Rebuilt around Standing, Authority, Permission Claim, Grant, Admission, Permission, Revocation, and Permission Exercise. |
| Witness independence was treated too much like an intrinsic property. | Recast as `IndependentFor`, scoped to the Witness, claimant, Claim, Observation, Order, controls, Authority, and admissibility provenance. |
| Specification's determinacy needed executable content and scope coherence. | Lean now carries a Boolean decision procedure, correctness proof, and conformity-within-scope proof, with concrete evaluations in the model. |
| Causal chaining should not require State equality. | Added Feeds in prose and a typed `FeedRelation` in Lean. |
| Capability lacked operating context. | Capability is now contextual in prose and Lean. |
| The finite model was too trivial to test Boundary semantics. | The v0.9 model admits activation, rejects identity-breaking failure, and proves both outcomes. |
| Adoption needed to be explicit and machine-checkable. | Added profiles, a manifest schema, an example, and a dependency-closure checker. |
| Source lineage needed term-level coverage. | Added a coverage-checked provenance ledger for all stable terms. |

## Deliberate limits

Lean remains noncanonical and partial. The adoption checker establishes manifest coherence against a pinned registry; it does not prove that a repository's prose accurately describes its implementation. Project review therefore still requires evidence inspection and an explicit exact/refinement/conflict/unmapped judgment.
