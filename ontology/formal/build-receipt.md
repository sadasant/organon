---
type: formal-build-receipt
status: verified
canonicality: noncanonical
created: 2026-08-02
updated: 2026-08-02
repository_commit: "c236cb74753a81762a18de0f5bf757d8dc3c922c"
---
# Lean Spike Build Receipt

This receipt records external Evidence for the noncanonical Lean spike. It does not promote the spike over [Daniel's Ontology v0.9](../ontology.md).

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
DanielOntology v0.9 spike: ontology and consciousness attribution-designation countermodels elaborated
```

The Lean sources contain no `sorry`, `admit`, or `axiom` declaration. The formal shadow models candidate conditions, Consciousness Attributions, and Order-indexed Consciousness Designations without defining a universal consciousness predicate. Its finite countermodels show that neither Attribution nor Designation entails candidate obtainment, and that candidate obtainment does not entail Designation. Designation remains institutionally dependent on an admitted Attribution. The artifact does not yet formalize evidentiary disposition.

The repository commit attested by this receipt is `c236cb74753a81762a18de0f5bf757d8dc3c922c`.

## Source digests

- `DanielOntology.lean`: `e351a893ebd4a016e0578f33ee02a4537e46c6b5d6295d000a5322ea261ef8af`
- `Consciousness.lean`: `1ce88fce1943039368d595c260ab74a7fd499f1d66513af00bce1238e1b80976`
- `Model.lean`: `5c11759209bffa5a75f58a35230d9638e487d5d0d6c959d44234ec9b0d367e25`
- `lakefile.toml`: `832aee6e08f6d518b17838932512a96374e0ca071c8f45ad175a573cab5fbb5e`
- `lean-toolchain`: `54727eec5cba149c18842e6deb5c41b369d66455c93ce135d7d5347c782b2325`
