# Organon

Software can pass every test and still describe itself incorrectly.

One repository calls something a permission. Another calls the same thing a capability. A third calls it policy, then lets the component being governed report whether the policy succeeded. Every sentence remains locally plausible. Together they produce a system nobody can reason about without first guessing which words survived the trip.

Organon exists for that failure.

It is a collection of instruments for making a body of work more internally legible: an ontology for stabilizing meaning, an editorial grammar for carrying difficult ideas, and formal artifacts for discovering where apparently compatible definitions collapse under pressure. The name comes from the traditional title for Aristotle's collected works on logic: instruments of reasoning, not the doctrine those instruments may later examine.

## Why it lives in Idolum

[Idolum](https://github.com/idolum-ai) builds systems in which agents act across boundaries of authority, evidence, and responsibility. Those systems make unusually expensive demands on language. A capability is not automatically a permission. An output is not automatically completion. A record is not automatically evidence. When a project blurs those distinctions, the implementation eventually inherits the confusion.

Organon provides a common surface from which Idolum's project documentation can be reviewed. It asks questions such as:

- What entities and relations does this document claim exist?
- Which actor possesses a capability, and which Principal grants Permission to use it?
- Who makes a Claim, what Witness is independent of that Claim, and what qualifies the result as Evidence?
- Where does a term change meaning as it crosses a repository boundary?
- Which uncertainty has been preserved as uncertainty, and which has been hidden by fluent prose?

The objective is not to make every repository sound alike. Project documentation should retain the vocabulary demanded by its own mechanisms. Organon supplies a place to notice when two documents appear to agree only because they use the same word differently.

## Who is Daniel?

Organon is not an anonymous standard. Its distinctions come from a particular history of building developer platforms, AI systems, and institutions around them. [Who is Daniel?](./DANIEL.md) records that position, the experience behind it, and the limits of his authority over work that other people maintain.

This matters because an ontology can be internally consistent and still reflect the attention of its author. Declaring that attention makes the work easier to challenge. It also prevents a useful instrument from acquiring the suspicious voice of a tablet recovered from a mountain.

## The current instrument

[Daniel's Ontology](./Daniels-Ontology.md) is the current binding Markdown artifact. It begins with Absence and Presence, then develops a dependency-ordered system for Difference, Relation, Transformation, identity, Agency, Evidence, Permission, Authority, and institutional action. Its [changelog](./Daniels-Ontology-Changelog.md) preserves earlier arguments and rejected formulations so the active document does not have to debate its own ghosts.

The ontology is binding only within work that adopts Organon. Binding does not mean complete, universally true, or immune to revision. It means that a capitalized term cannot quietly change meaning halfway through an argument. Proposed changes belong in the changelog and must preserve dependency closure or state which prior commitment they replace.

## The editorial instruments

The [Long-Form Editorial Grammar](./Long-Form-Editorial-Grammar.md) describes the relationship through which a reader comes to need, receive, and carry a difficult idea. The canonical [Short Form](./Samples/Short-Form.md) governs the sentence-scale delivery once that idea has been earned. They are separate from the ontology: one governs argumentative movement, one governs delivery, and neither may silently redefine what the ontology says exists.

The ontology's essay evidence is indexed through the public [Essay Corpus](./References/Essay-Corpus.md). Private drafts and review artifacts are declared through [Editorial Provenance](./References/Editorial-Provenance.md) rather than disguised as working links into Daniel's vault.

## The Lean experiment

The [Lean formalization spike](./Ontology/README.md) tests whether selected regions of the ontology can survive a stricter host language. It currently formalizes local shadows of A1-A5, separates metalinguistic ordering from ontological Direction, carries Entity identity through a dependent Boundary, and constructs finite inhabited models for Missingness, Entity, and Permission.

Lean is not yet canonical. An uninhabited Lean type is still an object inside an already-present formal system; it is not absolute Absence. Compilation proves that the encoded declarations elaborate under the pinned compiler. It does not prove that the encoding exhausted the prose, that the prose exhausted Reality, or that the compiler has become a metaphysician.

The separation is intentional:

- Markdown states the binding ontology.
- Lean exposes decisions the prose can defer.
- The [formalization decisions](./Ontology/Formalization-Decisions.md) record those decisions without silently rewriting the ontology.
- The [build receipt](./Ontology/Build-Receipt.md) records exactly what the compiler verified.

## How to use Organon in a documentation review

Begin with the project, not with the ontology. Identify what the project actually does, which boundaries it enforces, and what evidence it emits. Then use Organon as a comparison surface.

1. Extract the project's important nouns, actors, transformations, and authority claims.
2. Map only the terms that genuinely correspond to an Organon definition.
3. Record mismatches instead of normalizing them by vocabulary alone.
4. Distinguish a contradiction from a project-specific refinement.
5. Return the result to the project as concrete documentation changes, unresolved questions, or an explicit proposal to revise Organon.

The desired result is not terminological obedience. It is a document whose reader no longer has to reconstruct the system from accidental synonyms.

## Markdown in Obsidian and GitHub

Organon is edited inside an Obsidian vault and published through GitHub. The two do not need separate source documents. Repository-facing files use the portable intersection documented in [Markdown Policy](./MARKDOWN.md): ordinary Markdown, relative Markdown links, fenced code blocks, and only those callout forms both renderers understand.

Obsidian wikilinks, transclusions, block references, and query plugins remain useful in vault-private notes. They should not become dependencies of a public document. The rule is simple: Obsidian may provide the workshop, but GitHub must be able to read what leaves it.

Run the repository boundary check with:

```sh
python3 scripts/check-links.py
```

The checker rejects active wikilinks, private `Contexts/` paths, missing local targets, and relative links that escape the repository. Historical artifacts are exempt from syntax migration but must carry a public provenance notice.

## Status

Organon is provisional and already binding in a narrower sense: the ontology governs work that explicitly adopts it, while the larger editorial and repository-review method is still being exercised. The README is part of that exercise. If the instrument cannot explain itself without becoming ceremonial, that is evidence too.
