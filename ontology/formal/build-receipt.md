---
type: formal-build-receipt
status: verified
canonicality: noncanonical
created: 2026-08-02
updated: 2026-08-03
repository_commit: "2e333bd1b9a83bfdccedad60ec9a22642e94c963"
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

Result: all 22 build jobs completed successfully. The executable printed:

```text
OrganonCore v0.15 reduct: downstream classifiers and finite countermodels elaborated without the Absence extension
```

The Lean sources contain no `sorry`, `admit`, or `axiom` declaration. The existing formal witnesses remain intact: consciousness candidate/Attribution/Designation separation; discriminating Operationalization; participant-bound World access; ordered Substrate Persistence; Truth without modeled Agent access; accepted Trust versus involuntary Dependence; profile-scoped Alignment; joined adaptive Intelligence; useful-false Operative Knowledge; dormant Records; copied Records without recipient knowledge; and inter-agent plus self-transmission.

The build separately compiles `OrganonCore`, which contains the current downstream formal vocabulary without `Absent`, `Present`, `Mark`, or the Absence/Presence theorems, and `DanielOntology`, which restores those declarations as a conservative extension. `OrganonCorePreservation` proves by definitional equality that every classifier expressible over the shared carrier has the same result before and after an arbitrary exclusive and exhaustive Absence/Presence extension. This establishes classification preservation for the present Lean shadow. It does not establish preservation for all 104 binding prose terms, because the formal shadow is not yet term-for-term complete; that larger claim remains `UNKNOWN`.

The v0.15 shadow additionally constructs one Factive Operative Knowledge instance whose load-bearing Record carries the exact true Claim; one Warranted Knowledge instance with joined Observation, independent Witness, support, Rule, Order, Admission, and equality between the evidence claimant and operative interpreter; a useful operative falsehood that cannot inhabit the factive profile; a true Claim with no operative path; and a factive instance that cannot inhabit Warranted Knowledge under a closed Admission predicate. It constructs moral Attributions over obtaining and non-obtaining candidates, a Designation whose candidate does not obtain, a silent Order under which either candidate result remains possible, and Designation without downstream protection. It constructs one combined sovereignty world plus four profile-only worlds: each of Constituent, Constituted, Boundary, and External Sovereignty is inhabited while the other three structures are uninhabitable in the corresponding world. Boundary witnesses require unequal enforcement outcomes. External witnesses carry Rule, Standing, a scoped representative Action, own-Principal participation, and explicit exclusion of ActsFor relations to distinct Principals. It also constructs Preference without utility representation, a Utility Measure without modeled Preference, an observed choice that differs from the preferred option, Price without exchange or moral worth, and institutional valuation without moral worth.

Proposal-local evidence, sovereignty, own-Principal, observed-choice, exchange, and moral-worth predicates remain formal shadows rather than complete joins to every core Organon structure. Reality, universal Claim semantics, universal moral conditions, Action attribution, complete Evidence parity, Interior-and-Boundary Exposure, Action-to-Change Consequence, complete Sense-to-Perception access, fidelity, carrier realization, Alignment-profile composition, completeness and provenance of external Rule encodings, runtime construction, temporal ordering of transmission stages, universal semantic preservation, international-law sufficiency, preference revelation, expected utility, market clearing, generic Knowledge, generic Sovereignty, and generic Value remain open formalization gates.

The repository commit attested by this receipt is `2e333bd1b9a83bfdccedad60ec9a22642e94c963`.

## Source digests

- `OrganonCore.lean`: `b06fdcdab20ea0631db0be6b647bbf991750f0e7e2982c38293f48b9a35b0c8a`
- `OrganonCorePreservation.lean`: `e672e51e2a5cf84a83b73d5a65d325feb1aa2e76fc9733fd66a33d08d7534c2b`
- `DanielOntology.lean`: `2ffdf59c0a093c7420fba1e25d0684a5ffa75e476244dd43b4cf3f15665cb743`
- `Consciousness.lean`: `18c9af64b04e3f822c97cf24371d17dd22bd34c89e036d7362207fbba4e9cd86`
- `Operationalization.lean`: `14e75b936ad86f5a03292b316990b7d3ab7a1ada811cb1865ec2831ac8d1a3ce`
- `WorldSubstrate.lean`: `e25bacd5f16c130d3c3eef373411619c92521ed806430b9df770cb373170ec76`
- `TruthTrustAlignment.lean`: `086db013585d345f6a66800ce7cb43fdbeb3e3072eac3b5f09b2e46cd2a411bc`
- `IntelligenceKnowledge.lean`: `bc0ad1caa81adb25316f79aecd5011e32cf94cc73e1e046f7e13bcd10779aee8`
- `QuarantineProfiles.lean`: `d2847ccb48dfef4948f4bdc8d57da984cfd43c55a68e129529befc175f4b689d`
- `Model.lean`: `024665199e5b7242bd6d0f5d050517cc3f82d34334926c4d32501829058525cd`
- `lakefile.toml`: `faec91d4e17cdeda84aea6244b43e36c002345cde3f9b27bec52dd85798298d4`
- `lean-toolchain`: `54727eec5cba149c18842e6deb5c41b369d66455c93ce135d7d5347c782b2325`
