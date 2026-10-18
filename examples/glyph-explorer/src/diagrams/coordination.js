// Hand-reviewed, nonbinding String-diagram content for terms 41–80
// (Consequence through Shadow system). Canonical semantics live in
// ontology/ontology.md; these entries only illustrate them.
//
// kind "specification": structure.nodes are particular participants or
//   relationship occurrences in one schematic instance of the definition;
//   a shared node id means the same participant. structure.edges carry the
//   labelled definition role. Edge order marks the labelled relationship,
//   not automatic causality or implication; only kind "causal" asserts a
//   causal (or explicitly "can"-qualified possible causal) link. Identity
//   and comparison edges are unordered. structure.context names the
//   governing indices. The diagram is a qualified schematic: card.conditions
//   remain the obligations, and nothing drawn asserts sufficiency.
// ports remain as term-navigation inventory.

const coordination = {
  "organon:Consequence": {
    kind: "specification",
    title: "A Change at the end of an Action's path",
    structure: {
      context: "One Causal path p under one Direction d; a and tₙ coincide if p has one step",
      nodes: [
        { id: "a", label: "Action a\n(first step of p)" },
        { id: "p", label: "Causal path p\nunder Direction d" },
        { id: "tn", label: "last Transformation tₙ" },
        { id: "sx", label: "input State of tₙ" },
        { id: "sy", label: "end State of p" },
        { id: "c", label: "Change c\n(the Consequence)" },
      ],
      edges: [
        { from: "a", to: "p", label: "begins", kind: "membership" },
        { from: "tn", to: "p", label: "ends", kind: "membership" },
        { from: "a", to: "tn", label: "successive steps via\nFeeds (if >1 step)", kind: "causal" },
        { from: "tn", to: "sx", label: "input", kind: "role" },
        { from: "tn", to: "sy", label: "output", kind: "role" },
        { from: "sx", to: "sy", label: "Difference", kind: "comparison" },
        { from: "c", to: "sx", label: "Difference from", kind: "role" },
        { from: "c", to: "sy", label: "Difference to", kind: "role" },
      ],
    },
    ports: [
      { label: "Action (path begins here)", term: "organon:Action" },
      { label: "Causal path under one Direction", term: "organon:CausalPath" },
      { label: "Change at the path's end", term: "organon:Change" },
    ],
    conditions: [
      "The Causal path begins with an Action, not with any arbitrary State.",
      "The Change is at the end of that same Causal path.",
      "Each step's output Feeds the next step's input under one shared Direction.",
    ],
    reading:
      "An Action starts a Causal path, and the Change at the end of that path is the Consequence. The stages are ordered by the path's Direction.",
    note:
      "Later occurrence or correlation with an Action is not enough; the Change must close a Causal path that begins with that Action. Being a Consequence implies nothing about intent, benefit, or responsibility.",
  },

  "organon:Interpretation": {
    kind: "specification",
    title: "From Perception, Memory, or Model to a choice among Actions",
    structure: {
      context: "One Entity E; the input is any one of its Perception, Memory, or Model",
      nodes: [
        { id: "e", label: "Entity E" },
        { id: "m", label: "Perception, Memory,\nor Model m of E" },
        { id: "i", label: "Interpretation i\n(Transformation)" },
        { id: "sin", label: "input State\ncontaining m" },
        { id: "sout", label: "output State" },
        { id: "dist", label: "distinction among\navailable Actions" },
        { id: "acts", label: "Actions available\nto E: a₁, a₂, …" },
      ],
      edges: [
        { from: "m", to: "e", label: "belongs to", kind: "role" },
        { from: "m", to: "sin", label: "part of", kind: "membership" },
        { from: "i", to: "sin", label: "input", kind: "role" },
        { from: "i", to: "sout", label: "output (under a\nDirection)", kind: "role" },
        { from: "dist", to: "sout", label: "carried by", kind: "membership" },
        { from: "dist", to: "acts", label: "distinguishes among", kind: "role" },
        { from: "acts", to: "e", label: "available to", kind: "role" },
      ],
    },
    ports: [
      { label: "Perception, Memory, or Model of the Entity", term: "organon:Perception" },
      { label: "Interpretation (Transformation)", term: "organon:Transformation" },
      { label: "Distinction among available Actions", term: "organon:Action" },
    ],
    conditions: [
      "The input is that same Entity's Perception, Memory, or Model.",
      "The output is a distinction among Actions available to that Entity.",
      "It is a Transformation, so it maps an input State to an output State under a Direction.",
    ],
    reading:
      "Interpretation transforms what an Entity perceives, remembers, or models into a distinction among the Actions available to it.",
    note:
      "Interpretation does not have to produce an Action, and it implies nothing about accuracy, Truth, or consciousness. The input box can be any one of Perception, Memory, or Model; all three are not required.",
  },

  "organon:Agent": {
    kind: "specification",
    title: "An Entity whose Interpretation conditions its Action",
    structure: {
      context: "One Entity E; its Interpretation makes a difference to which Action occurs",
      nodes: [
        { id: "e", label: "Entity E\n(the Agent)" },
        { id: "i", label: "Interpretation i\nof E" },
        { id: "which", label: "which Action\noccurs" },
        { id: "a1", label: "candidate Action a₁\nof E" },
        { id: "a2", label: "candidate Action a₂\nof E" },
      ],
      edges: [
        { from: "i", to: "e", label: "belongs to", kind: "role" },
        { from: "i", to: "which", label: "conditions", kind: "role" },
        { from: "a1", to: "which", label: "candidate", kind: "membership" },
        { from: "a2", to: "which", label: "candidate", kind: "membership" },
        { from: "a1", to: "a2", label: "distinct", kind: "comparison" },
        { from: "a1", to: "e", label: "Action of", kind: "role" },
        { from: "a2", to: "e", label: "Action of", kind: "role" },
      ],
    },
    ports: [
      { label: "Entity", term: "organon:Entity" },
      { label: "Its Interpretation", term: "organon:Interpretation" },
      { label: "Action that occurs", term: "organon:Action" },
    ],
    conditions: [
      "The Interpretation belongs to the same Entity whose Action is conditioned.",
      "The Interpretation conditions which Action occurs, not merely that something happens.",
    ],
    reading:
      "An Entity is an Agent when its own Interpretation makes a difference to which Action occurs. The wires name the roles; they do not show a sequence.",
    note:
      "Agenthood does not require consciousness, a person, or Standing. Mechanical and institutional descriptions are projections of one Agent, not two kinds of Agent.",
  },

  "organon:Agency": {
    kind: "specification",
    title: "Interpretation joined to selection or production of Action",
    structure: {
      context: "One Agent A; projections are partial descriptions of that same Agent",
      nodes: [
        { id: "rel", label: "Agency relation" },
        { id: "ag", label: "Agent A" },
        { id: "i", label: "Interpretation i\nof A" },
        { id: "sel", label: "selection or\nproduction s by A" },
        { id: "a", label: "Action a of A" },
        { id: "mp", label: "mechanical\nprojection" },
        { id: "ip", label: "institutional\nprojection" },
      ],
      edges: [
        { from: "rel", to: "i", label: "first relatum", kind: "role" },
        { from: "rel", to: "sel", label: "second relatum", kind: "role" },
        { from: "i", to: "ag", label: "belongs to", kind: "role" },
        { from: "sel", to: "a", label: "selects or produces", kind: "role" },
        { from: "a", to: "ag", label: "Action of", kind: "role" },
        { from: "mp", to: "ag", label: "describes", kind: "denotation" },
        { from: "ip", to: "ag", label: "describes", kind: "denotation" },
      ],
    },
    ports: [
      { label: "Agent", term: "organon:Agent" },
      { label: "Agent's Interpretation", term: "organon:Interpretation" },
      { label: "Action selected or produced", term: "organon:Action" },
    ],
    conditions: [
      "The Interpretation and the Action belong to the same Agent.",
      "The Relation runs to the Agent's selection or production of that Action.",
    ],
    reading:
      "Agency is the Relation linking an Agent's Interpretation to the Action it selects or produces.",
    note:
      "A Model is not an Agent. An isolated model response does not establish the Entity, Boundary, Persistence, or Action that Agency requires. Agency has one form; mechanical and institutional accounts are projections of it.",
  },

  "organon:Tool": {
    kind: "specification",
    title: "In the Action's path, outside the Agent's identity",
    structure: {
      context: "One Agent A, one Action a; T stays outside A's identity criterion",
      nodes: [
        { id: "ag", label: "Agent A" },
        { id: "t", label: "Tool T\n(Entity)" },
        { id: "a", label: "Action a of A" },
        { id: "p", label: "Causal path p\nof a" },
        { id: "aid", label: "A's identity\n(Invariant, Boundary)" },
        { id: "tid", label: "T's own identity\ncriterion" },
      ],
      edges: [
        { from: "ag", to: "t", label: "incorporates", kind: "role" },
        { from: "t", to: "p", label: "step in", kind: "membership" },
        { from: "a", to: "p", label: "belongs to", kind: "membership" },
        { from: "a", to: "ag", label: "Action of", kind: "role" },
        { from: "ag", to: "aid", label: "reidentified by", kind: "role" },
        { from: "t", to: "aid", label: "not included in", kind: "constraint" },
        { from: "t", to: "tid", label: "reidentified by", kind: "role" },
      ],
    },
    ports: [
      { label: "Agent", term: "organon:Agent" },
      { label: "Tool Entity", term: "organon:Entity" },
      { label: "Causal path of the Action", term: "organon:CausalPath" },
      { label: "Agent's identity, which does not include the Tool" },
    ],
    conditions: [
      "The Agent incorporates the Tool into the Causal path of its Action.",
      "The Tool is not incorporated into the Agent's identity.",
      "The Tool is an Entity in its own right.",
    ],
    reading:
      "A Tool is an Entity that an Agent brings into the causal path of its Action while the Tool remains outside what makes the Agent the same Agent.",
    note:
      "Using a Tool does not make the Tool an Agent or part of the Agent. Incorporating it into the Agent's identity would mean it is no longer a Tool for that Agent.",
  },

  "organon:Capability": {
    kind: "specification",
    title: "What an Agent can produce, with a constructive witness",
    structure: {
      context: "Capability C of Agent A; membership of a needs a constructive witness w",
      nodes: [
        { id: "cap", label: "Capability C\n(Specification)" },
        { id: "ag", label: "Agent A" },
        { id: "k", label: "stated Constraints K\n(env · tech · time)" },
        { id: "proc", label: "constructive\nprocedure of C" },
        { id: "w", label: "satisfying\nConfiguration w" },
        { id: "ki", label: "named Constraint\ninterpretation" },
        { id: "path", label: "admitted Causal path\n(possible, not run)" },
        { id: "a", label: "Action a" },
      ],
      edges: [
        { from: "cap", to: "k", label: "states", kind: "role" },
        { from: "cap", to: "proc", label: "supplies", kind: "role" },
        { from: "proc", to: "w", label: "supplies witness", kind: "role" },
        { from: "w", to: "k", label: "satisfies", kind: "constraint" },
        { from: "w", to: "ki", label: "names", kind: "role" },
        { from: "k", to: "path", label: "admit, in w", kind: "constraint" },
        { from: "path", to: "ag", label: "for", kind: "role" },
        { from: "path", to: "a", label: "would produce", kind: "role" },
        { from: "a", to: "cap", label: "member only\nvia witness w", kind: "membership" },
      ],
    },
    ports: [
      { label: "Agent", term: "organon:Agent" },
      { label: "Specified Action", term: "organon:Action" },
      { label: "Environmental, technical, temporal Constraints", term: "organon:Constraint" },
      { label: "Constructive procedure (Specification)", term: "organon:Specification" },
      { label: "Satisfying Configuration witness", term: "organon:Configuration" },
      { label: "Action-producing Causal path", term: "organon:CausalPath" },
    ],
    conditions: [
      "The constructive procedure supplies at least one Configuration satisfying the stated Constraints.",
      "In that Configuration, the Constraints admit a Causal path that produces the Action for that same Agent.",
      "The witness names the Constraint interpretation under which the Action is relatively possible.",
      "The witness may exist before the Action is completed; prior exercise is not required.",
    ],
    reading:
      "An Action belongs to an Agent's Capability only when a constructive procedure exhibits a Configuration in which the interpreted Constraints admit a path from that Agent to that Action. Capability says what can occur.",
    note:
      "Capability is not permission. It supplies no Permission, Authority, desirability, or Truth, and Permission or Authority does not create Capability. Asserting a Capability without a witness is not enough.",
  },

  "organon:Interior": {
    kind: "specification",
    title: "States and Transformations specified as inside a Boundary",
    structure: {
      context: "Interior of Entity E relative to one Specification σ",
      nodes: [
        { id: "e", label: "Entity E" },
        { id: "b", label: "Boundary B of E" },
        { id: "spec", label: "Specification σ" },
        { id: "int", label: "Interior I\n(a Set)" },
        { id: "s", label: "State s of E" },
        { id: "t", label: "Transformation t\nof E" },
      ],
      edges: [
        { from: "b", to: "e", label: "delimits identity of", kind: "role" },
        { from: "spec", to: "int", label: "identifies", kind: "role" },
        { from: "s", to: "int", label: "member", kind: "membership" },
        { from: "t", to: "int", label: "member", kind: "membership" },
        { from: "s", to: "b", label: "remains within", kind: "constraint" },
        { from: "t", to: "b", label: "remains within", kind: "constraint" },
      ],
    },
    ports: [
      { label: "Entity", term: "organon:Entity" },
      { label: "Boundary", term: "organon:Boundary" },
      { label: "Identifying Specification", term: "organon:Specification" },
      { label: "Member States and Transformations", term: "organon:State" },
    ],
    conditions: [
      "Membership is fixed by a Specification, not by assertion.",
      "The States and Transformations belong to that Entity and remain within its Boundary.",
    ],
    reading:
      "An Entity's Interior is the set of its States and Transformations that a Specification identifies as staying within its Boundary.",
    note:
      "Interiority does not imply consciousness, privacy rights, or inaccessibility. A different Specification can identify a different Interior for the same Entity.",
  },

  "organon:Exposure": {
    kind: "specification",
    title: "An Interior State crossing its Boundary",
    structure: {
      context: "One Entity E; the crossed Boundary is the one defining E's Interior",
      nodes: [
        { id: "e", label: "Entity E" },
        { id: "b", label: "Boundary B of E" },
        { id: "int", label: "Interior I of E" },
        { id: "s", label: "Interior State s" },
        { id: "x", label: "Exposure x\n(Transformation)" },
        { id: "out", label: "output State\nbeyond B" },
      ],
      edges: [
        { from: "b", to: "e", label: "delimits identity of", kind: "role" },
        { from: "b", to: "int", label: "defines", kind: "role" },
        { from: "s", to: "int", label: "member", kind: "membership" },
        { from: "x", to: "s", label: "input", kind: "role" },
        { from: "x", to: "out", label: "output (under a\nDirection)", kind: "role" },
        { from: "x", to: "b", label: "crosses", kind: "role" },
      ],
    },
    ports: [
      { label: "Interior State inside the Boundary", term: "organon:State" },
      { label: "Boundary defining that Interior", term: "organon:Boundary" },
      { label: "Transformation by which the State crosses", term: "organon:Transformation" },
    ],
    conditions: [
      "The input State belongs to the Entity's Interior.",
      "The Boundary crossed is the one that defines that Interior.",
      "Exposure is a Transformation, so the crossing has a Direction.",
    ],
    reading:
      "Exposure is the Transformation through which a State from an Entity's Interior crosses the Boundary that defined it as interior.",
    note:
      "Accountability for external effects does not require total Exposure of the process that produced them. Interiority does not imply consciousness.",
  },

  "organon:Flow": {
    kind: "specification",
    title: "Repeated similar Transformations along persistent Relations",
    structure: {
      context: "One Scope S, one recurrence respect r, outputs ordered under one Direction d",
      nodes: [
        { id: "t1", label: "occurrence t₁" },
        { id: "t2", label: "occurrence t₂" },
        { id: "r", label: "recurrence\nRelation r" },
        { id: "sc", label: "Scope S" },
        { id: "y1", label: "output State y₁" },
        { id: "y2", label: "output State y₂" },
        { id: "v", label: "persisting Relation\nor Invariant v" },
      ],
      edges: [
        { from: "r", to: "t1", label: "joins", kind: "role" },
        { from: "r", to: "t2", label: "joins", kind: "role" },
        { from: "t1", to: "t2", label: "distinct", kind: "comparison" },
        { from: "t1", to: "sc", label: "within", kind: "membership" },
        { from: "t2", to: "sc", label: "within", kind: "membership" },
        { from: "t1", to: "y1", label: "output", kind: "role" },
        { from: "t2", to: "y2", label: "output", kind: "role" },
        { from: "y1", to: "y2", label: "before, under d", kind: "role" },
        { from: "v", to: "y1", label: "persists across", kind: "constraint" },
        { from: "v", to: "y2", label: "persists across", kind: "constraint" },
      ],
    },
    ports: [
      { label: "Two or more Transformation occurrences", term: "organon:Transformation" },
      { label: "Recurrence Relation (respect of repetition)", term: "organon:Relation" },
      { label: "Scope including the occurrences", term: "organon:Scope" },
      { label: "Direction ordering their outputs", term: "organon:Direction" },
      { label: "Persisting Relation or Invariant", term: "organon:Invariant" },
    ],
    conditions: [
      "At least two distinct Transformation occurrences are joined by one recurrence Relation within one Scope.",
      "Their outputs are ordered under one Direction.",
      "A named Relation or Invariant persists across those States.",
    ],
    reading:
      "A Flow is at least two similar Transformation occurrences that repeat in a named respect within one Scope. Their outputs are ordered under one Direction, and some named Relation or Invariant persists across them.",
    note:
      "The States need not be identical, and the intervals need not be periodic. No Agent, Representation, Rule, or Specification is required, and a classifier that labels the Flow does not create it.",
  },

  "organon:Interface": {
    kind: "specification",
    title: "A Boundary with explicitly represented permitted Transformations",
    structure: {
      context: "One Boundary B; its explicit Representation serves coordination",
      nodes: [
        { id: "b", label: "Boundary B" },
        { id: "perm", label: "Transformations\npermitted across B" },
        { id: "r", label: "explicit\nRepresentation ρ" },
        { id: "ea", label: "Entity E₁" },
        { id: "eb", label: "Entity E₂" },
      ],
      edges: [
        { from: "b", to: "perm", label: "permits", kind: "constraint" },
        { from: "r", to: "perm", label: "denotes", kind: "denotation" },
        { from: "r", to: "b", label: "is not", kind: "comparison" },
        { from: "ea", to: "r", label: "coordinates via", kind: "role" },
        { from: "eb", to: "r", label: "coordinates via", kind: "role" },
        { from: "ea", to: "eb", label: "distinct", kind: "comparison" },
      ],
    },
    ports: [
      { label: "Boundary", term: "organon:Boundary" },
      { label: "Representation of permitted Transformations", term: "organon:Representation" },
      { label: "Coordinating Entity A", term: "organon:Entity" },
      { label: "Coordinating Entity B", term: "organon:Entity" },
    ],
    conditions: [
      "The Transformations permitted across this Boundary are explicitly represented.",
      "The Representation exists to coordinate between Entities.",
    ],
    reading:
      "An Interface is a Boundary whose permitted Transformations are explicitly represented so that Entities can coordinate.",
    note:
      "The Representation is not the Boundary itself, and representing a Transformation as permitted does not make it occur. An Interface confers no Permission in the institutional sense.",
  },

  "organon:Claim": {
    kind: "specification",
    title: "A Representation asserted by an Agent within a Scope",
    structure: {
      context: "One asserting Agent, one Representation, one Scope",
      nodes: [
        { id: "ag", label: "Agent A" },
        { id: "c", label: "Claim c" },
        { id: "r", label: "Representation ρ" },
        { id: "tgt", label: "target: Presence,\nRelation, Configuration,\nor Record" },
        { id: "sc", label: "Scope S" },
      ],
      edges: [
        { from: "c", to: "r", label: "is", kind: "identity" },
        { from: "ag", to: "r", label: "asserts", kind: "role" },
        { from: "r", to: "tgt", label: "about", kind: "denotation" },
        { from: "c", to: "sc", label: "asserted within", kind: "role" },
        { from: "tgt", to: "sc", label: "within", kind: "membership" },
      ],
    },
    ports: [
      { label: "Asserting Agent", term: "organon:Agent" },
      { label: "Representation", term: "organon:Representation" },
      { label: "About: Presences, Relations, Configurations, Records", term: "organon:Presence" },
      { label: "Scope", term: "organon:Scope" },
    ],
    conditions: [
      "An Agent asserts the Representation.",
      "The Representation is about one or more Presences, Relations, Configurations, or Records.",
      "The assertion is made within a Scope.",
    ],
    reading:
      "A Claim is a Representation that an Agent asserts about something within a Scope.",
    note:
      "A Claim alone establishes neither Evidence nor Truth. An Agent's report of its own Action remains a Claim unless an admissible Observation supplies Evidence.",
  },

  "organon:Witness": {
    kind: "specification",
    title: "A distinct Entity producing an Observation on a Claim",
    structure: {
      context: "One Claim c by Agent A; distinctness only, not independence",
      nodes: [
        { id: "w", label: "Witness W\n(Entity)" },
        { id: "ag", label: "claimant Agent A" },
        { id: "c", label: "Claim c" },
        { id: "o", label: "Observation o" },
      ],
      edges: [
        { from: "ag", to: "c", label: "asserts", kind: "role" },
        { from: "w", to: "ag", label: "distinct", kind: "comparison" },
        { from: "w", to: "o", label: "produces", kind: "role" },
        { from: "o", to: "c", label: "bears on", kind: "role" },
      ],
    },
    ports: [
      { label: "Witness Entity", term: "organon:Entity" },
      { label: "Claimant Agent (distinct)", term: "organon:Agent" },
      { label: "Claim", term: "organon:Claim" },
      { label: "Observation bearing on the Claim", term: "organon:Observation" },
    ],
    conditions: [
      "The Witness is distinct from the Agent making the Claim.",
      "The Witness produces an Observation that bears on that Claim.",
    ],
    reading:
      "A Witness is an Entity, distinct from the claimant, that produces an Observation bearing on the claimant's Claim.",
    note:
      "Distinctness alone does not establish independence; independence requires IndependentFor. Evidence requires both the relevant independence and Admission, not Admission alone.",
  },

  "organon:Control": {
    kind: "specification",
    title: "An Agent's reach over a mechanism within a Scope",
    structure: {
      context: "Scoped to S; holds through available Actions, exercised or not",
      nodes: [
        { id: "ctl", label: "Control relation" },
        { id: "ag", label: "Agent A" },
        { id: "tgt", label: "target: Constraint,\nRule, Interface, or\nObservation process" },
        { id: "acts", label: "Actions available\nto A (possible)" },
        { id: "out", label: "relevant outputs\nof target" },
        { id: "path", label: "a Causal path" },
        { id: "sc", label: "Scope S" },
      ],
      edges: [
        { from: "ctl", to: "ag", label: "controller", kind: "role" },
        { from: "ctl", to: "tgt", label: "controlled", kind: "role" },
        { from: "ctl", to: "sc", label: "scoped to", kind: "constraint" },
        { from: "acts", to: "ag", label: "available to", kind: "role" },
        { from: "acts", to: "tgt", label: "can configure\nor bypass", kind: "causal" },
        { from: "acts", to: "out", label: "can determine", kind: "causal" },
        { from: "tgt", to: "out", label: "yields", kind: "role" },
        { from: "acts", to: "path", label: "can keep outputs\nfrom entering", kind: "causal" },
      ],
    },
    ports: [
      { label: "Agent", term: "organon:Agent" },
      { label: "Constraint, Rule, Interface, or Observation process", term: "organon:Constraint" },
      { label: "Available Actions", term: "organon:Action" },
      { label: "Scope", term: "organon:Scope" },
    ],
    conditions: [
      "Actions available to the Agent can configure, bypass, or determine the relevant outputs of the target, or keep those outputs out of a Causal path.",
      "The Relation holds only within the stated Scope.",
    ],
    reading:
      "An Agent has Control over a Constraint, Rule, Interface, or Observation process when Actions available to it can configure, bypass, determine, or suppress what that mechanism contributes.",
    note:
      "Control concerns available Actions, not Authority or Permission. It can hold without being exercised, and without any institutional recognition.",
  },

  "organon:Order": {
    kind: "specification",
    title: "A persistent configuration through which Agents coordinate",
    structure: {
      context: "Coordination Order O = (member inventory, specified structure); persistent; not a mathematical Order",
      nodes: [
        { id: "co", label: "Coordination Order O" },
        { id: "inv", label: "member Set\n(inventory)" },
        { id: "str", label: "specified structure\n(who joins where)" },
        { id: "m", label: "Constraints, Records,\nInterfaces, Rules" },
        { id: "r", label: "recurring Relation r" },
        { id: "a1", label: "participant Agent A₁" },
        { id: "a2", label: "participant Agent A₂" },
      ],
      edges: [
        { from: "co", to: "inv", label: "pairs", kind: "role" },
        { from: "co", to: "str", label: "pairs", kind: "role" },
        { from: "m", to: "inv", label: "members", kind: "membership" },
        { from: "r", to: "inv", label: "listed member", kind: "membership" },
        { from: "str", to: "r", label: "separately places", kind: "role" },
        { from: "r", to: "a1", label: "position 1", kind: "role" },
        { from: "r", to: "a2", label: "position 2", kind: "role" },
        { from: "a1", to: "a2", label: "plurality: distinct", kind: "comparison" },
        { from: "a1", to: "co", label: "coordinates Action\nthrough", kind: "role" },
        { from: "a2", to: "co", label: "coordinates Action\nthrough", kind: "role" },
      ],
    },
    ports: [
      { label: "Plurality of Agents", term: "organon:Agent" },
      { label: "Constraints and Rules", term: "organon:Rule" },
      { label: "Records and Interfaces", term: "organon:Record" },
      { label: "Recurring Relations", term: "organon:Relation" },
      { label: "Specified structure: who joins where", term: "organon:Configuration" },
    ],
    conditions: [
      "The Configuration persists, and a plurality of Agents coordinate Action through it.",
      "The member Set is the inventory of Constraints, Records, Interfaces, Rules, and recurring Relations.",
      "The structure separately names which Relations join which participants in which positions.",
    ],
    reading:
      "A Coordination Order is a persistent Configuration of Constraints, Records, Interfaces, Rules, and recurring Relations through which several Agents coordinate. Its identity depends on its specified structure, not just its inventory.",
    note:
      "Equal inventories with different structure are different Coordination Orders. Despite the label, it is not a mathematical order (reflexive, antisymmetric, transitive).",
  },

  "organon:Standing": {
    kind: "specification",
    title: "Placement within named statuses, not their recording",
    structure: {
      context: "Within Coordination Order O only; placement, not recording",
      nodes: [
        { id: "pl", label: "Standing\n(placement)" },
        { id: "co", label: "Coordination Order O" },
        { id: "rule", label: "Rule R" },
        { id: "e", label: "Entity E" },
        { id: "st", label: "named status\nor Action σ" },
        { id: "sc", label: "Scope S of O" },
        { id: "rec", label: "Record of σ for E\n(optional)" },
      ],
      edges: [
        { from: "pl", to: "co", label: "by", kind: "role" },
        { from: "pl", to: "rule", label: "under", kind: "constraint" },
        { from: "pl", to: "e", label: "places", kind: "role" },
        { from: "pl", to: "st", label: "within domain of", kind: "role" },
        { from: "pl", to: "sc", label: "in", kind: "constraint" },
        { from: "sc", to: "co", label: "specified in", kind: "membership" },
        { from: "rec", to: "pl", label: "neither required\nnor sufficient", kind: "comparison" },
      ],
    },
    ports: [
      { label: "Coordination Order", term: "organon:Order" },
      { label: "Rule", term: "organon:Rule" },
      { label: "Entity placed", term: "organon:Entity" },
      { label: "Named institutional status or Action" },
      { label: "Scope", term: "organon:Scope" },
    ],
    conditions: [
      "The Coordination Order places the Entity under a Rule within the domain of the named status or Action.",
      "The placement holds in the specified Scope of that same Coordination Order.",
      "No Record is required, and a Record of a status without that placement supplies no Standing.",
    ],
    reading:
      "Standing is how a Coordination Order, under a Rule, places an Entity within a named institutional status or Action in a Scope. \"Institutional eligibility\" is shorthand for this Relation.",
    note:
      "Standing is not Recognition. Recognition records Standing, but Standing can obtain without being recorded. Standing in one Coordination Order supplies no Standing in another.",
  },

  "organon:Recognition": {
    kind: "specification",
    title: "Recording Standing at exactly the same indices",
    structure: {
      context: "Record and Standing share all five indices: O, R, E, σ, S (shared nodes)",
      nodes: [
        { id: "co", label: "Coordination Order O" },
        { id: "rec", label: "O's record ρ" },
        { id: "std", label: "Standing\n(obtains)" },
        { id: "rule", label: "Rule R" },
        { id: "e", label: "Entity E" },
        { id: "st", label: "institutional\nstatus σ" },
        { id: "sc", label: "Scope S" },
      ],
      edges: [
        { from: "co", to: "rec", label: "makes", kind: "role" },
        { from: "rec", to: "std", label: "records", kind: "denotation" },
        { from: "std", to: "co", label: "in", kind: "role" },
        { from: "rec", to: "rule", label: "under", kind: "role" },
        { from: "std", to: "rule", label: "under", kind: "constraint" },
        { from: "rec", to: "e", label: "for", kind: "role" },
        { from: "std", to: "e", label: "places", kind: "role" },
        { from: "rec", to: "st", label: "status", kind: "role" },
        { from: "std", to: "st", label: "status", kind: "role" },
        { from: "rec", to: "sc", label: "in", kind: "role" },
        { from: "std", to: "sc", label: "in", kind: "constraint" },
      ],
    },
    ports: [
      { label: "Coordination Order", term: "organon:Order" },
      { label: "Rule", term: "organon:Rule" },
      { label: "Entity", term: "organon:Entity" },
      { label: "Institutional status" },
      { label: "Scope", term: "organon:Scope" },
      { label: "Standing being recorded", term: "organon:Standing" },
    ],
    conditions: [
      "The Coordination Order records Standing for the Entity under the Rule and Scope.",
      "That Standing actually obtains at exactly the same Coordination Order, Rule, Entity, status, and Scope.",
    ],
    reading:
      "Recognition happens when a Coordination Order records an Entity's Standing. The record and the Standing must share all five indices.",
    note:
      "A record at any different index is not Recognition of that Standing, and a record without underlying Standing recognizes nothing. Standing does not require Recognition.",
  },

  "organon:Principal": {
    kind: "specification",
    title: "The party on whose behalf Actions may count",
    structure: {
      context: "Indexed by Coordination Order O; says nothing about another Order O′",
      nodes: [
        { id: "e", label: "Entity P" },
        { id: "co", label: "Coordination Order O" },
        { id: "std", label: "Standing of P\nin O" },
        { id: "pos", label: "status: party on\nwhose behalf" },
        { id: "acts", label: "Actions that\nmay count" },
        { id: "o2", label: "another Order O′" },
      ],
      edges: [
        { from: "std", to: "co", label: "in", kind: "role" },
        { from: "std", to: "e", label: "places", kind: "role" },
        { from: "std", to: "pos", label: "within domain of", kind: "role" },
        { from: "acts", to: "e", label: "may count on\nbehalf of", kind: "role" },
        { from: "acts", to: "co", label: "counting in", kind: "constraint" },
        { from: "co", to: "o2", label: "distinct: no\ntransfer", kind: "comparison" },
      ],
    },
    ports: [
      { label: "Entity", term: "organon:Entity" },
      { label: "Coordination Order", term: "organon:Order" },
      { label: "Standing to serve as Principal", term: "organon:Standing" },
      { label: "Actions that may count on its behalf", term: "organon:Action" },
    ],
    conditions: [
      "The Entity has Standing in the Coordination Order to serve as the party on whose behalf Actions may count.",
      "Principalhood is indexed by that same Coordination Order.",
    ],
    reading:
      "A Principal is an Entity that a Coordination Order gives Standing to be the party on whose behalf Actions may count.",
    note:
      "Being a Principal in one Coordination Order says nothing about any other. A Principal need not be an Agent or act itself.",
  },

  "organon:ActsFor": {
    kind: "specification",
    title: "A recognized Agent–Principal Relation in a Scope",
    structure: {
      context: "Recognized by Coordination Order O within Scope S; not Authority for a particular Action",
      nodes: [
        { id: "co", label: "Coordination Order O" },
        { id: "af", label: "ActsFor relation" },
        { id: "ag", label: "Agent A" },
        { id: "p", label: "Principal P" },
        { id: "sc", label: "Scope S" },
      ],
      edges: [
        { from: "co", to: "af", label: "recognizes", kind: "role" },
        { from: "af", to: "ag", label: "agent position", kind: "role" },
        { from: "af", to: "p", label: "principal position", kind: "role" },
        { from: "af", to: "sc", label: "within", kind: "constraint" },
      ],
    },
    ports: [
      { label: "Coordination Order", term: "organon:Order" },
      { label: "Agent", term: "organon:Agent" },
      { label: "Principal", term: "organon:Principal" },
      { label: "Scope", term: "organon:Scope" },
    ],
    conditions: [
      "The same Coordination Order recognizes the Relation between this Agent and this Principal.",
      "The representation holds only within the stated Scope.",
    ],
    reading:
      "ActsFor is the Relation that a Coordination Order recognizes between an Agent and the Principal it represents within a Scope.",
    note:
      "Practical influence or Capability does not establish ActsFor without recognition by the Coordination Order. ActsFor alone is not Authority or Permission for a particular Action.",
  },

  "organon:CountsAs": {
    kind: "specification",
    title: "A recorded institutional status under a Rule",
    structure: {
      context: "Within Coordination Order O and Scope S only; the item itself is unchanged",
      nodes: [
        { id: "co", label: "Coordination Order O" },
        { id: "rec", label: "O's record:\nx has status σ" },
        { id: "rule", label: "Rule R" },
        { id: "x", label: "item x: Presence,\nAction, Claim, or Record" },
        { id: "st", label: "institutional\nstatus σ" },
        { id: "sc", label: "Scope S" },
      ],
      edges: [
        { from: "co", to: "rec", label: "makes", kind: "role" },
        { from: "rec", to: "rule", label: "under", kind: "constraint" },
        { from: "rec", to: "x", label: "item", kind: "role" },
        { from: "rec", to: "st", label: "status", kind: "role" },
        { from: "rec", to: "sc", label: "within", kind: "constraint" },
      ],
    },
    ports: [
      { label: "Coordination Order", term: "organon:Order" },
      { label: "Rule", term: "organon:Rule" },
      { label: "Presence, Action, Claim, or Record", term: "organon:Presence" },
      { label: "Institutional status" },
      { label: "Scope", term: "organon:Scope" },
    ],
    conditions: [
      "The Coordination Order records the item as having the status under the Rule.",
      "The status holds within that Coordination Order and Scope only.",
    ],
    reading:
      "CountsAs is how a Coordination Order, applying a Rule, records a Presence, Action, Claim, or Record as having an institutional status within a Scope.",
    note:
      "Institutional status does not change what the item physically is, and it does not establish Truth. The same item can count differently under another Coordination Order, Rule, or Scope.",
  },

  "organon:Authority": {
    kind: "specification",
    title: "When an Agent's Action may count as binding",
    structure: {
      context: "Indexed by Coordination Order O; binding force limited to Scope S",
      nodes: [
        { id: "auth", label: "Authority relation" },
        { id: "co", label: "Coordination Order O" },
        { id: "ag", label: "Agent A" },
        { id: "a", label: "Action a of A" },
        { id: "ca", label: "CountsAs: a as\nbinding (possible)" },
        { id: "p", label: "Principal P, or\nwithin O itself" },
        { id: "sc", label: "Scope S" },
      ],
      edges: [
        { from: "auth", to: "co", label: "indexed by", kind: "role" },
        { from: "auth", to: "ag", label: "holder", kind: "role" },
        { from: "a", to: "ag", label: "Action of", kind: "role" },
        { from: "a", to: "ca", label: "may enter", kind: "role" },
        { from: "ca", to: "co", label: "recorded by", kind: "role" },
        { from: "ca", to: "p", label: "binding on", kind: "role" },
        { from: "ca", to: "sc", label: "within", kind: "constraint" },
      ],
    },
    ports: [
      { label: "Coordination Order", term: "organon:Order" },
      { label: "Agent", term: "organon:Agent" },
      { label: "Agent's Action", term: "organon:Action" },
      { label: "Principal bound (or the Coordination Order)", term: "organon:Principal" },
      { label: "Scope", term: "organon:Scope" },
    ],
    conditions: [
      "Authority is indexed by one Coordination Order.",
      "Through it, the Agent's Action may enter CountsAs as binding on a Principal or within that Coordination Order.",
      "Binding force is limited to the stated Scope.",
    ],
    reading:
      "Authority is the Relation, indexed by a Coordination Order, through which an Agent's Action may count as binding on a Principal or within that Coordination Order and Scope.",
    note:
      "Authority is not Capability. It neither creates nor requires technical possibility. Authority in one Coordination Order carries no weight in another.",
  },

  "organon:PermissionClaim": {
    kind: "specification",
    title: "An assertion that an Order allows an Agent to act",
    structure: {
      context: "Asserted only; claimant and named Agent need not differ; not yet a Permission",
      nodes: [
        { id: "cl", label: "claimant Agent C" },
        { id: "pc", label: "Permission Claim π" },
        { id: "co", label: "named Order O" },
        { id: "ag", label: "named Agent A" },
        { id: "p", label: "Principal P" },
        { id: "acts", label: "Actions in Scope S" },
        { id: "iv", label: "stated interval" },
      ],
      edges: [
        { from: "cl", to: "pc", label: "asserts", kind: "role" },
        { from: "pc", to: "co", label: "names as allowing", kind: "denotation" },
        { from: "pc", to: "ag", label: "names as allowed", kind: "denotation" },
        { from: "pc", to: "acts", label: "names Actions", kind: "denotation" },
        { from: "pc", to: "p", label: "on behalf of", kind: "denotation" },
        { from: "pc", to: "iv", label: "during", kind: "denotation" },
      ],
    },
    ports: [
      { label: "Claimant Agent", term: "organon:Agent" },
      { label: "Named Coordination Order", term: "organon:Order" },
      { label: "Named permitted Agent", term: "organon:Agent" },
      { label: "Principal on whose behalf", term: "organon:Principal" },
      { label: "Actions in Scope", term: "organon:Scope" },
      { label: "Stated interval" },
    ],
    conditions: [
      "It is a Claim, so some Agent asserts it.",
      "It names the Coordination Order, the permitted Agent, the Principal, the Scope of Actions, and the interval.",
    ],
    reading:
      "A Permission Claim asserts that a named Coordination Order allows a named Agent to perform Actions in a Scope on a Principal's behalf during a stated interval.",
    note:
      "A Permission Claim is not a Permission. Without a valid Grant and Admission, it remains only a permission-shaped Claim.",
  },

  "organon:Declaration": {
    kind: "specification",
    title: "An authorized submission for institutional counting",
    structure: {
      context: "Submission to Coordination Order O for counting in Scope S; not Admission",
      nodes: [
        { id: "ag", label: "Agent A" },
        { id: "d", label: "Declaration δ\n(Action of A)" },
        { id: "auth", label: "Authority under which\nA declares" },
        { id: "c", label: "Claim c" },
        { id: "sp", label: "Specification σ" },
        { id: "co", label: "Coordination Order O" },
        { id: "sc", label: "Scope S" },
      ],
      edges: [
        { from: "ag", to: "d", label: "performs", kind: "role" },
        { from: "d", to: "auth", label: "made under", kind: "constraint" },
        { from: "d", to: "c", label: "submits", kind: "role" },
        { from: "d", to: "sp", label: "submits", kind: "role" },
        { from: "d", to: "co", label: "submits to", kind: "role" },
        { from: "d", to: "sc", label: "for counting\nwithin", kind: "constraint" },
      ],
    },
    ports: [
      { label: "Declaring Agent", term: "organon:Agent" },
      { label: "Authority it acts under", term: "organon:Authority" },
      { label: "Submitted Claim", term: "organon:Claim" },
      { label: "Submitted Specification", term: "organon:Specification" },
      { label: "Coordination Order", term: "organon:Order" },
      { label: "Scope", term: "organon:Scope" },
    ],
    conditions: [
      "The Declaration is an Action by the Agent under Authority.",
      "It submits both a Claim and a Specification for institutional counting within the Scope.",
    ],
    reading:
      "A Declaration is an Agent's Action, made under Authority, that submits a Claim and Specification to a Coordination Order for counting within a Scope.",
    note:
      "Submission is not Admission. The Coordination Order may still decline to count what was declared. Without Authority, the same Action is not a Declaration.",
  },

  "organon:Grant": {
    kind: "specification",
    title: "A Declaration submitting a Permission Claim with covering Authority",
    structure: {
      context: "Declarer's Authority covers each index π represents (shared nodes); candidate only, not yet admitted",
      nodes: [
        { id: "d", label: "Declaration δ" },
        { id: "pc", label: "submitted Claim π\n(Permission Claim)" },
        { id: "auth", label: "declarer's Authority" },
        { id: "p", label: "Principal P" },
        { id: "ag", label: "Agent A" },
        { id: "sc", label: "Scope S" },
        { id: "iv", label: "interval" },
      ],
      edges: [
        { from: "d", to: "pc", label: "submits", kind: "role" },
        { from: "d", to: "auth", label: "made under", kind: "constraint" },
        { from: "pc", to: "p", label: "represents", kind: "denotation" },
        { from: "pc", to: "ag", label: "represents", kind: "denotation" },
        { from: "pc", to: "sc", label: "represents", kind: "denotation" },
        { from: "pc", to: "iv", label: "represents", kind: "denotation" },
        { from: "auth", to: "p", label: "covers", kind: "constraint" },
        { from: "auth", to: "ag", label: "covers", kind: "constraint" },
        { from: "auth", to: "sc", label: "covers", kind: "constraint" },
        { from: "auth", to: "iv", label: "covers", kind: "constraint" },
      ],
    },
    ports: [
      { label: "Declaration", term: "organon:Declaration" },
      { label: "Submitted Permission Claim", term: "organon:PermissionClaim" },
      { label: "Authority of the declarer", term: "organon:Authority" },
      { label: "Principal, Agent, Scope, interval covered" },
    ],
    conditions: [
      "The Declaration's submitted Claim is a Permission Claim.",
      "The declarer's Authority covers the same Principal, Agent, Scope, and interval that the Permission Claim represents.",
    ],
    reading:
      "A Grant is a Declaration whose submitted Claim is a Permission Claim, made under Authority covering every party and index named in that Claim.",
    note:
      "A Grant is a candidate authorization, not yet a Permission. A Permission also needs the Coordination Order's Admission. Authority that misses any index does not produce a Grant.",
  },

  "organon:Admission": {
    kind: "specification",
    title: "Acceptance under a Rule for an institutional purpose",
    structure: {
      context: "Established by Coordination Order O for one institutional purpose u only",
      nodes: [
        { id: "co", label: "Coordination Order O" },
        { id: "rule", label: "Rule R (applied)" },
        { id: "adm", label: "Admission\n(CountsAs relation)" },
        { id: "x", label: "item: Claim,\nObservation, or Record" },
        { id: "u", label: "institutional\npurpose u" },
      ],
      edges: [
        { from: "co", to: "rule", label: "applies", kind: "role" },
        { from: "co", to: "adm", label: "establishes", kind: "role" },
        { from: "adm", to: "rule", label: "under", kind: "constraint" },
        { from: "adm", to: "x", label: "accepts", kind: "role" },
        { from: "adm", to: "u", label: "accepted for", kind: "role" },
      ],
    },
    ports: [
      { label: "Coordination Order", term: "organon:Order" },
      { label: "Applied Rule", term: "organon:Rule" },
      { label: "Claim, Observation, or Record accepted", term: "organon:Claim" },
      { label: "Institutional purpose" },
    ],
    conditions: [
      "Admission is a CountsAs Relation established by the Coordination Order.",
      "The Coordination Order applies a Rule to accept the item for a stated institutional purpose.",
    ],
    reading:
      "Admission is the CountsAs Relation that results when a Coordination Order applies a Rule to accept a Claim, Observation, or Record for an institutional purpose.",
    note:
      "Admission is purpose-bound and creates no Truth. Admitting an item for one purpose does not admit it for another.",
  },

  "organon:Permission": {
    kind: "specification",
    title: "An admitted Permission Claim carrying its full chain",
    structure: {
      context: "Record of Coordination Order O; Grant provenance and Admission provenance stay separate",
      nodes: [
        { id: "perm", label: "Permission\n(Record ρ)" },
        { id: "co", label: "Coordination Order O" },
        { id: "pc", label: "Permission Claim π" },
        { id: "g", label: "valid Grant γ\n(Declaration)" },
        { id: "adm", label: "Admission α\n(CountsAs by O)" },
        { id: "rule", label: "admitting Rule R" },
        { id: "idx", label: "π's indices: P, A,\nScope, interval" },
      ],
      edges: [
        { from: "g", to: "pc", label: "submits", kind: "role" },
        { from: "g", to: "idx", label: "Authority covers", kind: "constraint" },
        { from: "pc", to: "idx", label: "represents", kind: "denotation" },
        { from: "co", to: "adm", label: "establishes", kind: "role" },
        { from: "adm", to: "rule", label: "under", kind: "constraint" },
        { from: "adm", to: "pc", label: "admits, as\nresult of γ", kind: "role" },
        { from: "perm", to: "adm", label: "records, carries", kind: "role" },
        { from: "perm", to: "g", label: "carries", kind: "role" },
        { from: "perm", to: "co", label: "carries", kind: "role" },
        { from: "perm", to: "idx", label: "carries", kind: "role" },
      ],
    },
    ports: [
      { label: "Coordination Order", term: "organon:Order" },
      { label: "Admitted Permission Claim", term: "organon:PermissionClaim" },
      { label: "Valid Grant", term: "organon:Grant" },
      { label: "Admission", term: "organon:Admission" },
      { label: "Principal and Agent", term: "organon:Principal" },
      { label: "Scope and interval", term: "organon:Scope" },
    ],
    conditions: [
      "The Coordination Order admits the Permission Claim as the result of a valid Grant.",
      "The Record carries the Coordination Order, Principal, Agent, Scope, interval, Grant, and Admission.",
      "The Grant and Admission refer to the same Permission Claim and indices.",
    ],
    reading:
      "A Permission is the Record by which a Coordination Order admits a Permission Claim that resulted from a valid Grant. The Record carries the full chain that makes it institutionally valid.",
    note:
      "A permission-shaped Claim or Record without that chain is not a Permission. An assertion that a Permission is valid remains a Claim until it is admitted as Evidence or as an institutional fact. Permission supplies no Capability.",
  },

  "organon:Revocation": {
    kind: "specification",
    title: "An authorized Declaration ending admission of a Permission",
    structure: {
      context: "Governing Coordination Order O; effective from t only, earlier admission not erased",
      nodes: [
        { id: "ag", label: "declaring Agent" },
        { id: "rv", label: "Revocation\n(Declaration δ)" },
        { id: "auth", label: "Authority in O" },
        { id: "co", label: "Coordination Order O" },
        { id: "perm", label: "Permission ρ" },
        { id: "adm", label: "O's admission\nof ρ (before t)" },
        { id: "cease", label: "O ceases admitting ρ" },
        { id: "t", label: "stated time\nor State t" },
      ],
      edges: [
        { from: "ag", to: "rv", label: "performs", kind: "role" },
        { from: "rv", to: "auth", label: "made under", kind: "constraint" },
        { from: "auth", to: "co", label: "indexed by", kind: "role" },
        { from: "co", to: "adm", label: "maintains", kind: "role" },
        { from: "adm", to: "perm", label: "admits", kind: "role" },
        { from: "rv", to: "cease", label: "causes", kind: "causal" },
        { from: "cease", to: "adm", label: "ends", kind: "role" },
        { from: "cease", to: "t", label: "from", kind: "role" },
      ],
    },
    ports: [
      { label: "Permission admitted by the Coordination Order", term: "organon:Permission" },
      { label: "Revoking Declaration under Authority", term: "organon:Declaration" },
      { label: "Admission ceases from stated time or State", term: "organon:Order" },
    ],
    conditions: [
      "The revoking Declaration is made under Authority in the governing Coordination Order.",
      "The Declaration causes that Coordination Order to stop admitting the same Permission.",
      "The cessation takes effect from a stated time or State.",
    ],
    reading:
      "While the Coordination Order admits a Permission, an authorized Declaration causes it to stop admitting that Permission from a stated time or State.",
    note:
      "Revocation applies only from the stated time or State. It does not erase the earlier admission or earlier exercises. A Declaration without Authority does not revoke.",
  },

  "organon:PermissionExercise": {
    kind: "specification",
    title: "An Action performed under an unrevoked Permission",
    structure: {
      context: "One Permission ρ in governing Coordination Order O; actual performance",
      nodes: [
        { id: "perm", label: "Permission ρ" },
        { id: "ag", label: "ρ's Agent A" },
        { id: "a", label: "Action a\n(performed)" },
        { id: "sc", label: "ρ's Scope" },
        { id: "iv", label: "ρ's interval" },
        { id: "rev", label: "Revocation of ρ\n(if any)" },
        { id: "co", label: "governing Order O" },
      ],
      edges: [
        { from: "perm", to: "ag", label: "names", kind: "role" },
        { from: "a", to: "ag", label: "performed by", kind: "role" },
        { from: "a", to: "perm", label: "performed under", kind: "role" },
        { from: "a", to: "sc", label: "within", kind: "membership" },
        { from: "a", to: "iv", label: "within", kind: "membership" },
        { from: "a", to: "rev", label: "occurs before", kind: "role" },
        { from: "rev", to: "co", label: "in", kind: "role" },
      ],
    },
    ports: [
      { label: "Permission", term: "organon:Permission" },
      { label: "The Permission's Agent", term: "organon:Agent" },
      { label: "Action performed", term: "organon:Action" },
      { label: "Scope and interval", term: "organon:Scope" },
      { label: "Governing Coordination Order", term: "organon:Order" },
    ],
    conditions: [
      "The Action is by the same Agent that the Permission names.",
      "The Action falls within the Permission's Scope and interval.",
      "It occurs before Revocation in the governing Coordination Order.",
    ],
    reading:
      "A Permission Exercise is an Action by the Permission's own Agent, performed under that Permission within its Scope and interval before any Revocation.",
    note:
      "Exercise records actual performance. It does not show that the Action was good, successful, or Evidence of anything. An Action by any other Agent is not an exercise of this Permission.",
  },

  "organon:Exercisability": {
    kind: "specification",
    title: "Capability and still-admitted Permission at one Action and time",
    structure: {
      context: "Fixed indices: one Permission, one Action, one time t, one Configuration K",
      nodes: [
        { id: "perm", label: "Permission ρ" },
        { id: "a", label: "one Action a" },
        { id: "t", label: "time t" },
        { id: "co", label: "governing Order O" },
        { id: "ag", label: "ρ's Agent A" },
        { id: "cap", label: "A's Capability" },
        { id: "k", label: "Configuration K\n(env · tech · time)" },
      ],
      edges: [
        { from: "a", to: "perm", label: "in Scope of", kind: "membership" },
        { from: "t", to: "perm", label: "in interval of", kind: "membership" },
        { from: "co", to: "perm", label: "still admits at t", kind: "role" },
        { from: "perm", to: "ag", label: "names", kind: "role" },
        { from: "cap", to: "ag", label: "of", kind: "role" },
        { from: "a", to: "cap", label: "member (possible)", kind: "membership" },
        { from: "cap", to: "k", label: "under stated", kind: "constraint" },
      ],
    },
    ports: [
      { label: "Permission", term: "organon:Permission" },
      { label: "One Action", term: "organon:Action" },
      { label: "Time" },
      { label: "Constraint Configuration", term: "organon:Configuration" },
      { label: "Agent's Capability", term: "organon:Capability" },
      { label: "Governing Coordination Order", term: "organon:Order" },
    ],
    conditions: [
      "The Action is in the Permission's Scope and the time is in its interval.",
      "The governing Coordination Order still admits the Permission at that time.",
      "The Agent has the Capability to perform that same Action under the same stated Configuration.",
    ],
    reading:
      "A Permission is exercisable for one Action at one time when that Action is permitted, the Permission is still admitted, and the Agent can actually perform it under the stated Configuration. Authorization and technical possibility must hold together at the same indices.",
    note:
      "A Permission can stay valid while no Action, or only some Actions, are exercisable. Capability and Permission do not substitute for each other.",
  },

  "organon:Enforcement": {
    kind: "specification",
    title: "Coupling a Rule to what follows satisfaction or violation",
    structure: {
      context: "Coordination Order O couples one Rule R; the coupling alters at least one case",
      nodes: [
        { id: "co", label: "Coordination Order O" },
        { id: "rule", label: "Rule R" },
        { id: "cpl", label: "coupled Constraints,\nRecords, or Consequences" },
        { id: "sat", label: "case: R satisfied" },
        { id: "vio", label: "case: R violated" },
        { id: "o1", label: "what happens\nif satisfied" },
        { id: "o2", label: "what happens\nif violated" },
      ],
      edges: [
        { from: "co", to: "cpl", label: "couples to R", kind: "role" },
        { from: "cpl", to: "rule", label: "coupled to", kind: "role" },
        { from: "rule", to: "sat", label: "case", kind: "role" },
        { from: "rule", to: "vio", label: "case", kind: "role" },
        { from: "sat", to: "o1", label: "then", kind: "role" },
        { from: "vio", to: "o2", label: "then", kind: "role" },
        { from: "cpl", to: "o1", label: "alters at least\none of these cases", kind: "causal" },
        { from: "cpl", to: "o2", label: "alters at least\none of these cases", kind: "causal" },
      ],
    },
    ports: [
      { label: "Coordination Order", term: "organon:Order" },
      { label: "Rule", term: "organon:Rule" },
      { label: "Coupled Constraints, Records, or Consequences", term: "organon:Consequence" },
      { label: "Satisfaction or violation of the Rule" },
    ],
    conditions: [
      "The Coordination Order couples the Rule to Constraints, Records, or Consequences.",
      "The coupling changes what happens depending on whether the Rule is satisfied or violated.",
    ],
    reading:
      "Enforcement is how a Coordination Order connects a Rule to Constraints, Records, or Consequences so that satisfying or violating the Rule makes a difference.",
    note:
      "A Rule that is written down but coupled to nothing is not enforced. Enforcement does not make the Rule just or its Consequences favorable.",
  },

  "organon:Role": {
    kind: "specification",
    title: "An assigned configuration of Actions, Permissions, Authority",
    structure: {
      context: "Indexed by Coordination Order O; members versus assignment in structure",
      nodes: [
        { id: "role", label: "Role (persistent\nConfiguration)" },
        { id: "co", label: "Coordination Order O" },
        { id: "mem", label: "members: Actions,\nPermissions, Authority,\nConsequences" },
        { id: "asg", label: "assignment\n(specified structure)" },
        { id: "ag", label: "Agent A" },
        { id: "std", label: "Standing under which\nA is assigned" },
      ],
      edges: [
        { from: "role", to: "co", label: "indexed by", kind: "role" },
        { from: "mem", to: "role", label: "member Set of", kind: "membership" },
        { from: "role", to: "asg", label: "structure includes", kind: "role" },
        { from: "asg", to: "mem", label: "assigns", kind: "role" },
        { from: "asg", to: "ag", label: "to", kind: "role" },
        { from: "asg", to: "std", label: "under", kind: "constraint" },
        { from: "std", to: "ag", label: "places", kind: "role" },
      ],
    },
    ports: [
      { label: "Coordination Order", term: "organon:Order" },
      { label: "Agent assigned", term: "organon:Agent" },
      { label: "Standing of the Agent", term: "organon:Standing" },
      { label: "Member Actions and Permissions", term: "organon:Permission" },
      { label: "Member Authority and Consequences", term: "organon:Authority" },
    ],
    conditions: [
      "The Configuration persists and is indexed by one Coordination Order.",
      "Its members are assigned to the Agent under Standing; listing members alone does not assign them.",
    ],
    reading:
      "A Role is a persistent, Coordination Order-indexed Configuration of Actions, Permissions, Authority, and Consequences that is assigned to an Agent under Standing.",
    note:
      "A Role belongs to the institutional projection of an Agent. It supplies no Capability, and it is not a separate Entity or kind of Agency.",
  },

  "organon:AdmissibilityRule": {
    kind: "specification",
    title: "A Rule whose validity for admission is inspectable",
    structure: {
      context: "Recorded provenance makes validity inspectable; not truth-tracking or fairness",
      nodes: [
        { id: "r", label: "Rule R" },
        { id: "sp", label: "Specification of R" },
        { id: "u", label: "institutional\npurpose u" },
        { id: "d", label: "authorizing\nDeclaration δ" },
        { id: "co", label: "governing Order O" },
        { id: "recs", label: "provenance Records" },
        { id: "ca", label: "CountsAs: R valid\nfor admission" },
      ],
      edges: [
        { from: "r", to: "sp", label: "specified by", kind: "role" },
        { from: "recs", to: "sp", label: "records", kind: "denotation" },
        { from: "recs", to: "u", label: "records", kind: "denotation" },
        { from: "recs", to: "d", label: "records", kind: "denotation" },
        { from: "recs", to: "co", label: "records", kind: "denotation" },
        { from: "ca", to: "r", label: "item", kind: "role" },
        { from: "ca", to: "co", label: "recorded by", kind: "role" },
        { from: "recs", to: "ca", label: "make inspectable\nwhy", kind: "role" },
      ],
    },
    ports: [
      { label: "Rule", term: "organon:Rule" },
      { label: "Recorded Specification", term: "organon:Specification" },
      { label: "Institutional purpose" },
      { label: "Authorizing Declaration", term: "organon:Declaration" },
      { label: "Governing Coordination Order", term: "organon:Order" },
    ],
    conditions: [
      "The Rule's Specification, purpose, authorizing Declaration, and governing Coordination Order are all recorded.",
      "Those records make it inspectable why the Rule counts as valid for admission.",
    ],
    reading:
      "An Admissibility Rule is a Rule with its provenance recorded, so anyone can inspect why it counts as valid for admitting items.",
    note:
      "Recorded provenance makes validity inspectable. It does not make the Rule truth-tracking, fair, or independent. A self-authored Rule does not certify its own author.",
  },

  "organon:IndependentFor": {
    kind: "specification",
    title: "Mechanical and institutional independence in one Scope",
    structure: {
      context: "Scoped to this Witness, claimant, Claim, Observation, and Coordination Order O",
      nodes: [
        { id: "w", label: "Witness W" },
        { id: "cl", label: "claimant A" },
        { id: "c", label: "Claim c" },
        { id: "o", label: "Observation o" },
        { id: "proc", label: "W's Observation\nprocess" },
        { id: "k", label: "load-bearing\nConstraint k" },
        { id: "ar", label: "Admissibility Rule\napplied to o" },
        { id: "co", label: "Coordination Order O" },
      ],
      edges: [
        { from: "cl", to: "c", label: "asserts", kind: "role" },
        { from: "w", to: "proc", label: "runs", kind: "role" },
        { from: "proc", to: "o", label: "produces", kind: "role" },
        { from: "k", to: "o", label: "in Causal path of", kind: "membership" },
        { from: "o", to: "c", label: "bears on", kind: "role" },
        { from: "ar", to: "co", label: "in", kind: "role" },
        { from: "cl", to: "k", label: "lacks Control over", kind: "constraint" },
        { from: "cl", to: "proc", label: "lacks Authority\nover (in O)", kind: "constraint" },
        { from: "cl", to: "ar", label: "lacks Authority\nover (in O)", kind: "constraint" },
      ],
    },
    ports: [
      { label: "Witness", term: "organon:Witness" },
      { label: "Claimant Agent", term: "organon:Agent" },
      { label: "Claim", term: "organon:Claim" },
      { label: "Observation", term: "organon:Observation" },
      { label: "Coordination Order", term: "organon:Order" },
      { label: "Admissibility Rule applied", term: "organon:AdmissibilityRule" },
    ],
    conditions: [
      "Mechanical: a load-bearing Constraint in the Observation's Causal path is outside the claimant's Control.",
      "Institutional: the claimant lacks Authority over the Witness's relevant Observation process and over the Admissibility Rule applied to it.",
      "Both independences are required, for this Claim, Observation, and Coordination Order.",
    ],
    reading:
      "A Witness is IndependentFor a claimant and Claim when the claimant can neither mechanically control a load-bearing part of how the Observation arises nor institutionally direct that process or the Rule that admits it.",
    note:
      "Distinctness, or either kind of independence alone, is not enough. The Relation makes no universal claim about the Witness outside this Scope.",
  },

  "organon:Evidence": {
    kind: "specification",
    title: "An independently produced, admitted Observation",
    structure: {
      context: "Produced first by an independent Witness, then admitted by governing Order O",
      nodes: [
        { id: "o", label: "Observation o" },
        { id: "w", label: "Witness W" },
        { id: "cl", label: "claimant A" },
        { id: "c", label: "Claim c" },
        { id: "ind", label: "IndependentFor\n(W, A, c, o, O)" },
        { id: "co", label: "governing Order O" },
        { id: "adm", label: "Admission of o" },
        { id: "ar", label: "Admissibility Rule R" },
        { id: "sc", label: "Scope of R" },
      ],
      edges: [
        { from: "w", to: "o", label: "produces", kind: "role" },
        { from: "ind", to: "w", label: "witness", kind: "role" },
        { from: "ind", to: "cl", label: "claimant", kind: "role" },
        { from: "ind", to: "c", label: "claim", kind: "role" },
        { from: "co", to: "adm", label: "establishes", kind: "role" },
        { from: "adm", to: "o", label: "admits", kind: "role" },
        { from: "adm", to: "ar", label: "under", kind: "constraint" },
        { from: "ar", to: "sc", label: "Scope", kind: "role" },
        { from: "o", to: "sc", label: "included", kind: "membership" },
        { from: "c", to: "sc", label: "included", kind: "membership" },
      ],
    },
    ports: [
      { label: "Observation", term: "organon:Observation" },
      { label: "Witness IndependentFor claimant and Claim", term: "organon:IndependentFor" },
      { label: "Claim", term: "organon:Claim" },
      { label: "Governing Coordination Order", term: "organon:Order" },
      { label: "Admissibility Rule covering both", term: "organon:AdmissibilityRule" },
    ],
    conditions: [
      "The Observation is produced by a Witness IndependentFor this claimant and this Claim.",
      "It is then admitted by the governing Coordination Order under an Admissibility Rule.",
      "The Rule's Scope includes both the Observation and the Claim.",
    ],
    reading:
      "Evidence is an Observation from a Witness who is independent for the claimant and Claim, later admitted by the governing Coordination Order under an Admissibility Rule whose Scope covers both.",
    note:
      "Evidence does not entail Truth. Whether it supports or defeats a Claim is settled only through Evidential Bearing. A claimant's own report is not Evidence.",
  },

  "organon:EvidentialBearing": {
    kind: "specification",
    title: "A recorded supporting, defeating, or underdetermining result",
    structure: {
      context: "Indexed by Coordination Order O, evaluation Rule R, Scope S; no Truth entailed",
      nodes: [
        { id: "ev", label: "Evidence e" },
        { id: "c", label: "Claim c" },
        { id: "r", label: "evaluation Rule R" },
        { id: "proc", label: "R's constructive\nprocedure" },
        { id: "sc", label: "Scope S" },
        { id: "disp", label: "one disposition:\nsupporting | defeating |\nunderdetermining" },
        { id: "co", label: "Coordination Order O" },
        { id: "rec", label: "O's record\nof result" },
      ],
      edges: [
        { from: "r", to: "proc", label: "supplies", kind: "role" },
        { from: "proc", to: "ev", label: "input", kind: "role" },
        { from: "proc", to: "c", label: "input", kind: "role" },
        { from: "proc", to: "sc", label: "within", kind: "constraint" },
        { from: "proc", to: "disp", label: "returns exactly one", kind: "role" },
        { from: "co", to: "rec", label: "makes", kind: "role" },
        { from: "rec", to: "disp", label: "records", kind: "denotation" },
        { from: "rec", to: "r", label: "for Rule", kind: "role" },
      ],
    },
    ports: [
      { label: "Evidence", term: "organon:Evidence" },
      { label: "Claim", term: "organon:Claim" },
      { label: "Evaluation Rule", term: "organon:Rule" },
      { label: "Scope", term: "organon:Scope" },
      { label: "Coordination Order recording the result", term: "organon:Order" },
    ],
    conditions: [
      "The evaluation Rule's constructive procedure returns exactly one declared disposition: supporting, defeating, or underdetermining.",
      "The Coordination Order records that result for this Evidence, Claim, Rule, and Scope.",
    ],
    reading:
      "Evidential Bearing is the Relation in which an evaluation Rule, applied to Evidence and a Claim within a Scope, returns supporting, defeating, or underdetermining, and the Coordination Order records that result. These dispositions are typed results of the evaluation, not inherent properties of the Evidence.",
    note:
      "Evidential Bearing does not entail Truth. The same Evidence may bear differently under another Rule, Scope, or Coordination Order.",
  },

  "organon:Attestation": {
    kind: "specification",
    title: "A Witness's specified Claim about an Observation or Evidence",
    structure: {
      context: "Still a Claim by the Witness; its Specification is self-description, not certification",
      nodes: [
        { id: "w", label: "Witness W" },
        { id: "att", label: "Attestation\n(Claim by W)" },
        { id: "obj", label: "Observation\nor Evidence" },
        { id: "sp", label: "Specification σ" },
        { id: "id", label: "W's identity" },
        { id: "sc", label: "Scope" },
        { id: "co", label: "Coordination Order O" },
        { id: "ind", label: "relevant\nindependence" },
      ],
      edges: [
        { from: "w", to: "att", label: "makes", kind: "role" },
        { from: "att", to: "obj", label: "about", kind: "denotation" },
        { from: "att", to: "sp", label: "made under", kind: "constraint" },
        { from: "sp", to: "id", label: "specifies", kind: "denotation" },
        { from: "sp", to: "sc", label: "specifies", kind: "denotation" },
        { from: "sp", to: "co", label: "specifies", kind: "denotation" },
        { from: "sp", to: "ind", label: "specifies", kind: "denotation" },
      ],
    },
    ports: [
      { label: "Attesting Witness", term: "organon:Witness" },
      { label: "Observation or Evidence attested", term: "organon:Observation" },
      { label: "Specification: identity, Scope, independence", term: "organon:Specification" },
      { label: "Coordination Order", term: "organon:Order" },
    ],
    conditions: [
      "The Attestation is a Claim made by the Witness itself.",
      "It is about an Observation or Evidence.",
      "It specifies the Witness's identity, Scope, Coordination Order, and relevant independence.",
    ],
    reading:
      "An Attestation is a Claim that a Witness makes about an Observation or Evidence, accompanied by a Specification of who the Witness is, its Scope, its Coordination Order, and how it is independent.",
    note:
      "An Attestation is still a Claim, not Truth or automatic support. No Agent's Claim, self-authored Rule, or domesticated Witness independently certifies that Agent.",
  },

  "organon:Institution": {
    kind: "specification",
    title: "A Coordination Order that outlasts its participants",
    structure: {
      context: "One Coordination Order across participant turnover (States s₁, s₂)",
      nodes: [
        { id: "inst", label: "Institution\n(Coordination Order O)" },
        { id: "roles", label: "Roles" },
        { id: "rec", label: "Records and\nInterfaces" },
        { id: "flows", label: "recurring Flows" },
        { id: "a1", label: "participating Agents\nat s₁" },
        { id: "a2", label: "participating Agents\nat s₂" },
      ],
      edges: [
        { from: "inst", to: "roles", label: "persists through", kind: "role" },
        { from: "inst", to: "rec", label: "persists through", kind: "role" },
        { from: "inst", to: "flows", label: "persists through", kind: "role" },
        { from: "a1", to: "inst", label: "participate in", kind: "role" },
        { from: "a2", to: "inst", label: "participate in", kind: "role" },
        { from: "a1", to: "a2", label: "changed", kind: "comparison" },
      ],
    },
    ports: [
      { label: "Coordination Order", term: "organon:Order" },
      { label: "Roles", term: "organon:Role" },
      { label: "Records and Interfaces", term: "organon:Record" },
      { label: "Recurring Flows", term: "organon:Flow" },
      { label: "Changing participating Agents", term: "organon:Agent" },
    ],
    conditions: [
      "The Coordination Order persists through its Roles, Records, Interfaces, and recurring Flows.",
      "It persists despite changes in its participating Agents.",
    ],
    reading:
      "An Institution is a Coordination Order that keeps going through its Roles, Records, Interfaces, and recurring Flows even as the Agents taking part change.",
    note:
      "Persistence through turnover does not imply legitimacy, efficiency, or a single controlling Agent. A Coordination Order that ends when its participants change is not an Institution.",
  },

  "organon:Center": {
    kind: "specification",
    title: "Where Flows concentrate and Constraints propagate",
    structure: {
      context: "Within one Institution I; recurrence of both concentration and propagation",
      nodes: [
        { id: "inst", label: "Institution I" },
        { id: "c", label: "Center c\n(Entity or region of I)" },
        { id: "f1", label: "Flow f₁" },
        { id: "f2", label: "Flow f₂" },
        { id: "k", label: "Constraints on\nf₁ and f₂" },
      ],
      edges: [
        { from: "c", to: "inst", label: "part of", kind: "membership" },
        { from: "f1", to: "c", label: "recurrently\nconcentrates at", kind: "role" },
        { from: "f2", to: "c", label: "recurrently\nconcentrates at", kind: "role" },
        { from: "k", to: "c", label: "recurrently\npropagate from", kind: "role" },
        { from: "k", to: "f1", label: "constrain", kind: "constraint" },
        { from: "k", to: "f2", label: "constrain", kind: "constraint" },
      ],
    },
    ports: [
      { label: "Institution", term: "organon:Institution" },
      { label: "Entity or region of the Institution", term: "organon:Entity" },
      { label: "Recurrently concentrating Flows", term: "organon:Flow" },
      { label: "Constraints propagated on those Flows", term: "organon:Constraint" },
    ],
    conditions: [
      "Flows recurrently concentrate at this Entity or region.",
      "Constraints on those same Flows recurrently propagate from it.",
    ],
    reading:
      "A Center is a place in an Institution where Flows keep converging and from which Constraints on those Flows keep spreading.",
    note:
      "A Center need not be an Agent or a conscious planner, and concentration alone does not make something a Center. Being a Center does not confer Authority.",
  },

  "organon:Organ": {
    kind: "specification",
    title: "A specialized configuration doing recurring work for a whole",
    structure: {
      context: "Served whole W is a larger Entity or an Institution; H1 is only a hypothesis",
      nodes: [
        { id: "org", label: "Organ\n(persistent specialized\nConfiguration)" },
        { id: "t1", label: "Transformation t₁" },
        { id: "t2", label: "recurrence t₂" },
        { id: "whole", label: "larger Entity\nor Institution W" },
      ],
      edges: [
        { from: "org", to: "t1", label: "performs", kind: "role" },
        { from: "org", to: "t2", label: "performs", kind: "role" },
        { from: "t1", to: "t2", label: "recurring kind", kind: "comparison" },
        { from: "t1", to: "whole", label: "for", kind: "role" },
        { from: "t2", to: "whole", label: "for", kind: "role" },
      ],
    },
    ports: [
      { label: "Persistent specialized Configuration", term: "organon:Configuration" },
      { label: "Recurring Transformations performed", term: "organon:Transformation" },
      { label: "Larger Entity or Institution served", term: "organon:Institution" },
    ],
    conditions: [
      "The Configuration persists and is specialized.",
      "It performs recurring Transformations for a larger Entity or Institution.",
    ],
    reading:
      "An Organ is a persistent, specialized Configuration that performs recurring Transformations on behalf of a larger Entity or Institution.",
    note:
      "The idea that Organs preserve solutions absorbed by Centers from stable Flows is a hypothesis, not a consequence of the definitions. An Organ need not be an Agent.",
  },

  "organon:CanonicalSystem": {
    kind: "specification",
    title: "The Map an Institution recognizes as official",
    structure: {
      context: "Official status is recognition by Institution I, not accuracy",
      nodes: [
        { id: "inst", label: "Institution I" },
        { id: "map", label: "Map M" },
        { id: "rel", label: "relevant States,\nRelations, Actions" },
        { id: "om", label: "omitted Presence" },
        { id: "real", label: "Reality" },
      ],
      edges: [
        { from: "inst", to: "map", label: "recognizes as\nofficial account", kind: "role" },
        { from: "map", to: "rel", label: "accounts for", kind: "denotation" },
        { from: "map", to: "om", label: "omits", kind: "role" },
        { from: "om", to: "real", label: "part of", kind: "membership" },
        { from: "map", to: "real", label: "not identical", kind: "comparison" },
      ],
    },
    ports: [
      { label: "Institution", term: "organon:Institution" },
      { label: "Map", term: "organon:Map" },
      { label: "Relevant States, Relations, and Actions", term: "organon:State" },
    ],
    conditions: [
      "The Institution recognizes this Map as its official account.",
      "The Map covers the relevant States, Relations, and Actions.",
    ],
    reading:
      "A Canonical system is the Map that an Institution treats as the official account of the States, Relations, and Actions relevant to it.",
    note:
      "Official status does not make the Map accurate, complete, or identical with Reality. Actual coordination can depend on what the Map leaves out.",
  },

  "organon:ShadowSystem": {
    kind: "specification",
    title: "What coordination needs that the canon excludes",
    structure: {
      context: "Exclusion from Canonical system M, not Absence or illegitimacy",
      nodes: [
        { id: "sh", label: "Shadow system X\n(persistent\nConfiguration)" },
        { id: "mem", label: "Records, Relations,\nor Actions" },
        { id: "coord", label: "actual coordination" },
        { id: "canon", label: "Canonical system M" },
        { id: "inst", label: "Institution I" },
      ],
      edges: [
        { from: "mem", to: "sh", label: "members", kind: "membership" },
        { from: "coord", to: "sh", label: "requires", kind: "role" },
        { from: "canon", to: "sh", label: "excludes", kind: "constraint" },
        { from: "inst", to: "canon", label: "recognizes as\nofficial", kind: "role" },
      ],
    },
    ports: [
      { label: "Persistent Records, Relations, or Actions", term: "organon:Configuration" },
      { label: "Actual coordination requiring them" },
      { label: "Canonical system excluding them", term: "organon:CanonicalSystem" },
    ],
    conditions: [
      "The Configuration persists and is required for actual coordination.",
      "It is excluded from the Canonical system of the same Institution.",
    ],
    reading:
      "A Shadow system is a persistent Configuration of Records, Relations, or Actions that actual coordination depends on but that the Canonical system leaves out.",
    note:
      "\"Shadow\" means excluded from the official Map, not Absent, illegitimate, or hidden by design. Missing from the canon is not the same as absence.",
  },
};

export default coordination;
