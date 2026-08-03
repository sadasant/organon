---
type: formal-build-receipt
status: verified
canonicality: noncanonical
created: 2026-08-02
updated: 2026-08-03
repository_commit: "67cb38820ca0d00e64f02a2ff567535d04345173"
---
# Lean Spike Build Receipt

This receipt records external Evidence for the noncanonical Lean spike. It does not promote the spike over [Daniel's Ontology v0.15](../ontology.md).

## Toolchain

- Lean: `4.30.0`, arm64 macOS
- Commit: `d024af099ca4bf2c86f649261ebf59565dc8c622`
- Project pin: `leanprover/lean4:v4.30.0`
- Local Elan override: `organon-lean-4.30.0`

## Verification

From `ontology/formal/` at the repository root:

```sh
lake build
lake exe ontology_check
```

Result: all 18 build jobs completed successfully. The executable printed:

```text
DanielOntology v0.15 spike: ontology, consciousness, operationalization, World, Substrate, Truth, Trust, Alignment, adaptive knowledge, epistemic, moral, sovereignty, and valuation countermodels elaborated
```

The Lean sources contain no `sorry`, `admit`, or `axiom` declaration. The existing formal witnesses remain intact: consciousness candidate/Attribution/Designation separation; discriminating Operationalization; participant-bound World access; ordered Substrate Persistence; Truth without modeled Agent access; accepted Trust versus involuntary Dependence; profile-scoped Alignment; joined adaptive Intelligence; useful-false Operative Knowledge; dormant Records; copied Records without recipient knowledge; and inter-agent plus self-transmission.

The v0.15 shadow additionally constructs one Factive Operative Knowledge instance whose load-bearing Record carries the exact true Claim; one Warranted Knowledge instance with joined Observation, independent Witness, support, Rule, Order, and Admission; a useful operative falsehood that cannot inhabit the factive profile; a true Claim with no operative path; and a factive instance that cannot inhabit Warranted Knowledge under a closed Admission predicate. It constructs moral Attributions over obtaining and non-obtaining candidates, a Designation whose candidate does not obtain, a silent Order under which either candidate result remains possible, and Designation without downstream protection. It constructs one combined sovereignty world plus four profile-only worlds: each of Constituent, Constituted, Boundary, and External Sovereignty is inhabited while the other three structures are uninhabitable in the corresponding world. It also constructs Preference without utility representation, a Utility Measure without modeled Preference, an observed choice that differs from the preferred option, Price without exchange or moral worth, and institutional valuation without moral worth.

Proposal-local evidence, sovereignty, own-Principal, observed-choice, exchange, and moral-worth predicates remain formal shadows rather than complete joins to every core Organon structure. Reality, universal Claim semantics, universal moral conditions, Action attribution, complete Evidence parity, Interior-and-Boundary Exposure, Action-to-Change Consequence, complete Sense-to-Perception access, fidelity, carrier realization, Alignment-profile composition, completeness and provenance of external Rule encodings, runtime construction, temporal ordering of transmission stages, universal semantic preservation, international-law sufficiency, preference revelation, expected utility, market clearing, generic Knowledge, generic Sovereignty, and generic Value remain open formalization gates.

The repository commit attested by this receipt is `67cb38820ca0d00e64f02a2ff567535d04345173`.

## Source digests

- `DanielOntology.lean`: `e351a893ebd4a016e0578f33ee02a4537e46c6b5d6295d000a5322ea261ef8af`
- `Consciousness.lean`: `1ce88fce1943039368d595c260ab74a7fd499f1d66513af00bce1238e1b80976`
- `Operationalization.lean`: `f9ccc4233423e3f4806dfad588167e540fc1fcff9680708b7ab7bbd931c59ea8`
- `WorldSubstrate.lean`: `8898e43b317077ff83a749668fa90d510371589b651b47b00ff8169656ab1da2`
- `TruthTrustAlignment.lean`: `f21a878db97b0bb503d36189533e66287d02e7bd8b8e53d88a80202f79f4f9c4`
- `IntelligenceKnowledge.lean`: `bc0ad1caa81adb25316f79aecd5011e32cf94cc73e1e046f7e13bcd10779aee8`
- `QuarantineProfiles.lean`: `f3844c508a59dc4ffd0731501d867d059b416d2819bdc321ef275bb8933cfebe`
- `Model.lean`: `373091ccefb3db379f2fced35dcc007ce0fc2503abd7a15381fc89e8a147e0eb`
- `lakefile.toml`: `3c9e2d5bc40befd81d605e3f58d616cf6f8351d18e5028953e6559328a54ffcb`
- `lean-toolchain`: `54727eec5cba149c18842e6deb5c41b369d66455c93ce135d7d5347c782b2325`
