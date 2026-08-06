# Lessons retained from PR #11

PR #11 was exploratory. Its value came from exposing where an evaluation can
look rigorous while quietly losing the thing it claims to govern. These are the
lessons retained after removing the intermediate artifacts.

## Trust-boundary lessons

- A relative-looking selector is not confined until absolute paths, parent
  traversal, and symlink escape are all rejected.
- A Git commit alone is false provenance when model-visible inputs differ from
  that commit. Governed inputs must be tracked and byte-identical to HEAD.
- A judgment over candidate A can be attached to candidate B unless name and
  digest are checked together.
- Answer identity is insufficient when the source essay changes. Reuse requires
  both answer identity and source identity.
- Source digests are mandatory, not optional metadata.

## Evaluation-design lessons

- Deterministic checks should own length, cardinality, path, digest, schema, and
  citation bounds. Asking a model to estimate them makes the gate weaker.
- Judges need non-overlapping ownership. A short-form judge should see the
  declared delivery, not fail a README for missing installation instructions.
- Organon fidelity comes before elegance. A fluent artifact with a term collapse
  is not ready.
- Same-model generation and judging can be useful pressure but is not independent
  corroboration.
- Revision must be bounded. A residual failure is a result worth preserving.

## Editorial lessons

- Essay questions needed their own form. Short-form discipline alone produced
  answers that were correct but disproportionate.
- Effective answers require a thin, evidenced model of the questioner's likely
  background and purpose—not an invented biography and not a hostile straw man.
- Long-form evaluation is about reader transition and earned delivery, while
  README evaluation also requires operational completeness and source fidelity.

## Ontology lessons

- Project language must be described before it is translated into Organon.
- Local terms such as “authority,” “world,” “evidence,” or “declaration” can be
  disciplined and still conflict with Organon's registered terms.
- A mapping is load-bearing only when its required participants and relations
  join in one path. Decorative parameters and neighboring examples do not close
  the dependency.
- `unmapped` is often the rigorous result. Promotion gates are more useful than
  premature refinements.

## Product lesson

Raw iterations are laboratory debris unless they change the instrument. Keep
one canonical record of the learned experiment, encode its lesson in code or
methodology, and let Git history preserve the rest.
