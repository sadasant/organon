---
type: formal-build-receipt
status: verified
canonicality: noncanonical
created: 2026-08-02
updated: 2026-08-02
repository_commit: "d4349463435b605c944df1493a8253ed2ea08784"
---
# Lean Spike Build Receipt

This receipt records external Evidence for the noncanonical Lean spike. It does not promote the spike over [Daniel's Ontology v0.11](../ontology.md).

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
DanielOntology v0.11 spike: ontology, consciousness, and operationalization countermodels elaborated
```

The Lean sources contain no `sorry`, `admit`, or `axiom` declaration. The formal shadow models candidate conditions, Consciousness Attributions, and Order-indexed Consciousness Designations without defining a universal consciousness predicate. It also constructs a discriminating Operationalization whose selected Transformation occurs in a Causal path. Its finite countermodels establish the named anti-entailments: Attribution and Designation do not entail candidate obtainment; non-designation does not decide candidate obtainment; and Operationalization or occurrence of its selected output entails neither Map fidelity nor admission as Evidence. The local fidelity and Evidence predicates do not constitute complete formalizations of those ontology regions.

The repository commit attested by this receipt is `d4349463435b605c944df1493a8253ed2ea08784`.

## Source digests

- `DanielOntology.lean`: `e351a893ebd4a016e0578f33ee02a4537e46c6b5d6295d000a5322ea261ef8af`
- `Consciousness.lean`: `1ce88fce1943039368d595c260ab74a7fd499f1d66513af00bce1238e1b80976`
- `Operationalization.lean`: `f9ccc4233423e3f4806dfad588167e540fc1fcff9680708b7ab7bbd931c59ea8`
- `Model.lean`: `d28f07a1734e8f4b7a38ce8d117cf5e83833968b2d6b13daaaf5dc484e470591`
- `lakefile.toml`: `667839d47a079dded0cd81417812777bb1e8fc264fbe33bc3af5812a4448b677`
- `lean-toolchain`: `54727eec5cba149c18842e6deb5c41b369d66455c93ce135d7d5347c782b2325`
