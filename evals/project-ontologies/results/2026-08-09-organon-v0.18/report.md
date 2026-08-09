---
type: organon-evaluation
evaluation: project-ontologies
model: gpt-5.6-sol
generated_at: 2026-08-09T17:03:11+00:00
complete: true
passed: false
---

# Project Ontology Assessments

> [!summary]
> Deterministic contracts and two ordered judges assessed 2 exact project-ontology snapshots. The Organon judge ran first; the documentation judge then assessed source traceability, cadence, maintenance readiness, and delivery. These verdicts are generated evidence about this run, not project adoption or independent certification.

## Run

| Field | Value |
|---|---|
| Judge | `gpt-5.6-sol` / `high` |
| Organon commit | `a85a8f3e912d88cc56d1cd9987a304c94f2cacb3` |
| Ontology SHA-256 | `b187ea9298909b8b36cbc36bc8f05d980e8bab376eba036588f01f60737a9ec9` |
| Documentation rubric SHA-256 | `3ca1eeb33767711dc466e3d987b6aa9ebdaac4dd2604ab7652ac10a47667b452` |
| Judge order | organon-ontology -> open-source-documentation |
| Gate | 0 pass / 2 revise |

## Engram

> Snapshot: `https://github.com/idolum-ai/engram@1b56983ac658f10bfbd76c44bfc99c20b1355ebe` · Gate: **revise**

| Layer | Result | Minimum score | Critical violations | Revision |
|---|---|---:|---|---|
| Deterministic | pass | - | - | none |
| Organon ontology | revise | 2/4 | The promoted `validated terminal binding` → `organon:Invariant` mapping does not establish preservation across its named transformation family. The cited requirements establish effect-time identity validation, not before-and-after preservation; most input operations are not bracketed by a post-effect identity witness, and destructive close necessarily terminates rather than preserves the pane binding. Only the styled-capture excerpt supplies an explicit before/after identity comparison. | Replace the broad Invariant promotion with an unmapped result, or narrow it to the exact styled-capture interval and name the pre-capture State, post-capture State, capture Transformation, equality Invariant, and before/after witness from `CaptureStyled`. Do not include destructive close, and do not treat a precondition check as preservation. If the broader input family is retained, map its binding-equality mechanism only after selecting an Organon term whose complete definition matches a conditional guard, or add source-backed post-operation States proving preservation for every named transformation. Keep the existing conflict and unmapped institutional/evidentiary results unchanged. |
| Documentation | pass | 4/4 | none | No blocking revision is required. For marginal usability improvement, add a short navigation list before the mapping manifest and optionally include the source-index digest from the release metadata in the front matter; neither change is necessary for review readiness. |

**Ontology evidence:** The candidate is otherwise unusually disciplined. Its Frame→State, Watch→Record, Current view→Representation, and route-validity→Constraint packets follow the dependency order and name appropriate expression, target, state, persistence, and exclusion witnesses. The guarded reply-input CausalPath explicitly joins the incoming reply, prepared text, expected watch, terminal binding, validation stages, and tmux operation through named Feeds, rather than attaching a causal label to an unrelated example. Conflicts around local “source of truth” and GitHub “grant” are reported honestly instead of being forced into Organon Truth or Grant. Audit material, guide output, authorization checks, approvals, tokens, and leases remain unmapped where Evidence, Authority, Permission, or Capability constructors are incomplete. The scope and nonclaims also consistently prevent repository requirements or self-description from becoming security, completion, adoption, Truth, Evidence, or successful execution. The sole material promoted defect is the Invariant packet: `requirements/tmux.md:27-46` requires validation immediately before operations, while `internal/tmux/tmux.go:677-776` brackets only styled capture with before/after checks, and destructive close cannot preserve the named triple.

**Documentation evidence:** The ontology pins the repository, branch, commit, and Organon version, then supports material definitions, paths, invariants, boundary cases, and every mapping-manifest entry with exact file and line ranges. It explicitly distinguishes code mechanisms, binding requirements, design language, and repository self-description, and repeatedly refuses unsupported claims about security, adoption, Truth, Evidence, Authority, or successful operation. Coverage includes actors, operational boundaries, persisted and transient states, capture and input transformations, authority and evidence gaps, prohibited collapses, failure seams, and nonclaims without becoming a general feature inventory. Reader progression follows purpose and scope, local vocabulary, participants and boundaries, load-bearing paths, mappings, boundary cases, and promotion gates. Project terms such as watch, frame, current view, route, shelf, approval, grant, and lease are defined locally before mapping; refinement, conflict, and unmapped outcomes remain distinct. Maintenance support is unusually strong: the exact snapshot is named, source-visible terminology conflicts are preserved, uncertainties are explicit, and concrete drift triggers and promotion gates tell a later reviewer when to reopen classifications. Sentences generally preserve actors, mechanisms, scope, and qualifications despite the technical density, and the document ends with the mapping manifest rather than a promotional recap.

## Kenogram

> Snapshot: `https://github.com/idolum-ai/kenogram@8c00104bb4b666d844715bf9840634cf92e571e2` · Gate: **revise**

| Layer | Result | Minimum score | Critical violations | Revision |
|---|---|---:|---|---|
| Deterministic | pass | - | - | none |
| Organon ontology | revise | 2/4 | K5 promotes the required-observation world-pattern as an Organon Invariant, but its preserved bearer is described as a finite contract rather than an unambiguously identified runtime part, Relation, or Configuration. The named Transformation set also includes successful replacement generally, although replacement can change the declaration and therefore the required pattern. Normative conformance language and project claims that observations are preserved do not by themselves witness preservation in each mapped instance.; K2 and K6 rely on incomplete hidden bridges. K2 identifies a Representation and a loosely described denoted target but does not name an ordered Denotation with explicit expression and target positions as required for Representation and Specification. K6 likewise does not provide an instance-level Denotation, and its Persistence account does not name the preserved Invariant, ordered States, and Transformations constituting the required persistence witness. | Retain K1, K3, and K4, and retain K7–K13 as gated. Revise K5 to map only an actual runtime Relation or Configuration observed in both endpoint States of a specifically identified pattern-preserving replacement or same-declaration reapplication. Restrict the Transformation set accordingly, name the exact preserved bearer, and require pre/post observation witnesses; otherwise classify world-pattern as an unmapped local specification rather than an Invariant. For K2, explicitly declare the ordered Denotation: expression participant = the version-1 contract/schema Representation; target participant = the version-1 declaration-conformity Configuration within the stated Scope. For K6, require each promoted history entry to name its exact earlier State, Relation, or Change through an ordered Denotation and supply a Persistence witness naming the preserved entry/hash Invariant, ordered post-append States, and relevant subsequent transformations or verification steps. Until those packets are supplied, gate K2, K5, and K6 rather than promoting them. |
| Documentation | pass | 3/4 | none | Review-ready. For a final polish, split the densest mapping and promotion-gate sentences so each first names the local actor or mechanism and then states the missing Organon dependency. Preserve the current citations, ordering, nonclaims, mapping distinctions, manifest, and drift triggers. |

**Ontology evidence:** The candidate is notably faithful to the pinned source and correctly gates Kenogram's local authority, allow/revoke, runtime evidence, world, boundary, interface, and agent vocabulary rather than forcing Organon classifications. K7–K9 preserve the capability/authority and claim/evidence boundaries, consistent with README.md:116-133, requirements/jobs.md:239-258, and requirements/provenance.md:29-32. K1, K3, and K4 are substantially well scoped: operational absence remains relational Missingness; generations are indexed runtime Configurations; and successful replacement joins named predecessor and successor States under a forward cutover Direction. The blocking defects are concentrated in K5's contract-to-Invariant promotion and the missing Denotation and Persistence constructors in K2 and K6. These violate Organon C1 and C24 despite the candidate's otherwise strong anti-collapse language.

**Documentation evidence:** The ontology pins the repository, branch, commit, and Organon version, and material claims and mappings cite exact files and line ranges from that snapshot. It clearly treats repository self-description as Claim rather than proof. Coverage includes participants, trust boundaries, lifecycle states, transformations, authority and verification paths, invariants, nonclaims, boundary cases, and unresolved dependencies without becoming a feature inventory. Progression follows scope and purpose, local vocabulary, participants, load-bearing paths, mappings, boundary cases, and promotion gates. Local terms are defined before mapping, and refinement, conflict, and unmapped outcomes remain distinct. Maintenance information is unusually strong: explicit exclusions, mapping packets, machine-readable evidence references, uncertainty gates, and concrete drift triggers allow later reconstruction. Sentence-level delivery is review-ready but not exemplary throughout because some mapping and gate sentences stack several specialist dependencies and exclusions before reaching the concrete mechanism.

## Canonicality boundary

The project ontologies remain generated candidates until project maintainers review and adopt them. A passing assessment means the exact dossiers survived this declared deterministic and same-model judge contract. It does not establish that the mapped claims are true, complete, externally adopted, or stable across later project revisions.
