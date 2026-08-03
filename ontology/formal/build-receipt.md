---
type: formal-build-receipt
status: verified
canonicality: noncanonical
created: 2026-08-02
updated: 2026-08-03
repository_commit: "e2bc81fdc17d604e230d3f4d615f069e17945b8b"
---
# Lean Spike Build Receipt

This receipt records external Evidence for the noncanonical Lean spike. It does not promote the spike over [Daniel's Ontology v0.13](../ontology.md).

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

Result: all 14 build jobs completed successfully. The executable printed:

```text
DanielOntology v0.13 spike: ontology, consciousness, operationalization, World, Substrate, Truth, Trust, and Alignment countermodels elaborated
```

The Lean sources contain no `sorry`, `admit`, or `axiom` declaration. The formal shadow models candidate conditions, Consciousness Attributions, and Order-indexed Consciousness Designations without defining a universal consciousness predicate. It constructs a discriminating Operationalization whose selected Transformation occurs in a Causal path; a scoped World whose participant-bound access paths begin at the participant's current State and witness advertised availability on actual Transformations; a contextual Substrate whose source Invariant is preserved across at least two directionally ordered States; a true toy Claim whose target no modeled Agent can supply; a Trust witness whose trustee-supplied future Transformation occurs on an actual Causal path and supplies its Consequence without confidence or Permission; and an Alignment witness accepted by one profile and rejected by another. Its finite countermodels establish only the named anti-entailments. Reality, complete Claim semantics, Interior-and-Boundary Trust Exposure, complete Sense-to-Perception access, fidelity, carrier realization, and Alignment-profile composition remain open formalization gates.

The repository commit attested by this receipt is `e2bc81fdc17d604e230d3f4d615f069e17945b8b`.

## Source digests

- `DanielOntology.lean`: `e351a893ebd4a016e0578f33ee02a4537e46c6b5d6295d000a5322ea261ef8af`
- `Consciousness.lean`: `1ce88fce1943039368d595c260ab74a7fd499f1d66513af00bce1238e1b80976`
- `Operationalization.lean`: `f9ccc4233423e3f4806dfad588167e540fc1fcff9680708b7ab7bbd931c59ea8`
- `WorldSubstrate.lean`: `8898e43b317077ff83a749668fa90d510371589b651b47b00ff8169656ab1da2`
- `TruthTrustAlignment.lean`: `9bbd8ad84826e977f8ec08ff9c271b0ed1617af1e3f3f8bd5616e1ea3faccff8`
- `Model.lean`: `971707c18bd80a00f6aace9dae6571dac90d17fe1cd9859089afdf23663b7a53`
- `lakefile.toml`: `83eb594006fcfe31be329e1c415743fc5d5b4ddd1a11366df5ed7e2642ed69ac`
- `lean-toolchain`: `54727eec5cba149c18842e6deb5c41b369d66455c93ce135d7d5347c782b2325`
