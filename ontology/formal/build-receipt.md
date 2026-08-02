---
type: formal-build-receipt
status: verified
canonicality: noncanonical
created: 2026-08-02
updated: 2026-08-02
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
DanielOntology v0.9 spike: finite ontology and consciousness anti-collapse models elaborated
```

The Lean sources contain no `sorry`, `admit`, or `axiom` declaration. The finite models construct Missingness; an Entity whose Boundary admits activation and rejects identity-breaking failure; a Boolean Specification with evaluated positive and negative cases; one institutional Permission; one contextual PermissionExercise; and a consciousness proposal witness in which attribution, institutional recognition, and the candidate condition remain logically distinct.

## Source digests

- `DanielOntology.lean`: `e351a893ebd4a016e0578f33ee02a4537e46c6b5d6295d000a5322ea261ef8af`
- `Consciousness.lean`: `d6145862060dc7b7e59f1e7ad789f7285188742d95b1e8e5b9daf9fd55ca1746`
- `Model.lean`: `a97b55a5e8a5c93113d95c97617f1f744651e8367fcca7a7cd8e8b7949a691d9`
- `lakefile.toml`: `832aee6e08f6d518b17838932512a96374e0ca071c8f45ad175a573cab5fbb5e`
- `lean-toolchain`: `54727eec5cba149c18842e6deb5c41b369d66455c93ce135d7d5347c782b2325`
