# Essay-question evaluation

This evaluation asks GPT-5.6 Luna to answer four reader questions for each of Daniel's ten most recent canonical essays. The current Essay-Answer Form lane gives every request:

1. the complete binding `ontology/ontology.md`;
2. the complete proposed `editorial/essay-answer-form.md`;
3. one canonical essay body from the Parergon Essays context; and
4. that essay's four versioned reader questions.

The ontology governs term use and anti-collapse constraints. The Essay-Answer Form governs the relational answer shape. Every output records a thin, evidenced, defeasible interlocutor hypothesis before producing the visible answer. The prompt explicitly forbids treating either instrument as evidence that an essay's factual Claims are true.

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

Add `--selection calibration.json` for the ten-question calibration surface. After judging that result, `compare.py` renders the baseline answer, candidate answer, interlocutor hypothesis, length change, and gate evidence together for review.

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
- SHA-256 digests of the ontology, Essay-Answer Form, optional selection, questions, and essays;
- each question's original lens and pressure point;
- answer disposition, answer, essay anchors, and limitation;
- whether the run completed all ten essays and forty questions.

Generated answers are not Daniel-authored prose, corrections to the essays, or binding Organon Claims.

`evaluate.py` applies deterministic answer-contract checks and two separate judge calls to a recorded result: one for ontology correctness and one for Essay-Answer Form fit. The ontology judge does not demand exhaustive dependency rendering. The editorial judge scores responsiveness, interlocutor fit, proportionality, necessary bridge, epistemic boundary, and stopping discipline. An answer passes only when every deterministic check passes, every judge criterion scores at least 3/4, and neither judge reports a critical violation. `--baseline-evaluation` reuses a prior judgment only when the complete answer record has the same canonical digest; changed answers alone are rejudged. This makes a refinement sequence attributable rather than allowing a fresh judge pass to reopen unchanged answers. Same-model generation and judging remains an explicit limitation.

`refine.py` rewrites only failed answer IDs and records the source and evaluation digests. Passing answers are preserved byte-for-byte. Refinement is bounded by the caller; a residual failed gate remains a result, not permission to lower the threshold or loop indefinitely.

## Recorded runs

| Ontology snapshot | JSON | Markdown |
|---|---|---|
| v0.16 | [machine record](./results/gpt-5.6-luna-2026-08-04.json) | [readable projection](./results/gpt-5.6-luna-2026-08-04.md) |
| v0.17 | [machine record](./results/gpt-5.6-luna-2026-08-04-v0.17.json) | [readable projection](./results/gpt-5.6-luna-2026-08-04-v0.17.md) |
| v0.17 refined candidate (35/40 pass) | [machine record](./results/gpt-5.6-luna-2026-08-05-v0.17-final.json) | [readable projection](./results/gpt-5.6-luna-2026-08-05-v0.17-final.md) |
| v0.17 final judgments | [machine record](./results/gpt-5.6-luna-2026-08-05-v0.17-final-evaluation.json) | [readable projection](./results/gpt-5.6-luna-2026-08-05-v0.17-final-evaluation.md) |
| Essay-Answer Form v0.2 calibration (9/10 pass) | [machine record](./results/gpt-5.6-luna-2026-08-05-answer-form-v0.2-calibration.json) | [baseline comparison](./results/gpt-5.6-luna-2026-08-05-answer-form-v0.2-calibration-comparison.md) |
| Essay-Answer Form v0.2 complete candidate (39/40 pass) | [machine record](./results/gpt-5.6-luna-2026-08-05-answer-form-v0.2-complete-refined.json) | [readable projection](./results/gpt-5.6-luna-2026-08-05-answer-form-v0.2-complete-refined.md) |
| Essay-Answer Form v0.2 complete judgments | [machine record](./results/gpt-5.6-luna-2026-08-05-answer-form-v0.2-complete-refined-evaluation.json) | [baseline comparison](./results/gpt-5.6-luna-2026-08-05-answer-form-v0.2-complete-comparison.md) |

Version 0.1 is retained as calibration evidence: it improved reader fit but increased visible answer length by roughly 17%. Version 0.2 adds the 35–90 word and two-to-four-sentence contract. Its complete refined set contains 2,641 visible words versus 2,965 in the previous short-form-governed baseline, an 11% reduction. AP-1 remains the sole failed gate because the question's ordinary “artificial personhood” language repeatedly collapses into Organon's distinct Institution, Person, and Agency terms.
