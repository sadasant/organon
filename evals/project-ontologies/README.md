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
revision. It exposes every deterministic requirement in the prompt and permits
at most three correction attempts driven by exact preflight failures. A run is
written only after its manifest, headings, provenance, registered IDs, and
covered citations all pass. The generated candidate is not silently inserted
into `project-ontologies/`.

## Run

```sh
OPENAI_API_KEY='injected-by-your-secret-manager' \
python evals/project-ontologies/generate.py \
  --target-id engram-project-ontology \
  --run-dir /tmp/engram-ontology-candidate

OPENAI_API_KEY='injected-by-your-secret-manager' \
python evals/project-ontologies/run.py \
  --run-dir evals/project-ontologies/results/YYYY-MM-DD-organon-v0.18
```

The Organon judge runs before the documentation judge. Same-model agreement is
useful generated pressure, not independent certification or project adoption.

## Retained finding

The [current pointer](current.json) selects the
[v0.18 run](results/2026-08-09-organon-v0.18-final/report.md), which
passes both project ontologies after preserving two earlier `revise` runs as
their correction lineage. Engram narrows its Invariant promotion to the exact
styled-capture interval with before-and-after identity witnesses. Kenogram
demotes unsupported Missingness, Invariant, Record, and Evidence mappings while
retaining its complete Specification, State, and successful-Transformation
packets. Both remain generated candidates rather than project adoption.
