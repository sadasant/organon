# Editorial-artifact evaluation

This evaluation generates long-form artifacts about Organon and reviewable replacement READMEs for selected Idolum projects, then evaluates each with deterministic checks and three separate model-judge calls:

1. ontology fidelity and anti-collapse discipline;
2. canonical short-form delivery discipline; and
3. provisional long-form grammar.

The generator and judges receive the complete current ontology and both editorial instruments. Target briefs and source files are versioned in `targets.json`. External README inputs are vendored snapshots pinned to an upstream repository, `main` commit, path, and SHA-256 digest; the runner fails closed if a pinned digest drifts. A result passes only when its target-specific deterministic contract passes, every judge criterion scores at least 3/4, and no judge reports a critical violation. The short-form judge receives only the draft's declared delivery beats, never the whole essay. Each beat must also satisfy the deterministic 15–100 word contract. Failed drafts may receive a caller-bounded number of feedback-driven revisions; every attempt retains both its draft and evaluation.

The same named model family performs generation and judging through separate prompts and calls. The artifact records that limitation. Judge agreement is generated Evidence about one pipeline run, not independent human validation or a binding Organon Claim.

Judge ownership is explicit. Deterministic checks own exact artifact and delivery lengths. The short-form judge sees only the declared sentence-scale deliveries plus a 15–100-word delivery contract; it cannot fail them for omitting the complete README. The long-form judge assesses structure and proportionality but is instructed not to estimate a word count already computed exactly elsewhere.

## Run

Use the existing essay-evaluation environment or install these pinned requirements, then inject only `OPENAI_API_KEY` into the child process:

```sh
python run.py \
  --target-id engram-main-readme \
  --target-id kenogram-main-readme \
  --output-stem results/gpt-5.6-sol-v0.18 \
  --artifact-output-dir results/gpt-5.6-sol-v0.18-artifacts \
  --obsidian-output /absolute/path/to/Parergon/Contexts/Organon/Evaluations/Long-Form-GPT-5-6-Sol-v0.18.md \
  --obsidian-artifact-output-dir /absolute/path/to/Parergon/Contexts/Organon/Evaluations/GPT-5-6-Sol-v0.18-README-Candidates
```

Generated articles are proposals for review. They do not replace repository documentation or become Daniel-authored merely by satisfying the automated gate.

The default generator and judge are both `gpt-5.6-sol` at the pre-existing explicit `high` reasoning effort. This preserves the prior reasoning contract while moving the quality-first long-form workload from the Luna throughput tier to the Sol flagship tier. Requests have a ten-minute fail-closed timeout, and target-level progress is printed without prompt bodies or credentials.

The Sol prompt contract follows OpenAI's GPT-5.6 guidance: it states the outcome and target-specific success criteria, preserves the source artifact and factual claims before improving prose, names grounding and anti-invention constraints once, and stops when the artifact is operationally complete. The v0.18 run selects only the two new README targets; the manifest retains the two historical Organon targets for reproducibility and future reruns.

## Recorded runs

The v0.17 bounded run generated both requested targets. The ontology artifact passed all gates after one revision. The Organon-project artifact remained below the complete gate after three revisions; its ontology, delivery, and long-form criticisms are retained rather than converting the threshold into a moving target.

- [machine record](./results/gpt-5.6-luna-2026-08-05-v0.17-final-2.json)
- [readable projection](./results/gpt-5.6-luna-2026-08-05-v0.17-final-2.md)

The v0.18 Sol run extends the target set with pinned Engram and Kenogram `main` README snapshots. Its generated candidates are review artifacts only: no downstream repository README is changed by this evaluation.

- [machine record](./results/gpt-5.6-sol-2026-08-05-v0.18.json)
- [readable projection](./results/gpt-5.6-sol-2026-08-05-v0.18.md)
- [Engram README candidate](./results/gpt-5.6-sol-2026-08-05-v0.18-artifacts/engram-main-readme.md)
- [Kenogram README candidate](./results/gpt-5.6-sol-2026-08-05-v0.18-artifacts/kenogram-main-readme.md)
