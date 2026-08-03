---
type: formal-experiment-audit
status: draft
canonicality: noncanonical
created: 2026-08-03
ontology_version: "0.15.0"
generated_by: scripts/check-organon-core-audit.py
---
# OrganonCore term audit

This table accounts for every registered term. `proved` means only that the declared challenge classifier is preserved in Lean. It is not automatically a complete encoding of the binding prose. `compiled shadow` means a named Lean shadow builds without the Absence extension; it does not mean that the shadow is extensionally identical to the binding prose definition.

Result totals: **4 proved translations**, **1 pending representation decision**, **1 intentionally excluded**, and **98 unknown**.

| Claim | Term | Reduct disposition | Experiment result | Reason |
|---|---|---|---|---|
| P1 | `organon:Absence` | extension-only | excluded | The reduct intentionally has no classifier named Absence. |
| A3 | `organon:Presence` | translated | proved | CorePresence is definitionally Nonempty, exactly the current Present shadow. |
| A5 | `organon:Missingness` | translated | proved | An expected value supplies Presence; nonmembership remains the load-bearing relation. |
| D001 | `organon:Reality` | challenge seam | pending | Choose an ambient metatheoretic or universe-indexed projection; no local carrier is Reality as a whole. |
| D002 | `organon:Difference` | direct translation gate | unknown | The prose definition names Presence directly and lacks an exact paired classifier. |
| D003 | `organon:Relation` | direct translation gate | unknown | The prose definition names Presence directly and lacks an exact paired classifier. |
| D004 | `organon:Configuration` | direct translation gate | unknown | The prose definition names Presence directly and lacks an exact paired classifier. |
| D005 | `organon:State` | compiled shadow | unknown | The Lean shadow is extension-invariant; exact prose parity is not established. |
| D006 | `organon:Direction` | compiled shadow | unknown | The Lean shadow is extension-invariant; exact prose parity is not established. |
| D007 | `organon:Transformation` | compiled shadow | unknown | The Lean shadow is extension-invariant; exact prose parity is not established. |
| D008 | `organon:Change` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D009 | `organon:Feeds` | compiled shadow | unknown | The Lean shadow is extension-invariant; exact prose parity is not established. |
| D010 | `organon:CausalPath` | compiled shadow | unknown | The Lean shadow is extension-invariant; exact prose parity is not established. |
| D011 | `organon:Invariant` | challenge support | unknown | Used by the adversarial history classifier; binding parity remains unproved. |
| D012 | `organon:Persistence` | translated | proved | The classifier carries an ordered history and identity Invariant and is extension-invariant. |
| D013 | `organon:Constraint` | compiled shadow | unknown | The Lean shadow is extension-invariant; exact prose parity is not established. |
| D014 | `organon:Entity` | translated | proved | Every Entity now carries a classified Persistence witness for its identity. |
| D015 | `organon:Boundary` | challenge support | unknown | Used by the adversarial history classifier; binding parity remains unproved. |
| D016 | `organon:Environment` | direct translation gate | unknown | The prose definition names Presence directly and lacks an exact paired classifier. |
| D017 | `organon:Representation` | direct translation gate | unknown | The prose definition names Presence directly and lacks an exact paired classifier. |
| D018 | `organon:Scope` | compiled shadow | unknown | The Lean shadow is extension-invariant; exact prose parity is not established. |
| D019 | `organon:Specification` | compiled shadow | unknown | The Lean shadow is extension-invariant; exact prose parity is not established. |
| D020 | `organon:Rule` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D021 | `organon:Sign` | direct translation gate | unknown | The prose definition names Presence directly and lacks an exact paired classifier. |
| D022 | `organon:Symbol` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D023 | `organon:Language` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D024 | `organon:Map` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D025 | `organon:Reference` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D026 | `organon:Sense` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D027 | `organon:Perception` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D028 | `organon:Record` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D029 | `organon:Observation` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D030 | `organon:Memory` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D031 | `organon:Model` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D032 | `organon:Action` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D033 | `organon:Consequence` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D034 | `organon:Interpretation` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D035 | `organon:Agent` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D036 | `organon:Agency` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D037 | `organon:Tool` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D038 | `organon:Capability` | compiled shadow | unknown | The Lean shadow is extension-invariant; exact prose parity is not established. |
| D039 | `organon:Interior` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D040 | `organon:Exposure` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D041 | `organon:Flow` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D042 | `organon:Interface` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D043 | `organon:Claim` | direct translation gate | unknown | The prose definition names Presence directly and lacks an exact paired classifier. |
| D044 | `organon:Witness` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D045 | `organon:Control` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D046 | `organon:Order` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D047 | `organon:Standing` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D048 | `organon:Recognition` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D049 | `organon:Principal` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D050 | `organon:ActsFor` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D051 | `organon:CountsAs` | direct translation gate | unknown | The prose definition names Presence directly and lacks an exact paired classifier. |
| D052 | `organon:Authority` | compiled shadow | unknown | The Lean shadow is extension-invariant; exact prose parity is not established. |
| D053 | `organon:PermissionClaim` | compiled shadow | unknown | The Lean shadow is extension-invariant; exact prose parity is not established. |
| D054 | `organon:Declaration` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D055 | `organon:Grant` | compiled shadow | unknown | The Lean shadow is extension-invariant; exact prose parity is not established. |
| D056 | `organon:Admission` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D057 | `organon:Permission` | compiled shadow | unknown | The Lean shadow is extension-invariant; exact prose parity is not established. |
| D058 | `organon:Revocation` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D059 | `organon:PermissionExercise` | compiled shadow | unknown | The Lean shadow is extension-invariant; exact prose parity is not established. |
| D060 | `organon:Exercisability` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D061 | `organon:FullyExercisablePermission` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D062 | `organon:Enforcement` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D063 | `organon:Role` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D064 | `organon:AdmissibilityRule` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D065 | `organon:IndependentFor` | compiled shadow | unknown | The Lean shadow is extension-invariant; exact prose parity is not established. |
| D066 | `organon:Evidence` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D067 | `organon:Attestation` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D068 | `organon:Institution` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D069 | `organon:Center` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D070 | `organon:Organ` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D071 | `organon:CanonicalSystem` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D072 | `organon:ShadowSystem` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D073 | `organon:Person` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D074 | `organon:Receipt` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D075 | `organon:Ledger` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D076 | `organon:Polity` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D077 | `organon:ConstitutedExercise` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D078 | `organon:ConstituentExercise` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D079 | `organon:ConstituentPower` | downstream translation gate | unknown | No exact paired classifier yet; dependency closure alone cannot prove preservation. |
| D080 | `organon:ConsciousnessAttribution` | compiled shadow | unknown | The Lean shadow is extension-invariant; exact prose parity is not established. |
| D081 | `organon:ConsciousnessDesignation` | compiled shadow | unknown | The Lean shadow is extension-invariant; exact prose parity is not established. |
| D082 | `organon:Operationalization` | compiled shadow | unknown | The Lean shadow is extension-invariant; exact prose parity is not established. |
| D083 | `organon:World` | compiled shadow | unknown | The Lean shadow is extension-invariant; exact prose parity is not established. |
| D084 | `organon:Substrate` | compiled shadow | unknown | The Lean shadow is extension-invariant; exact prose parity is not established. |
| D085 | `organon:Truth` | compiled shadow | unknown | The Lean shadow is extension-invariant; exact prose parity is not established. |
| D086 | `organon:Trust` | compiled shadow | unknown | The Lean shadow is extension-invariant; exact prose parity is not established. |
| D087 | `organon:Alignment` | compiled shadow | unknown | The Lean shadow is extension-invariant; exact prose parity is not established. |
| D088 | `organon:Intelligence` | compiled shadow | unknown | The Lean shadow is extension-invariant; exact prose parity is not established. |
| D089 | `organon:OperativeKnowledge` | compiled shadow | unknown | The Lean shadow is extension-invariant; exact prose parity is not established. |
| D090 | `organon:KnowledgeTransmission` | compiled shadow | unknown | The Lean shadow is extension-invariant; exact prose parity is not established. |
| D091 | `organon:FactiveOperativeKnowledge` | compiled shadow | unknown | The Lean shadow is extension-invariant; exact prose parity is not established. |
| D092 | `organon:WarrantedKnowledge` | compiled shadow | unknown | The Lean shadow is extension-invariant; exact prose parity is not established. |
| D093 | `organon:MoralStatusAttribution` | compiled shadow | unknown | The Lean shadow is extension-invariant; exact prose parity is not established. |
| D094 | `organon:MoralPersonhoodDesignation` | compiled shadow | unknown | The Lean shadow is extension-invariant; exact prose parity is not established. |
| D095 | `organon:ConstituentSovereignty` | compiled shadow | unknown | The Lean shadow is extension-invariant; exact prose parity is not established. |
| D096 | `organon:ConstitutedSovereignty` | compiled shadow | unknown | The Lean shadow is extension-invariant; exact prose parity is not established. |
| D097 | `organon:BoundarySovereignty` | compiled shadow | unknown | The Lean shadow is extension-invariant; exact prose parity is not established. |
| D098 | `organon:ExternalSovereignty` | compiled shadow | unknown | The Lean shadow is extension-invariant; exact prose parity is not established. |
| D099 | `organon:Preference` | compiled shadow | unknown | The Lean shadow is extension-invariant; exact prose parity is not established. |
| D100 | `organon:UtilityMeasure` | compiled shadow | unknown | The Lean shadow is extension-invariant; exact prose parity is not established. |
| D101 | `organon:Price` | compiled shadow | unknown | The Lean shadow is extension-invariant; exact prose parity is not established. |
