---
type: formal-build-receipt
status: verified
canonicality: noncanonical
created: 2026-08-02
updated: 2026-08-02
---
# Lean Spike Build Receipt

This receipt records external Evidence for the noncanonical Lean spike. It does not promote the spike over [[Contexts/Organon/Daniels-Ontology|Daniel's Ontology v0.7]].

## Toolchain

- Lean: `4.30.0`, arm64 macOS
- Commit: `d024af099ca4bf2c86f649261ebf59565dc8c622`
- Project pin: `leanprover/lean4:v4.30.0`
- Local Elan override: `organon-lean-4.30.0`

## Verification

From `Contexts/Organon/Ontology`:

```sh
lake build
lake exe ontology_check
```

Result: all six build jobs completed successfully. The executable printed:

```text
DanielOntology formal spike: model elaborated
```

The Lean sources contain no `sorry`, `admit`, or `axiom` declaration. The model constructs inhabited instances of Missingness, Entity, and dependent Permission.

## Source digests

- `DanielOntology.lean`: `be079087e70b0d61aec1095c36b7340847a882bef525f48431e2dd3ce79776e7`
- `Model.lean`: `a4751db4d2c8878b7c70c1f7e0c239fc9906cafec41b29792b9a150f214ed9fd`
- `lakefile.toml`: `2a2a0a5688bc5c8259cd93dc78d454275c681e75a43fae16def404304dc8d65e`
- `lean-toolchain`: `54727eec5cba149c18842e6deb5c41b369d66455c93ce135d7d5347c782b2325`
