# Essay-question evaluation

This evaluation asks GPT-5.6 Luna to answer four reader questions for each of Daniel's ten most recent canonical essays. Every request receives:

1. the complete binding `ontology/ontology.md`;
2. the complete canonical `editorial/short-form.md`;
3. one canonical essay body from the Parergon Essays context; and
4. that essay's four versioned reader questions.

The ontology governs term use and anti-collapse constraints. The short-form note governs delivery only. The prompt explicitly forbids treating either instrument as evidence that an essay's factual Claims are true.

## Context boundary

The Organon repository does not absorb the essay corpus. `questions.md` is a versioned evaluation input containing repository-safe relative selectors for the canonical notes. At runtime, `run.py` resolves those selectors against `PARERGON_VAULT`, reads the ten essay bodies, and records a SHA-256 digest for every source. Generated answers can therefore be compared to the exact local corpus snapshot without duplicating the essays or private vault paths into this repository.

## Credential boundary

`.env.example` is safe to commit. A populated `.env` is ignored, but the preferred execution path injects only `OPENAI_API_KEY` from a secret manager or existing environment. The runner never reads Engram configuration, writes a key, or includes a key in an artifact.

For Daniel's current machine, the one-time invocation can extract only `OPENAI_API_KEY` from the existing `~/.engram/.env` into the child process. Do not source that entire file: it contains unrelated credentials.

## Install and test

```sh
python3.12 -m venv .venv
.venv/bin/python -m pip install -r requirements-dev.txt
.venv/bin/python -m pytest
```

## Run

```sh
OPENAI_API_KEY='injected-by-your-secret-manager' \
PARERGON_VAULT='/absolute/path/to/Parergon' \
.venv/bin/python run.py \
  --output-stem results/gpt-5.6-luna-YYYY-MM-DD \
  --obsidian-output '/absolute/path/to/Parergon/Contexts/Organon/Evaluations/Essay-Questions.md'
```

Defaults:

- model: `gpt-5.6-luna`
- API surface: OpenAI Responses through DSPy's `model_type="responses"`
- reasoning effort: `medium`
- batching: one request per essay
- DSPy response caching: enabled

The runner fails closed if a model omits, duplicates, or invents question IDs. It writes JSON first and renders the Obsidian/GitHub-compatible Markdown table from that validated JSON.

## Artifacts

The JSON result is the machine-readable record. The committed Markdown result is a repository-safe projection for human review. The optional Obsidian projection adds local wikilinks and is written only into the vault. Each records:

- model and reasoning configuration;
- source commit and generation time;
- SHA-256 digests of the ontology, short-form note, questions, and essays;
- each question's original lens and pressure point;
- answer disposition, answer, essay anchors, and limitation;
- whether the run completed all ten essays and forty questions.

Generated answers are not Daniel-authored prose, corrections to the essays, or binding Organon Claims.

## Recorded runs

| Ontology snapshot | JSON | Markdown |
|---|---|---|
| v0.16 | [machine record](./results/gpt-5.6-luna-2026-08-04.json) | [readable projection](./results/gpt-5.6-luna-2026-08-04.md) |
| v0.17 | [machine record](./results/gpt-5.6-luna-2026-08-04-v0.17.json) | [readable projection](./results/gpt-5.6-luna-2026-08-04-v0.17.md) |
