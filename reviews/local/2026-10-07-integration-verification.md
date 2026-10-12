# PR18 combined-source verification

Implementation commit: `1a882da27fa4797b536ced4a3fd50fe39d2bc09d`. Parent PR18 head: `7a7afa21d6bbc8ecf2008c562425abeac0e51574`. Evidence in this later commit attests that implementation. Original `revision/pr18-auto-governance` worktree and local drafts are preserved.

Daniel authorized integration and normal push for review, requested retaining both contributions, and deferred cleanup of their combined effects. No force push, merge, site/PDF update, vocabulary-wide rename, or further semantic redesign is performed.

## Incorporated work

- `proposals/self-auto.md` retains proposed Self, Auto, Governance, Self-governance, Autogovernance, Autonomy and Self-perception; the full old candidate ontology, registry, definition packet, baseline records and limited historical shadow are preserved under `reviews/local/`. Original Markdown bytes are available as `.original.txt`; relocated Markdown links remain usable. Historical snapshot validators and source-pinned reports are not current validation.
- D111 joins actual changed/contrast last occurrences and constructive availability; D112 is Configuration instead of Agent/Action Capability. Embodied Perspective premises remain intact. EC-D5 exposes the strengthened joins.
- `PR18Governance.lean` is in the default build, with an inhabited actual-Sense/internal-Governance/Interpretation/Action profile, own-Entity perception, negative cases and complete common-Scope/Boundary admission across declared paths. It is not a generic Auto or universal Autonomy proof.
- Daniel's `AttentionLoveCare.lean` and `AttentionLoveCareContracts.lean` are byte-identical to the parent PR18 source. Snapshot-local Attention, behavioral Action independence and record-independent participant classification are preserved.

## Checks

From repository root: `python3 scripts/check-links.py`, `check-semantics.py`, `check-proposals.py`, `check-formal-receipt.py`, `check-structure.py`, and `check-adoption.py examples/organon-adoption.json --repo-root .` pass. Prompt, reduction, registry-reflection and algebra projections are regenerated; algebra and build receipt pin the implementation above. `git diff --check` passes.

From `ontology/formal`: `lake build` passes all 38 jobs; `lake exe ontology_check` passes. `lake env lean -o .lake/build/lib/lean/PR18ReviewDraft.olean PR18ReviewDraft.lean` compiles the limited historical shadow separately. `lake env lean ../../reviews/local/2026-10-07-integrated-axiom-audit.lean` checks 2,436 project theorem declarations, including the repaired profile and historical draft, with zero declared project axioms and only `propext`, `Classical.choice`, `Quot.sound` dependencies. Lean 4.30.0 compiler commit is `d024af099ca4bf2c86f649261ebf59565dc8c622`. A code-token scan of all 20 top-level formal Lean sources finds zero `sorry`, `admit`, `sorryAx`, `axiom` or `opaque` tokens outside comments. The raw textual scan finds only Daniel's English comment “both Boundaries admit every Transformation”; it is not a proof placeholder.

`python3 scripts/check-ontology-frameworks.py` passes its separate 30-theorem audit. `/tmp/organon-framework-evals-py312/bin/python -m pytest evals --tb=short`: **68 passed, 1 failed**. The only failure is `test_promoted_schema_v2_manifest_has_exact_source_review`, reflecting the intentionally stale historical promotion review hashes described below. Source selectors are refreshed to actual bytes; deterministic evaluation snapshots preserve history and remain incomplete with artifact promotion on hold. Model judgments were not rerun.

## Remaining failed check

`python3 scripts/check-promotion-review.py` fails for changed source digests in both historical promotion records (`attention-love-care.json`, `embodied-consciousness.json`). This failure is preserved honestly: the older records are not a renewed review of the integrated source. The integration does not mark them green or manufacture a new independent approval. Generic Auto's organizational role, generic Governance role realization and universal participant identity remain the existing proposal/projection boundaries; Consciousness is deferred. The current reading proposal and historical candidates coexist for Daniel's review.
