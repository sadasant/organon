# Organon

Software can pass every test and still describe itself incorrectly.

One repository calls something a permission. Another calls the same thing a capability. A third calls it policy, then lets the component being governed report whether the policy succeeded. Every sentence remains locally plausible. Together they produce a system nobody can reason about without first guessing which words survived the trip.

Organon exists for that failure.

It is a collection of instruments for making a body of work internally legible: an ontology for stabilizing meaning, an editorial grammar for carrying difficult ideas, and formal artifacts for discovering where apparently compatible definitions collapse under pressure. The name comes from the traditional title for Aristotle's collected works on logic: instruments of reasoning, not the doctrine those instruments may later examine.

## Why it lives in Idolum

[Idolum](https://github.com/idolum-ai) builds systems in which agents act across boundaries of authority, evidence, and responsibility. Those systems make unusually expensive demands on language. A capability is not automatically a permission. An output is not automatically completion. A record is not automatically evidence. When a project blurs those distinctions, the implementation eventually inherits the confusion.

Organon provides a common surface from which project documentation can be reviewed. It asks:

- Which actor possesses a Capability, and which Principal grants Permission to use it?
- Who makes a Claim, what Witness is independent for that Claim, and what Rule admits the result as Evidence?
- Where does a term change meaning as it crosses a repository boundary?
- Which uncertainty remains explicit, and which has been hidden by fluent prose?

The objective is not terminological obedience. Project vocabulary should describe project mechanisms. Organon makes the correspondence inspectable.

## Who is Daniel?

Organon is not an anonymous standard. Its distinctions come from a particular history of building developer platforms, AI systems, and institutions around them. [Who is Daniel?](./DANIEL.md) records that position, the experience behind it, and the limits of his authority over work that other people maintain.

This matters because an ontology can be internally consistent and still reflect the attention of its author. Declaring that attention makes the work easier to challenge. It also prevents a useful instrument from acquiring the suspicious voice of a tablet recovered from a mountain.

## Repository map

```text
ontology/       binding prose, stable term registry, profiles, and Lean experiment
editorial/      long-form grammar and canonical short-form delivery language
provenance/     essay, editorial, and term-level evidence lineage
proposals/      nonbinding promotion dossiers for quarantined vocabulary
reviews/        reusable review method and completed project audits
schemas/        machine-readable adoption contract
examples/       example adoption manifests
scripts/        repository, semantic, and adoption checks
```

The binding artifact is [Daniel's Ontology v0.10](./ontology/ontology.md). It remains readable as one Markdown document; the machine-readable registry and formal artifacts check and challenge it without replacing it. Its [term registry](./ontology/terms.yaml) assigns stable `organon:*` identifiers, typed claims, and explicit dependencies. The [changelog](./ontology/changelog.md) keeps earlier arguments and rejected formulations out of the active system.

Terms under quarantine are developed through [proposal pull requests](./proposals/README.md). A proposal may preserve candidate definitions, hypotheses, evidence requirements, and reasons for refusal without changing the binding ontology merely by existing.

Capitalization is not adoption. A downstream repository adopts Organon by naming a version and profiles, declaring governed paths, and explicitly mapping its local vocabulary through an [adoption manifest](./schemas/organon-adoption-schema.json). The [example manifest](./examples/organon-adoption.json) is executable documentation.

## Editorial instruments

The [Long-Form Editorial Grammar](./editorial/long-form.md) describes how a reader comes to need, receive, and carry a difficult idea. The canonical [Short Form](./editorial/short-form.md) governs sentence-scale delivery once that idea has been earned. Neither may silently redefine what the ontology says exists.

The ontology's essay evidence is indexed through the public [Essay Corpus](./provenance/essays.md). Private drafts and review artifacts are declared through [Editorial Provenance](./provenance/editorial.md). [Term Provenance](./provenance/terms.md) records the lineage claimed for every stable term without presenting lineage as proof of truth.

## Lean experiment

The [Lean formalization](./ontology/formal/README.md) prices decisions that prose can hide. It encodes selected high-risk regions, including classical A3, Direction-indexed Transformations, explicit feeding between States, executable Specifications, contextual Capability, Order-indexed Permission, scoped Witness independence, and a nontrivial Boundary model.

Lean is not canonical. Compilation proves that the declarations elaborate under the pinned compiler. It does not prove that the encoding exhausted the prose, that the prose exhausted Reality, or that the compiler has become a metaphysician. The [formalization decisions](./ontology/formal/decisions.md) and [build receipt](./ontology/formal/build-receipt.md) preserve that boundary.

## Adoption and review

Begin with the project. Identify its actual actors, boundaries, transformations, records, and authority paths. Then use the [review template](./reviews/template.md) to classify each correspondence as exact, a refinement, a conflict, or unmapped. A defect may belong to the project, to Organon, or to the proposed mapping.

Repositories can adopt one or more profiles from [profiles.json](./ontology/profiles.json). The checker expands every selected profile through the registry's dependency closure and validates local mappings:

```sh
python3 scripts/check-adoption.py path/to/organon-adoption.json --repo-root path/to/repository
```

## Verification

From the repository root:

```sh
python3 scripts/check-links.py
python3 scripts/check-semantics.py
python3 scripts/check-proposals.py
python3 scripts/check-formal-receipt.py
python3 scripts/check-adoption.py examples/organon-adoption.json --repo-root .
(cd ontology/formal && lake build && lake exe ontology_check)
```

The link check keeps public Markdown inside the portable Obsidian/GitHub intersection documented in [Markdown Policy](./MARKDOWN.md). The semantic check verifies stable markers, claim types, dependency order, governed projections, and term-level provenance. The adoption check verifies the contract a downstream repository would make.

## Status

Organon v0.10 is provisional and binding only where explicitly adopted. The ontology is not complete, universally true, or immune to revision. It is a versioned promise that named distinctions will not quietly change halfway through an argument.
