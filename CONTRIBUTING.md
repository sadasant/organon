# Contributing to Organon

Organon changes the vocabulary through which other work may be judged. A locally plausible definition can therefore create repository-wide confusion if its dependencies, anti-entailments, or intellectual inheritance remain implicit. Review depth must track semantic risk.

## Canonical boundary

The binding artifact is the readable, single-file [ontology](./ontology/ontology.md). The term registry, provenance records, Lean sources, examples, and release notes must agree with it, but none silently replaces it. Proposals remain nonbinding until their exact promoted content enters the ontology and every governed projection is updated.

A proposal manifest must list its `introduced_terms`. Proposal dependency closure is evaluated against the current registry with those terms removed; a statement may depend on an earlier proposal statement ID, but it may not borrow closure from the same promotion it is arguing for. When a promotion is enacted, update the dossier's independent lifecycle status to `partially-promoted` or `promoted`. The dossier remains nonbinding provenance after that transition.

## Change classes

1. **Editorial or nonbinding:** wording, navigation, provenance, or a quarantined proposal that does not alter binding meaning.
2. **Registry-preserving:** a mechanical projection or check whose meaning is already fixed by the ontology.
3. **Binding promotion:** a new or changed definition, axiom, constraint, relation signature, dependency, or adopted profile. This class requires the full protocol below.

## Binding-promotion protocol

### 1. State the candidate claim

Write the shortest exact claim being promoted. Identify its corpus evidence and provenance. Essays can motivate a term; they do not prove it.

### 2. Challenge termhood

Try to express the candidate as an existing term, a Configuration of existing terms, or a derived consequence. A new stable term is justified only when that reduction loses a distinction the ontology needs. Record the strongest rejected reduction and the surviving difference.

### 3. Type and order dependencies

Classify the candidate as an Entity, Relation, Configuration, Specification, Rule, institutional record, or another already-defined kind. List every earlier term used anywhere in the complete logical form, including positive premises, participant and index types, alternatives, contrasts, exclusions, and anti-entailments. Record positive premises and witnesses separately. `depends_on` establishes lexical closure and definition order; it is not an instance constructor. Do not use undeclared object-language vocabulary to explain the candidate.

### 4. Audit collapses in both directions

For every adjacent term, ask both implications separately. State which implications hold, which fail, and under what Scope. Include negative cases. If the proposal says two things are independent, replace that slogan with the exact anti-entailments.

### 5. Identify intellectual shadows

Name the strongest local precedent for each region, inherit available rigor, and state the originality boundary. Similarity is neither disqualification nor borrowed authority. The contribution may be the unification, restriction, or dependency discipline rather than a novel local term.

### 6. Price the formal commitment

Use Lean when dependent structure and proof obligations are central; use a finite model finder when satisfiability or collapse hunting benefits from exhaustive small worlds. If no formal artifact is proportionate, say why and record the remaining gate. Formalization must expose commitments rather than decorate prose.

### 7. Supply witnesses and countermodels

Add at least one finite inhabited witness for a promoted structure. For every claimed anti-entailment, add a countermodel or explain why the claim is outside the current formal boundary. Do not use `sorry`, `admit`, or undeclared axioms as promotion evidence.

### 8. Preserve the readable ontology

Read the complete ontology as one document after the change. It must define itself without conversation history, obsolete formulations, or references to prior drafts. Changelog and proposal records carry the argument with previous versions.

### 9. Update every governed surface

Update the binding prose, `ontology/terms.yaml`, profiles, provenance, changelog, release note, adoption example, formal decision record, and build receipt wherever applicable. A formal receipt attests an implementation commit by exact source digests; commit the implementation first and the receipt second.

### 10. Record objections and gates

Distinguish resolved objections from open promotion gates. Quarantined vocabulary may be partially promoted: Organon can govern Claims, evidence, or institutional treatment around a condition while the condition itself remains undefined.

## Review maturity

- **Draft / unreviewed:** a candidate exists; no claim of completeness.
- **Locally verified:** repository checks pass and governed surfaces agree.
- **Adversarially reviewed:** termhood, dependencies, collapses, shadows, and countermodels have been challenged.
- **Promotion-ready:** adversarial findings are resolved or declared as explicit gates, the readable ontology is coherent, and exact-head verification passes.

Passing CI establishes local verification, not adversarial review or philosophical truth.

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

Also run `git diff --check` and read the rendered Markdown in both GitHub and Obsidian-compatible form. Review the exact pushed head, not an earlier local commit.
