# Term Provenance

This ledger records why each stable Organon term is present. It establishes lineage, not truth. A term may be recoverable from Daniel's essays, adopted through direct review, repaired after formalization, or sharpened by an external critique; none of those facts makes its definition correct by itself.

The machine-readable coverage ledger is [terms.json](./terms.json). Every `organon:*` identifier in the binding [term registry](../ontology/terms.yaml) must occur exactly once in that ledger. The semantic checker rejects missing, duplicated, or unknown terms and unknown source identifiers.

## Provenance bases

- `corpus-extraction`: the recurring distinction was extracted from one or more published essays indexed by [Essay Corpus](./essays.md).
- `adopted-commitment`: Daniel directly selected or corrected the binding distinction during ontology review.
- `formalization-finding`: Lean exposed a commitment, collapse, or missing dependency that the prose then adopted.
- `review-repair`: adversarial review exposed a local ambiguity, collision, or incompleteness that the binding system repaired.

The sources are deliberately coarse. This is not a claim that each article contains the current definition verbatim. It is a falsifiable record of the intellectual and review surfaces from which the current term was consolidated.

## Maintenance

When a term changes meaning, update its definition, registry dependencies, provenance entry, and changelog together. When a new term has no honest source, label its basis as a new adopted commitment rather than manufacturing ancestry.
