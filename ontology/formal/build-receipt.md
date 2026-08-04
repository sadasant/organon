---
type: formal-build-receipt
status: verified
canonicality: noncanonical
created: 2026-08-02
updated: 2026-08-03
repository_commit: "6467eec1d9b012069f746f765d64f423bfaf64ae"
---
# Lean Spike Build Receipt

This receipt records external Evidence for the noncanonical Lean spike. It does not promote the spike over [Daniel's Ontology v0.16](../ontology.md).

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

Result: all 26 build jobs completed successfully. The executable printed:

```text
OrganonCore v0.16 reduct: hidden bridge relations, downstream shadows, four preserved challenge classifiers, and one pending Reality representation elaborated
```

The Lean sources contain no `sorry`, `admit`, or `axiom` declaration. The existing formal witnesses remain intact: consciousness candidate/Attribution/Designation separation; discriminating Operationalization; participant-bound World access; ordered Substrate Persistence; Truth without modeled Agent access; accepted Trust versus involuntary Dependence; profile-scoped Alignment; joined adaptive Intelligence; useful-false Operative Knowledge; dormant Records; copied Records without recipient knowledge; and inter-agent plus self-transmission. The v0.16 bridge module additionally constructs unequal Denotation, paired-path Causal Contribution, constructive Capability realization, Standing without duplicate eligibility, and supportive Evidential Bearing for a false Claim.

The build separately compiles `OrganonCore`, which contains the current downstream formal vocabulary without `Absent`, `Present`, `Mark`, or the Absence/Presence theorems, and `DanielOntology`, which restores those declarations as a conservative extension. `OrganonCorePreservation` proves by definitional equality that every classifier expressible over the shared carrier has the same result before and after an arbitrary exclusive and exhaustive Absence/Presence extension. This establishes classification preservation for the present Lean shadow. It does not establish preservation for all 107 binding prose terms, because the formal shadow is not yet term-for-term complete; that larger claim remains `UNKNOWN`.

`OrganonCoreChallenge` additionally preserves declared challenge classifiers for Presence, Missingness, Persistence, and Entity. The finite model admits an ordered identity-preserving history, rejects an ordered history ending in an identity-breaking State, and requires every `Entity` to carry an explicit Persistence witness naming its identity Invariant. A universe-relative local-Reality equivalence elaborates, but the report does not count it as preservation of binding Reality: one carrier is not the totality of all Presence. Reality may remain ambient and metatheoretic or receive a universe-indexed projection in the canonicalization follow-up. The generated 107-term audit therefore records 4 proved challenge classifications, 1 pending Reality representation decision, 1 intentionally excluded primitive, and 101 unknowns.

The shadow additionally constructs one Factive Operative Knowledge instance whose load-bearing Record carries the exact true Claim; one Warranted Knowledge instance with joined Observation, independent Witness, Rule, Order, Admission, recorded supportive Evidential Bearing, and equality between the evidence claimant and operative interpreter; a useful operative falsehood that cannot inhabit the factive profile; a true Claim with no operative path; and a factive instance that cannot inhabit Warranted Knowledge under a closed Admission predicate. It constructs moral Attributions over obtaining and non-obtaining candidates, a Designation whose candidate does not obtain, a silent Order under which either candidate result remains possible, and Designation without downstream protection. It constructs one combined sovereignty world plus four profile-only worlds: each of Constituent, Constituted, Boundary, and External Sovereignty is inhabited while the other three structures are uninhabitable in the corresponding world. Boundary witnesses require unequal enforcement outcomes. External witnesses carry Rule, Standing, a scoped representative Action, own-Principal participation, and explicit exclusion of ActsFor relations to distinct Principals. It also constructs Preference without utility representation, a Utility Measure without modeled Preference, an observed choice that differs from the preferred option, Price without exchange or moral worth, and institutional valuation without moral worth.

Proposal-local evidence, sovereignty, own-Principal, observed-choice, exchange, and moral-worth predicates remain formal shadows rather than complete joins to every core Organon structure. Reality, universal Claim semantics, universal moral conditions, Action attribution, complete Evidence parity, Interior-and-Boundary Exposure, Action-to-Change Consequence, complete Sense-to-Perception access, fidelity, carrier realization, Alignment-profile composition, completeness and provenance of external Rule encodings, runtime construction, temporal ordering of transmission stages, universal semantic preservation, international-law sufficiency, preference revelation, expected utility, market clearing, generic Knowledge, generic Sovereignty, and generic Value remain open formalization gates.

The repository commit attested by this receipt is `6467eec1d9b012069f746f765d64f423bfaf64ae`.

## Source digests

- `OrganonCore.lean`: `a798ac9d91d46775fadaa0635c4d3ac2a8c3e3c9115cbc266dc8e7c0bee5bdca`
- `OrganonCorePreservation.lean`: `e672e51e2a5cf84a83b73d5a65d325feb1aa2e76fc9733fd66a33d08d7534c2b`
- `OrganonCoreChallenge.lean`: `e3aa3028ce6aa5d449540abf87aefe0cfe96d9e25ae542020589e5d4f6777d8a`
- `DanielOntology.lean`: `f8880dbdd90b198beba9392d3ef8ab18e575715f206ec1e497fe3d31eab69ba1`
- `BridgeRelations.lean`: `25861ac5a119f323670ef0e0a44b15d78b86e41ea60f78d2b1a183958432f46a`
- `Consciousness.lean`: `18c9af64b04e3f822c97cf24371d17dd22bd34c89e036d7362207fbba4e9cd86`
- `Operationalization.lean`: `14e75b936ad86f5a03292b316990b7d3ab7a1ada811cb1865ec2831ac8d1a3ce`
- `WorldSubstrate.lean`: `d3a9d36f6acfe56318ba35dd1f742d2d2e73136f84d70ed27267eb7228122ec5`
- `TruthTrustAlignment.lean`: `b920005fd6179db81fb84091317963d5323d52edc7eafc8ba6d7af218ce9cdd8`
- `IntelligenceKnowledge.lean`: `bc0ad1caa81adb25316f79aecd5011e32cf94cc73e1e046f7e13bcd10779aee8`
- `QuarantineProfiles.lean`: `0537fd637612fbe72385824ba8a5c36748d353dda26aa2bc182be055950d8da5`
- `Model.lean`: `18b2870064450f844bbf5488916ccc61e9605642549760baa92b5c4d3699bce5`
- `lakefile.toml`: `9fb021ea9d4179ff5a087c78b15ee487786f1b2345eb1ec1bfda270669d0c630`
- `lean-toolchain`: `54727eec5cba149c18842e6deb5c41b369d66455c93ce135d7d5347c782b2325`
