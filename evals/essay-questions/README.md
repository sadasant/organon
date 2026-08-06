# Essay-question suite

This suite calibrates the [Essay-Answer Form](../../editorial/essay-answer-form.md)
against forty reader questions for Daniel's ten most recent canonical essays.
It is the only suite that reads a private corpus; selectors remain portable and
the run records only source digests, never the vault root.

## Contract

Each answer receives the complete binding ontology, the complete Essay-Answer
Form, one essay, and that essay's questions. The generator first records the
thinnest interlocutor hypothesis supported by the question, then answers in
35–90 words and two-to-four sentences. It may not invent Daniel's position or
treat the ontology as factual Evidence.

The ordered gate is:

1. deterministic answer shape and required metadata;
2. Organon term, anti-collapse, epistemic, and source fidelity;
3. responsiveness, interlocutor fit, proportionality, necessary bridge,
   epistemic boundary, and stopping discipline.

Judgment reuse requires identical answer bytes **and** identical essay bytes.
Refinement changes only failed IDs. Comparison fails closed unless the
evaluation names and hashes the exact candidate.

## Inputs and outputs

```text
inputs/
├── questions.md
└── calibration.json
results/<run>/
├── candidate.json
├── candidate.md
├── evaluation.json
├── evaluation.md
├── improvement-plan.json
├── improvement-plan.md
├── comparison.json
└── comparison.md
```

`candidate.*` is generated first. Evaluation, optional bounded refinement, and
comparison are explicit later commands in the same lineage; no stage silently
overwrites another.

## Run

From the repository root, after installing `evals/requirements-dev.txt`:

```sh
OPENAI_API_KEY='injected-by-your-secret-manager' \
PARERGON_VAULT='/absolute/path/to/Parergon' \
python evals/essay-questions/run.py \
  --run-dir evals/essay-questions/results/YYYY-MM-DD-answer-form-v0.2
```

Use `evaluate.py`, `refine.py`, and `compare.py` with the named artifacts in
that directory. `--selection evals/essay-questions/inputs/calibration.json`
selects the ten-question calibration surface.

## Retained finding

The v0.2 experiment is the canonical retained run. Its 35–90 word contract
reduced visible answer length from 2,965 to 2,641 words while 39 of 40 answers
passed. The remaining AP-1 failure exposed a real pressure: ordinary
“artificial personhood” language tends to collapse Organon's distinct
Institution, Person, and Agency terms. The result remains a calibration finding,
not a reason to weaken the ontology or the gate.
