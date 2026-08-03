---
type: formal-build-receipt
status: verified
canonicality: noncanonical
created: 2026-08-02
updated: 2026-08-03
repository_commit: "5a7f89c4789154e112c149dff9db5062d7b11b40"
---
# Lean Spike Build Receipt

This receipt records external Evidence for the noncanonical Lean spike. It does not promote the spike over [Daniel's Ontology v0.12](../ontology.md).

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

Result: all build jobs completed successfully. The executable printed:

```text
DanielOntology v0.12 spike: ontology, consciousness, operationalization, World, and Substrate countermodels elaborated
```

The Lean sources contain no `sorry`, `admit`, or `axiom` declaration. The formal shadow models candidate conditions, Consciousness Attributions, and Order-indexed Consciousness Designations without defining a universal consciousness predicate. It constructs a discriminating Operationalization whose selected Transformation occurs in a Causal path; a scoped World whose participant-bound access paths begin at the participant's current State and witness advertised availability on actual Transformations; and a contextual Substrate whose source Invariant is preserved across at least two directionally ordered States. Its finite countermodels establish only the named anti-entailments: Attribution and Designation do not entail candidate obtainment; non-designation does not decide candidate obtainment; Operationalization or occurrence of its selected output entails neither Map fidelity nor admission as Evidence; a World Scope need not contain every inhabited State of its carrier type; causal access paths need not expose identical States; and ordered source Persistence does not entail preservation of the same Invariant in every supported output. Reality, complete Sense-to-Perception access, fidelity, and carrier-realization joins remain open formalization gates.

The repository commit attested by this receipt is `5a7f89c4789154e112c149dff9db5062d7b11b40`.

## Source digests

- `DanielOntology.lean`: `e351a893ebd4a016e0578f33ee02a4537e46c6b5d6295d000a5322ea261ef8af`
- `Consciousness.lean`: `1ce88fce1943039368d595c260ab74a7fd499f1d66513af00bce1238e1b80976`
- `Operationalization.lean`: `f9ccc4233423e3f4806dfad588167e540fc1fcff9680708b7ab7bbd931c59ea8`
- `WorldSubstrate.lean`: `8898e43b317077ff83a749668fa90d510371589b651b47b00ff8169656ab1da2`
- `Model.lean`: `a38644ffa86acbab9e35072dcd9a4cbf6fb6e22ddbcc2609c6ae7aa9edaa6c87`
- `lakefile.toml`: `f4e27425e578f2ae577842125f8728f26bed44af81d4604add7e99b5388092ce`
- `lean-toolchain`: `54727eec5cba149c18842e6deb5c41b369d66455c93ce135d7d5347c782b2325`
