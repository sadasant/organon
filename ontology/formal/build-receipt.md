---
type: formal-build-receipt
status: verified
canonicality: noncanonical
created: 2026-08-02
updated: 2026-08-03
repository_commit: "dea469071fe5350157670e84136b84f8e961e245"
---
# Lean Spike Build Receipt

This receipt records external Evidence for the noncanonical Lean spike. It does not promote the spike over [Daniel's Ontology v0.14](../ontology.md).

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

Result: all 16 build jobs completed successfully. The executable printed:

```text
DanielOntology v0.14 spike: ontology, consciousness, operationalization, World, Substrate, Truth, Trust, Alignment, Intelligence, Operative Knowledge, and Knowledge Transmission countermodels elaborated
```

The Lean sources contain no `sorry`, `admit`, or `axiom` declaration. The formal shadow models candidate conditions, Consciousness Attributions, and Order-indexed Consciousness Designations without defining a universal consciousness predicate. It constructs a discriminating Operationalization whose selected Transformation occurs in a Causal path; a scoped World whose participant-bound access paths begin at the participant's current State and witness advertised availability on actual Transformations; a contextual Substrate whose source Invariant is preserved across at least two directionally ordered States; a materially adequate true toy Claim whose target no modeled Agent can supply; one accepted causal Dependence without confidence or Permission; one confidence-bearing involuntary Dependence over the same participants that cannot inhabit Trust; one Alignment using the exact Representation of a false Claim; one JointSituation connecting a true Claim, its trusted contribution, and its aligned Representation; one joined adaptive case whose two States are absent from an explicit Rule encoding, whose first State proves Perception-to-Model, Memory-to-Model, Model-to-Interpretation, Interpretation-to-Action, and Action-to-Consequence counterfactual dependence, and whose two actual Consequences conform; one fixed pipeline that cannot satisfy the adaptive relation; one false Claim Record that forms locally successful Operative Knowledge through a Rule individually naming every toy State, while no Intelligence with that same Agent and Rule can be inhabited; one dormant context in which no Operative Knowledge can be inhabited; one copied Record that supplies no recipient knowledge; one inter-agent Knowledge Transmission preserving specified success while changing Record and Model; and one stage-distinct self-transmission using the same persistent Agent. Operative Knowledge effects receive only selected Actions, not Records. Alignment uses ordered roles rather than temporal Direction, and the formal Trust output remains `dependentOutput` rather than canonical Consequence. Reality, universal Claim semantics, Action attribution, Interior-and-Boundary Exposure, Action-to-Change Consequence, complete Sense-to-Perception access, fidelity, carrier realization, Alignment-profile composition, completeness and provenance of external Rule encodings, runtime construction, temporal ordering of transmission stages, universal semantic preservation, and factive knowledge remain open formalization gates.

The repository commit attested by this receipt is `dea469071fe5350157670e84136b84f8e961e245`.

## Source digests

- `DanielOntology.lean`: `e351a893ebd4a016e0578f33ee02a4537e46c6b5d6295d000a5322ea261ef8af`
- `Consciousness.lean`: `1ce88fce1943039368d595c260ab74a7fd499f1d66513af00bce1238e1b80976`
- `Operationalization.lean`: `f9ccc4233423e3f4806dfad588167e540fc1fcff9680708b7ab7bbd931c59ea8`
- `WorldSubstrate.lean`: `8898e43b317077ff83a749668fa90d510371589b651b47b00ff8169656ab1da2`
- `TruthTrustAlignment.lean`: `f21a878db97b0bb503d36189533e66287d02e7bd8b8e53d88a80202f79f4f9c4`
- `IntelligenceKnowledge.lean`: `bc0ad1caa81adb25316f79aecd5011e32cf94cc73e1e046f7e13bcd10779aee8`
- `Model.lean`: `715029704d25c0a9d8df764fb455d81ad956068918550d86e8efc5c4d391dca2`
- `lakefile.toml`: `ac115f883cdec00e7421e7ef128efdbbaf989ee82d7085e658f066837e0ed336`
- `lean-toolchain`: `54727eec5cba149c18842e6deb5c41b369d66455c93ce135d7d5347c782b2325`
