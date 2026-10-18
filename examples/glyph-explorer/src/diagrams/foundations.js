// Nonbinding review diagrams for Organon terms 1–40 (excluding Transformation,
// Feeds and CausalPath, which have custom diagrams). Each entry illustrates
// the canonical definition in ontology/ontology.md; none is a dependency graph,
// a sufficiency claim or a substitute for the full entry.
//
// kind 'specification': `structure` is a qualified schematic of one
//   illustrative instance. Nodes are particular participants or relationship
//   occurrences (a shared node ID means one and the same participant); edges
//   are definition roles, not dependency edges. An ordered edge states only
//   its labelled relationship, never automatic causality or implication;
//   identity and comparison edges are unordered. The diagram is not a
//   sufficiency claim: every card.conditions entry remains an obligation, and
//   optional properties drawn in the example are not asserted of every
//   instance. `ports` remain as term navigation inventory.
// kind 'relational': drawn by a custom renderer.
// kind 'foundation': no ports and no wires; the term is shown with its
//   conditions only.

const T = (name) => `organon:${name}`;
const n = (id, label) => ({ id, label });
const e = (from, to, label, kind) => ({ from, to, label, kind });

export default {
  [T("Absence")]: {
    kind: "foundation",
    title: "Absolute Absence",
    ports: [],
    conditions: [
      "Absence has no interior: no part, quality, position, boundary, order, duration or relation.",
      "Absence is exact. Almost, partial or qualified Absence is not Absence.",
      "Absence is not an empty region, an omitted item, a zero, a shadow, a silence or the absence of something.",
    ],
    reading:
      "Absence is the primitive. It is absolute and exact, and nothing is inside it, outside it, before it, after it or related to it.",
    note:
      "This box is a drawn mark, so under A4 it is Presence. It names Absence by convention and does not depict it. The empty space around the box is not Absence either.",
  },

  [T("Presence")]: {
    kind: "foundation",
    title: "Whatever is not identically Absence",
    ports: [],
    conditions: [
      "For anything the ontology considers, exactly one holds: it is identically Absence, or it is Presence.",
      "Nothing is both, and there is no third condition. Excluded middle is a classical commitment of the metalanguage.",
      "Presence obtains performatively: any statement, including this diagram, is not identically Absence.",
    ],
    reading:
      "Presence is defined by contrast: whatever is not identically Absence. This is a partition stated in the metalanguage, not an event and not a derivation of Presence from Absence.",
    note:
      "No wire joins Presence to Absence because the contrast is not a Relation. Drawing one would place Absence inside an association among Presences. Classical exhaustiveness also does not mean anyone knows which side a candidate falls on.",
  },

  [T("Identity")]: {
    kind: "specification",
    structure: {
      context: "Declared domain of Presence · comparison positions belong to the metalanguage",
      nodes: [
        n("id", "Identity claim\non positions 1, 2"),
        n("p1", "comparison\nposition 1"),
        n("p2", "comparison\nposition 2"),
        n("x", "one Presence x\nin the declared domain"),
        n("phi", "predicate φ\nabout x"),
        n("ab", "tuple ⟨a, b⟩"),
        n("ba", "tuple ⟨b, a⟩"),
      ],
      edges: [
        e("id", "p1", "first compared\nposition", "role"),
        e("id", "p2", "second compared\nposition", "role"),
        e("p1", "x", "filled by x", "role"),
        e("p2", "x", "filled by the same x", "role"),
        e("id", "phi", "licenses substitution\nin φ", "constraint"),
        e("ab", "ba", "same constituents;\nIdentity only if same\none in each position", "comparison"),
      ],
    },
    title: "One and the same Presence",
    ports: [
      { label: "compared item in position 1" },
      { label: "compared item in position 2 (may denote the same item)" },
      { label: "declared domain of Presence for both items", term: T("Presence") },
    ],
    conditions: [
      "The items in both positions are one and the same Presence, or one and the same ordered tuple of Presence.",
      "Tuples match only with the same constituents in the same positions. Equality after discarding order is not Identity.",
      "Identity is reflexive, symmetric and transitive, and permits substitution in predicates about the same items.",
    ],
    reading:
      "Two comparison positions, which belong to the metalanguage, are filled by one and the same Presence or ordered configuration of Presence. Logical equality restricted to Presence obtains when that is so.",
    note:
      "Two positions do not mean two things, and making the comparison does not produce Identity. Identity is not a Transformation, not likeness, not agreement in selected properties and not indistinguishability to an observer.",
  },

  [T("Missingness")]: {
    kind: "specification",
    structure: {
      context: "Relation within Presence · field, target and noncontainment all specified",
      nodes: [
        n("m", "Missingness of k in F"),
        n("f", "specified field F\n(e.g. a drawer)"),
        n("k", "specified target:\nparticular key k"),
        n("y", "contained key y\n(compatible, not k)"),
        n("c", "target condition C:\n“any compatible key”"),
      ],
      edges: [
        e("m", "f", "field", "role"),
        e("m", "k", "represented or\nexpected target", "role"),
        e("f", "y", "contains", "membership"),
        e("y", "k", "differ: y is\nnot identical to k", "comparison"),
        e("f", "k", "noncontainment:\nno member matches k", "constraint"),
        e("y", "c", "satisfies C, so F\nlacks no C-satisfier", "constraint"),
      ],
    },
    title: "A field with no matching Presence",
    ports: [
      { label: "field that represents or expects a target" },
      { label: "specified target Presence, or explicit target condition" },
      { label: "specified noncontainment: no match in the field" },
    ],
    conditions: [
      "The field represents or expects one specified Presence, or a Presence satisfying an explicit target condition.",
      "For a particular target, a match means Identity with it. For a condition, the field must contain no satisfier at all.",
      "The field, the represented or expected target, and the noncontainment must all be specified.",
    ],
    reading:
      "Missingness is a relation within Presence. A specified field represents or expects a target but contains nothing that matches it. A drawer holding a different compatible key lacks that particular key, but not every compatible key.",
    note:
      "Missingness is not Absence. Gaps, zeros and silences are present signs of it. Noncontainment alone sets no expectation, and an expected condition need not have any actual satisfier.",
  },

  [T("Reality")]: {
    kind: "foundation",
    title: "The totality of Presence",
    ports: [],
    conditions: [
      "Reality is the totality of Presence.",
      "No part of Reality may identify the portion available to it with Reality as a whole.",
      "World and substrate are not synonyms for Reality.",
    ],
    reading:
      "Reality is the totality of Presence. A participant may not identify the portion available to it with that totality.",
    note:
      "A bounded box cannot show a totality. This drawing is part of Reality and does not enclose or depict all of it. No local domain, World, Map or Set stands in for Reality.",
  },

  [T("Difference")]: {
    kind: "specification",
    structure: {
      context: "Each comparison is its own question · criterion fixes what positions denote",
      nodes: [
        n("q", "Difference claim\non (a, b)"),
        n("crit", "criterion fixing what\neach position denotes"),
        n("a", "Presence a"),
        n("b", "Presence b"),
        n("c", "Presence c"),
      ],
      edges: [
        e("q", "a", "compared item 1", "role"),
        e("q", "b", "compared item 2", "role"),
        e("q", "crit", "positions fixed by", "role"),
        e("a", "b", "differ:\nnot identical", "comparison"),
        e("c", "b", "differ:\nnot identical", "comparison"),
        e("a", "c", "identical: Difference\nneed not be transitive", "identity"),
      ],
    },
    title: "Failure of Identity between compared items",
    ports: [
      { label: "compared Presence or ordered tuple a", term: T("Presence") },
      { label: "compared Presence or ordered tuple b", term: T("Presence") },
      { label: "criterion fixing what each position denotes" },
    ],
    conditions: [
      "For the same compared items a and b, exactly one of Identity and Difference obtains.",
      "Difference is symmetric and irreflexive.",
      "Difference need not be transitive: a and c can each differ from b while being identical to each other.",
    ],
    reading:
      "Difference holds between two compared items, inside Reality, exactly when they are not one and the same. Changing the items, their order or the denotation criterion asks a new question.",
    note:
      "The classical partition does not mean an observer knows which side holds. The departure of Presence from Absence belongs to the metalanguage and is not a Difference.",
  },

  [T("Relation")]: {
    kind: "specification",
    structure: {
      context: "Positions are ordered, n ≥ 2 · position order is not time or cause",
      nodes: [
        n("r", "Relation R(a, b, c)\n(itself a Presence)"),
        n("s", "Relation S(a, a)"),
        n("a", "participant a"),
        n("b", "participant b"),
        n("c", "participant c"),
      ],
      edges: [
        e("r", "a", "position 1", "role"),
        e("r", "b", "position 2", "role"),
        e("r", "c", "position 3\n(optional, n = 3)", "role"),
        e("s", "a", "positions 1 and 2:\nsame participant", "role"),
        e("a", "b", "any Difference\nis preserved", "comparison"),
      ],
    },
    title: "Ordered association of Presences",
    ports: [
      { label: "participant in position 1", term: T("Presence") },
      { label: "participant in position 2", term: T("Presence") },
      { label: "further positions 3…n, if any (n ≥ 2)" },
    ],
    conditions: [
      "Two or more Presences occupy ordered positions.",
      "The Relation is itself a Presence.",
      "The Relation does not erase whatever differences hold among its participants.",
    ],
    reading:
      "A Relation is a Presence in which two or more Presences have an ordered association. Each participant keeps its own position.",
    note:
      "Positions are ordered, but the participants need not be distinct or unequal. The definition preserves any differences and does not require them. Order of positions is not chronological or causal order.",
  },

  [T("Denotation")]: {
    kind: "specification",
    structure: {
      context: "Ordered Relation · establishes no fidelity, Truth, Interpretation or Causal path",
      nodes: [
        n("d", "Denotation D (e, t)"),
        n("e", "expression e\n(e.g. the word “river”)"),
        n("t", "target t: Presence,\nRelation or\nConfiguration"),
        n("r", "Relation R (t, e):\npositions swapped"),
      ],
      edges: [
        e("d", "e", "position 1:\nexpression", "role"),
        e("d", "t", "position 2:\ntarget", "role"),
        e("e", "t", "denotes under D", "denotation"),
        e("r", "t", "position 1", "role"),
        e("r", "e", "position 2", "role"),
        e("d", "r", "not the same\nDenotation", "comparison"),
      ],
    },
    title: "An expression position and its target",
    ports: [
      { label: "first position: expression Presence", term: T("Presence") },
      { label: "later position: target Presence, Relation or Configuration" },
    ],
    conditions: [
      "Denotation is an ordered Relation with an expression position first and a target position later.",
      "Both participants and their ordered positions must be named.",
      "The target may be a Presence, a Relation or a Configuration.",
    ],
    reading:
      "Denotation ties whatever occupies the expression position to a named target. Swapping the positions does not give the same Denotation.",
    note:
      "Denotation alone establishes no fidelity, Truth, Interpretation, institutional status or participation in a Causal path.",
  },

  [T("Set")]: {
    kind: "specification",
    structure: {
      context: "Declared local domain Δ, not Reality · membership supplied by the metalanguage",
      nodes: [
        n("dom", "declared domain Δ"),
        n("s", "Set listed {a, b}"),
        n("s2", "Set listed {b, a, a}"),
        n("a", "member a"),
        n("b", "member b"),
        n("z", "empty Set ∅\n(Presence)"),
      ],
      edges: [
        e("a", "s", "∈", "membership"),
        e("b", "s", "∈", "membership"),
        e("a", "s2", "∈", "membership"),
        e("b", "s2", "∈", "membership"),
        e("s", "s2", "same members:\none Set", "identity"),
        e("s", "dom", "Set in domain", "role"),
        e("z", "dom", "Set in domain;\nno members", "role"),
      ],
    },
    title: "Fixed by its members in a declared domain",
    ports: [
      { label: "declared domain" },
      { label: "member Presences (possibly none)", term: T("Presence") },
    ],
    conditions: [
      "Two Sets in the same domain have Identity exactly when they have the same members.",
      "Listing order and repetition do not change a Set.",
      "A Set may have no members. The empty Set is Presence, not Absence.",
    ],
    reading:
      "A Set is fixed by which Presences are its members within a declared domain. Membership itself is supplied by the metalanguage.",
    note:
      "The domain is local, not Reality and not a universal carrier. Membership orders nothing and relates nothing further. There is no unrestricted comprehension, and a list does not show that its members exist.",
  },

  [T("MathematicalOrder")]: {
    kind: "specification",
    structure: {
      context: "Order = (member Set, extension of ≤) · reflexive pairs (x, x) not drawn",
      nodes: [
        n("o", "Order O = (S, ≤)"),
        n("s", "member Set S"),
        n("ext", "extension of ≤:\nset of ordered pairs"),
        n("a", "member a"),
        n("b", "member b"),
        n("c", "member c"),
      ],
      edges: [
        e("o", "s", "first component", "role"),
        e("o", "ext", "second component", "role"),
        e("a", "s", "∈", "membership"),
        e("b", "s", "∈", "membership"),
        e("c", "s", "∈", "membership"),
        e("a", "b", "a ≤ b:\n(a, b) in extension", "comparison"),
        e("a", "c", "a ≤ c:\n(a, c) in extension", "comparison"),
        e("b", "c", "incomparable\n(permitted)", "comparison"),
      ],
    },
    title: "A member Set paired with ≤",
    ports: [
      { label: "member Set (may be empty)", term: T("Set") },
      { label: "extension of ≤: ordered pairs of members" },
    ],
    conditions: [
      "For all members a: a ≤ a (reflexive).",
      "For all members a, b: a ≤ b and b ≤ a imply a and b have Identity (antisymmetric).",
      "For all members a, b, c: a ≤ b and b ≤ c imply a ≤ c (transitive).",
      "Two Orders have Identity exactly when they have the same members and the same extension.",
    ],
    reading:
      "An Order is the pair of a member Set and a metalinguistic binary relation ≤ on its members. The pair is the Order; the member Set alone is not.",
    note:
      "Total comparability is not required, so members may be incomparable. ≤ need not be realized as registered Relations, and an Order supplies no time, causation, rank or global ordering of Presence.",
  },

  [T("Configuration")]: {
    kind: "specification",
    structure: {
      context: "Configuration = (member Set, specified structure) · membership ≠ structural role",
      nodes: [
        n("k", "Configuration K"),
        n("k2", "Configuration K′:\nsame members,\nno specified Relations"),
        n("m", "member Set {a, Q}"),
        n("a", "member a"),
        n("q", "Relation Q:\nmember only"),
        n("r", "specified\nRelation R(a, z)"),
        n("z", "participant z\n(not a member)"),
      ],
      edges: [
        e("k", "m", "member Set", "role"),
        e("k", "r", "specified structure", "role"),
        e("r", "a", "position 1\n(a member)", "role"),
        e("r", "z", "position 2", "role"),
        e("a", "m", "∈", "membership"),
        e("q", "m", "∈, with no\nstructural role", "membership"),
        e("k2", "m", "member Set", "role"),
        e("k", "k2", "same members,\nnot identical", "comparison"),
      ],
    },
    title: "Members plus specified relational structure",
    ports: [
      { label: "member Set of Presences (may be empty)", term: T("Set") },
      { label: "specified Relations (may be none)", term: T("Relation") },
      { label: "participant occupying each ordered position" },
    ],
    conditions: [
      "Each specified Relation is a member or has at least one member as a participant.",
      "Identity needs the same member Set and the same Relations with the same participants in the same positions.",
      "Being a member does not by itself give a Relation a structural role.",
    ],
    reading:
      "A Configuration pairs a member Set with specified relational structure, and that pair is the Configuration. Forgetting the structure leaves only the member Set.",
    note:
      "Specifying a Relation does not create it or change its participants. Nonemptiness and full connectivity are not required, and the same members do not make two Configurations identical.",
  },

  [T("State")]: {
    kind: "specification",
    structure: {
      context: "Positions come from the metalanguage's ordering · a position adds no Relation",
      nodes: [
        n("k", "Configuration K"),
        n("i", "position i"),
        n("j", "position j"),
        n("s", "State s = (K, i)"),
        n("s2", "State s′ = (K, j)"),
      ],
      edges: [
        e("s", "k", "Configuration", "role"),
        e("s", "i", "position", "role"),
        e("s2", "k", "same Configuration", "role"),
        e("s2", "j", "position", "role"),
        e("i", "j", "different positions", "comparison"),
        e("s", "s2", "two distinct States", "comparison"),
      ],
    },
    title: "A Configuration at a position",
    ports: [
      { label: "Configuration", term: T("Configuration") },
      { label: "position in the metalanguage's ordering" },
    ],
    conditions: [
      "Two States have Identity exactly when they share a position and their Configurations have Identity.",
      "One Configuration at two different positions gives two States.",
      "The position adds no Relation to the Configuration.",
    ],
    reading:
      "A State pairs a Configuration with a position in the metalanguage's ordering. The position indexes the State and is not part of the Configuration.",
    note:
      "The index does not itself establish clock time or causation. Two States with identical Configurations still differ if their positions differ.",
  },

  [T("Direction")]: {
    kind: "specification",
    structure: {
      context: "One Direction d between States · asymmetric · need not be transitive or follow the index",
      nodes: [
        n("d", "Direction d"),
        n("o1", "d orders s₀\nbefore s₁"),
        n("o2", "d orders s₁\nbefore s₂"),
        n("s0", "State s₀"),
        n("s1", "State s₁"),
        n("s2", "State s₂"),
      ],
      edges: [
        e("o1", "d", "pair of d", "membership"),
        e("o2", "d", "pair of d", "membership"),
        e("o1", "s0", "earlier position", "role"),
        e("o1", "s1", "later position", "role"),
        e("o2", "s1", "earlier position", "role"),
        e("o2", "s2", "later position", "role"),
        e("s1", "s0", "excluded: d does not\norder s₁ before s₀", "constraint"),
        e("s0", "s2", "not required: d need\nnot order s₀ before s₂", "constraint"),
      ],
    },
    title: "Asymmetric ordering between States",
    ports: [
      { label: "State ordered first by this Direction", term: T("State") },
      { label: "State ordered second by this Direction", term: T("State") },
    ],
    conditions: [
      "If the Direction orders State s before State s′, the same Direction does not order s′ before s.",
      "Direction need not be transitive: s₀ before s₁ and s₁ before s₂ do not give s₀ before s₂.",
      "Direction need not agree with the indexing order of the States it relates.",
    ],
    reading:
      "A Direction is a Relation between States that is asymmetric: whatever it orders one way, it does not order the other way. It brings that asymmetry into Presence as a Relation.",
    note:
      "Direction need not be chronological order or agree with the metalanguage's index. Asymmetry alone does not make it the strict part of an Order.",
  },

  [T("Change")]: {
    kind: "specification",
    structure: {
      context: "Change is the Difference itself, not the Transformation joining the States",
      nodes: [
        n("t", "Transformation T\nunder Direction d"),
        n("s0", "input State s₀"),
        n("s1", "output State s₁"),
        n("ch", "Change:\nDifference (s₀, s₁)"),
        n("u", "State u\nnot joined to s₁"),
      ],
      edges: [
        e("t", "s0", "input", "role"),
        e("t", "s1", "output", "role"),
        e("ch", "s0", "compared item 1", "role"),
        e("ch", "s1", "compared item 2", "role"),
        e("s0", "s1", "differ (a position\ndifference suffices)", "comparison"),
        e("u", "s1", "differ, but unjoined:\nno Change", "comparison"),
      ],
    },
    title: "Difference between joined States",
    ports: [
      { label: "input State s₀", term: T("State") },
      { label: "output State s₁", term: T("State") },
      { label: "Transformation joining s₀ to s₁", term: T("Transformation") },
    ],
    conditions: [
      "One Transformation joins input State s₀ to output State s₁.",
      "The Change is the Difference between s₀ and s₁.",
    ],
    reading:
      "Change is the Difference between the two States that a Transformation joins. It is the Difference, not the Transformation that joins the States.",
    note:
      "A Difference between unjoined States is not a Change. Since States are indexed by position, a Change does not require their Configurations to differ.",
  },

  [T("CausalContribution")]: {
    kind: "relational",
    title: "A contrast between two matched paths",
    ports: [
      { label: "comparison Causal path P₁ (nonempty)", term: T("CausalPath") },
      { label: "comparison Causal path P₂ (nonempty)", term: T("CausalPath") },
      { label: "Direction shared by P₁ and P₂", term: T("Direction") },
      { label: "named upstream Difference between inputs", term: T("Difference") },
      { label: "named downstream Change at the endpoints", term: T("Change") },
      { label: "account matching every other stated input" },
    ],
    conditions: [
      "P₁ and P₂ are both nonempty Causal paths and share one Direction.",
      "Their inputs match at every stated position except the named upstream Difference.",
      "Their endpoint States exhibit the named downstream Change.",
      "Both path witnesses and the matched-input account are required.",
    ],
    reading:
      "Causal Contribution compares two Causal paths that match except at one named upstream Difference. When their endpoints show the named Change, that Difference contributes to the Change within this comparison.",
    note:
      "The contribution holds only within the stated comparison. Occurrence in one path, temporal precedence or correlation is insufficient.",
  },

  [T("Invariant")]: {
    kind: "specification",
    structure: {
      context: "Meaningful only relative to the named item and the named Transformations",
      nodes: [
        n("inv", "Invariant I"),
        n("x", "named item x: part,\nRelation or\nConfiguration"),
        n("ts", "named set\n{T₁, T₂}"),
        n("t1", "Transformation T₁"),
        n("t2", "Transformation T₂"),
        n("t3", "unnamed\nTransformation T₃"),
      ],
      edges: [
        e("inv", "x", "preserved item", "role"),
        e("inv", "ts", "named\nTransformations", "role"),
        e("t1", "ts", "∈", "membership"),
        e("t2", "ts", "∈", "membership"),
        e("t1", "x", "preserves x", "constraint"),
        e("t2", "x", "preserves x", "constraint"),
        e("t3", "x", "outside I:\nnothing implied", "constraint"),
      ],
    },
    title: "Preserved under named Transformations",
    ports: [
      { label: "named part, Relation or Configuration preserved" },
      { label: "named set of Transformations", term: T("Transformation") },
    ],
    conditions: [
      "What is preserved is named: a part, a Relation or a Configuration.",
      "The Transformations across which it is preserved are named.",
      "Under each named Transformation, the named item is preserved.",
    ],
    reading:
      "An Invariant is something named as preserved under a named set of Transformations. It is only meaningful when both are named.",
    note:
      "Invariance holds relative to the named Transformations only. It implies nothing about other Transformations and is not a timeless property.",
  },

  [T("Persistence")]: {
    kind: "specification",
    structure: {
      context: "Ordered sequence of States · witness required for a persistent Configuration",
      nodes: [
        n("p", "Persistence of I"),
        n("inv", "named Invariant I"),
        n("seq", "ordered sequence\n(s₀, s₁, …)"),
        n("s0", "State s₀ with\nConfiguration K₀"),
        n("s1", "State s₁ with\nConfiguration K₁"),
        n("w", "Persistence witness\n(Configuration case)"),
      ],
      edges: [
        e("p", "inv", "preserved Invariant", "role"),
        e("p", "seq", "across", "role"),
        e("s0", "seq", "position 0", "membership"),
        e("s1", "seq", "position 1", "membership"),
        e("inv", "s0", "preserved at s₀", "constraint"),
        e("inv", "s1", "preserved at s₁", "constraint"),
        e("w", "p", "witnesses\nreidentification", "role"),
        e("s0", "s1", "K₀, K₁ may differ\nwhere I is silent", "comparison"),
      ],
    },
    title: "An Invariant preserved across States",
    ports: [
      { label: "named Invariant", term: T("Invariant") },
      { label: "ordered sequence of States s₀ … sₙ", term: T("State") },
      { label: "Persistence witness (for Configurations)" },
    ],
    conditions: [
      "The named Invariant is preserved at each State of the ordered sequence.",
      "A persistent Configuration is one Configuration at each State, joined by the Invariant and a Persistence witness.",
      "Those Configurations need not have Identity; they may differ wherever the Invariant does not fix them.",
    ],
    reading:
      "Persistence is the preservation of a named Invariant across an ordered sequence of States. What persists is what the Invariant fixes, not necessarily everything else.",
    note:
      "Persistence is not Identity of Configurations across States. Reidentification across States needs the named Invariant and a Persistence witness, not resemblance.",
  },

  [T("Constraint")]: {
    kind: "specification",
    structure: {
      context: "One definition covers bounding action and producing legibility",
      nodes: [
        n("c", "Constraint C:\na Relation"),
        n("per", "Persistence of C\nacross States"),
        n("inv", "named Invariant\nfixing C"),
        n("tx", "excluded\nTransformation Tₓ"),
        n("tp", "permitted\nTransformation Tₚ"),
      ],
      edges: [
        e("per", "c", "persisting Relation", "role"),
        e("per", "inv", "preserved Invariant", "role"),
        e("c", "tx", "excludes\n(at least one)", "constraint"),
        e("c", "tp", "permits\n(at least one)", "constraint"),
        e("tx", "tp", "different\nTransformations", "comparison"),
      ],
    },
    title: "Excluding some Transformations, permitting others",
    ports: [
      { label: "persistent Relation", term: T("Relation") },
      { label: "excluded Transformations (at least one)", term: T("Transformation") },
      { label: "permitted Transformations (at least one)", term: T("Transformation") },
    ],
    conditions: [
      "The Relation is persistent.",
      "It excludes some Transformations.",
      "It permits others.",
    ],
    reading:
      "A Constraint is a persistent Relation that excludes some Transformations while permitting others. A prohibition, a prism and a sensory organ all fit this one definition.",
    note:
      "Bounding action and producing legibility are two uses of one definition, not two kinds of Constraint. A Relation that excludes nothing, or permits nothing, is not a Constraint.",
  },

  [T("Entity")]: {
    kind: "specification",
    structure: {
      context: "Claim names the ordered States and witness · adds no sufficient identity condition",
      nodes: [
        n("e0", "Entity E\nreidentified at s₀"),
        n("e1", "Entity E\nreidentified at s₁"),
        n("s0", "State s₀:\nConfiguration K₀"),
        n("s1", "State s₁:\nConfiguration K₁"),
        n("inv", "named Invariant I:\nidentity criterion"),
        n("w", "Persistence\nwitness W"),
        n("u", "State u\nalso satisfying I"),
      ],
      edges: [
        e("e0", "s0", "at State", "role"),
        e("e1", "s1", "at State", "role"),
        e("e0", "e1", "one Entity:\nIdentity asserted", "identity"),
        e("s0", "s1", "need not be\nidentical", "comparison"),
        e("e0", "inv", "identity criterion", "role"),
        e("w", "inv", "realizes criterion", "role"),
        e("w", "s0", "witness from", "role"),
        e("w", "s1", "witness to", "role"),
        e("u", "inv", "satisfies I only:\nnot in E's history", "constraint"),
      ],
    },
    title: "A Presence reidentified across States",
    ports: [
      { label: "reidentified Presence", term: T("Presence") },
      { label: "ordered States, each with its own Configuration", term: T("State") },
      { label: "named Invariant as identity criterion", term: T("Invariant") },
      { label: "Persistence witness realizing that criterion" },
    ],
    conditions: [
      "The Entity claim names the ordered States and the Persistence witness that realize the identity criterion.",
      "Reidentification asserts Identity of the Entity, not a second relation of sameness.",
      "The criterion distinguishes this particular Entity, not merely a shared property.",
    ],
    reading:
      "An Entity is a Presence reidentified across ordered States through a named Invariant and Persistence witness. Its successive States need not be identical.",
    note:
      "An Entity is neither one of its Configurations nor a single Configuration that changes. Sharing an Invariant does not make two Entities identical, and satisfying it does not place a State in the Entity's history.",
  },

  [T("Boundary")]: {
    kind: "specification",
    structure: {
      context: "Members are Constraints only · no closure under combination · empty case: I must survive all",
      nodes: [
        n("b", "Boundary B\n(a Configuration)"),
        n("c1", "Constraint C₁"),
        n("c2", "Constraint C₂"),
        n("inv", "identity Invariant I"),
        n("e", "Entity E"),
        n("tp", "Transformation\npreserving I"),
        n("tx", "Transformation\ncrossing E's\ndistinction"),
      ],
      edges: [
        e("c1", "b", "member", "membership"),
        e("c2", "b", "member", "membership"),
        e("b", "inv", "indexed to", "role"),
        e("inv", "e", "Persistence\nconstitutes identity of", "role"),
        e("b", "tp", "determines:\npreserves identity", "constraint"),
        e("b", "tx", "determines:\ncrosses distinction", "constraint"),
      ],
    },
    title: "Constraints indexed to an identity Invariant",
    ports: [
      { label: "member Constraints (possibly none)", term: T("Constraint") },
      { label: "Invariant whose Persistence constitutes identity", term: T("Invariant") },
      { label: "Entity whose identity it delimits", term: T("Entity") },
      { label: "separately specified joining Relations, if any" },
    ],
    conditions: [
      "The members are Constraints, indexed to the Invariant that constitutes the Entity's identity.",
      "They determine which Transformations preserve that identity and which cross the Entity's distinction from other Presence.",
      "Combining member Constraints does not add new Constraints to the Boundary.",
      "With no Constraints, the Invariant must survive every Transformation.",
    ],
    reading:
      "A Boundary is a Configuration of Constraints tied to an Entity's identity Invariant. Those Constraints determine which Transformations preserve that identity and which cross the distinction between the Entity and other Presence.",
    note:
      "A Boundary is not necessarily a spatial edge or a skin. Having no Constraints creates the largest preservation obligation, not none.",
  },

  [T("Environment")]: {
    kind: "specification",
    structure: {
      context: "Environment of one Entity E · not Reality minus E",
      nodes: [
        n("e", "Entity E"),
        n("b", "Boundary B of E"),
        n("id", "identity of E\ndelimited by B"),
        n("r", "Relation R\nbetween E and p"),
        n("p", "Presence p"),
        n("env", "Environment of E"),
        n("q", "Presence q\nunrelated to E"),
      ],
      edges: [
        e("b", "id", "delimits", "role"),
        e("id", "e", "identity of", "role"),
        e("r", "e", "participant", "role"),
        e("r", "p", "participant", "role"),
        e("p", "id", "not included in", "constraint"),
        e("p", "env", "∈", "membership"),
        e("q", "env", "excluded:\nnot related to E", "constraint"),
      ],
    },
    title: "Related to an Entity, outside its identity",
    ports: [
      { label: "Entity", term: T("Entity") },
      { label: "Boundary delimiting that Entity's identity", term: T("Boundary") },
      { label: "Presence related to the Entity", term: T("Presence") },
    ],
    conditions: [
      "The Presence is related to the Entity.",
      "It is not included in the identity delimited by the Entity's Boundary.",
    ],
    reading:
      "An Entity's Environment is the Presence related to it but outside the identity its Boundary delimits. Each Environment belongs to a particular Entity.",
    note:
      "Environment is not Reality minus the Entity: unrelated Presence is excluded. Entity alone does not imply anything biological, conscious, legal or morally considerable.",
  },

  [T("Representation")]: {
    kind: "specification",
    structure: {
      context: "Claim names the Denotation and its target · no Interpretation or use implied",
      nodes: [
        n("d", "named Denotation D"),
        n("r", "Representation r"),
        n("t", "named target t"),
        n("x", "Presence x in no\nexpression position"),
      ],
      edges: [
        e("d", "r", "expression position", "role"),
        e("d", "t", "target position", "role"),
        e("r", "t", "denotes under D\n(r is not t)", "denotation"),
        e("x", "r", "x is no Representation\nwithout such a position", "comparison"),
      ],
    },
    title: "What occupies the expression position",
    ports: [
      { label: "named Denotation", term: T("Denotation") },
      { label: "Presence in its expression position", term: T("Presence") },
      { label: "named target of that Denotation" },
    ],
    conditions: [
      "The Representation is the Presence in the expression position of a Denotation.",
      "The claim names both that Denotation and its target.",
      "The Representation is not identical with its target.",
    ],
    reading:
      "Something is a Representation by occupying the expression position in a named Denotation that has a named target.",
    note:
      "Denotation alone establishes no Interpretation, causal use, institutional use or fidelity to the target.",
  },

  [T("Scope")]: {
    kind: "specification",
    structure: {
      context: "Member kinds shown are examples; a Scope need not contain each kind",
      nodes: [
        n("x", "Representation or\nConstraint X"),
        n("s", "Scope of X"),
        n("p", "Presence p"),
        n("r", "Relation r"),
        n("st", "State s"),
        n("t", "Transformation t"),
      ],
      edges: [
        e("x", "s", "applies to\nexactly these", "role"),
        e("p", "s", "∈", "membership"),
        e("r", "s", "∈", "membership"),
        e("st", "s", "∈", "membership"),
        e("t", "s", "∈", "membership"),
      ],
    },
    title: "Where a Representation or Constraint applies",
    ports: [
      { label: "applying Representation or Constraint" },
      { label: "Presences, Relations, States or Transformations applied to" },
    ],
    conditions: [
      "The Scope belongs to a particular Representation or Constraint.",
      "Its members are what that Representation or Constraint applies to.",
    ],
    reading:
      "A Scope is the set of Presences, Relations, States or Transformations to which a Representation or Constraint applies.",
    note:
      "A Scope bounds where something applies. It does not show that the Representation is accurate or that the Constraint is satisfied.",
  },

  [T("Specification")]: {
    kind: "specification",
    structure: {
      context: "A constructive procedure is required · bivalence alone does not decide",
      nodes: [
        n("r", "Specification r\n(a Representation)"),
        n("s", "identified Scope S"),
        n("pi", "constructive decision\nprocedure π"),
        n("x", "candidate x"),
        n("phi", "bare predicate φ\n(no procedure)"),
      ],
      edges: [
        e("r", "s", "identifies", "role"),
        e("r", "pi", "supplies", "role"),
        e("pi", "x", "applied to", "role"),
        e("x", "s", "membership or\nconformity decided by π", "membership"),
        e("phi", "r", "φ with bivalence only\nis not a Specification", "comparison"),
      ],
    },
    title: "A Scope with a constructive decision procedure",
    ports: [
      { label: "Representation", term: T("Representation") },
      { label: "identified Scope", term: T("Scope") },
      { label: "constructive procedure deciding membership or conformity" },
    ],
    conditions: [
      "The Representation identifies a Scope.",
      "It supplies a constructive decision procedure for membership or conformity within that Scope.",
    ],
    reading:
      "A Specification is a Representation that identifies a Scope and says constructively how to decide membership or conformity within it.",
    note:
      "Classical bivalence does not turn an arbitrary predicate into a Specification. Without the decision procedure, the description is only a Representation.",
  },

  [T("Rule")]: {
    kind: "specification",
    structure: {
      context: "Inputs map to a set of outputs · a Rule is not enforcement or recognition",
      nodes: [
        n("r", "Rule ρ\n(a Specification)"),
        n("tg", "specified Constraint\nor Transformation"),
        n("ci", "conforming inputs"),
        n("i", "conforming input i"),
        n("o", "output set O(i)"),
        n("o1", "output o₁"),
        n("o2", "output o₂"),
      ],
      edges: [
        e("r", "tg", "specifies", "role"),
        e("r", "ci", "identifies as Scope", "role"),
        e("i", "ci", "∈", "membership"),
        e("i", "o", "mapped by ρ to", "role"),
        e("o1", "o", "∈", "membership"),
        e("o2", "o", "∈", "membership"),
      ],
    },
    title: "Specifying conforming inputs and outputs",
    ports: [
      { label: "Specification", term: T("Specification") },
      { label: "specified Constraint or Transformation" },
      { label: "conforming inputs" },
      { label: "set of outputs for those inputs" },
    ],
    conditions: [
      "The Rule is a Specification of a Constraint or a Transformation.",
      "It maps conforming inputs to a set of outputs.",
    ],
    reading:
      "A Rule specifies a Constraint or Transformation by saying which inputs conform and to which set of outputs they map.",
    note:
      "Inputs map to a set of outputs, not necessarily one output. A Rule is a Specification and is not, by itself, enforcement or institutional recognition.",
  },

  [T("Sign")]: {
    kind: "specification",
    structure: {
      context: "Both a Denotation and a Causal path from the target are required",
      nodes: [
        n("t", "target: Presence,\nRelation or Change\n(e.g. a step taken)"),
        n("p", "Causal path P"),
        n("s", "State s where P ends"),
        n("g", "Sign g\n(e.g. a footprint)"),
        n("a", "assigned label\nwith no such path"),
      ],
      edges: [
        e("g", "t", "denotes\n(as Representation)", "denotation"),
        e("p", "t", "joins from target", "role"),
        e("p", "s", "ends in", "role"),
        e("g", "s", "contained in", "membership"),
        e("a", "t", "denotes only:\nnot a trace", "denotation"),
      ],
    },
    title: "A trace joined to its target by a Causal path",
    ports: [
      { label: "target Presence, Relation or Change" },
      { label: "Causal path from the target", term: T("CausalPath") },
      { label: "State containing the Sign, where the path ends", term: T("State") },
    ],
    conditions: [
      "The Sign is a Representation of its target.",
      "A Causal path joins the target to the Sign.",
      "That path ends in the State that contains the Sign.",
    ],
    reading:
      "A Sign is a Representation joined to its target by a Causal path ending in the State that contains the Sign, as with a footprint or a smoke trace.",
    note:
      "An assigned Denotation without that Causal path is not a trace, and the Causal path alone is not a Denotation. Both are required.",
  },

  [T("Symbol")]: {
    kind: "specification",
    structure: {
      context: "No Causal path from the target is required · co-occurrence without a Rule is not enough",
      nodes: [
        n("d", "Denotation D"),
        n("sym", "Symbol σ\n(a Representation)"),
        n("t", "target t"),
        n("per", "Persistence of D"),
        n("r1", "repeated State or\nTransformation 1"),
        n("r2", "repeated State or\nTransformation 2"),
        n("rule", "Rule ρ"),
      ],
      edges: [
        e("d", "sym", "expression position", "role"),
        e("d", "t", "target position", "role"),
        e("per", "d", "preserved Denotation", "role"),
        e("per", "r1", "holds across", "role"),
        e("per", "r2", "holds across", "role"),
        e("rule", "per", "persistence\nholds under ρ", "constraint"),
      ],
    },
    title: "Denotation persisting under a Rule",
    ports: [
      { label: "Representation", term: T("Representation") },
      { label: "its Denotation", term: T("Denotation") },
      { label: "repeated States or Transformations" },
      { label: "Rule under which the Denotation persists", term: T("Rule") },
    ],
    conditions: [
      "The Representation's Denotation persists across repeated States or Transformations.",
      "That Persistence holds under a Rule.",
    ],
    reading:
      "A Symbol is a Representation whose Denotation persists across repeated States or Transformations under a Rule.",
    note:
      "No Causal path from the target is required, which is what separates a Symbol from a Sign. Repeated co-occurrence without a Rule does not make a Symbol.",
  },

  [T("Language")]: {
    kind: "specification",
    structure: {
      context: "Persistent system · coordination must be possible, not necessarily achieved",
      nodes: [
        n("l", "Language Λ\n(persistent system)"),
        n("s1", "Symbol σ₁"),
        n("s2", "Symbol σ₂"),
        n("r", "Rule ρ"),
        n("c", "possible coordinated\nchange of State"),
      ],
      edges: [
        e("s1", "l", "∈ Symbols", "membership"),
        e("s2", "l", "∈ Symbols", "membership"),
        e("r", "l", "∈ Rules", "membership"),
        e("r", "s1", "transforms: input", "role"),
        e("r", "s2", "transforms: output", "role"),
        e("l", "c", "can coordinate\n(possibility only)", "role"),
      ],
    },
    title: "A persistent system of Symbols and Rules",
    ports: [
      { label: "Symbols", term: T("Symbol") },
      { label: "Rules for transforming those Symbols", term: T("Rule") },
      { label: "changes of State it can coordinate" },
    ],
    conditions: [
      "The system of Symbols and Rules is persistent.",
      "Its Rules transform its Symbols.",
      "Changes of State can be coordinated through it.",
    ],
    reading:
      "A Language is a persistent system of Symbols together with Rules for transforming them, through which changes of State can be coordinated.",
    note:
      "The definition requires that coordination be possible, not that it succeeds. Symbols without Rules for transforming them, or Rules without Symbols, are not a Language.",
  },

  [T("Map")]: {
    kind: "specification",
    structure: {
      context: "Selects from Reality, never all of it · omission and distortion are definitional",
      nodes: [
        n("d", "Denotation D"),
        n("m", "Map M\n(a Representation)"),
        n("sel", "selected portion\nof Reality"),
        n("u", "organizing use:\nnavigation, prediction\nor governance"),
        n("od", "omissions and\ndistortions of M"),
      ],
      edges: [
        e("d", "m", "expression position", "role"),
        e("d", "sel", "target position", "role"),
        e("m", "sel", "selects", "denotation"),
        e("m", "u", "organized for\n(one or more)", "role"),
        e("m", "od", "belong to\nwhat M is", "role"),
      ],
    },
    title: "A Representation organized for use",
    ports: [
      { label: "Representation", term: T("Representation") },
      { label: "organizing use: navigation, prediction or governance" },
      { label: "what it selects from Reality", term: T("Reality") },
    ],
    conditions: [
      "The Representation is organized for navigation, prediction or governance.",
      "It selects from Reality.",
      "Omissions and distortions belong to what a Map is.",
    ],
    reading:
      "A Map is a Representation organized for navigation, prediction or governance. It selects from Reality, so omissions and distortions are part of what it is.",
    note:
      "Omission and distortion are part of the definition, not only failures. A Map is never Reality or a complete copy of it.",
  },

  [T("Reference")]: {
    kind: "specification",
    structure: {
      context: "Pair for use as a comparison surface · enumerated distortions remain",
      nodes: [
        n("ref", "Reference\n(pair: M, S)"),
        n("m", "Map M"),
        n("s", "Specification S"),
        n("sc", "Scope of M"),
        n("cs", "Constraints of M"),
        n("ds", "enumerated\ndistortions of M"),
        n("x", "compared item x"),
      ],
      edges: [
        e("ref", "m", "Map component", "role"),
        e("ref", "s", "Specification\ncomponent", "role"),
        e("s", "sc", "specifies", "role"),
        e("s", "cs", "specifies", "role"),
        e("s", "ds", "enumerates", "role"),
        e("sc", "m", "Scope of", "role"),
        e("x", "ref", "compared against\n(intended use)", "comparison"),
      ],
    },
    title: "A Map specified as a comparison surface",
    ports: [
      { label: "Map", term: T("Map") },
      { label: "Specification of the Map's Scope", term: T("Specification") },
      { label: "specified Constraints", term: T("Constraint") },
      { label: "enumerated distortions" },
      { label: "use as a comparison surface" },
    ],
    conditions: [
      "The Map is paired with a Specification.",
      "That Specification covers its Scope, Constraints and enumerated distortions.",
      "The pair is for use as a comparison surface.",
    ],
    reading:
      "A Reference is a Map whose Scope, Constraints and distortions have been specified so that other things can be compared against it.",
    note:
      "Enumerating distortions does not remove them. A Reference is not Reality and does not establish Truth.",
  },

  [T("Sense")]: {
    kind: "specification",
    structure: {
      context: "One Entity E · the Sense is the Constraint subset, not the whole path",
      nodes: [
        n("e", "Entity E"),
        n("b", "Boundary B of E"),
        n("sn", "Sense Σ ⊆\nConstraints of B"),
        n("c1", "Constraint C₁"),
        n("c2", "Constraint C₂\n(not in Σ)"),
        n("dx", "Difference in\nE's Environment"),
        n("di", "Difference\ninside E"),
      ],
      edges: [
        e("b", "e", "Boundary of", "role"),
        e("c1", "b", "member", "membership"),
        e("c2", "b", "member", "membership"),
        e("c1", "sn", "∈", "membership"),
        e("dx", "c1", "enters Causal path P\nthrough", "causal"),
        e("c1", "di", "P ends in", "causal"),
        e("di", "e", "inside", "role"),
      ],
    },
    title: "Where environmental Differences enter",
    ports: [
      { label: "Differences in the Entity's Environment", term: T("Environment") },
      { label: "Sense: subset of the Entity's Boundary Constraints", term: T("Constraint") },
      { label: "Causal path entered through that subset", term: T("CausalPath") },
      { label: "Differences inside that same Entity", term: T("Difference") },
    ],
    conditions: [
      "The Sense is a subset of the Constraints in one Entity's Boundary.",
      "Differences in that Entity's Environment enter a Causal path through it.",
      "The Causal path ends in Differences inside the same Entity.",
    ],
    reading:
      "Environmental Differences enter a Causal path through some of the Entity's Boundary Constraints, and that path ends in Differences inside the Entity. The Sense is that subset of Constraints, not the whole sequence.",
    note:
      "The causal edges show the path stated in the definition. The Sense is the subset of Boundary Constraints only, not the path. It does not imply awareness or an accurate Representation.",
  },

  [T("Perception")]: {
    kind: "specification",
    structure: {
      context: "Perception is a State · produced through Sense · accuracy and awareness not implied",
      nodes: [
        n("e", "Entity E"),
        n("sn", "Sense Σ of E"),
        n("dx", "Difference in\nE's Environment"),
        n("p", "internal State p of E:\nthe Perception"),
      ],
      edges: [
        e("sn", "e", "Sense of", "role"),
        e("dx", "sn", "enters through", "causal"),
        e("sn", "p", "produces", "causal"),
        e("p", "e", "internal State of", "role"),
      ],
    },
    title: "An internal State produced through Sense",
    ports: [
      { label: "Differences in the Environment", term: T("Environment") },
      { label: "Sense of the Entity", term: T("Sense") },
      { label: "internal State of that Entity: the Perception", term: T("State") },
    ],
    conditions: [
      "The Perception is a State internal to the Entity.",
      "That State is produced through the Entity's Sense.",
    ],
    reading:
      "A Perception is an internal State of an Entity produced through one of its Senses, at the end of the Causal path that Sense opens from the Environment.",
    note:
      "Perception is defined as a State. Being produced through Sense does not make it accurate, conscious, reported or a Representation of its source.",
  },

  [T("Record")]: {
    kind: "specification",
    structure: {
      context: "No Causal path from the target required · neither accuracy nor Evidence status implied",
      nodes: [
        n("d", "Denotation D"),
        n("r", "Record r\n(a Representation)"),
        n("t", "earlier State,\nRelation or Change t"),
        n("per", "Persistence of r"),
        n("s", "later State s\ncontaining r"),
      ],
      edges: [
        e("d", "r", "expression position", "role"),
        e("d", "t", "target position", "role"),
        e("per", "r", "persisting\nRepresentation", "role"),
        e("r", "s", "contained in", "membership"),
        e("t", "s", "t earlier than s", "comparison"),
      ],
    },
    title: "A persistent Representation of something earlier",
    ports: [
      { label: "Representation", term: T("Representation") },
      { label: "earlier State, Relation or Change represented" },
      { label: "Persistence of the Representation", term: T("Persistence") },
    ],
    conditions: [
      "The Representation is persistent.",
      "Its target is an earlier State, Relation or Change.",
    ],
    reading:
      "A Record is a persistent Representation of an earlier State, Relation or Change.",
    note:
      "The definition does not require a Causal path from the target, as a Sign does. Being persistent and earlier does not make a Record accurate or admitted as Evidence.",
  },

  [T("Observation")]: {
    kind: "specification",
    structure: {
      context: "Specifying the path does not make the Record true or independent",
      nodes: [
        n("o", "Observation o\n(a Record)"),
        n("pr", "production of o"),
        n("s", "Specification S"),
        n("p", "Causal path P"),
        n("env", "Environment of E"),
        n("sn", "Sense Σ of E"),
      ],
      edges: [
        e("pr", "o", "produces", "role"),
        e("s", "pr", "included in", "membership"),
        e("s", "p", "specifies", "role"),
        e("p", "env", "runs from", "role"),
        e("p", "sn", "runs through", "role"),
      ],
    },
    title: "A Record with a specified sensing path",
    ports: [
      { label: "Record", term: T("Record") },
      { label: "Specification included in its production", term: T("Specification") },
      { label: "specified Causal path", term: T("CausalPath") },
      { label: "Environment where the path starts", term: T("Environment") },
      { label: "Sense the path runs through", term: T("Sense") },
    ],
    conditions: [
      "The Observation is a Record.",
      "Its production includes a Specification of a Causal path.",
      "The specified path runs from an Environment through a Sense.",
    ],
    reading:
      "An Observation is a Record whose production includes a Specification of how a Causal path ran from an Environment through a Sense.",
    note:
      "An Observation is not Reality and does not become independent just because it was recorded. Specifying the path does not make the Record true.",
  },

  [T("Memory")]: {
    kind: "specification",
    structure: {
      context: "Capacity to condition, not actual conditioning · one and the same Entity E",
      nodes: [
        n("e", "Entity E"),
        n("m", "internal Record m\nof E"),
        n("per", "Persistence of m"),
        n("s", "State s of E\ncontaining m"),
        n("s2", "later State s′ of E"),
      ],
      edges: [
        e("m", "e", "internal to", "role"),
        e("m", "s", "contained in", "membership"),
        e("per", "m", "persisting Record", "role"),
        e("per", "s2", "can condition\n(possibility only)", "causal"),
        e("s", "e", "State of", "role"),
        e("s2", "e", "State of\n(same Entity)", "role"),
        e("s", "s2", "s′ later than s", "comparison"),
      ],
    },
    title: "An internal Record that can condition later States",
    ports: [
      { label: "Entity", term: T("Entity") },
      { label: "internal Record of that Entity", term: T("Record") },
      { label: "Persistence of that Record", term: T("Persistence") },
      { label: "later State of the same Entity", term: T("State") },
    ],
    conditions: [
      "The Record is internal to one Entity.",
      "Its Persistence can condition a later State of that same Entity.",
    ],
    reading:
      "A Memory is an internal Record of an Entity whose Persistence can condition a later State of the same Entity.",
    note:
      "Memory requires the capacity to condition a later State, not that it actually does. It need not be accurate, and the conditioned State must belong to the same Entity.",
  },

  [T("Model")]: {
    kind: "specification",
    structure: {
      context: "Organization is specified structure, not membership · stated Constraints",
      nodes: [
        n("m", "Model M\n(a Configuration)"),
        n("r", "Representation r\n(member)"),
        n("t", "Transformation t\n(member)"),
        n("j", "named join J(r, t)"),
        n("pm", "Perception and\nMemory"),
        n("ls", "later States"),
        n("cs", "stated Constraints\nof M"),
      ],
      edges: [
        e("r", "m", "∈", "membership"),
        e("t", "m", "∈", "membership"),
        e("m", "j", "specified structure", "role"),
        e("j", "r", "position 1", "role"),
        e("j", "t", "position 2", "role"),
        e("m", "pm", "relates from", "role"),
        e("m", "ls", "relates to", "role"),
        e("cs", "m", "relating holds\nunder these", "constraint"),
      ],
    },
    title: "An organized Configuration relating inputs to later States",
    ports: [
      { label: "member Representations", term: T("Representation") },
      { label: "member Transformations", term: T("Transformation") },
      { label: "named Relation joining one of each" },
      { label: "Perception and Memory it relates" },
      { label: "later States under its stated Constraints", term: T("State") },
    ],
    conditions: [
      "The Model is a Configuration whose members are Representations and Transformations.",
      "Its specified structure names at least one Relation joining a member Representation to a member Transformation.",
      "It relates Perception and Memory to later States under its stated Constraints.",
    ],
    reading:
      "A Model is a Configuration of Representations and Transformations, organized by at least one named join between them. It relates Perception and Memory to later States under stated Constraints.",
    note:
      "Organization means specified structure, not membership. A list of Representations and Transformations without a named join is not a Model.",
  },

  [T("Action")]: {
    kind: "specification",
    structure: {
      context: "No intention, success, Agent or Consequence implied",
      nodes: [
        n("e", "Entity E"),
        n("b", "Boundary B of E"),
        n("s", "internal State s\nof E"),
        n("p", "Causal path P"),
        n("a", "Transformation T\nacross B: the Action"),
      ],
      edges: [
        e("s", "e", "internal to", "role"),
        e("b", "e", "Boundary of", "role"),
        e("p", "s", "begins with", "role"),
        e("a", "p", "step of", "membership"),
        e("a", "b", "crosses", "role"),
        e("s", "a", "earlier steps of P\n(possibly none)", "causal"),
      ],
    },
    title: "A Causal path out across the Boundary",
    ports: [
      { label: "internal State of the Entity: start of the path", term: T("State") },
      { label: "earlier steps of the same Causal path (possibly none)", term: T("CausalPath") },
      { label: "Transformation crossing its Boundary: the Action", term: T("Transformation") },
    ],
    conditions: [
      "The Action is a Transformation across the Entity's Boundary.",
      "It belongs to a Causal path.",
      "That Causal path begins with an internal State of the same Entity.",
    ],
    reading:
      "An Action is the Transformation that crosses an Entity's Boundary as part of a Causal path that begins inside that Entity, in one of its internal States.",
    note:
      "The earlier steps may be none: the crossing Transformation can itself start from the internal State. Action does not imply intention, success, an Agent or any Consequence.",
  },
};
