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
> Inventory counts below describe the catalog at [81aad87](https://github.com/sadasant/organon/commit/81aad87daa679378d54cde7c3d5ce2da61d37e08), sha256 `dffbc37d1b493a78a06f7cad5b14cd6ab70586fb99a7a27c6d01895998bc2e6e`: 117 glyphs, 89 named strokes, three unused. The current follow-up has 118 glyphs and 91 strokes: State uses `stateOverlap`, leaving `grouping` and `index` unused; MathematicalOrder reuses `members` with `partialOrder` cover edges. Thus `members` now has three uses and `memberLinks` one. The command below measures the current catalog, not the historical counts.

Run from the repository root:

```sh
node --input-type=module <<'EOF'
import { glyphs, strokes } from "./proposals/glyph-catalog.mjs";
const ops = {
  dot: ["dot", "seed", "members", "inversePresence", "stateOverlap"],
  parallelBars: ["bars"],
  shortStroke: ["bar", "cap", "foot", "wings", "ticks", "index"],
  vertical: ["axis", "rails", "echo", "association", "comparison", "party", "factive"],
  arrowhead: ["arrow", "up", "down", "denotes", "endpoint", "interpretedAction", "realizable", "statusAssignment", "binding", "issuedPermission", "permittedRealization", "admittedOther", "knowledgePath", "enforcedBoundary", "uptake", "adjustedAction", "constrainedAction"],
  angleTag: ["chevron", "conditionI", "conditionII"],
  turningPath: ["step", "ordered", "endpoint", "realizable", "placement", "statusAssignment", "binding", "permittedRealization", "ruleCoupling", "continuingOrder", "portableRecord", "tracedRecord", "partialMap", "structuredModel", "recordedExchange", "scopedWorld", "feedingSource", "correspondence", "knowledgePath", "constituents", "tracking", "adjustedAction"],
  branching: ["tree", "fork", "routing", "feedingSource", "ruleCoupling", "tracking", "interpretedAction", "constituents", "enforcedBoundary", "partialOrder"],
  contour: ["ring", "inversePresence", "square", "gate", "vessel", "frame", "portFrame", "open", "arch", "eye", "diamond", "double", "triangle", "memberLinks", "grouping", "personRecord", "partialMap", "tracedRecord", "portableRecord", "recordedPlacement", "recordedExchange", "structuredModel", "knowledgePath", "assertion", "registration", "endpoint", "statusAssignment", "placement", "admittedRecord", "constituents", "constrainedAction", "factive", "stateOverlap"],
  cornerMark: ["grouping", "warranted", "hooks", "participants", "surroundings", "scopedWorld", "permittedRealization", "issuedPermission"],
  strike: ["slash", "cross", "routing", "enforcedBoundary"],
  wave: ["wave"],
  figurative: ["crown", "roots", "star", "assignedBundle"],
};
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

| Cue | Glyphs | Learned reading | Does not mean | Review |
| --- | --- | --- | --- | --- |
| Circular contour | [Presence](../ontology/ontology.md#organon-presence) (ring and dot), [Missingness](../ontology/ontology.md#organon-missingness) (ring), [Reality](../ontology/ontology.md#organon-reality) (filled disk, clear center) | The three field terms share one outer contour, so they read as a set of companions. | A Boundary, an Entity or a container. Reality's clear center is negative space in the inscription, not Absence inside Reality. An empty ring does not establish Missingness without a specified target. | `pair_review`, `field_review` |
| Standalone underscore | [Absence](../ontology/ontology.md#organon-absence) | A minimal conventional name. | A slot, ground, baseline or position. The same `foot` stroke elsewhere is not Absence. | `pair_review` |
| Two equal parallel bars | [Identity](../ontology/ontology.md#organon-identity) (`=`), [Difference](../ontology/ontology.md#organon-difference) (bars with slash), [Relation](../ontology/ontology.md#organon-relation) (bars joined by a vertical) | Identity and Difference form the classical equals / not-equals pair. Relation borrows the proportions. | An operator. Relation does not require Identity, and two bars do not limit Relation to two participants. | `identity_review`, `relation_review` |
| Member dots and straight edges | [Set](../ontology/ontology.md#organon-set) (three solid dots), [Configuration](../ontology/ontology.md#organon-configuration) (the same dots joined) | Shared dots cue the member Set; edges cue additional specified structure. | Three members, member order, complete connectivity, causation or binary-only Relations. | `set_configuration_review`, `structured_configuration_correction` |
| Maps-to | [Denotation](../ontology/ontology.md#organon-denotation) | Expression side (tail) to target side (arrowhead). | A function's uniqueness condition, causation, fidelity or Truth. | `denotation_review` |

State now uses two equal, upright Configuration-like triangles with exactly half-base overlap, approved in `state_overlap_review`. Four equally spaced baseline nodes alternate hollow, solid, hollow, solid; each apex sits directly above the other triangle's inner base node. The left triangle has hollow vertices and the right has solid vertices. The shared baseline is drawn once and the diagonal crossing has no node. Edges stop outside hollow centers, so the font keeps actual negative space rather than background-colored masks.

This is a term-specific mnemonic for an indexed Configuration, not a diagram of two required States or a Transformation. Hollow/solid does not mean Missingness/Presence, past/present, possible/actual or less/more real. The drawing does not establish an index domain or its ordering; the distinction between an index and an ordered position remains a separate definition/formalization question. Retain labels and test the hollow centers at text size.

Order extends the approved member-dot family with a Hasse-diagram mnemonic, approved in `order_hasse_review`: Set's three dots joined along the two sloping sides, without Configuration's bottom edge. Read upward, each lower member precedes the upper member and the lower pair is incomparable. In a Hasse diagram, edges show cover relationships; reflexive loops and edges implied by transitivity are omitted. This borrows a [mathematical drawing convention](https://mathworld.wolfram.com/HasseDiagram.html), not a new comparison sign or a compositional operation on Configuration. It does not require three members, a greatest member, branching, finiteness or incomparability in every Order; empty and total Orders remain permitted. Upward means order here, not causation, authority or improvement. Labels remain necessary.

## Candidate family cues

These reuses follow a definitional dependency and help a reader find a family. All are revised or retained trials awaiting design and reader review, so none is part of the approved vocabulary yet.

| Shared drawing | Glyphs | Why reuse is supported | Open risk |
| --- | --- | --- | --- |
| `partialMap` | Map, Reference | Reference visibly contains Map. | Map collapses toward Observation and Evidence at small sizes. |
| `tracedRecord` | Observation, Evidence | Evidence is an admitted Observation. | The `admittedRecord` marker is tiny and resembles Consequence's endpoint box. |
| `realizable` | Capability, Constituent Power | Constituent Power is a Capability. | The ascent reads as progress and as a Causal path. |
| `knowledgePath`, `factive` | Operative Knowledge, Factive Operative Knowledge, Warranted Knowledge | Each successive term adds a condition to the previous one. | The `warranted` corner is a generic frame, not an Evidence cue. |
| `tracking` | Attention, Care | Care is Attention conditioning Action. | Converging pair aimed at a bar resembles Enforcement. |
| ring with axis | Entity, Principal, Person | Principal and Person are Entities. | Any ring and axis may be read as a Principal or Person. |
| diamond with axis | Truth, and the `factive` mark | The Factive and Warranted terms involve Truth. | The diamond is also Boundary's and Symbol's. Reserve diamond-on-axis for Truth-involving terms. |
| `double` | Ritual, Meaning | Meaning is constituted by Ritual. | Recurrent Integration also uses `double` without that dependency. |
| `assertion`, `registration` with `conditionI` / `conditionII` | The two Attributions and the two Designations | Flag marks Attribution, form marks Designation, tag marks the domain. | Only a 5–6 unit tag separates consciousness from moral status. |
| gate with arrow, slash or up | Permission, Revocation, Permission Exercise | All three concern one governed passage. | The same gate also appears in Claim, Rule, Admission and the sovereignty glyphs. |
| routing template | Control, Boundary Sovereignty | Boundary Sovereignty requires Control. | Substrate's split resembles it with no such dependency. |
| `slash` on a shape | Difference, Change | Change is defined as a Difference (D008). | Revocation uses the same slash for cancellation. |

## Four readings the vocabulary refuses

### A dot is not Presence

Presence is ring and dot. The dot alone is drawn in 11 glyphs at the pinned source, including Representation, Claim, Truth, Interior, Perception's pupil and Transformation's bead. Under A4 every inscription is already Presence, so no stroke can mark it uniquely. A dot is a point of attention in the drawing. It is not a located Entity, a target or a witness of existence. The geometry rules also forbid distinguishing semantically opposed terms by a tiny dot alone; Presence and Missingness are not opposed, but their dot difference still needs small-size testing.

### A line is not causation

At the pinned source, 28 glyphs carry an arrowhead and 30 carry a stepped or right-angled path. Configuration's edges, Relation's vertical and Denotation's stem are lines too. Arrowheads and paths are order or attention cues. They do not assert a Causal path (D010), a Feeds join, transfer of possession, or command. Even the Causal path glyph does not show the Feeds joins its definition requires. An ascending path does not mean improvement.

### An enclosure is not a boundary

Closed and near-closed contours appear in 76 glyphs at the pinned source: rings, squares, gates, vessels, frames, the eye, boxes inside signatures, and Configuration's triangle. None of them depicts a Boundary in the sense of D015, an Interior, a jurisdiction or a recorded status. Boundary's own glyph is a diamond with outer strokes, and even that glyph's legend says a Boundary need not be geometric. Recognition's closed square, Person's open record box and the vessel family are stipulated mnemonics, not pictures of containment.

### Identity's bars are not an operator

The `bars` stroke appears in 8 glyphs at the pinned source. In Identity, Difference and Relation it carries the approved equals-sign reading. In Invariant it forms a hash, in Specification a list, in Memory stored lines, in Ledger a grid, in Bodily Organization a pair of parts. Those glyphs do not contain Identity. Likewise, Difference's slash is a mnemonic for that pair, not a general negation operator, and Relation's vertical is association, not an operation on Identity.

## Inventory by drawing operation

Every named stroke appears below. Counts are glyphs at the pinned source.

### Dots and solid marks

| Strokes | Glyphs | Class | Note |
| --- | --- | --- | --- |
| `dot` | 11 | Conflicting | Approved only as part of Presence. Elsewhere arbitrary. |
| `members` | 2 | Approved family cue | Set and Configuration. |
| `stateOverlap` | 1 in the current follow-up | Approved, term-specific | State's half-overlapping triangles extend the geometric family without making hollow/solid a general semantic operator. |
| `inversePresence` | 1 | Approved, term-specific | Reality. Overlapping construction strokes are not layers of Reality. |
| `seed` | 1 | Term-specific, arbitrary | Operationalization. |

### Horizontal strokes

| Strokes | Glyphs | Class | Note |
| --- | --- | --- | --- |
| `bars` | 8 | Approved for Identity, Difference, Relation; conflicting elsewhere | See [Identity's bars are not an operator](#identitys-bars-are-not-an-operator). |
| `foot` | 11 | Conflicting | Approved only as standalone Absence. Elsewhere an arbitrary differentiator, for example between Admission and Admissibility Rule. |
| `bar`, `cap`, `wings` | 6, 5, 6 | Conflicting | Arbitrary differentiators. A cap is not Authority; wings are not extension. |
| `ticks`, `index` | 1 each at the historical pin | Term-specific | Organ; State's former index is now unused. |

### Vertical strokes

| Strokes | Glyphs | Class | Note |
| --- | --- | --- | --- |
| `axis` | 9 | Candidate family cue with Entity's ring or Truth's diamond; unsupported in Sign, Preference, Ritual, Embodied Perspective; unclear in Agent | An axis is not identity through States unless the glyph belongs to the Entity family. Agent's triangle-on-axis shares nothing else with Entity. |
| `rails` | 9 | Conflicting | The review recommends restricting rails to persistence-bearing terms. The nine current uses have not been audited against that rule. |
| `echo` | 3 | Conflicting | Boundary, Constituent Power and Recurrent Integration share outer bars with no shared meaning. `comparison` (Reference) resembles them. |
| `association`, `comparison`, `party` | 1 each | Term-specific | Relation (approved), Reference, Principal. |
| `factive` | 2 | Candidate family cue | Truth's diamond-on-axis, reduced. |

### Arrowheads

| Strokes | Glyphs | Class | Note |
| --- | --- | --- | --- |
| `arrow` | 8 | Conflicting | Generic arrow in Causal path, Action, ActsFor, Permission Exercise, Evidential Bearing, Constituent Exercise, Operationalization, Knowledge Transmission. |
| `up`, `down` | 2, 1 | Conflicting, term-specific | Up in Direction and Permission may read as increase. Down is Feeds only. |
| `denotes` | 1 | Approved, term-specific | Denotation. |
| `realizable`, `knowledgePath` | 2, 3 | Candidate family cues | See [Candidate family cues](#candidate-family-cues). |
| `endpoint`, `interpretedAction`, `statusAssignment`, `binding`, `issuedPermission`, `permittedRealization`, `admittedOther`, `uptake`, `enforcedBoundary`, `adjustedAction`, `constrainedAction` | 1 each | Term-specific | Order mnemonics. Several still collide by template; see [Unresolved collisions](#unresolved-collisions-and-reader-tests). |

### Angles and domain tags

| Strokes | Glyphs | Class | Note |
| --- | --- | --- | --- |
| `chevron` | 4 | Conflicting | Interpretation, Admission, Admissibility Rule, Preference. Checkmark and down-arrow readings. |
| `conditionI`, `conditionII` | 2 each | Candidate family cue | Domain tags only. They depict neither consciousness nor morality. |

### Turning paths

| Strokes | Glyphs | Class | Note |
| --- | --- | --- | --- |
| `step` | 4 | Conflicting | Transformation, Causal path, Record, Utility Measure. Record and Utility Measure are not Transformations. |
| `partialMap`, `tracedRecord`, `tracking` | 2 each | Candidate family cues | |
| `ordered`, `placement`, `ruleCoupling`, `continuingOrder`, `portableRecord`, `structuredModel`, `recordedExchange`, `scopedWorld`, `feedingSource`, `correspondence`, `constituents` | 1 each | Term-specific | Stepped connectors now recur in 30 glyphs, so the step itself carries no family meaning. |

### Branching junctions

| Strokes | Glyphs | Class | Note |
| --- | --- | --- | --- |
| `tree` | 5 | Conflicting | Declaration, Canonical and Shadow system, Polity, Bodily Organization. |
| `fork` | 3 | Conflicting | Causal Contribution, Intelligence, Internal Activity Selection. Reads as choice. |
| `routing`, `enforcedBoundary` | 1 each | Candidate template family | Control and Boundary Sovereignty. |
| `feedingSource`, `ruleCoupling`, `interpretedAction`, `constituents` | 1 each | Term-specific | Substrate, Enforcement, Agency, Body. Splits and merges still resemble one another. |

### Closed and near-closed contours

| Strokes | Glyphs | Class | Note |
| --- | --- | --- | --- |
| `ring` | 8 | Approved for Presence and Missingness; candidate family cue for Entity, Principal, Person; conflicting in Persistence, Center, Organ | |
| `memberLinks` | 1 | Approved, term-specific | Configuration's edges, not an enclosed region. |
| `square` | 7 | Conflicting | Proposed anchor for Representation, but also Specification, Record, Canonical system, Ledger, Operationalization, Knowledge Transmission. |
| `gate` | 11 | Candidate family cue for Permission, Revocation, Permission Exercise; conflicting elsewhere | Claim, Rule, Admission and the sovereignty glyphs make the gate read as institutional. |
| `eye` | 7 | Conflicting | Imports visual seeing into terms that do not require it. |
| `vessel` | 5 | Conflicting | Enclosure-as-interior is stipulated; Bodily Organization contains Memory's drawing. |
| `diamond` | 3 | Conflicting | Boundary, Symbol, Truth. |
| `triangle` | 3 | Conflicting | Agent and ActsFor versus Change. |
| `double` | 3 | Candidate family cue for Ritual and Meaning; conflicting in Recurrent Integration | |
| `frame`, `open` | 3, 2 | Conflicting | Frame in Constraint, Scope, Shadow system; Exposure's open arc is inherited by External Sovereignty. |
| `arch`, `portFrame`, `grouping`, `personRecord`, `recordedPlacement`, `assertion`, `registration`, `admittedRecord` | 1–2 each at the historical pin | Term-specific or candidate pairs | `recordedPlacement` and `registration` share a post-stem-box template with `placement` and `constituents` that remains a collision. State's redraw leaves `grouping` unused in the current catalog. |

### Corner marks, strikes, waves and figures

| Strokes | Glyphs | Class | Note |
| --- | --- | --- | --- |
| `warranted`, `hooks`, `participants`, `surroundings` | 1 each | Term-specific | A generic corner reads as Scope or a frame. |
| `slash` | 3 | Approved within Difference; candidate in Change; conflicting in Revocation | |
| `cross` | 2 | Conflicting | Language and Organ. |
| `wave` | 3 | Conflicting | Feeds, Flow, Knowledge Transmission. Periodicity is not implied. |
| `crown` | 3 | Conflicting | The sovereignty profiles do not entail one another, and the crown imports monarchy. |
| `roots` | 3 | Conflicting | Legs import bodily locomotion and crowds. |
| `star` | 2 | Conflicting | Symbol and Center. |
| `assignedBundle` | 1 | Term-specific | Role. |
| `crescent`, `link`, `orbit` | 0 | Unused | Retired drawings kept in the catalog. Not part of the vocabulary. |

## Unresolved collisions and reader tests

Ordered by priority. Approved marks come first because readers will learn them first.

1. **Presence, Missingness and Reality at text size.** Only a dot separates Presence from Missingness, and Reality's clear center can fill in to a solid disk. Test pairwise discrimination in inline text, tiles and graphs.
2. **The bars family.** Test Identity, Difference and Relation side by side at text size, Relation against the double-dagger, and whether readers read Identity into Invariant, Specification, Memory or Ledger.
3. **State's overlapping triangles.** Check the three hollow centers, four-node baseline and unmarked diagonal crossing at text size. Compare with Configuration, Order and Change; ask whether the pair suggests a transition, two required States or a past/present contrast. Exact midpoint alignment is geometric, not an identity or ordering proof.
4. **MathematicalOrder's Hasse fork.** Test it against Set's unconnected dots, Configuration's closed triangle and State's overlapping triangles at text size. Check that the missing bottom edge remains visible, that readers learn the upward convention, and that the fork does not imply a greatest member, authority, causation or an incomplete Configuration.
5. **Arrowheads read as causation.** Causal path against the Capability family; Denotation's maps-to against a generic arrow; Consequence against CountsAs.
6. **Template collisions recorded in the semantic review.** Sense against Trust; the post-stem-box template in Standing, Recognition, the Designations and Body; Map and Reference against Observation and Evidence; Attention and Care against Enforcement; Control, Boundary Sovereignty and Substrate; Model against Price.
7. **Imported imagery.** The eye, crown, legs, Admission's checkbox and the gate's institutional reading.
8. **Domain tags.** Small-size discrimination of `conditionI` from `conditionII`.

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
8. **Unused strokes stay out.** `crescent`, `link` and `orbit` re-enter only through step 1.

## Related entries

- [Organon symbol review](./glyph-atlas.md), the generated per-term table.
- [Semantic review data](./glyph-semantic-review.json), which holds the approvals cited above.
- [Shared glyph catalog](./glyph-catalog.mjs) and [geometry rules](./glyph-geometry.json).
- [Unicode symbolic vocabulary study](./unicode-vocabulary.md), the method and its historical alternatives.
- [Daniel's Ontology](../ontology/ontology.md), which governs what each term means.
