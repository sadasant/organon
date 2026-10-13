---
type: formal-build-receipt
status: verified
canonicality: noncanonical
created: 2026-08-02
updated: 2026-10-12
---
# Lean Spike Build Receipt

This receipt records the toolchain for the noncanonical Lean sources and the last
local verification. CI rebuilds every head with that toolchain and runs the
finite models and axiom audits; that build, not this file, is the evidence for
the current sources. The readable [ontology](../ontology.md) remains binding.
Earlier receipts and their counts remain in Git; they are not evidence for
current definitions.

## Toolchain

- Lean: `4.30.0`, x86_64 Linux orb
- Commit: `d024af099ca4bf2c86f649261ebf59565dc8c622`
- Project pin: `leanprover/lean4:v4.30.0`

## Current integration verification

On October 13, the Order/Configuration integration working sources passed `lake build` (**58 jobs**) and `lake exe ontology_check`. This adds three modules and nine promotion contracts. Exact reviewed sources and validation boundaries are recorded in the [integration review](../../reviews/promotion/order-and-configuration-integration.json); the earlier receipt below remains historical evidence, not a claim about current theorem counts.

## Previous local verification

On 2026-10-13, for the sources committed at `a253e0118e394220d2e5e444f85a159b0f70b884`, from `ontology/formal/`:

```sh
lake build
lake exe ontology_check
lake env lean -o .lake/build/lib/lean/PR18ReviewDraft.olean PR18ReviewDraft.lean
lake env lean ../../reviews/local/2026-10-07-integrated-axiom-audit.lean
```

The build completed successfully: **50 jobs**. The finite executable completed.
The separate historical draft was rebuilt before the integrated audit:

```text
PROJECT_AXIOM_AUDIT: 2582 project theorems checked; 0 declared project axioms; allowed only propext, Classical.choice, Quot.sound.
```

From the repository root, `python3 scripts/check-ontology-frameworks.py` passed
all **30 theorems**, with no proof placeholders or nonstandard axiom dependencies.
Compilation and axiom checks establish the recorded Lean claims, not complete
prose parity, empirical applicability, or downstream model quality.

## Current contracts and limits

- The registry contains **118 terms, 115 definitions and 53 commitments**.
  Current attention-dossier contracts are AC-D3, AC-D7 and AC-D8. The embodiment
  dossier retains eleven contracts with their dependency dispositions.
- Order has strict-part, identity and finite-countermodel contracts. Structured
  Configuration is retained in indexed States, an Entity history, configured
  Boundaries and a concrete Model pipeline. Supplied interpretation and empirical
  Entity identity remain gates; full Perception/Memory parity is not claimed.
- The Identity dossier adds four contracts: equality, the Identity/Difference
  partition, exact-target Missingness, and finite anti-collapse witnesses.
  Empirical individuation, carrier adequacy and actual expectation provenance
  remain outside the proofs. Existing Missingness constructors are unchanged.
- Attention has eight bounded response-model tests. Canonical Entity identity,
  Perception, Interpretation, Causal Contribution and continuity between samples
  remain unproved; no mandatory finite channel ratio is promoted.
- Care has five bounded selector tests. Response and Specification sensitivity
  do not establish successful conformity, benefit, or the complete Attention,
  Action, Consequence and same-target causal joins.
- Respect has seven bounded admission tests. Expressed conditions override
  contextual defaults within Scope. Admission alone does not establish condition
  provenance, consent, canonical Action/Agency or actual causal regulation.
- `restrictedSelectionOrdersOutputs` exposes the retained selection witness's
  extra temporal ordering. Canonical D111 rejection need not occur or precede the
  selected outcome. EC-D5 and the dependent consciousness candidate are restricted
  constructions, not full canonical selection. Exact availability is declared
  membership, not a proof of feasibility or computational constructivity.
- Withdrawn composites and historical finite Attention/Love/Care/Respect records
  remain examples. InstitutionalRevision and Self/Auto remain nonbinding.
  No universal Consciousness, Love, Intention, Auto or Autonomy is promoted.
- Standing and Recognition have separate same-index placement/recording witnesses.
  Complete institutional parity, including External Sovereignty recognition,
  remains outside the current shadow.

The [attention review](../../reviews/promotion/attention-love-care.json) and
[embodiment review](../../reviews/promotion/embodied-consciousness.json) separately
record the local adversarial findings, the sources pinned at review, and the
contract statements CI keeps frozen. They do not claim
independent external review. Downstream evaluations remain **incomplete/hold**:
source snapshots were refreshed, but model generation and judgments were not rerun.
