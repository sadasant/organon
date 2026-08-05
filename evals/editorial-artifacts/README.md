# Editorial-artifact evaluation

This evaluation generates two initial long-form artifacts—one about Organon as a project and one about its ontology—then evaluates each with deterministic checks and three separate model-judge calls:

1. ontology fidelity and anti-collapse discipline;
2. canonical short-form delivery discipline; and
3. provisional long-form grammar.

The generator and judges receive the complete current ontology and both editorial instruments. Target briefs and source files are versioned in `targets.json`. A result passes only when its deterministic contract passes, every judge criterion scores at least 3/4, and no judge reports a critical violation. The short-form judge receives only the draft's declared delivery beats, never the whole essay. Each beat must also satisfy the deterministic 15–100 word contract. Failed drafts may receive a caller-bounded number of feedback-driven revisions; every attempt retains both its draft and evaluation.

The same named model family performs generation and judging through separate prompts and calls. The artifact records that limitation. Judge agreement is generated Evidence about one pipeline run, not independent human validation or a binding Organon Claim.

## Run

Use the existing essay-evaluation environment or install these pinned requirements, then inject only `OPENAI_API_KEY` into the child process:

```sh
python run.py \
  --output-stem results/gpt-5.6-luna-v0.17 \
  --obsidian-output /absolute/path/to/Parergon/Contexts/Organon/Evaluations/Long-Form-GPT-5-6-Luna-v0.17.md
```

Generated articles are proposals for review. They do not replace repository documentation or become Daniel-authored merely by satisfying the automated gate.

## Recorded run

The v0.17 bounded run generated both requested targets. The ontology artifact passed all gates after one revision. The Organon-project artifact remained below the complete gate after three revisions; its ontology, delivery, and long-form criticisms are retained rather than converting the threshold into a moving target.

- [machine record](./results/gpt-5.6-luna-2026-08-05-v0.17-final-2.json)
- [readable projection](./results/gpt-5.6-luna-2026-08-05-v0.17-final-2.md)
