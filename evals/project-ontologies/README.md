# Project-ontology evaluation

This evaluation judges project-specific ontology dossiers against two separate
contracts in a fixed order:

1. the complete binding Organon ontology, for term fidelity, dependency order,
   anti-collapse discipline, and load-bearing causal and institutional joins;
2. the versioned project-ontology documentation rubric, with the canonical
   short-form and provisional long-form instruments as bounded supporting
   context.

The runner does not generate or revise the ontologies. It evaluates exact
committed ontology and source snapshots pinned in `targets.json`. Deterministic
checks validate snapshot identity, source digests, required sections, embedded
mapping manifests, registered `organon:*` identifiers, and source-reference
line bounds before either model judge runs.

Both judges use separate calls. Same-model agreement is generated evidence
about one pipeline run, not independent validation, project adoption, or a
binding Organon claim.

## Run

```sh
python run.py \
  --output-stem results/gpt-5.6-sol-2026-08-06-v0.17 \
  --obsidian-output /absolute/path/to/Parergon/Contexts/Organon/Evaluations/Project-Ontologies-GPT-5-6-Sol-2026-08-06-v0.17.md
```

The default judge is `gpt-5.6-sol` with `high` reasoning effort and a ten-minute
fail-closed request timeout.
