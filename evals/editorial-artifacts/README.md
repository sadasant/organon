# Editorial-artifact suite

This suite generates reviewable READMEs and long-form documentation from
digest-pinned sources, then evaluates and selectively revises them under
Organon's editorial instruments.

## Contract

The generator must preserve source-backed facts, commands, links, status,
nonclaims, and safety boundaries before improving hierarchy or prose. The
ordered gate is:

1. deterministic artifact length, delivery length, anchors, and path safety;
2. Organon fidelity and anti-collapse discipline;
3. sentence-scale delivery under short form;
4. reader progression and earned delivery under long form.

The short-form judge receives only the declared delivery beats. The long-form
judge owns structure and proportionality but not exact length. Revision is
caller-bounded, preserves passing layers, and never lowers the threshold.

## Inputs and outputs

```text
inputs/
├── targets.json
└── sources/
results/<run>/
├── run.json
├── report.md
├── improvement-plan.json
├── improvement-plan.md
└── artifacts/
```

External README sources are pinned to repository, commit, path, and SHA-256.
Generated candidates remain proposals; this suite never writes into the target
repository.

## Run

```sh
OPENAI_API_KEY='injected-by-your-secret-manager' \
python evals/editorial-artifacts/run.py \
  --target-id engram-main-readme \
  --target-id kenogram-main-readme \
  --run-dir evals/editorial-artifacts/results/YYYY-MM-DD-readmes
```

The defaults are GPT-5.6 Sol at high reasoning effort for generation and all
three separate judge calls. The prompts follow the versioned GPT-5.6 contract
recorded in the run.

## Retained finding

The [current pointer](current.json) selects the
[v0.18 Sol run](results/2026-08-09-v0.18/report.md), which passes all
four targets through deterministic, Organon, short-form, and long-form gates.
The Organon project narrative and Kenogram README passed their first attempts;
the ontology narrative and current Engram README passed after one bounded
revision each. Engram is pinned to public commit `1b56983`; Kenogram remains
pinned to `8c00104`.

Their value is not that generated prose “won.” Each candidate is traceable to
exact source bytes and layer-specific evidence, and each remains held for human
review rather than silently promoted into its target repository.
