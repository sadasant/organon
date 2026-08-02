---
type: formal-build-receipt
status: verified
canonicality: noncanonical
created: 2026-08-02
updated: 2026-08-02
---
# Lean Spike Build Receipt

This receipt records external Evidence for the noncanonical Lean spike. It does not promote the spike over [Daniel's Ontology v0.8](../Daniels-Ontology.md).

## Toolchain

- Lean: `4.30.0`, arm64 macOS
- Commit: `d024af099ca4bf2c86f649261ebf59565dc8c622`
- Project pin: `leanprover/lean4:v4.30.0`
- Local Elan override: `organon-lean-4.30.0`

## Verification

From `Ontology/` at the repository root:

```sh
lake build
lake exe ontology_check
```

Result: all six build jobs completed successfully. The executable printed:

```text
DanielOntology formal spike: finite model elaborated
```

The Lean sources contain no `sorry`, `admit`, or `axiom` declaration. The finite model constructs inhabited instances of Missingness, one concrete Entity, one institutional Permission over a toy Agent, and one separately coherent ExercisablePermission.

## Source digests

- `DanielOntology.lean`: `fb04120722670999d75b7be3c21df0c6e7a387f8c4b365ee14b2fff3ef643890`
- `Model.lean`: `9d79c46095a9b5eb7347bb44d1016743879c566027d123bc4d50f93752d9f5e6`
- `lakefile.toml`: `2a2a0a5688bc5c8259cd93dc78d454275c681e75a43fae16def404304dc8d65e`
- `lean-toolchain`: `54727eec5cba149c18842e6deb5c41b369d66455c93ce135d7d5347c782b2325`
