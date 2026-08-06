# Evaluations

Organon evaluations turn a governed source snapshot into a reviewable candidate,
a layered assessment, and a bounded improvement plan. They are instruments for
learning and revision—not machinery for declaring generated prose canonical.

## One methodology

Every retained suite follows the same lifecycle:

1. **Snapshot** exact source bytes and identity.
2. **Preflight** deterministic contracts before any model receives the input.
3. **Generate** a candidate when the suite owns generation.
4. **Judge** with ordered, non-overlapping rubrics.
5. **Diagnose** failures as explicit changes with successful properties to preserve.
6. **Revise** only within a caller-bounded attempt budget.
7. **Compare** the exact candidate against its baseline when comparison is meaningful.
8. **Promote** only through human review in the target repository.

The binding contract is [the methodology](./methodology/README.md). The
[lessons record](./methodology/lessons.md) explains why each constraint exists.

## Structure

```text
evals/
├── core/                      # shared provenance, judging, output, and planning
├── methodology/               # lifecycle, target profiles, and lessons
├── essay-questions/
│   ├── inputs/
│   ├── results/<run>/
│   └── tests/
├── editorial-artifacts/
│   ├── inputs/
│   ├── results/<run>/
│   └── tests/
└── project-ontologies/
    ├── inputs/
    ├── results/<run>/
    └── tests/
```

Each final run directory contains `run.json`, `report.md`, and
`improvement-plan.{json,md}`. A generative suite may also contain `artifacts/`.
The essay suite names its staged files `candidate.*`, `evaluation.*`, and
`comparison.*` because generation, judgment, revision, and comparison can be
run independently inside one lineage.

## Suites

| Suite | Target | Owned model work | Ordered gates |
|---|---|---|---|
| [Essay questions](./essay-questions/README.md) | Answers to reader questions | Generate, judge, selectively revise, compare | Deterministic answer shape → Organon fidelity → Essay-Answer Form |
| [Editorial artifacts](./editorial-artifacts/README.md) | READMEs and long-form documentation | Generate, judge, bounded revision | Deterministic artifact contract → Organon fidelity → sentence delivery → long-form grammar |
| [Project ontologies](./project-ontologies/README.md) | Source-pinned repository ontologies | Judge and diagnose | Deterministic mapping/provenance contract → Organon fidelity → open-source documentation |

## Shared trust boundary

- Model-visible selectors cannot be absolute, traverse parents, or escape by symlink.
- Every repository source is digest-pinned before it is read.
- Every control input is tracked and byte-identical to the recorded Git HEAD.
- A judgment is reusable only when both candidate bytes and governed source bytes match.
- Comparison is bound to the exact candidate name and digest.
- Deterministic code owns exact quantities and identities; model judges own semantic judgments.
- Separate calls from the same model are not independent witnesses.
- Outputs never overwrite an existing run artifact.

Install once from this directory with `requirements-dev.txt`. Inject only
`OPENAI_API_KEY`; the runners never read or persist a secret on their own.
