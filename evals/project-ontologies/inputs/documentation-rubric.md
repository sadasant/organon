# Project Ontology Documentation Rubric

A project ontology is a maintenance instrument between source code,
documentation, and Organon's binding vocabulary. It must remain useful to a
reader who knows the project but not Daniel's ontology, and to a reviewer who
knows Organon but not the project.

Judge the document in this order:

1. **Source traceability.** Material classifications cite exact files and line
   locations from the pinned project snapshot. Project self-description is a
   Claim, not proof of adoption, effectiveness, or security.
2. **Coverage.** The document identifies the actors, boundaries, states,
   transformations, authority paths, evidence paths, and nonclaims required to
   reason about the project. It does not become a feature inventory.
3. **Documentation cadence.** The reader encounters purpose and scope before
   vocabulary, vocabulary before load-bearing paths, paths before mappings,
   and mappings before unresolved gates. Deviations are acceptable when they
   improve comprehension rather than conceal a dependency.
4. **Local-language preservation.** Project terms are explained in their own
   language before being mapped. Exact, refinement, conflict, and unmapped are
   distinct outcomes; Organon does not win by definition.
5. **Maintenance readiness.** The exact repository snapshot, nonclaims,
   uncertainty, and change triggers are explicit enough for a later reviewer to
   determine whether the ontology has drifted.
6. **Delivery.** Sentences preserve actors, mechanisms, and scope; use concrete
   language before specialist vocabulary; and stop without promotional recap.

The ontology may be technically complete and still fail as documentation if a
new maintainer cannot reconstruct why a classification was made. It may be
beautifully written and still fail if its mappings are not source-backed.
