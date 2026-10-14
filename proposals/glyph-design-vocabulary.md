# Organon glyph design vocabulary

*Drafted October 13, 2026 for PR44. Design guidance; nonbinding.*

Every Organon mark is drawn from named strokes in the [shared glyph catalog](./glyph-catalog.mjs). The same ring, dot, bar or arrowhead returns in glyph after glyph. A reader who sees a stroke repeat will reasonably expect it to mean the same thing each time. Usually it does not.

This document names the few geometric cues that may carry a stable, learned reading, and records where repetition is only a drawing habit. It guides drawing and review. It does not define terms, add Claims to the ontology, or turn the glyphs into a compositional language. Labels and Organon IDs remain authoritative, as the [symbol review](./glyph-atlas.md), the [semantic review data](./glyph-semantic-review.json) and the [geometry rules](./glyph-geometry.json) already state.

## Contents

- [Source pin and counts](#source-pin-and-counts)
- [Three kinds of reuse](#three-kinds-of-reuse)
- [The approved vocabulary](#the-approved-vocabulary)
- [Candidate family cues](#candidate-family-cues)
- [Four readings the vocabulary refuses](#four-readings-the-vocabulary-refuses)
- [Inventory by drawing operation](#inventory-by-drawing-operation)
- [Unresolved collisions and reader tests](#unresolved-collisions-and-reader-tests)
- [Incremental policy](#incremental-policy)
- [Related entries](#related-entries)

## Source pin and counts

> [!NOTE]
> Inventory counts below describe the catalog at [81aad87](https://github.com/sadasant/organon/commit/81aad87daa679378d54cde7c3d5ce2da61d37e08), sha256 `dffbc37d1b493a78a06f7cad5b14cd6ab70586fb99a7a27c6d01895998bc2e6e`: 117 glyphs, 89 named strokes, three unused. The current follow-up has 118 glyphs and 92 strokes: State uses `stateOverlap`, leaving `grouping` and `index` unused; MathematicalOrder reuses `members` with `partialOrder` cover edges. Transformation uses `transformationEdge` instead of `step` and `dot`. Thus `members` now has three uses and `memberLinks` one. The approved process and preservation batch adds six strokes, for 98: Change drops `slash` and keeps only `triangle`; Feeds uses `memberBridge`, Causal path `directedChain`, Causal Contribution `comparisonLanes`, Invariant `twoPivotSectors`, Persistence `threePivotSectors` and Constraint `selectiveBranch`. Their former `wave`, `down`, `step`, `arrow`, `fork`, `bar`, `rails`, `bars`, `ring` and `frame` uses are gone, leaving `down` unused alongside `crescent`, `link`, `orbit`, `grouping` and `index`. The identity and expression batch (`identity_expression_review`) adds six more, for 104: Entity uses `sixPivotSectors`, Environment `externalSet`, Scope `coverageSpan`, Specification `testSheet`, Rule `mappingSheet` and Sign `traceToken`. Their former `ring`, `axis`, `surroundings`, `frame`, `cap`, `foot`, `square`, `bars`, `gate`, `bar`, `dot` and `wings` uses are gone, leaving `surroundings` unused as well. Counts in the tables below remain pinned to 81aad87 unless a row says otherwise. The command below measures the current catalog, not the historical counts.

The expression and recording batch (`expression_recording_review`) adds four strokes, for 108: Language uses `rewriteNetwork`, Map `unevenMesh`, Record `retainedToken` and Observation `witnessedRecord`. Reference and Evidence keep `partialMap` and `tracedRecord` respectively; those older drawings are not changed by cascade. Boundary and Symbol are explicitly retained, with the diamond question deferred.

The action and Interior batch (`action_interior_review`) adds twelve strokes, for 120: Model uses `organizedSurface`, Action `outwardCrossing`, Consequence `changeAfterTurn`, Interpretation `perceptualFork`, Agency `interpretationAction`, Tool `sideCoupledParticipant` and Capability `actionSpecification`; Memory, Exposure, Bodily Organization, Embodied Perspective and Internal Activity Selection keep the unchanged `vessel` and add `internalInfluence`, `outwardExposure`, `internalNetwork`, `internalPerspective` and `internalSelection` respectively. Interior is retained unchanged. Their former `structuredModel`, `endpoint`, `interpretedAction` and `hooks` strokes are now unused, and the former `bars`, `arrow`, `roots`, `eye`, `chevron`, `rails`, `bar`, `open`, `wings`, `tree`, `axis`, `fork` and `dot` uses are gone from these terms. Exercisability, Constituent Power and External Sovereignty keep the old Capability staircase and Exposure arc; they are not changed by cascade. Reference and Sense remain pending with their older drawings.

The coordination batch (`coordination_review`) adds six strokes, for **126 strokes and 118 glyphs**: Flow uses `openSequence`, Interface adds `compactToken` to the retained Boundary, Control uses `adjustedRule`, Standing uses `scopedPlacement`, Recognition adds `standingSheet` to that exact Standing, and Principal uses `standingEntity`. Claim and ActsFor are explicitly retained. The former `portFrame`, `ordered`, `routing`, `placement`, `recordedPlacement` and `party` strokes are now unused. Historical inventory rows below retain their pins; this paragraph and the coordination review supersede their former-shape comparisons.

The institutional batch (`institutional_review`) adds five strokes, for **131 strokes and 118 glyphs**: CountsAs uses `pairedStatusRecord`, Authority `agentInDomain`, Permission Claim `scopedAssertion`, Declaration `submittedClaim` and Permission `recordedPassage`. Admission and Revocation are explicitly retained; Grant remains unresolved with its current drawing, and the proposed V extension to Permission was not approved. The former `statusAssignment` and `binding` strokes are now unused, and the former `gate`, `dot`, `wings`, `tree`, `cap` and `up` uses are gone from these terms. This paragraph and the institutional review supersede former-shape comparisons for these five terms below.

The permission and evidence batch (`permission_evidence_review`) adds eight strokes, for **139 strokes and 118 glyphs**: Grant uses `scopedSubmission`, Permission Exercise `actionUnderRecord`, Exercisability `actionWithinWindow`, Enforcement `ruleCoupledAction`, Role `configurationInStanding`, Admissibility Rule `ruleForAdmission`, IndependentFor `witnessBeyondControl` and Evidence `admittedObservation`. Grant is no longer unresolved. Grant's 0.8-scaled Permission Claim and Enforcement's 0.6-scaled Rule are flattened into path coordinates, keeping their coordinates and arrowhead sizes but drawn at the font-wide 1.1 stroke width; every other drawing follows the study exactly. The former `issuedPermission`, `permittedRealization`, `ruleCoupling`, `assignedBundle`, `tracedRecord` and `admittedRecord` strokes are now unused, and the former `gate`, `arrow`, `chevron`, `foot`, `rails`, `dot` and `wings` uses are gone from these terms. This paragraph and the permission and evidence review supersede former-shape comparisons for these eight terms below.

Run from the repository root:

```sh
node --input-type=module <<'EOF'
import { glyphs, strokes } from "./proposals/glyph-catalog.mjs";
const ops = {
  dot: ["dot", "seed", "members", "inversePresence", "stateOverlap", "transformationEdge", "memberBridge", "directedChain", "comparisonLanes", "twoPivotSectors", "threePivotSectors", "sixPivotSectors", "externalSet", "coverageSpan", "traceToken", "retainedToken", "witnessedRecord", "organizedSurface", "outwardCrossing", "perceptualFork", "interpretationAction", "sideCoupledParticipant", "internalInfluence", "outwardExposure", "internalNetwork", "internalPerspective", "internalSelection"],
  parallelBars: ["bars"],
  shortStroke: ["bar", "cap", "foot", "wings", "ticks", "index", "retainedToken"],
  vertical: ["axis", "rails", "echo", "association", "comparison", "party", "factive", "outwardCrossing", "outwardExposure"],
  arrowhead: ["arrow", "up", "down", "denotes", "endpoint", "interpretedAction", "realizable", "statusAssignment", "binding", "issuedPermission", "permittedRealization", "admittedOther", "knowledgePath", "enforcedBoundary", "uptake", "adjustedAction", "constrainedAction", "directedChain", "comparisonLanes", "selectiveBranch", "mappingSheet", "traceToken", "rewriteNetwork", "outwardCrossing", "changeAfterTurn", "interpretationAction", "sideCoupledParticipant", "actionSpecification", "internalInfluence", "outwardExposure"],
  angleTag: ["chevron", "conditionI", "conditionII"],
  turningPath: ["step", "ordered", "endpoint", "realizable", "placement", "statusAssignment", "binding", "permittedRealization", "ruleCoupling", "continuingOrder", "portableRecord", "tracedRecord", "partialMap", "structuredModel", "recordedExchange", "scopedWorld", "feedingSource", "correspondence", "knowledgePath", "constituents", "tracking", "adjustedAction", "testSheet", "changeAfterTurn", "internalInfluence"],
  branching: ["tree", "fork", "routing", "feedingSource", "ruleCoupling", "tracking", "interpretedAction", "constituents", "enforcedBoundary", "partialOrder", "twoPivotSectors", "threePivotSectors", "selectiveBranch", "sixPivotSectors", "externalSet", "rewriteNetwork", "perceptualFork", "internalSelection"],
  contour: ["ring", "inversePresence", "square", "gate", "vessel", "frame", "portFrame", "open", "arch", "eye", "diamond", "double", "triangle", "memberLinks", "grouping", "personRecord", "partialMap", "tracedRecord", "portableRecord", "recordedPlacement", "recordedExchange", "structuredModel", "knowledgePath", "assertion", "registration", "endpoint", "statusAssignment", "placement", "admittedRecord", "constituents", "constrainedAction", "factive", "stateOverlap", "transformationEdge", "memberBridge", "externalSet", "testSheet", "mappingSheet", "traceToken", "rewriteNetwork", "unevenMesh", "retainedToken", "witnessedRecord", "organizedSurface", "changeAfterTurn", "perceptualFork", "interpretationAction", "sideCoupledParticipant", "actionSpecification", "internalNetwork", "internalPerspective"],
  cornerMark: ["grouping", "warranted", "hooks", "participants", "surroundings", "scopedWorld", "permittedRealization", "issuedPermission", "externalSet", "coverageSpan"],
  strike: ["slash", "cross", "routing", "enforcedBoundary", "testSheet"],
  wave: ["wave"],
  figurative: ["crown", "roots", "star", "assignedBundle"],
};
ops.dot.push("openSequence", "compactToken", "adjustedRule", "scopedPlacement", "standingEntity");
ops.vertical.push("scopedPlacement", "standingEntity");
ops.arrowhead.push("adjustedRule");
ops.turningPath.push("openSequence");
ops.branching.push("standingEntity");
ops.contour.push("compactToken", "adjustedRule", "standingSheet");
ops.dot.push("pairedStatusRecord", "scopedAssertion", "submittedClaim");
ops.vertical.push("agentInDomain", "scopedAssertion");
ops.arrowhead.push("submittedClaim", "recordedPassage");
ops.contour.push("pairedStatusRecord", "agentInDomain", "scopedAssertion", "submittedClaim", "recordedPassage");
ops.dot.push("scopedSubmission", "actionUnderRecord", "configurationInStanding", "witnessBeyondControl", "admittedObservation");
ops.vertical.push("scopedSubmission", "actionUnderRecord", "ruleCoupledAction", "configurationInStanding", "ruleForAdmission", "witnessBeyondControl");
ops.arrowhead.push("scopedSubmission", "actionUnderRecord", "actionWithinWindow", "ruleCoupledAction", "ruleForAdmission");
ops.angleTag.push("ruleForAdmission", "admittedObservation");
ops.contour.push("scopedSubmission", "actionUnderRecord", "ruleCoupledAction", "configurationInStanding", "ruleForAdmission", "witnessBeyondControl", "admittedObservation");
ops.cornerMark.push("actionWithinWindow");
const use = {};
for (const g of glyphs) for (const m of g.motifs) (use[m] ??= []).push(g.term);
console.log(`glyphs ${glyphs.length}; named strokes ${Object.keys(strokes).length}`);
for (const [m, t] of Object.entries(use).sort((a, b) => b[1].length - a[1].length || a[0].localeCompare(b[0])))
  console.log(`motif ${m} ${t.length}: ${t.join(", ")}`);
console.log(`unused ${Object.keys(strokes).filter((s) => !use[s]).join(", ")}`);
for (const [op, names] of Object.entries(ops)) {
  const hits = glyphs.filter((g) => g.motifs.some((m) => names.includes(m)));
  console.log(`operation ${op} ${hits.length}: ${hits.map((g) => g.term).join(", ")}`);
}
const grouped = new Set(Object.values(ops).flat());
console.log(`ungrouped ${Object.keys(use).filter((s) => !grouped.has(s)).join(", ") || "none"}`);
EOF
```

The `motif` lines are mechanical: they count glyphs listing a named stroke. The `operation` lines rest on an editorial reading of each path, and one stroke may sit in several groups. `endpoint`, for example, contains a turning path, an arrowhead and a box. The final line must print `ungrouped none`; any other output means a new stroke needs a home in this inventory.

## Three kinds of reuse

- **Family cue.** A drawing operation shared by terms whose definitions depend on one another in a stated way, so the shared stroke can be learned as a hint. It suggests a family. It never establishes inclusion, entailment or composition.
- **Term-specific mnemonic.** A drawing that helps a reader remember one term, or one approved pair. Its reading does not travel to other glyphs.
- **Conflicting or unsupported reuse.** The same stroke appears in terms with unrelated or opposed definitions, or imports an image the definition denies. The legend should say it carries no meaning, and new glyphs should not add to it.

Most repetition in the current catalog falls in the third class. That is the finding, not a defect of this document.

## The approved vocabulary

Daniel approved these drawings in the review sections named below. Approval covers a design direction for the listed terms. It is not semantic equivalence or reader-test evidence.

All triangle motifs use equilateral geometry, recorded in `equilateral_review` and `transformation_edge_review`: Set, Configuration, Order, State and Transformation use equal sides between vertex centers; Change, Agent and ActsFor use equal sides between path vertices. Feeds' two node triangles are equilateral, and the Invariant and Persistence spokes are equal radii exactly 60 degrees apart (`process_preservation_review`); Entity's six spokes follow the same rule around a pivot at the cell center (`identity_expression_review`). Model's and Bodily Organization's node triangles, Consequence's delta and Internal Activity Selection's open 60-degree sector are equilateral (`action_interior_review`). Heights are derived, not grid-snapped. State retains exact half-base overlap. Font-outline quantization introduces only rounding, not a different intended proportion. This drawing rule adds no ontological entailment.

| Cue | Glyphs | Learned reading | Does not mean | Review |
| --- | --- | --- | --- | --- |
| Circular contour | [Presence](../ontology/ontology.md#organon-presence) (ring and dot), [Missingness](../ontology/ontology.md#organon-missingness) (ring), [Reality](../ontology/ontology.md#organon-reality) (filled disk, clear center) | The three field terms share one outer contour, so they read as a set of companions. | A Boundary, an Entity or a container. Reality's clear center is negative space in the inscription, not Absence inside Reality. An empty ring does not establish Missingness without a specified target. | `pair_review`, `field_review` |
| Standalone underscore | [Absence](../ontology/ontology.md#organon-absence) | A minimal conventional name. | A slot, ground, baseline or position. The same `foot` stroke elsewhere is not Absence. | `pair_review` |
| Two equal parallel bars | [Identity](../ontology/ontology.md#organon-identity) (`=`), [Difference](../ontology/ontology.md#organon-difference) (bars with slash), [Relation](../ontology/ontology.md#organon-relation) (bars joined by a vertical) | Identity and Difference form the classical equals / not-equals pair. Relation borrows the proportions. | An operator. Relation does not require Identity, and two bars do not limit Relation to two participants. | `identity_review`, `relation_review` |
| Member dots and straight edges | [Set](../ontology/ontology.md#organon-set) (three solid dots), [Configuration](../ontology/ontology.md#organon-configuration) (the same dots joined) | Shared dots cue the member Set; edges cue additional specified structure. | Three members, member order, complete connectivity, causation or binary-only Relations. | `set_configuration_review`, `structured_configuration_correction` |
| Maps-to | [Denotation](../ontology/ontology.md#organon-denotation) | Expression side (tail) to target side (arrowhead). | A function's uniqueness condition, causation, fidelity or Truth. | `denotation_review` |
| Open pivot fan | [Invariant](../ontology/ontology.md#organon-invariant) (two sectors, three spokes), [Persistence](../ontology/ontology.md#organon-persistence) (three sectors, four spokes), [Entity](../ontology/ontology.md#organon-entity) (six sectors, six spokes, centered pivot) | A filled pivot held while equal spokes reach hollow nodes; Persistence carries Invariant's pivot through one more sector, following D012's dependency on Invariant, and Entity completes the turn, following D014's dependency on both. | Pointwise or geometric invariance, rotation, a fixed number of Transformations or States, completeness, causality or a Center. Entity's six endpoints are not six States. The missing outer edges are not omitted Relations or negation. | `process_preservation_review`, `identity_expression_review` |
| Shared sheet | [Specification](../ontology/ontology.md#organon-specification) (test sheet), [Rule](../ontology/ontology.md#organon-rule) (mapping sheet), [Capability](../ontology/ontology.md#organon-capability) (action specification) | The same full-height sheet; Rule, a Specification by D020, carries a maps-to inside it, and Capability, a Specification of Actions by D038, carries a condition line above an action arrow. | Composition, a document or text, an inferable constructive procedure, or a function. Capability's arrow is not an actual or completed Action. Representation keeps its own square and dot. | `identity_expression_review`, `action_interior_review` |
| Vessel (U) | [Interior](../ontology/ontology.md#organon-interior) (vessel and dot), [Memory](../ontology/ontology.md#organon-memory), [Exposure](../ontology/ontology.md#organon-exposure), [Bodily Organization](../ontology/ontology.md#organon-bodily-organization), [Embodied Perspective](../ontology/ontology.md#organon-embodied-perspective), [Internal Activity Selection](../ontology/ontology.md#organon-internal-activity-selection) | A learned internality cue: each definition is stated through an Entity's Interior, and the exact unchanged contour holds a term-specific content. | A universal container, a physical cavity, a drawing of the Boundary, consciousness or inclusion by depiction. The open top is a drawing convention, not a gap in a Boundary; Exposure's arrow through it is only a crossing mnemonic. Other enclosures are not Interiors. | `action_interior_review` |
| Admission's V | [Admission](../ontology/ontology.md#organon-admission) (chevron in its gate), [Admissibility Rule](../ontology/ontology.md#organon-admissibility-rule) (V below Rule's maps-to on a sheet), [Evidence](../ontology/ontology.md#organon-evidence) (V below a compact eye on a sheet) | Admissibility Rule's admission purpose and Evidence's admission (D064, D066). | Truth, correctness, approval, that every candidate passes, or Permission; the V is not added to Permission or to any other term without review. | `permission_evidence_review` |

State now uses two equal, upright Configuration-like triangles with exactly half-base overlap, approved in `state_overlap_review`. Four equally spaced baseline nodes alternate hollow, solid, hollow, solid; each apex sits directly above the other triangle's inner base node. The left triangle has hollow vertices and the right has solid vertices. The shared baseline is drawn once and the diagonal crossing has no node. Edges stop outside hollow centers, so the font keeps actual negative space rather than background-colored masks.

This is a term-specific mnemonic for an indexed Configuration, not a diagram of two required States or a Transformation. Hollow/solid does not mean Missingness/Presence, past/present, possible/actual or less/more real. The drawing does not establish an index domain or its ordering; the distinction between an index and an ordered position remains a separate definition/formalization question. Retain labels and test the hollow centers at text size.

Transformation uses two equilateral triangles joined along the upright ghost triangle's right edge, approved as option A in `transformation_edge_review`. The three ghost vertices remain hollow, including the two shared nodes; only the new rightmost vertex is solid. This preserves the ghost intact rather than reproducing a fully solid Configuration for the result. The shared edge is drawn once, and edges stop outside hollow centers. The 60-degree turn cues input-to-output orientation, not required spatial rotation, rigid motion, reversibility, shared participants or structure preservation. Compare its shared-edge silhouette with State's half-overlap; retain labels and check the hollow centers at inline sizes.

Order extends the approved member-dot family with a Hasse-diagram mnemonic, approved in `order_hasse_review`: Set's three dots joined along the two sloping sides, without Configuration's bottom edge. Read upward, each lower member precedes the upper member and the lower pair is incomparable. In a Hasse diagram, edges show cover relationships; reflexive loops and edges implied by transitivity are omitted. This borrows a [mathematical drawing convention](https://mathworld.wolfram.com/HasseDiagram.html), not a new comparison sign or a compositional operation on Configuration. It does not require three members, a greatest member, branching, finiteness or incomparability in every Order; empty and total Orders remain permitted. Upward means order here, not causation, authority or improvement. Labels remain necessary.

Seven process and preservation drawings are approved in `process_preservation_review`. Node glyphs reuse the font's stroke-only node convention: hollow nodes are r=2 rings, solid nodes are concentric disks, and every connection stops 2.5 units from a node center, so hollow centers remain transparent negative space without masks. Hollow/solid marks drawing roles only, never Missingness/Presence, past/present, possible/actual or truth.

- **Change** is the plain equilateral delta, without Difference's slash: a borrowed conventional name for finite change, not a numerical restriction. The joining Transformation is not drawn, and Agent and ActsFor still contain the same triangle, pending a separate Agent redesign.
- **Feeds** introduces the *part-to-part bridge*: two disjoint equilateral node triangles, with one bridge from the first triangle's right base node to the second triangle's apex. The connector ends at selected members, not whole groups; it does not assert their equality, and the groups are not full State glyphs. The study geometry is uniformly scaled by 0.95 about the cell center to keep its outer rings inside the ink margin.
- **Causal path** is a *directed chain*: three horizontal nodes, the last solid, ending in a rightward arrowhead. It borrows the directed-path convention and still does not show the Feeds joins.
- **Causal Contribution** introduces *comparison lanes*: two parallel same-direction chains rather than a fork. The upper chain is hollow; the lower chain's first and last nodes are solid, a local contrast between the two witnesses. The upper arrowhead stops outside its hollow end node.
- **Invariant** and **Persistence** form the open pivot fan in the table above.
- **Constraint** introduces *stop versus passage*: one input branches into a route ending in a corner arrowhead and a route meeting a transverse stop. The stop is not Absence or Revocation, and the branch does not require an Agent's choice.

Six identity, applicability and expression drawings are approved in `identity_expression_review`. They reuse the same node helpers, stroke width, square caps and miter joins; Rule's and Sign's arrowheads are symmetric 3-unit strokes at 0.6 radians from the shaft.

- **Entity** joins the open pivot fan: six equal spokes every 60 degrees from a solid pivot at the cell center, six distinct hollow endpoints and no outer hexagon. The full turn is a family resemblance, not completeness, six States or causality.
- **Environment** introduces the *external set* (option C): a box with a solid node, an unarrowed connector and a separate bracket of three hollow outside members. Inclusion is not spatial, three members are not required and the connector asserts no flow.
- **Scope** introduces the *coverage span*: open upper and lower spans over three solid member dots. Neither three members nor a nonempty Scope is required, and Scope need not be ordered or spatial.
- **Specification** is the *test sheet*: a sheet with a condition line and a route meeting a transverse result mark. Constructivity cannot be inferred from the drawing.
- **Rule** is the *mapping sheet*: the same sheet with a maps-to expression. It imposes no function, determinism or unique output.
- **Sign** is *trace into token*: a hollow target node, an arrow and a separate token box. The arrow runs target to token, the causal trace direction, not Denotation's expression-to-target orientation.

Daniel retained Boundary (diamond with echo bars) and Representation (square with dot), superseding the study's tentative selective-perimeter and expression-stem proposals, and kept Perception, Witness and Agent. Principal and Person were not redrawn, so their ring and axis no longer match Entity: the former Entity family is broken, recorded below rather than repaired by cascade.

Four expression and recording drawings are approved in `expression_recording_review`:

- **Language** is the *rewrite network*: token boxes connected by branching directed paths. It cues transformations of expressions, not a causal proof, deterministic rule or required input/output count.
- **Map** is the *uneven mesh*: a skew quadrilateral with diagonals and a crossbar. The irregular cells are deliberate, not Configuration triangles; the existing triangle-based family remains equilateral. Distortion need not be geometric.
- **Record** is the *retained token*: a sheet with a hollow circle and one short lower line. This extends Representation's square-and-circle resemblance. The line is local to Record, not Absence or a universal Persistence operator.
- **Observation** is the *witnessed record*: an eye with a hollow pupil inside a sheet. The study name does not require a Witness, vision or consciousness. The drawing asserts neither Truth nor independence and does not show the specified production path. It deliberately does not inherit Record's retention line.

Twelve action and Interior-family drawings are approved in `action_interior_review`, and Interior A is retained unchanged. Study geometry is kept exactly: Model's edges stop 2.8 units from node centers rather than the helper's 2.5; the five Interior-family contents sit in the exact unchanged vessel contour; compact eyes keep hollow r=1.5 pupils; arrowheads are the symmetric 3-unit helper. Boundary, Symbol, Representation, Perception, Witness and Agent stay retained; Reference and Sense remain pending; Memory's earlier request for cleaner alternatives is resolved. As with every section here, approval is design direction, not reader testing.

- **Model** is the *organized surface*: a frame enclosing an inverted equilateral triangle of hollow nodes. It nearly repeats Bodily Organization's network in a frame; three nodes are not three members.
- **Action** is the *outward crossing*: a hollow node and an arrow crossing a vertical barrier. The barrier is not Boundary's glyph, and left/right is not inside/outside.
- **Consequence** is *change after turn*: an elbow arrow ending above a small equilateral delta echoing Change. It no longer ends in a box like CountsAs.
- **Interpretation** is the *perceptual fork*: a compact eye whose stem splits in two. The fork marks a distinction among available Actions, not a choice, and resembles Intelligence.
- **Agency** is *interpretation to action*: a compact eye followed by an arrow. Both links are partial: the fork and Action's barrier are not drawn.
- **Tool** is the *side-coupled participant*: a box with a hollow node, joined by a stem to the side of an action arrow. Side coupling is a mnemonic for non-identity with the Agent; it resembles Respect.
- **Capability** is the *action specification*: the shared Specification sheet with a condition line above an action arrow. Constituent Power keeps the old staircase; Exercisability now uses an action window (`permission_evidence_review`).
- **Memory** is *internal influence*: a hollow node whose line turns up to an arrowhead inside the vessel. The upward arrow is not increase or causation.
- **Exposure** is *through the opening*: a hollow node near Interior's dot with an arrow rising out of the vessel. It nearly contains Interior's drawing; External Sovereignty keeps the old open arc.
- **Bodily Organization** is the *internal network*: an equilateral triangle of hollow nodes in the vessel. It does not show Organs, their feeds or the required inter-Organ join.
- **Embodied Perspective** is the *internal perspective*: a compact eye in the vessel. It requires neither vision, consciousness nor self-description.
- **Internal Activity Selection** is the *emphasized alternative*: an open equilateral sector whose upper-left endpoint is solid and upper-right endpoint stays hollow as a retained contrast. The solid endpoint locally designates the selected alternative; it does not mean Truth, Permission, Presence or a past State, and the hollow contrast is not Missingness.

These cues are term-specific, except the pivot fan, the shared Specification sheet (Specification, Rule, Capability) and the vessel. Their reuse elsewhere needs the review steps in the [incremental policy](#incremental-policy).

The coordination batch adds two approved family relationships and one local metaphor:

- **Standing, Recognition and Principal:** Standing C is a hollow role between two posts. Recognition B encloses that exact geometry in a record sheet; Standing itself does not require recording (D047–D048). Principal A replaces the role with Entity's six equal-angle spokes at radius 7, keeping the posts. This follows Principal being an Entity with Standing (D049), without implying Agency. The sheet does not establish exact-index matching, and the fan does not show the special on-whose-behalf role. Check Recognition's close parallel edges and Principal's six hollow centers at text size.
- **Boundary and Interface:** Interface C contains the exact retained Boundary plus a compact Representation square with a hollow r=1.5 node, following D042's explicit representation condition. The diamond question remains deferred; adding a token does not prove permitted Transformations or coordination.
- **Control:** D uses a hollow adjustment knob joined to a narrow mapping sheet. This is a local adjustment metaphor, justified by configuring a Rule being one form of Control (D045), not a new universal operator or Authority. Bypass and prevention remain implicit. Compare with Rule and Sign.

Flow C is an open sequence of four equal 12-unit edges at 60 degrees, with five nodes and only the final node solid. Equal geometry does not mean periodic timing, and the final fill is not Presence, Truth or actual rather than possible State. It recalls the equilateral family without containing Transformation's whole glyph. Compare it with a waveform and Causal path.

Claim keeps its open-bottom frame and hollow circle: the frame is a **candidate assertion cue**, not yet universal grammar. ActsFor keeps its triangle and arrow without Agent's vertical axis. Person keeps the old Entity ring and axis; Boundary Sovereignty keeps the old Control routing template; Body and the Designations keep the old placement template; Knowledge Transmission keeps the old Flow wave. None is changed by cascade. These family breaks supersede their older descriptions below.

The institutional batch (`institutional_review`) approves five term-specific drawings:

- **CountsAs** D is a *paired status record*: a closed sheet holding a hollow node joined to a small status box, over a bottom retention line. **Permission** B is a *recorded passage*: a closed sheet holding a horizontal arrow over the same kind of retention line. Both are Records or recordings by a Coordination Order (D051, D057), but the sheet and line are a learned record cue, not proof of a valid Grant and Admission chain, and Permission's arrow is not an exercised Action.
- **Authority** B places Agent's triangle and axis, reduced to side 14, between two full-height posts. It follows Authority being an Agent's Action entering CountsAs within an Order and Scope (D052) without drawing the Principal or bindingness. The posts recall Standing but are not its exact geometry.
- **Permission Claim** D places a smaller open Claim frame between posts, and **Declaration** B sends an arrow out of a smaller open Claim frame. Both follow their definitions as a Claim and a Claim submission (D053, D054), which strengthens Claim's frame as a candidate assertion cue without making it universal grammar. Declaration's arrow is submission, not causation, transfer or announcement.

Admission and Revocation keep their gates. Permission no longer uses the gate, so the gate family below has lost its namesake. Grant, unresolved in that batch, is resolved below. Approval is a design direction, not ontology adoption or reader evidence.

The permission and evidence batch (`permission_evidence_review`) approves eight term-specific drawings:

- **Grant** A reduces the exact Permission Claim drawing and adds Declaration's outgoing arrow through the right post, following D055. Covering Authority is not drawn, and the arrow is submission, not transfer or scope-crossing. A Grant need not be admitted, so it has no V.
- **Permission Exercise** D hangs a small record token above Action's hollow node and arrow, its stem standing where Action's barrier stands. The token is not the full Permission glyph and does not cause the Action. **Exercisability** D places an action arrow in an open upper and lower window; the window is not necessarily time, Permission and Capability are not drawn, and it nearly repeats Scope's coverage spans.
- **Enforcement** C couples Rule's reduced mapping sheet to an action path. It is not punishment, and the Order and the satisfied and violated outcomes are not drawn. **Role** B places an equilateral triangle of hollow nodes between Standing-like posts; three nodes are not three members or the four named categories, and it is close to Authority.
- **Admissibility Rule** B puts Rule's maps-to above Admission's V on one sheet, and **Evidence** B puts a compact eye above the same V. The V marks admission purpose and admission, not Truth; Evidence's sheet and eye are a near Observation link, not its exact drawing. **IndependentFor** B separates a small open Claim frame from a compact eye by a post; the separation is a spatial mnemonic and cannot certify either independence condition.

Admission, Revocation, Permission and every other approved drawing are unchanged. Revocation is now the only Permission-family term on the gate; Constituent Exercise keeps Permission Exercise's former gate and arrow, and Constituent Power the old staircase. Selection is a design direction, not semantic certification or reader evidence.

## Candidate family cues

These reuses follow a definitional dependency and help a reader find a family. All are revised or retained trials awaiting design and reader review, so none is part of the approved vocabulary yet.

| Shared drawing | Glyphs | Why reuse is supported | Open risk |
| --- | --- | --- | --- |
| `partialMap` | Reference (formerly also Map) | Reference is a Map by definition. | Broken family: Map now uses the uneven mesh. Reference stays unchanged pending approval. |
| `tracedRecord` | None in the current follow-up (formerly Evidence and Observation) | Evidence is an admitted Observation. | Retired: Evidence now uses `admittedObservation`, a compact eye and Admission's V on a sheet (`permission_evidence_review`); `tracedRecord` and `admittedRecord` are unused. |
| old Capability staircase (`realizable`, `permittedRealization`) | Constituent Power (formerly also Capability and Exercisability) | Constituent Power is a Capability. | Broken family: Capability now uses the action-specification sheet (`action_interior_review`), not cascaded here, and Exercisability uses an action window (`permission_evidence_review`). The old ascent still reads as progress and as a Causal path. |
| `knowledgePath`, `factive` | Operative Knowledge, Factive Operative Knowledge, Warranted Knowledge | Each successive term adds a condition to the previous one. | The `warranted` corner is a generic frame, not an Evidence cue. |
| `tracking` | Attention, Care | Care is Attention conditioning Action. | Enforcement no longer uses a converging pair (`permission_evidence_review`). |
| ring with axis | Principal, Person (formerly also Entity) | Principal and Person are Entities. | Broken family: Entity now uses the six-sector pivot fan (`identity_expression_review`), so the shared ring and axis no longer show Entity status. Any ring and axis may be read as a Principal or Person. |
| diamond with axis | Truth, and the `factive` mark | The Factive and Warranted terms involve Truth. | The diamond is also Boundary's and Symbol's. Reserve diamond-on-axis for Truth-involving terms. |
| `double` | Ritual, Meaning | Meaning is constituted by Ritual. | Recurrent Integration also uses `double` without that dependency. |
| `assertion`, `registration` with `conditionI` / `conditionII` | The two Attributions and the two Designations | Flag marks Attribution, form marks Designation, tag marks the domain. | Only a 5–6 unit tag separates consciousness from moral status. |
| gate with arrow or slash (formerly also up) | Revocation (formerly also Permission and Permission Exercise) | Revocation concerns a governed passage. | Broken family: Permission now uses the recorded-passage sheet (`institutional_review`) and Permission Exercise an action under a record (`permission_evidence_review`). The same gate also appears in Claim, Admission, Constituent Exercise and the sovereignty glyphs. |
| routing template | Control, Boundary Sovereignty | Boundary Sovereignty requires Control. | Substrate's split resembles it with no such dependency. |

## Four readings the vocabulary refuses

### A dot is not Presence

Presence is ring and dot. The dot alone is drawn in 11 glyphs at the pinned source, including Representation, Claim, Truth, Interior, Perception's pupil and Transformation's bead. Under A4 every inscription is already Presence, so no stroke can mark it uniquely. A dot is a point of attention in the drawing. It is not a located Entity, a target or a witness of existence. Likewise, Internal Activity Selection's local solid endpoint designates the selected alternative within that glyph; it does not mean Truth, Permission, Presence or a past State. The geometry rules also forbid distinguishing semantically opposed terms by a tiny dot alone; Presence and Missingness are not opposed, but their dot difference still needs small-size testing.

### A line is not causation

At the pinned source, 28 glyphs carry an arrowhead and 30 carry a stepped or right-angled path. Configuration's edges, Relation's vertical and Denotation's stem are lines too. Arrowheads and paths are order or attention cues. They do not assert a Causal path (D010), a Feeds join, transfer of possession, or command. Even the current Causal path glyph, a directed node chain, does not show the Feeds joins its definition requires. An ascending path does not mean improvement.

### An enclosure is not a boundary

Closed and near-closed contours appear in 76 glyphs at the pinned source: rings, squares, gates, vessels, frames, the eye, boxes inside signatures, and Configuration's triangle. None of them depicts a Boundary in the sense of D015, an Interior, a jurisdiction or a recorded status. Boundary's own glyph is a diamond with outer strokes, and even that glyph's legend says a Boundary need not be geometric. Recognition's closed square and Person's open record box are stipulated mnemonics, not pictures of containment. The vessel (U) is now an approved, learned internality cue for Interior and its five listed contents only; it is not a universal container, a Boundary drawing or a sign of consciousness.

### Identity's bars are not an operator

The `bars` stroke appears in 8 glyphs at the pinned source. In Identity, Difference and Relation it carries the approved equals-sign reading. In Invariant it forms a hash, in Specification a list, in Memory stored lines, in Ledger a grid, in Bodily Organization a pair of parts. Those glyphs do not contain Identity. In the current catalog only Identity, Difference, Relation and Ledger keep `bars`; Memory and Bodily Organization dropped them in `action_interior_review`. Likewise, Difference's slash is a mnemonic for that pair, not a general negation operator, and Relation's vertical is association, not an operation on Identity.

## Inventory by drawing operation

Every named stroke appears below. Counts are glyphs at the pinned source.

### Dots and solid marks

| Strokes | Glyphs | Class | Note |
| --- | --- | --- | --- |
| `dot` | 11 | Conflicting | Approved only as part of Presence. Elsewhere arbitrary. Sign no longer uses it in the current follow-up, nor do Permission Claim and IndependentFor; Representation keeps it. |
| `members` | 2 | Approved family cue | Set and Configuration. |
| `stateOverlap` | 1 in the current follow-up | Approved, term-specific | State's half-overlapping triangles extend the geometric family without making hollow/solid a general semantic operator. |
| `memberBridge`, `directedChain`, `comparisonLanes` | 1 each in the current follow-up | Approved, term-specific | Feeds' part-to-part bridge, Causal path's directed chain and Causal Contribution's comparison lanes. Hollow and solid nodes are drawing roles; connections stop outside hollow centers. |
| `twoPivotSectors`, `threePivotSectors`, `sixPivotSectors` | 1 each in the current follow-up | Approved family cue | Invariant, Persistence and Entity. See the open pivot fan in [the approved vocabulary](#the-approved-vocabulary). |
| `externalSet`, `coverageSpan`, `traceToken` | 1 each in the current follow-up | Approved, term-specific | Environment's external set, Scope's coverage span and Sign's trace into token. Hollow and solid nodes are drawing roles. |
| `organizedSurface`, `outwardCrossing`, `internalInfluence`, `outwardExposure`, `internalNetwork`, `internalSelection` | 1 each in the current follow-up | Approved, term-specific (`action_interior_review`) | Model, Action, Memory, Exposure, Bodily Organization and Internal Activity Selection. Hollow nodes are drawing roles; Internal Activity Selection's one solid endpoint locally designates the selected alternative, not Truth, Permission, Presence or a past State. Model keeps its 2.8-unit edge trim. |
| `inversePresence` | 1 | Approved, term-specific | Reality. Overlapping construction strokes are not layers of Reality. |
| `seed` | 1 | Term-specific, arbitrary | Operationalization. |

### Horizontal strokes

| Strokes | Glyphs | Class | Note |
| --- | --- | --- | --- |
| `bars` | 8 | Approved for Identity, Difference, Relation; conflicting elsewhere | See [Identity's bars are not an operator](#identitys-bars-are-not-an-operator). Invariant and Specification no longer use them in the current follow-up, nor do Memory and Bodily Organization. |
| `foot` | 11 | Conflicting | Approved only as standalone Absence. Elsewhere an arbitrary differentiator, for example between Admission and Admissibility Rule at the pin. Scope, Rule and Admissibility Rule no longer use it in the current follow-up. |
| `bar`, `cap`, `wings` | 6, 5, 6 | Conflicting | Arbitrary differentiators. A cap is not Authority; wings are not extension. Causal Contribution, Constraint and Rule no longer use `bar`, Scope no longer uses `cap` and Sign no longer uses `wings` in the current follow-up; Tool no longer uses `bar` and Exposure no longer uses `wings`; Declaration no longer uses `cap` and Permission Claim no longer uses `wings`; IndependentFor no longer uses `wings`. |
| `ticks`, `index` | 1 each at the historical pin | Term-specific | Organ; State's former index is now unused. |

### Vertical strokes

| Strokes | Glyphs | Class | Note |
| --- | --- | --- | --- |
| `axis` | 9 | Candidate family cue with Entity's ring or Truth's diamond; unsupported in Sign, Preference, Ritual, Embodied Perspective; unclear in Agent | An axis is not identity through States unless the glyph belongs to the Entity family. Agent's triangle-on-axis shares nothing else with Entity. Entity and Sign no longer use the axis in the current follow-up, so it no longer marks Entity at all; Embodied Perspective no longer uses it either. |
| `rails` | 9 | Conflicting | Invariant and Persistence no longer use rails in the current follow-up, and Tool no longer uses them, leaving five uses in terms that do not require Persistence; IndependentFor no longer uses them either (`permission_evidence_review`). Rails carry no persistence reading. |
| `outwardCrossing`, `outwardExposure` | 1 each in the current follow-up | Approved, term-specific | Action's vertical barrier and Exposure's rising shaft. The barrier is not Boundary's glyph; upward is not increase. |
| `echo` | 3 | Conflicting | Boundary, Constituent Power and Recurrent Integration share outer bars with no shared meaning. `comparison` (Reference) resembles them. |
| `association`, `comparison`, `party` | 1 each | Term-specific | Relation (approved), Reference, Principal. |
| `factive` | 2 | Candidate family cue | Truth's diamond-on-axis, reduced. |

### Arrowheads

| Strokes | Glyphs | Class | Note |
| --- | --- | --- | --- |
| `arrow` | 8 | Conflicting | Generic arrow in Causal path, Action, ActsFor, Permission Exercise, Evidential Bearing, Constituent Exercise, Operationalization, Knowledge Transmission. Causal path uses `directedChain` and Action `outwardCrossing` in the current follow-up; Permission Exercise uses `actionUnderRecord`. |
| `up`, `down` | 2, 1 | Conflicting, term-specific | Up in Direction and Permission may read as increase; Permission no longer uses it in the current follow-up. Down was Feeds only and is unused in the current follow-up. |
| `denotes` | 1 | Approved, term-specific | Denotation. |
| `realizable`, `knowledgePath` | 2, 3 | Candidate family cues | See [Candidate family cues](#candidate-family-cues). Capability no longer uses `realizable` in the current follow-up; only Constituent Power keeps it. |
| `endpoint`, `interpretedAction`, `statusAssignment`, `binding`, `issuedPermission`, `permittedRealization`, `admittedOther`, `uptake`, `enforcedBoundary`, `adjustedAction`, `constrainedAction` | 1 each | Term-specific | Order mnemonics. Several still collide by template; see [Unresolved collisions](#unresolved-collisions-and-reader-tests). `endpoint`, `interpretedAction`, `statusAssignment`, `binding`, `issuedPermission` and `permittedRealization` are unused in the current follow-up. |
| `outwardCrossing`, `changeAfterTurn`, `interpretationAction`, `sideCoupledParticipant`, `actionSpecification`, `internalInfluence`, `outwardExposure` | 1 each in the current follow-up | Approved, term-specific (`action_interior_review`) | Action, Consequence, Agency, Tool, Capability, Memory and Exposure use the symmetric 3-unit arrowhead helper. Arrowheads are order cues, not causal proofs; upward arrows are not increase. |

### Angles and domain tags

| Strokes | Glyphs | Class | Note |
| --- | --- | --- | --- |
| `chevron` | 4 | Conflicting | Interpretation, Admission, Admissibility Rule, Preference. Checkmark and down-arrow readings. Interpretation and Admissibility Rule no longer use the stroke in the current follow-up; Admissibility Rule and Evidence redraw the same V inside `ruleForAdmission` and `admittedObservation`. |
| `conditionI`, `conditionII` | 2 each | Candidate family cue | Domain tags only. They depict neither consciousness nor morality. |

### Turning paths

| Strokes | Glyphs | Class | Note |
| --- | --- | --- | --- |
| `step` | 4 | Conflicting | Transformation, Causal path, Record, Utility Measure at the pin. Only Utility Measure keeps it in the current follow-up. |
| `partialMap`, `tracedRecord`, `tracking` | 2 each at the pin | Candidate family cues | `partialMap` now has one use, pending Reference review; `tracedRecord` is unused in the current follow-up. |
| `ordered`, `placement`, `ruleCoupling`, `continuingOrder`, `portableRecord`, `structuredModel`, `recordedExchange`, `scopedWorld`, `feedingSource`, `correspondence`, `constituents` | 1 each | Term-specific | Stepped connectors now recur in 30 glyphs, so the step itself carries no family meaning. `structuredModel` and `ruleCoupling` are unused in the current follow-up. |
| `changeAfterTurn`, `internalInfluence` | 1 each in the current follow-up | Approved, term-specific | Consequence's elbow arrow and Memory's upturned line. Neither is a staircase or a causal proof. |

### Branching junctions

| Strokes | Glyphs | Class | Note |
| --- | --- | --- | --- |
| `tree` | 5 | Conflicting | Declaration, Canonical and Shadow system, Polity, Bodily Organization. Bodily Organization and Declaration no longer use it in the current follow-up. |
| `fork` | 3 | Conflicting | Causal Contribution, Intelligence, Internal Activity Selection. Reads as choice. Causal Contribution uses comparison lanes and Internal Activity Selection `internalSelection` in the current follow-up, leaving Intelligence. |
| `perceptualFork`, `internalSelection` | 1 each in the current follow-up | Approved, term-specific | Interpretation's split stem and Internal Activity Selection's open equilateral sector. They may read as choice; Interpretation's fork resembles Intelligence. |
| `selectiveBranch` | 1 in the current follow-up | Approved, term-specific | Constraint's stop versus passage. The transverse stop is not Absence or Revocation; the branch resembles `routing` and `fork`. |
| `routing`, `enforcedBoundary` | 1 each | Candidate template family | Control and Boundary Sovereignty. |
| `feedingSource`, `ruleCoupling`, `interpretedAction`, `constituents` | 1 each | Term-specific | Substrate, Enforcement, Agency, Body. Splits and merges still resemble one another. `interpretedAction` and `ruleCoupling` are unused in the current follow-up. |

### Closed and near-closed contours

| Strokes | Glyphs | Class | Note |
| --- | --- | --- | --- |
| `ring` | 8 | Approved for Presence and Missingness; broken family cue for Principal and Person; conflicting in Persistence, Center, Organ | Persistence and Entity no longer use it in the current follow-up. |
| `memberLinks` | 1 | Approved, term-specific | Configuration's edges, not an enclosed region. |
| `square` | 7 | Conflicting | Retained for Representation (`identity_expression_review`), but also Record, Canonical system, Ledger, Operationalization, Knowledge Transmission. Specification no longer uses it in the current follow-up. |
| `testSheet`, `mappingSheet`, `actionSpecification` | 1 each in the current follow-up | Approved family cue | Specification, Rule and Capability share the full-height sheet. Its route, result mark, maps-to and action arrow are term-specific. |
| `organizedSurface`, `internalNetwork` | 1 each in the current follow-up | Approved, term-specific | Model's framed node triangle and Bodily Organization's node triangle in the vessel. They nearly repeat each other and resemble Configuration; three nodes are not three members. |
| `perceptualFork`, `interpretationAction`, `internalPerspective` | 1 each in the current follow-up | Approved, term-specific | Compact eyes with hollow r=1.5 pupils in Interpretation, Agency and Embodied Perspective. They import seeing but require neither vision nor consciousness. |
| `changeAfterTurn`, `sideCoupledParticipant` | 1 each in the current follow-up | Approved, term-specific | Consequence's small delta echoing Change; Tool's box with a hollow node, close to Respect's condition box. |
| `gate` | 11 | Candidate family cue for Permission, Revocation, Permission Exercise; conflicting elsewhere | Claim, Rule, Admission and the sovereignty glyphs make the gate read as institutional. Rule, Permission, Permission Claim, Permission Exercise and Admissibility Rule no longer use it in the current follow-up, leaving Revocation as the only Permission-family gate. |
| `eye` | 7 | Conflicting | Imports visual seeing into terms that do not require it. Interpretation and Embodied Perspective use compact eyes inside their new strokes in the current follow-up. |
| `vessel` | 5; 6 in the current follow-up | Approved family cue (`action_interior_review`) | Interior, Memory, Exposure, Bodily Organization, Embodied Perspective and Internal Activity Selection share the exact unchanged contour as a learned internality cue, not a universal container, Boundary drawing or consciousness. Bodily Organization no longer contains Memory's drawing; Exposure nearly contains Interior's. |
| `pairedStatusRecord`, `agentInDomain`, `scopedAssertion`, `submittedClaim`, `recordedPassage` | 1 each in the current follow-up | Approved, term-specific (`institutional_review`) | CountsAs, Authority, Permission Claim, Declaration and Permission. CountsAs and Permission share a closed sheet and bottom retention line; Permission Claim and Declaration reuse a smaller open Claim frame; Authority reuses Agent's triangle and axis between posts. None is a compositional operator. |
| `scopedSubmission`, `actionUnderRecord`, `actionWithinWindow`, `ruleCoupledAction`, `configurationInStanding`, `ruleForAdmission`, `witnessBeyondControl`, `admittedObservation` | 1 each in the current follow-up | Approved, term-specific (`permission_evidence_review`) | Grant, Permission Exercise, Exercisability, Enforcement, Role, Admissibility Rule, IndependentFor and Evidence. Grant reduces Permission Claim, Enforcement reduces Rule, Permission Exercise reuses Action's node and arrow, and Admissibility Rule and Evidence share Admission's V on a sheet; IndependentFor and Evidence use compact eyes. None is a compositional operator. |
| `diamond` | 3 | Conflicting | Boundary, Symbol, Truth. |
| `triangle` | 3 | Approved alone for Change; conflicting in Agent and ActsFor | Change is now the plain delta, so Agent and ActsFor contain the whole Change glyph. |
| `double` | 3 | Candidate family cue for Ritual and Meaning; conflicting in Recurrent Integration | |
| `frame`, `open` | 3, 2 | Conflicting | Frame in Constraint, Scope, Shadow system; the open arc was Exposure's and External Sovereignty's. Constraint and Scope no longer use the frame in the current follow-up, and Exposure now uses the vessel, so External Sovereignty keeps the old Exposure arc alone. |
| `arch`, `portFrame`, `grouping`, `personRecord`, `recordedPlacement`, `assertion`, `registration`, `admittedRecord` | 1–2 each at the historical pin | Term-specific or candidate pairs | `recordedPlacement` and `registration` share a post-stem-box template with `placement` and `constituents` that remains a collision. State's redraw leaves `grouping` unused in the current catalog, and Evidence's redraw leaves `admittedRecord` unused. |

### Corner marks, strikes, waves and figures

| Strokes | Glyphs | Class | Note |
| --- | --- | --- | --- |
| `warranted`, `hooks`, `participants`, `surroundings` | 1 each | Term-specific | A generic corner reads as Scope or a frame. Environment's `surroundings` and Tool's `hooks` are unused in the current follow-up. |
| `slash` | 3 | Approved within Difference; conflicting in Revocation | Change no longer uses the slash in the current follow-up. |
| `cross` | 2 | Conflicting | Language and Organ at the pin; only Organ retains it in the current follow-up. |
| `wave` | 3 | Conflicting | Feeds, Flow, Knowledge Transmission. Periodicity is not implied. Feeds uses `memberBridge` in the current follow-up. |
| `crown` | 3 | Conflicting | The sovereignty profiles do not entail one another, and the crown imports monarchy. |
| `roots` | 3 | Conflicting | Legs import bodily locomotion and crowds. Action no longer uses them in the current follow-up. |
| `star` | 2 | Conflicting | Symbol and Center. |
| `assignedBundle` | 1 | Term-specific | Role at the pin; unused in the current follow-up. |
| `crescent`, `link`, `orbit` | 0 | Unused | Retired drawings kept in the catalog. Not part of the vocabulary. `grouping`, `index`, `down`, `surroundings`, `structuredModel`, `endpoint`, `interpretedAction`, `hooks`, `statusAssignment`, `binding`, `issuedPermission`, `permittedRealization`, `ruleCoupling`, `assignedBundle`, `tracedRecord` and `admittedRecord` are also unused in the current follow-up. |

## Unresolved collisions and reader tests

Ordered by priority. Approved marks come first because readers will learn them first.

1. **Presence, Missingness and Reality at text size.** Only a dot separates Presence from Missingness, and Reality's clear center can fill in to a solid disk. Test pairwise discrimination in inline text, tiles and graphs.
2. **The bars family.** Test Identity, Difference and Relation side by side at text size, Relation against the double-dagger, and whether readers read Identity into Ledger.
3. **State's overlapping triangles.** Check the three hollow centers, four-node baseline and unmarked diagonal crossing at text size. Compare with Configuration, Order and Change; ask whether the pair suggests a transition, two required States or a past/present contrast. Exact midpoint alignment is geometric, not an identity or ordering proof.
4. **MathematicalOrder's Hasse fork.** Test it against Set's unconnected dots, Configuration's closed triangle and State's overlapping triangles at text size. Check that the missing bottom edge remains visible, that readers learn the upward convention, and that the fork does not imply a greatest member, authority, causation or an incomplete Configuration.
5. **Arrowheads read as causation.** Causal path's directed chain against Causal Contribution's lanes and the old Capability staircase kept by Constituent Power; Denotation's maps-to against a generic arrow; the arrowheads added in Action, Consequence, Agency, Tool, Capability, Memory and Exposure, including upward arrows read as increase or upload.
6. **Template collisions recorded in the semantic review.** Sense and Trust against each other and against Action's barrier crossing; the post-stem-box template in Standing, Recognition, the Designations and Body; Tool against Respect and Permission Exercise; Map and Reference against Observation; Scope against Exercisability; Control, Boundary Sovereignty and Substrate; Interpretation against Intelligence; Model against Bodily Organization and Configuration; Capability against Rule.
7. **Imported imagery.** The eye, crown, legs, Admission's checkbox and the gate's institutional reading.
8. **Domain tags.** Small-size discrimination of `conditionI` from `conditionII`.
9. **Process and preservation drawings.** Check every hollow center in Feeds, Causal path, Causal Contribution, Invariant and Persistence at text size; Invariant against Persistence, one spoke apart, and both against Center; Change's plain delta against Configuration and the Agent family; Constraint's selective branch against Control and the remaining forks.
10. **Identity and expression drawings.** Check Entity's six hollow centers and its asterisk, Center and Symbol readings; Environment against Feeds and Scope; Specification's result mark near the sheet edge; Rule against Denotation; Sign's arrow direction against Denotation; and whether readers still take Principal and Person's ring and axis as Entity.
11. **Action and Interior drawings.** Check every r=1.5 pupil and hollow node; Exposure against Interior; whether readers take the vessel as a container or consciousness rather than a learned internality cue; Internal Activity Selection's solid and hollow endpoints, and whether the solid one reads as Truth, Permission, Presence or a past State; and whether Constituent Power and External Sovereignty still read as Capability or Exposure.
12. **Institutional drawings.** Check CountsAs against Recognition, Record, Tool and Price; Permission against Capability, Rule and CountsAs; Authority against Agent, Standing and Principal and warning-sign or tent readings; Permission Claim and Declaration against Claim, Principal and send or export icons; every hollow node.
13. **Permission and evidence drawings.** Check Grant against Permission Claim, Declaration and Principal, its arrow through the post and its reduced circle; Permission Exercise against Tool, Respect and Action; Exercisability against Scope; Enforcement's reduced Rule against Rule, Capability and Tool; Role against Authority, Principal and Configuration; Admissibility Rule and Evidence against Rule, Capability, Observation and Admission; IndependentFor against Claim, Witness and Action; and whether the V reads as a check mark, approval or Truth.

Each test should ask for a spontaneous reading without labels, then for pairwise discrimination with labels, at the sizes the site actually uses. Record results as reader evidence, separate from design approval.

## Incremental policy

The vocabulary grows one reviewed cue at a time. Nothing in it licenses reading meaning from an unreviewed combination.

1. **A cue enters by review.** A drawing becomes a family cue only through a named review section, like `pair_review`, that lists its terms, the drawing operation, the permitted reading, its anti-entailments and the open reader-test gate.
2. **A cue covers only its listed terms.** Reusing it in another glyph requires a definitional dependency in the ontology and an update to the same review. Otherwise draw the new glyph differently or label the reuse term-specific.
3. **Do not infer meaning from arbitrary differentiators.** `dot`, `foot`, `bar`, `cap`, `wings` and `seed` need a justified family relationship and explicit design and reader review before promotion to consistent cues. A new glyph should not rely on one of them as its only difference from a neighbor.
4. **Stroke names document intent, nothing more.** A stroke called `binding` or `admittedRecord` does not make a glyph binding or admitted.
5. **Every addition gets a collision check.** Append a font slot for a new term; preserve it when redrawing an existing glyph. Rerun the count command, compare the new glyph against every glyph sharing one of its operation groups, and record the nearest collisions in its review entry.
6. **Counts travel with their pin.** Quote a count only with the catalog hash it came from, and update the pin when the catalog changes.
7. **Failed cues are demoted, not defended.** If reader testing shows a family cue misleads, reclassify it as term-specific or conflicting before redrawing. Approved drawings change only with Daniel's approval.
8. **Unused strokes stay out.** `crescent`, `link`, `orbit`, `grouping`, `index`, `down`, `surroundings`, `structuredModel`, `endpoint`, `interpretedAction` and `hooks` re-enter only through step 1.

## Related entries

- [Organon symbol review](./glyph-atlas.md), the generated per-term table.
- [Semantic review data](./glyph-semantic-review.json), which holds the approvals cited above.
- [Shared glyph catalog](./glyph-catalog.mjs) and [geometry rules](./glyph-geometry.json).
- [Unicode symbolic vocabulary study](./unicode-vocabulary.md), the method and its historical alternatives.
- [Daniel's Ontology](../ontology/ontology.md), which governs what each term means.
