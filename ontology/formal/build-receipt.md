---
type: formal-build-receipt
status: verified
canonicality: noncanonical
created: 2026-08-02
updated: 2026-08-03
repository_commit: "823b78e6dd43c1ded5fe439b757c7d5ff3d66d61"
---
# Lean Spike Build Receipt

This receipt records external Evidence for the noncanonical Lean spike. It does not promote the spike over [Daniel's Ontology v0.15](../ontology.md).

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

Result: all 24 build jobs completed successfully. The executable printed:

```text
OrganonCore v0.15 reduct: downstream shadows plus four preserved challenge classifiers and one pending Reality representation elaborated
```

The Lean sources contain no `sorry`, `admit`, or `axiom` declaration. The existing formal witnesses remain intact: consciousness candidate/Attribution/Designation separation; discriminating Operationalization; participant-bound World access; ordered Substrate Persistence; Truth without modeled Agent access; accepted Trust versus involuntary Dependence; profile-scoped Alignment; joined adaptive Intelligence; useful-false Operative Knowledge; dormant Records; copied Records without recipient knowledge; and inter-agent plus self-transmission.

The build separately compiles `OrganonCore`, which contains the current downstream formal vocabulary without `Absent`, `Present`, `Mark`, or the Absence/Presence theorems, and `DanielOntology`, which restores those declarations as a conservative extension. `OrganonCorePreservation` proves by definitional equality that every classifier expressible over the shared carrier has the same result before and after an arbitrary exclusive and exhaustive Absence/Presence extension. This establishes classification preservation for the present Lean shadow. It does not establish preservation for all 104 binding prose terms, because the formal shadow is not yet term-for-term complete; that larger claim remains `UNKNOWN`.

`OrganonCoreChallenge` additionally preserves declared challenge classifiers for Presence, Missingness, Persistence, and Entity. The finite model admits an ordered identity-preserving history, rejects an ordered history ending in an identity-breaking State, and requires every `Entity` to carry an explicit Persistence witness naming its identity Invariant. A universe-relative local-Reality equivalence elaborates, but the report does not count it as preservation of binding Reality: one carrier is not the totality of all Presence. Reality may remain ambient and metatheoretic or receive a universe-indexed projection in the canonicalization follow-up. The generated 104-term audit therefore records 4 proved challenge classifications, 1 pending Reality representation decision, 1 intentionally excluded primitive, and 98 unknowns.

The v0.15 shadow additionally constructs one Factive Operative Knowledge instance whose load-bearing Record carries the exact true Claim; one Warranted Knowledge instance with joined Observation, independent Witness, support, Rule, Order, Admission, and equality between the evidence claimant and operative interpreter; a useful operative falsehood that cannot inhabit the factive profile; a true Claim with no operative path; and a factive instance that cannot inhabit Warranted Knowledge under a closed Admission predicate. It constructs moral Attributions over obtaining and non-obtaining candidates, a Designation whose candidate does not obtain, a silent Order under which either candidate result remains possible, and Designation without downstream protection. It constructs one combined sovereignty world plus four profile-only worlds: each of Constituent, Constituted, Boundary, and External Sovereignty is inhabited while the other three structures are uninhabitable in the corresponding world. Boundary witnesses require unequal enforcement outcomes. External witnesses carry Rule, Standing, a scoped representative Action, own-Principal participation, and explicit exclusion of ActsFor relations to distinct Principals. It also constructs Preference without utility representation, a Utility Measure without modeled Preference, an observed choice that differs from the preferred option, Price without exchange or moral worth, and institutional valuation without moral worth.

Proposal-local evidence, sovereignty, own-Principal, observed-choice, exchange, and moral-worth predicates remain formal shadows rather than complete joins to every core Organon structure. Reality, universal Claim semantics, universal moral conditions, Action attribution, complete Evidence parity, Interior-and-Boundary Exposure, Action-to-Change Consequence, complete Sense-to-Perception access, fidelity, carrier realization, Alignment-profile composition, completeness and provenance of external Rule encodings, runtime construction, temporal ordering of transmission stages, universal semantic preservation, international-law sufficiency, preference revelation, expected utility, market clearing, generic Knowledge, generic Sovereignty, and generic Value remain open formalization gates.

The repository commit attested by this receipt is `823b78e6dd43c1ded5fe439b757c7d5ff3d66d61`.

## Source digests

- `OrganonCore.lean`: `66622a2dc8c2440905520ebc583f12538594dae1742c3f92016af1d1f361d845`
- `OrganonCorePreservation.lean`: `e672e51e2a5cf84a83b73d5a65d325feb1aa2e76fc9733fd66a33d08d7534c2b`
- `OrganonCoreChallenge.lean`: `e3aa3028ce6aa5d449540abf87aefe0cfe96d9e25ae542020589e5d4f6777d8a`
- `DanielOntology.lean`: `f8880dbdd90b198beba9392d3ef8ab18e575715f206ec1e497fe3d31eab69ba1`
- `Consciousness.lean`: `18c9af64b04e3f822c97cf24371d17dd22bd34c89e036d7362207fbba4e9cd86`
- `Operationalization.lean`: `14e75b936ad86f5a03292b316990b7d3ab7a1ada811cb1865ec2831ac8d1a3ce`
- `WorldSubstrate.lean`: `d3a9d36f6acfe56318ba35dd1f742d2d2e73136f84d70ed27267eb7228122ec5`
- `TruthTrustAlignment.lean`: `581c9356ec67ac60f2700d7aa5500f1d33009a08edaf7d001b852efcc96bb494`
- `IntelligenceKnowledge.lean`: `bc0ad1caa81adb25316f79aecd5011e32cf94cc73e1e046f7e13bcd10779aee8`
- `QuarantineProfiles.lean`: `d2847ccb48dfef4948f4bdc8d57da984cfd43c55a68e129529befc175f4b689d`
- `Model.lean`: `b9f8b97cf1f578fa12c353222c6b84cc8438b97f2fc51a3b89ed62a3f935718f`
- `lakefile.toml`: `2372de8ea17497ca99548c6e1c751c57830a513a6f34b0dc8ab5b0daa5af1b21`
- `lean-toolchain`: `54727eec5cba149c18842e6deb5c41b369d66455c93ce135d7d5347c782b2325`
