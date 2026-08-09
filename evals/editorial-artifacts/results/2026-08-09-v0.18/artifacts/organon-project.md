# The Instrument That Refuses to Win by Definition

Software can pass every test and still describe itself incorrectly.

One repository calls an operation a permission. Another calls the same operation a capability. A third calls it policy, then accepts the governed component’s own report that the policy succeeded. Each sentence may be plausible in isolation. The assembled system is harder to reason about because its words changed obligations while crossing repository boundaries.

This is not primarily a style problem. If Capability and Permission are interchangeable, technical possibility can be mistaken for institutional authorization. If a Record is automatically Evidence, the actor being evaluated can certify its own performance. If output means completion, producing bytes can silently become equivalent to satisfying a responsibility.

Organon exists for this failure. As the repository [README](README.md) explains, it is a collection of instruments: an ontology for stabilizing meaning, an editorial grammar for carrying difficult ideas, and formal artifacts for exposing decisions that fluent prose can hide. Its name follows the traditional title for Aristotle’s collected works on logic. The intended posture is instrument, not doctrine.

**A system becomes impossible to govern when its terms remain locally plausible but their correspondences disappear at repository boundaries.**

## When technical language begins carrying authority

Developer infrastructure often starts with apparently mechanical questions. Can this component invoke the tool? Did the request return? Was a record written? Those questions remain technical, but they stop being sufficient when an output is allowed to count on someone’s behalf.

At that point the system also has institutional questions. Who was allowed to request the action? On whose behalf did it occur? What Rule makes the result count as complete? Who can observe the action without being controlled by the claimant? What happens if the authorization remains valid but the system lacks the Capability to exercise it?

Organon keeps these distinctions in one dependency chain rather than allowing the technical and institutional descriptions to drift apart. Capability does not create Permission or Authority. Permission does not manufacture Capability. A component’s report about its own action remains a Claim unless the required Observation, Witness independence, admission Rule, and governing Order are supplied for Evidence.

The ontology does not establish that any particular system has those relations. It supplies stable terms and asks a project to identify the mechanisms and witnesses that would make its local Claims inspectable. That difference matters: vocabulary can structure an investigation, but it cannot substitute for the project’s facts.

## Three instruments with different jobs

The ontology is the binding vocabulary where Organon is explicitly adopted. It defines terms in dependency order, assigns stable identifiers, states relation signatures, and records anti-collapses: the implications that must not be smuggled from one term into another. Its readable Markdown remains canonical. Registries and generated projections make that structure inspectable, but they do not silently replace the prose.

The ontology also has a quarantine. A familiar word does not receive technical force merely because it appears in an essay or sounds important. Candidate terms can remain proposed, disputed, or deliberately undefined. Capitalization is not adoption, and resemblance is not a mapping.

The editorial grammar solves a different problem. An exact definition can still arrive before a reader has any use for it. Long-form work therefore begins in a world the reader recognizes, makes a consequential gap perceptible, negotiates reasonable resistance, delivers a distinction, and returns that distinction to the original situation. Short form governs the compressed sentence once the idea has been earned. Neither editorial instrument may redefine what the ontology says exists.

That editorial language also has provenance. The canonical Short Form emerged through generated samples, Daniel’s inline feedback, a four-person review panel, and three review rounds. The private intermediate artifacts named in [Editorial Provenance](provenance/editorial.md) record process history but are not dependencies of the public document and carry no binding authority over the adopted result. Adoption establishes the current editorial status; it does not erase the tools and reviewers that contributed.

Formal work applies pressure to the definitions. Lean encodes selected high-risk regions where prose can conceal dependent structure, missing witnesses, or illicit substitutions. Finite witnesses show that a proposed structure can be inhabited under an encoding. Countermodels test whether two nearby terms have accidentally been made to entail one another. Other experiments mutate witness structures and search for collapse.

None of this makes Lean canonical. A successful build shows that declarations elaborate under the pinned compiler. It does not show that the encoding exhausted the prose, that the prose exhausted Reality, or that a proof assistant has settled the philosophical question.

**Formalization does not certify the ontology. It makes hidden commitments expensive enough to inspect, reject, or revise before they become inherited confusion.**

The instruments constrain one another without becoming interchangeable. The ontology prevents editorial fluency from changing definitions. Editorial grammar prevents definition lists from masquerading as explanations. Formal artifacts force selected commitments into shapes that can fail more explicitly. Human review retains the decision about what becomes binding.

## The objection Organon has to survive

The strongest objection is not that shared vocabulary is useless. It is that the author of the vocabulary can use it to control every disagreement.

Organon is not an anonymous standard. [Who is Daniel?](DANIEL.md) records the experience and perspective behind it, including work on developer platforms, cloud SDKs, AI systems, and governed agent execution. That history helps explain why Organon repeatedly attends to identity, authority, operational evidence, and the boundary between an agent’s action and its account of that action. The biography does not certify the ontology.

The conflict is sharper because Daniel is both the author of the comparison surface and a maintainer of systems that may be compared against it. Naming that conflict does not remove it. It makes the authority path reviewable.

Project mechanisms remain the primary evidence about what a project does. Project maintainers retain authority over their repositories. When a project and Organon disagree, the result must remain open to at least three diagnoses: the project documentation is defective, the project contains a legitimate distinction Organon does not yet represent, or Organon is defective. The ontology does not win by being the ontology.

The same boundary applies to collaborative authorship. AI systems have contributed wording, criticism, organization, and formalization. Daniel is responsible for adopting the commitments. Generated language remains a proposal until adopted, while future contributors should receive credit for the distinctions, counterexamples, and corrections they introduce. Anonymous collaboration must not harden into anonymous authority.

## Using Organon without surrendering local judgment

Adoption begins with the project, not with a search-and-replace over its nouns.

First, identify the actual actors, boundaries, transformations, records, and authority paths. Ask who can perform each action under which technical constraints, who may authorize it, whose interests count as the Principal’s, and which observations are outside the claimant’s relevant control.

Next, choose the Organon version and any profiles the repository intends to adopt. Declare the governed paths. Map local vocabulary explicitly rather than assuming that matching words have matching meanings.

Each proposed correspondence can then be classified as:

- **Exact:** the local mechanism satisfies the Organon definition within the declared Scope.
- **Refinement:** the local term adds constraints while preserving the mapped distinction.
- **Conflict:** the local and Organon terms make incompatible commitments.
- **Unmapped:** the project needs a distinction for which no responsible correspondence has been established.

Unmapped is not automatic failure. It may be the most accurate result available. A useful review preserves the location of disagreement long enough to decide whether the project, the mapping, or Organon should change.

An adoption manifest records the version, profiles, governed paths, and local mappings. The repository checker expands selected profiles through the ontology’s dependency closure and validates the declared contract:

```sh
python3 scripts/check-adoption.py path/to/organon-adoption.json --repo-root path/to/repository
```

Passing that check establishes agreement with the declared machine-readable contract. It does not establish that the mapping is philosophically correct, that the project has implemented every documented mechanism, or that a human maintainer has approved adoption. Automated gates produce review material; they do not grant themselves authority.

## A vocabulary that can be changed without quietly changing

Because Organon may influence how other repositories are judged, binding changes carry a larger burden than ordinary wording edits. [Contributing to Organon](CONTRIBUTING.md) requires a proposed term to survive a termhood challenge, explicit dependency ordering, collapse audits in both directions, comparison with strong intellectual precedents, proportionate formal pressure, witnesses and countermodels, and a complete rereading of the readable ontology.

Governed surfaces must then be updated together. Objections must be separated into those resolved and those that remain open gates. Passing CI establishes local verification, not adversarial review or philosophical truth. The exact promoted content becomes binding only when it enters the canonical ontology and its governed projections agree.

That revision process is part of the instrument’s meaning. Organon v0.18 is provisional and binding only where explicitly adopted. It does not claim completeness, universal truth, or immunity to correction. Its narrower promise is that named distinctions will not quietly change halfway through an argument—and that changing them later will leave an inspectable record of who changed what, under which procedure, and with which unresolved objections.

A project can therefore use Organon without yielding its own judgment. It can adopt a distinction, refine it, reject a mapping, expose an unrepresented mechanism, or return a counterexample to the ontology. The common vocabulary becomes useful precisely because disagreement remains typed rather than suppressed.

**A shared vocabulary is infrastructure only when its correspondences, authority, and revision conditions remain inspectable.**
