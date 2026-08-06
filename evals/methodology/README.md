# Artifact improvement methodology

This methodology converts a repository artifact from an object of taste into a
bounded claim: these exact bytes, under these exact sources and instruments,
passed these exact checks. Its purpose is not to mechanize taste. Its purpose is
to make the reasons for revision inspectable and reusable.

## The unit of work

One target is a tuple:

```text
(source identity, source bytes, target brief, governing instruments,
 candidate bytes, deterministic observations, judge observations,
 improvement plan, human disposition)
```

Changing any load-bearing member creates a new run. A passing judgment cannot be
moved to another candidate, and a judgment over one source snapshot cannot be
reused after that source changes.

## Lifecycle

### 1. Snapshot

Pin repository, commit, path, and SHA-256. For a local corpus, record a portable
selector and the source digest without committing the private root. Build the
smallest dossier that still lets a reviewer reconstruct every material claim.

### 2. Deterministic preflight

Reject bad identity, unsafe selectors, missing digests, malformed manifests,
out-of-range citations, missing required fields, and exact length violations.
Do this before model invocation. A judge should never be asked to estimate what
code can decide.

### 3. Generate

Give the generator the target brief, pinned dossier, and only the instruments
that govern this artifact kind. Preserve source-backed facts, commands, links,
status, and nonclaims. Generated text is a candidate, never an in-place edit.

### 4. Judge in declared order

Judges have separate ownership. The Organon judge runs before editorial or
documentation judges because a graceful term collapse is still a collapse.
Sentence delivery is not asked to prove document completeness. Long-form shape
is not asked to estimate word counts. Each judge returns scores, critical
violations, evidence, and one bounded revision instruction.

### 5. Diagnose

Translate failed layers into an improvement plan with three parts:

- what must change;
- what successful properties must survive;
- what evidence would close the gate.

A pass produces no synthetic work. It means “hold for human review,” not “ship.”

### 6. Revise under a budget

Revise only failed properties, preserve passing layers, and cap attempts before
the run begins. A remaining failure is information. It is never permission to
move the threshold.

### 7. Compare

When a baseline exists, compare exact bytes and reader-relevant consequences:
claims preserved, gates changed, length changed, and remaining resistance. Do
not call difference improvement merely because a judge score increased.

### 8. Human promotion

The target maintainer decides whether to adopt, revise, or reject the candidate.
Applying it to another repository is a separate authorized workflow with that
repository's tests, contribution rules, and review.

## Target profiles

The machine-readable [profiles](./profiles.json) specialize this lifecycle.

### README and documentation

The source artifact is authoritative for existing facts, commands, links, and
status. Generation may improve hierarchy, explanation, and progression but may
not turn evidence into a promise. A good candidate helps a new reader answer:
what is this, why does it exist, what boundary does it enforce, how do I try it,
and where do I inspect deeper claims?

### Project ontology

Describe local vocabulary before mapping it. Every mapping is `exact`,
`refinement`, `conflict`, or `unmapped`; “plausible analogy” is not a fifth
class. Organon mappings require their dependency packets, not matching words.
Unclosed mappings remain explicit promotion gates.

### Essay answer

Infer only the thinnest reader background supported by the question. Answer the
question's actual debt, include the necessary bridge, mark the epistemic edge,
and stop. This profile calibrates an editorial instrument; it is not a general
documentation generator.

## Use outside Organon

To improve another project later:

1. add a pinned target and source dossier;
2. run the relevant suite into a new run directory;
3. inspect the candidate, report, and improvement plan together;
4. revise or reject locally until the evidence is worth presenting;
5. open a separate pull request in the target repository, carrying source
   provenance and unresolved limitations with the candidate.

The transferable muscle is not “ask a model to rewrite the README.” It is the
ability to preserve identity, separate kinds of judgment, and show exactly why
the proposed artifact deserves a maintainer's attention.

