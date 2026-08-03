---
type: finite-model-report
status: verified
canonicality: noncanonical
created: 2026-08-03
updated: 2026-08-03
ontology_version: "0.15"
---
# Finite Global Inhabitant Report

## Result

The complete Organon v0.15 registry has a nondegenerate inhabitant under the finite relational projection defined by [`registry-global.als`](./registry-global.als). Alloy 6.2.0 with Glucose returned one satisfying instance for `NondegenerateGlobalInhabitant`; the independently checked constructive witness is [`registry-global-instance.json`](./registry-global-instance.json).

The result establishes that the exact registry topology and the obligations encoded as Alloy facts are jointly satisfiable in one finite structure. It does not establish satisfiability of every sentence in the binding prose.

## What “complete” means

The model contains every one of the 104 registered terms with its exact `depends_on` edges, every one of the 34 typed commitments with its exact term and commitment dependencies, and every one of the 50 relation signatures declared in the ontology. Every non-Absence term has at least one classified node. Absence remains represented as registry metadata but has no inhabitant.

The relation signatures are manually normalized into finite role slots because the canonical Markdown table is written for readers rather than as a parser-complete type language. Generation fails if the normalized map omits or invents a declared relation name, and the independent checker requires one well-typed witness for every declared signature.

## What “nondegenerate” means

The inhabitant has 110 distinct classified nodes rather than one universal object. Presence, State, Entity, and Order are explicitly distinct. Repeated typed roles receive distinct participants where needed. Two additional configurations join the causal and institutional regions, and relation witnesses share participants across events. Every relation signature has one typed output and contiguous typed argument slots.

The model also carries six positive profile joins, 62 explicit anti-entailment counterexamples, and 10 disjointness obligations. These stop a satisfying instance from being obtained merely by classifying every node as everything.

## The failed first inhabitant

The first constructive pass failed C14. It supplied separate Claim, Representation, Rule, Presence, and Specification witnesses, but no single node carried that complete antecedent while remaining outside Truth. The checker rejected the instance. The repaired model adds an explicit compound counterexample node, making the anti-entailment load-bearing rather than assuming that five unrelated examples jointly refute an implication.

An earlier Alloy encoding also made `expects` total over every role slot, accidentally requiring every relation definition to type all eleven slots. Changing the field from `some Term` to `set Term` restored the intended partial role map. Both failures were modeling defects found before the satisfying result.

## Commitment coverage

Nineteen commitments contribute executable constraints: C1, C4-C7, C10-C23. Their current coverage includes non-inhabited Absence, positive joins, class disjointness, and exact anti-entailment witnesses. C2, C3, C8, and C9 remain metadata-only despite being binding constraints because their temporal, boundary, and invariance semantics exceed the present classification layer.

The remaining metadata-only commitments are A1-A5, U1, Pj1-Pj4, H1, C2, C3, C8, and C9. Their identifiers, types, and dependencies are exact, but this experiment does not claim to execute their full meaning.

## Solver evidence

- Analyzer: Alloy 6.2.0 official macOS arm64 distribution
- Distribution SHA-256: `d7ce578954e24f8faa81bd8ad4fb56dd146555a39740fed3ef8c9d34a7333f63`
- Solver: Glucose
- Command: `run NondegenerateGlobalInhabitant for 0 Int`
- Result: satisfiable, one solution and one instance
- Solver-reported duration: 33,456 ms

The compact [`analyzer-receipt.json`](./analyzer-receipt.json) preserves exact source digests without committing Alloy's much larger raw instance envelope. The constructive JSON witness is the reviewable instance; the Alloy result is independent confirmation that its generated facts admit an inhabitant.

## What remains unproved

The model does not prove complete prose-to-relation parity, the metaphysical axioms, temporal Persistence, identity through change, the semantic correctness of a Specification, causal efficacy, evidentiary independence, or universal institutional validity. It does not identify one finite carrier with Reality. It does not show that the current role normalization is uniquely correct.

The next useful work is falsification-first: promote one metadata-only commitment at a time into executable relations, require its witness to join the same load-bearing participants, and rerun the global search. A future contradiction would locate either an inconsistent commitment or an unfaithful translation; a future satisfying instance would strengthen the result without retroactively enlarging this one.
