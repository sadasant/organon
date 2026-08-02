---
type: formal-ontology-spike
status: noncanonical
created: 2026-08-02
updated: 2026-08-02
prose_ontology: "../ontology.md"
---
# Daniel's Ontology - Lean Spike

This directory tests whether [Daniel's Ontology v0.9](../ontology.md) can become a proof-checked Lean artifact. It is deliberately **noncanonical**. The Markdown ontology remains binding until Daniel explicitly promotes a formal artifact after term-for-term parity, a complete model, clean builds without `sorry`, and a stable Markdown projection.

## Included in the spike

- A local encoding of A1-A5 using an uninhabited-type predicate, `Nonempty`, and an inhabited `Mark`.
- Explicit acknowledgement that `Empty` is an uninhabited type inside Lean's present metatheory, not absolute Absence.
- Classical exhaustiveness of `Absent α ∨ Present α`, with the classical commitment visible in the theorem.
- State is the actual carrier of Direction, Transformation, Invariant, Boundary, and Entity; no object-level numeric index stands in for metalinguistic order.
- Transformation is indexed by Direction, making shared Direction a type-level fact for Causal paths.
- Constraint, Invariant, Boundary, and Entity as dependent proof-carrying structures.
- Causal paths compose through an explicit `FeedRelation`; consecutive States need not be equal.
- Specification carries a Boolean decision procedure, a correctness proof, and scope coherence.
- Capability is parameterized by Context rather than treated as an intrinsic possession.
- Permission is produced through an Order-indexed chain of standing-aware claim, Authority, Grant, and Admission; exercise separately requires current Capability and absence of Revocation.
- Witness independence is scoped to witness, claimant, Claim, Observation, and Order, with mechanical non-control and institutional non-authority.
- One finite model admits an identity-preserving Transformation, rejects an identity-breaking one, evaluates a Specification, and inhabits Permission and PermissionExercise.
- A separate consciousness-proposal shadow distinguishes a candidate condition, its attribution, and Order-indexed recognition, with finite witnesses that recognition does not entail the candidate and non-recognition does not decide it.

See [Formalization Decisions](./decisions.md) for commitments exposed by Lean and [Build Receipt](./build-receipt.md) for reproducible evidence.

## Canonicality boundary

The Lean source makes formal Claims. Successful elaboration by the pinned compiler is external Evidence that those Claims type-check. The theorem `presenceObtains` witnesses an inhabited mark inside Lean; the compiler receipt witnesses that the file itself was successfully elaborated. These levels must not be collapsed.

The formal spike does not yet cover the complete ontology, generate the Markdown projection, prove satisfiability beyond its small models, settle identity through time beyond a Boundary-indexed Invariant, or define a universal consciousness condition.

## Toolchain

- Project pin: `leanprover/lean4:v4.30.0`
- Verified local compiler: Lean 4.30.0, commit `d024af099ca4bf2c86f649261ebf59565dc8c622`
- Downloaded archive SHA-256: `072dca4a38fbc0d3cedb96fea886cc243b424f2bd16247596200b9a9ab93f0f5`

## Build

From this directory:

```sh
lake build
lake exe ontology_check
```

The local machine uses an Elan override named `organon-lean-4.30.0` because Elan's channel installer failed before extraction. The checked-in toolchain pin remains the standard portable identifier.

## Promotion gates

1. Every binding Markdown term maps to a Lean declaration or an explicitly metatheoretic statement.
2. No `sorry`, `admit`, or undeclared axiom remains.
3. At least one complete inhabited model elaborates.
4. Anti-collapse obligations are theorems or type-level impossibilities.
5. Markdown is rendered deterministically from Lean declarations and doc-comments.
6. The generated Markdown is readable in Obsidian and has stable internal links.
7. Daniel explicitly promotes Lean from experimental artifact to canonical ontology.
