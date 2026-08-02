---
type: formal-ontology-spike
status: noncanonical
created: 2026-08-02
updated: 2026-08-02
prose_ontology: "[[Contexts/Organon/Daniels-Ontology]]"
---
# Daniel's Ontology - Lean Spike

This directory tests whether [[Contexts/Organon/Daniels-Ontology|Daniel's Ontology v0.7]] can become a proof-checked Lean artifact. It is deliberately **noncanonical**. The Markdown ontology remains binding until Daniel explicitly promotes a formal artifact after term-for-term parity, a complete model, clean builds without `sorry`, and a stable Markdown projection.

## Included in the spike

- A local encoding of A1-A5 using an uninhabited-type predicate, `Nonempty`, and an inhabited `Mark`.
- Explicit acknowledgement that `Empty` is an uninhabited type inside Lean's present metatheory, not absolute Absence.
- Classical exhaustiveness of `Absent α ∨ Present α`, with the classical commitment visible in the theorem.
- State indices separated from first-class asymmetric Direction.
- Constraint, Invariant, Boundary, and Entity as dependent proof-carrying structures.
- Specification determinacy without an implicit testing Agent.
- Permission as a dependent record relating Principal, Agent, Capability, Action, Scope, and Interval.
- One finite inhabited model for Entity and Permission.

See [[Contexts/Organon/Ontology/Formalization-Decisions|Formalization Decisions]] for commitments exposed by Lean and [[Contexts/Organon/Ontology/Build-Receipt|Build Receipt]] for reproducible evidence.

## Canonicality boundary

The Lean source makes formal Claims. Successful elaboration by the pinned compiler is external Evidence that those Claims type-check. The theorem `presenceObtains` witnesses an inhabited mark inside Lean; the compiler receipt witnesses that the file itself was successfully elaborated. These levels must not be collapsed.

The formal spike does not yet cover the complete ontology, generate the Markdown projection, prove satisfiability beyond its small model, or settle identity through time beyond a Boundary-indexed Invariant.

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
