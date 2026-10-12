---
type: formal-build-receipt
status: verified
canonicality: noncanonical
created: 2026-08-02
updated: 2026-10-12
repository_commit: "e4acf50bd2ff6cf06aab0eb64a5cc6c6f7970480"
---
# Lean Spike Build Receipt

This receipt attests the committed noncanonical Lean sources below. The readable
[ontology](../ontology.md) remains binding. Earlier build receipts and their
historical counts remain in Git; they are not evidence for current definitions.

## Toolchain

- Lean: `4.30.0`, x86_64 Linux orb
- Commit: `d024af099ca4bf2c86f649261ebf59565dc8c622`
- Project pin: `leanprover/lean4:v4.30.0`

## Executed verification

From `ontology/formal/`:

```sh
lake build
lake exe ontology_check
lake env lean -o .lake/build/lib/lean/PR18ReviewDraft.olean PR18ReviewDraft.lean
lake env lean ../../reviews/local/2026-10-07-integrated-axiom-audit.lean
```

The build completed successfully: **48 jobs**. The finite executable completed.
The separate historical draft was rebuilt before the integrated audit:

```text
PROJECT_AXIOM_AUDIT: 2549 project theorems checked; 0 declared project axioms; allowed only propext, Classical.choice, Quot.sound.
```

From the repository root, `python3 scripts/check-ontology-frameworks.py` passed
all **30 theorems**, with no proof placeholders or nonstandard axiom dependencies.
Compilation and axiom checks establish the recorded Lean claims, not complete
prose parity, empirical applicability, or downstream model quality.

## Current contracts and limits

- The registry contains **115 terms, 112 definitions and 53 commitments**.
  Current attention-dossier contracts are AC-D3, AC-D7 and AC-D8. The embodiment
  dossier retains eleven contracts with their dependency dispositions.
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
record the local adversarial findings and exact-source pins. They do not claim
independent external review. Downstream evaluations remain **incomplete/hold**:
source snapshots were refreshed, but model generation and judgments were not rerun.

## Source digests

<!-- Generated from the attested implementation; includes historical draft sources. -->

- `AttentionLoveCare.lean`: `1bbf88735c0ff93d9ac1c8fda87799b7339a905bfe247a22b3cc079468e5ec11`
- `AttentionLoveCareContracts.lean`: `adbf027a16775bbd074295510aea5999dae9f1f80b08bf3e032b4aea7bd26c1c`
- `AttentionRevision.lean`: `5945b555eeee5b875fdaae2cf1021870dbc8d15050f1ee99c2c7785770d1e2aa`
- `BridgeRelations.lean`: `021dc3e5394a1c64c1055f2526cafee440ce9f7f7f168217d03f329ac59389ff`
- `CareRevision.lean`: `24a85f0de2be128eae7b6b221dbb9ffa2e1af19d7f0a5d2cdb182f529c28e1e3`
- `Consciousness.lean`: `18c9af64b04e3f822c97cf24371d17dd22bd34c89e036d7362207fbba4e9cd86`
- `DanielOntology.lean`: `f8880dbdd90b198beba9392d3ef8ab18e575715f206ec1e497fe3d31eab69ba1`
- `EmbodiedConsciousness.lean`: `10f3d176bfcfbc27305def3a33bb470dfa1e1d1036f8a605c9e17643bfd8fc4b`
- `InstitutionalRevision.lean`: `56bb2c4ee85f1617966beae97eb239f1d87d9c30c1cb36e13acdcad673b37e10`
- `IntelligenceKnowledge.lean`: `bc0ad1caa81adb25316f79aecd5011e32cf94cc73e1e046f7e13bcd10779aee8`
- `Model.lean`: `fc704c2f6599642b69e7242efedb2f04c1ba3cf277417f412d251d9c5ef431c8`
- `OntologyCompleteness.lean`: `b43715f38100c6fb89418e8aa0b0f8c1b1b669a80bbbf5c15493e4ba00afc88f`
- `Operationalization.lean`: `14e75b936ad86f5a03292b316990b7d3ab7a1ada811cb1865ec2831ac8d1a3ce`
- `OrganonCore.lean`: `d080cd83c6d946fe48e8219f02ba6277367a49f8ac88186ce40a1531220a65d0`
- `OrganonCoreChallenge.lean`: `e3aa3028ce6aa5d449540abf87aefe0cfe96d9e25ae542020589e5d4f6777d8a`
- `OrganonCorePreservation.lean`: `e672e51e2a5cf84a83b73d5a65d325feb1aa2e76fc9733fd66a33d08d7534c2b`
- `PR18Governance.lean`: `cd26841c40ff8808bae91d0f31547a3fb0f1f693b049433ee4baa411bbdc5550`
- `PR18ReviewDraft.lean`: `736485b4859be92602ef238c237033ab4d880489167e320488377cff1de786bc`
- `PromotionContracts.lean`: `2ad1d436f4bd85e0164f1d113ec97212f975f7f5155da66d17078109b0c3d3c4`
- `QuarantineProfiles.lean`: `769a1fd2a8817476d55cefc7323da0837245783eb09a3dcc1e2657aa704d0509`
- `RepresentationActivityExample.lean`: `e4dbab2ecfeba547f3ba9a3148c065e3bd7340897f3711a5aa55a7e10440af1d`
- `RespectRevision.lean`: `48d7cb506d26002eed417d76047b500eee54869c82ff67f70a850cbd1a69be88`
- `RitualMeaning.lean`: `4154d3d8ec479679ec0faab4f8d4bb4364c8ed670b61528e77fcf996e537a68e`
- `TruthTrustAlignment.lean`: `bdaa0217e7434c9bc1d7cd3a6a2d489c684fbf38ffeb98a87388864d1cd5a733`
- `WorldSubstrate.lean`: `d3a9d36f6acfe56318ba35dd1f742d2d2e73136f84d70ed27267eb7228122ec5`
- `lakefile.toml`: `98605ff873c0dc0664c5f8f7961fbbe66cb7980b531b6618f815dcae3f0d268d`
- `lake-manifest.json`: `f8c2b12c90acc605d7faf8f63003abbf8a8ca7696b4292ec2aa515a4e265d969`
- `lean-toolchain`: `54727eec5cba149c18842e6deb5c41b369d66455c93ce135d7d5347c782b2325`
