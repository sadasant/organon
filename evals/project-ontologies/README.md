# Project-ontology suite

This suite generates or evaluates source-pinned descriptions of a repository's
local vocabulary and its proposed mappings into Organon. Generation always
produces a candidate; judgment begins only after those exact bytes are reviewed,
registered in `inputs/targets.json`, and committed.

## Contract

Every project ontology describes local terms first, then marks mappings as
`exact`, `refinement`, `conflict`, or `unmapped`. Its embedded machine manifest
must cite exact upstream ranges covered by the generated source dossier.

The ordered gate is:

1. deterministic provenance, headings, manifest, registered IDs, and line bounds;
2. Organon dependency, anti-collapse, causal, epistemic, and institutional fidelity;
3. open-source traceability, coverage, cadence, local-language preservation,
   maintenance readiness, and delivery.

A plausible analogy does not count as a refinement. Unclosed dependency packets
become explicit promotion gates in the improvement plan.

## Inputs and outputs

```text
inputs/
├── targets.json
├── documentation-rubric.md
└── sources/
results/<run>/
├── run.json
├── report.md
├── improvement-plan.json
└── improvement-plan.md
```

`build-source-dossier.py` verifies the exact public checkout commit and copies
only cited ranges, retaining upstream line coordinates and file digests.

`generate.py` creates a fresh candidate or, when given both an existing
candidate and its `improvement-plan.json`, performs one evidence-bounded
revision. It runs the deterministic manifest and citation gate before writing.
The generated candidate is not silently inserted into `project-ontologies/`.

## Run

```sh
OPENAI_API_KEY='injected-by-your-secret-manager' \
python evals/project-ontologies/generate.py \
  --target-id engram-project-ontology \
  --run-dir /tmp/engram-ontology-candidate

OPENAI_API_KEY='injected-by-your-secret-manager' \
python evals/project-ontologies/run.py \
  --run-dir evals/project-ontologies/results/YYYY-MM-DD-organon-v0.17
```

The Organon judge runs before the documentation judge. Same-model agreement is
useful generated pressure, not independent certification or project adoption.

## Retained finding

The [canonical run](results/2026-08-06-organon-v0.17/report.md) holds both
project ontologies at `revise`. Their local vocabularies, public citations, and
anti-collapse boundaries are strong; their positive mappings still promote
several incomplete dependency packets. The generated
[improvement plan](results/2026-08-06-organon-v0.17/improvement-plan.md) names
the exact missing causal, institutional, identity, and maintenance joins. That
is a successful evaluation result, not a reason to relax the mapping contract.
