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
DanielOntology v0.9 spike: nontrivial finite model elaborated
```

The Lean sources contain no `sorry`, `admit`, or `axiom` declaration. The finite model constructs Missingness; an Entity whose Boundary admits activation and rejects identity-breaking failure; a Boolean Specification with evaluated positive and negative cases; one institutional Permission; and one contextual PermissionExercise.

## Source digests

- `DanielOntology.lean`: `e351a893ebd4a016e0578f33ee02a4537e46c6b5d6295d000a5322ea261ef8af`
- `Model.lean`: `482b83d374704f6c549effbe85044309c76208fca797ac97d47cd88dab42ff8f`
- `lakefile.toml`: `2a2a0a5688bc5c8259cd93dc78d454275c681e75a43fae16def404304dc8d65e`
- `lean-toolchain`: `54727eec5cba149c18842e6deb5c41b369d66455c93ce135d7d5347c782b2325`
