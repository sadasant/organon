// Shared, nonbinding source for the study, symbol font, and website.
// Motif combinations are mnemonics, NOT a compositional semantic grammar.
// Derive heights rather than snapping equilateral vertices to the integer grid.
const equilateralHeight = (side) => side * Math.sqrt(3) / 2;
const memberTop = 24 - equilateralHeight(20);
const stateTop = 24 - equilateralHeight(16);
// Trim 2.5 units along a 60-degree edge to preserve hollow node centers.
const stateTrimY = equilateralHeight(2.5);

// Node-graph conventions shared by the process and preservation glyphs:
// hollow nodes are r=2 rings; solid nodes are concentric strokes with a core.
// Every connection stops 2.5 units from a node center, outside hollow centers.
const nodeTrim = 2.5;
const hollowNode = ([x, y]) => `M${x} ${y-2}a2 2 0 1 1 0 4a2 2 0 1 1 0-4`;
const solidNode = ([x, y]) =>
  [1, 2].map((r) =>
    `M${x} ${y-r}a${r} ${r} 0 1 1 0 ${2*r}a${r} ${r} 0 1 1 0 ${-2*r}`,
  ).join(" ") + ` M${x} ${y-1}V${y+1}`;
const graph = (nodes, edges, solid = []) => [
  ...edges.map(([a, b]) => {
    const [[x, y], [u, v]] = [nodes[a], nodes[b]];
    const t = nodeTrim / Math.hypot(u - x, v - y);
    return `M${x+(u-x)*t} ${y+(v-y)*t} ${u-(u-x)*t} ${v-(v-y)*t}`;
  }),
  ...nodes.map((node, i) => (solid.includes(i) ? solidNode : hollowNode)(node)),
].join(" ");
// The point where a segment from outside reaches nodeTrim from a node center.
const stopOutside = ([x, y], [u, v], [cx, cy]) => {
  const [dx, dy, fx, fy] = [u - x, v - y, x - cx, y - cy];
  const [a, b, c] = [dx*dx + dy*dy, 2*(fx*dx + fy*dy), fx*fx + fy*fy - nodeTrim**2];
  const t = (-b - Math.sqrt(b*b - 4*a*c)) / (2*a);
  return `${x+dx*t} ${y+dy*t}`;
};
// Three horizontal nodes joined in sequence, as in the approved study sketches.
const graphRow = (y, solid = []) => graph([[4, y], [16, y], [28, y]], [[0, 1], [1, 2]], solid);
// Equal 12-unit spokes from a solid pivot at (16,10), 60 degrees apart.
// Outer triangle edges are omitted: the sectors stay open.
const pivotSectors = (sectors) => {
  const ends = Array.from({ length: sectors + 1 }, (_, i) =>
    [16 + 12*Math.cos(i*Math.PI/3), 10 + 12*Math.sin(i*Math.PI/3)]);
  return graph([[16, 10], ...ends], ends.map((_, i) => [0, i + 1]), [0]);
};
// Six equal 12-unit spokes from a solid pivot at the cell center, every
// 60 degrees, each ending in its own hollow node. No outer hexagon is drawn.
const sixSpokeEnds = Array.from({ length: 6 }, (_, i) =>
  [16 + 12*Math.cos(i*Math.PI/3), 16 + 12*Math.sin(i*Math.PI/3)]);
// Symmetric open arrowhead: two 3-unit strokes at +/-0.6 rad from the shaft,
// meeting at the tip, as in the reviewed study sketches.
const arrowHead = ([x, y], [u, v]) => {
  const a = Math.atan2(v - y, u - x);
  return `M${u-3*Math.cos(a-0.6)} ${v-3*Math.sin(a-0.6)}L${u} ${v}L${u-3*Math.cos(a+0.6)} ${v-3*Math.sin(a+0.6)}`;
};
// Shared Representation sheet for Specification and Rule.
const sheet = "M4 3H28V29H4Z";
// Feeds study geometry scaled by 0.95 about the cell center, so r=2 rings
// at its outer vertices stay inside the 1-unit ink margin. Similarity
// preserves the equilateral triangles and the bridge angle.
const feedsNodes = [[3, 14], [8, 14 - equilateralHeight(10)], [13, 14],
  [19, 27], [24, 27 - equilateralHeight(10)], [29, 27]]
  .map((point) => point.map((c) => 16 + 0.95*(c - 16)));

export const strokes = {
  ring: "M16 8a8 8 0 1 1 0 16a8 8 0 1 1 0-16",
  // Overlapping concentric strokes form solid ink, leaving a small clear center.
  // These are drawing operations, not layers or parts of Reality.
  inversePresence: [3, 4, 5, 6, 7, 8].map((r) =>
    `M16 ${16-r}a${r} ${r} 0 1 1 0 ${2*r}a${r} ${r} 0 1 1 0 ${-2*r}`,
  ).join(" "),
  crescent: "M21 5a12 12 0 0 0 0 22M21 5a16 16 0 0 0 0 22",
  open: "M24 9a11 11 0 1 0 0 14",
  diamond: "M16 5 27 16 16 27 5 16Z",
  square: "M7 7H25V25H7Z",
  frame: "M11 5H5V27H11M21 5H27V27H21",
  vessel: "M6 9V16Q6 24 16 24Q26 24 26 16V9",
  arch: "M6 25V15Q6 5 16 5Q26 5 26 15V25",
  triangle: `M16 ${26-equilateralHeight(22)} 27 26H5Z`,
  gate: "M6 26V6H26V26",
  eye: "M3 16Q16 0 29 16Q16 32 3 16Z",
  wave: "M3 19Q9 7 16 16T29 13",
  link: "M7 11a5 5 0 1 1 0 10a5 5 0 1 1 0-10M25 11a5 5 0 1 1 0 10a5 5 0 1 1 0-10M12 16H20",
  double:
    "M16 4a6 6 0 1 1 0 12a6 6 0 1 1 0-12M16 16a6 6 0 1 1 0 12a6 6 0 1 1 0-12",
  tree: "M16 3V29M5 7 16 15 27 7",
  fork: "M16 29V15L5 4M16 15 27 4",
  axis: "M16 2V30",
  bar: "M3 16H29",
  rails: "M11 3V29M21 3V29",
  cap: "M10 3H22",
  foot: "M9 29H23",
  dot: "M16 14a2 2 0 1 1 0 4a2 2 0 1 1 0-4",
  seed: "M16 27a1 1 0 1 1 0 2a1 1 0 1 1 0-2",
  star: "M16 10V22M10 16H22M12 12 20 20M20 12 12 20",
  slash: "M5 27 27 5",
  cross: "M10 10 22 22M22 10 10 22",
  step: "M4 23H11V16H21V9H28",
  arrow: "M3 16H28M21 9 28 16 21 23",
  up: "M16 29V4M10 10 16 4 22 10",
  // Retired Feeds arrow, retained for the historical design inventory.
  down: "M16 3V28M10 22 16 28 22 22",
  chevron: "M10 12 16 18 22 12",
  crown: "M5 7V3M16 7V2M27 7V3",
  wings: "M3 11H8M24 11H29",
  roots: "M16 23 7 30M16 23 25 30",
  ticks: "M3 10H8M3 22H8M24 10H29M24 22H29",
  bars: "M8 12H24M8 20H24",
  association: "M16 8V24",
  orbit: "M2 16Q16 7 30 16Q16 25 2 16Z",
  echo: "M3 5V27M29 5V27",
  hooks: "M4 5V11H10M28 27V21H22",
  // Revision 2: term-specific signatures keep the semantic distinctions that
  // generic crowns, eyes, and tiny decorative additions obscured. These names
  // document design intent; combining paths still does not assert entailment.
  ordered: "M4 7H9V13H20V24H27M4 4V10M17 10V16M24 21V27",
  denotes: "M5 8V24M5 16H27M20 9 27 16 20 23",
  grouping: "M10 4H4V10M22 4H28V10M4 22V28H10M28 22V28H22M9 10V16M15 20H21M21 9H25",
  // Concentric strokes and a short core fill three solid, circular dots.
  members: [[16, memberTop], [6, 24], [26, 24]].map(([x, y]) =>
    [1, 2].map((r) =>
      `M${x} ${y-r}a${r} ${r} 0 1 1 0 ${2*r}a${r} ${r} 0 1 1 0 ${-2*r}`,
    ).join(" ") + ` M${x} ${y-1}V${y+1}`,
  ).join(" "),
  memberLinks: `M16 ${memberTop} 6 24H26Z`,
  // Retired State marker, retained for the historical design inventory.
  index: "M2 16H6",
  // Equal triangles shifted by half a base: baseline x=4,12,20,28;
  // apices x=12,20. Stop edges outside hollow centers; no opaque masks.
  stateOverlap: [
    `M5.25 ${24-stateTrimY} 10.75 ${stateTop+stateTrimY}M13.25 ${stateTop+stateTrimY} 18.75 ${24-stateTrimY}M12 24 20 ${stateTop} 28 24M6.5 24H17.5M22.5 24H28`,
    ...[[4, 24], [12, stateTop], [20, 24]].map(([x, y]) =>
      `M${x} ${y-2}a2 2 0 1 1 0 4a2 2 0 1 1 0-4`,
    ),
    ...[[12, 24], [20, stateTop], [28, 24]].map(([x, y]) =>
      [1, 2].map((r) =>
        `M${x} ${y-r}a${r} ${r} 0 1 1 0 ${2*r}a${r} ${r} 0 1 1 0 ${-2*r}`,
      ).join(" ") + ` M${x} ${y-1}V${y+1}`,
    ),
  ].join(" "),
  // Same side length as State; a 60-degree turn shares the ghost's right edge.
  // Keep all three ghost nodes hollow, including the two shared vertices.
  transformationEdge: [
    `M5.25 ${24-stateTrimY} 10.75 ${stateTop+stateTrimY}M6.5 24H17.5M13.25 ${stateTop+stateTrimY} 18.75 ${24-stateTrimY}M14.5 ${stateTop}H28M21.25 ${24-stateTrimY} 28 ${stateTop}`,
    ...[[4, 24], [12, stateTop], [20, 24]].map(([x, y]) =>
      `M${x} ${y-2}a2 2 0 1 1 0 4a2 2 0 1 1 0-4`,
    ),
    ...[1, 2].map((r) =>
      `M28 ${stateTop-r}a${r} ${r} 0 1 1 0 ${2*r}a${r} ${r} 0 1 1 0 ${-2*r}`,
    ),
    `M28 ${stateTop-1}V${stateTop+1}`,
  ].join(" "),
  // Hasse cover edges, read upward; the lower members are incomparable.
  partialOrder: `M6 24 16 ${memberTop} 26 24`,
  portFrame: "M8 2H2V30H8M24 2H30V30H24",
  // Retired Environment corner, retained for the historical design inventory.
  surroundings: "M9 10V22H23M3 6H7M16 3V7M26 5 29 8M25 16H30M17 27V30",
  partialMap: "M6 6H26V12M26 20V26H6V6M6 20H13V13H21",
  comparison: "M2 11V21M30 11V21",
  uptake: "M14 4V11M14 21V28M3 16H22L27 11M22 16 27 21M9 11 14 16 9 21",
  tracedRecord: "M10 5H27V27H10V17M3 8V13H17V21H23",
  admittedRecord: "M2 20H7V27H2Z",
  structuredModel: "M3 5H13V15H3ZM19 17H29V27H19ZM13 10H24V17M8 15V23H19",
  endpoint: "M4 7H13V16H26V23M22 19 26 23 30 19M22 23H30V29H22Z",
  interpretedAction: "M4 6 11 13 4 20M11 13H23M18 8 23 13 18 18M11 13V27H26",
  realizable: "M3 26H10V17H18V7H28M3 22V29M24 4 28 7 24 10M15 26H28",
  routing: "M4 6V25M4 15H17L27 6M17 15 27 24M20 4 29 13",
  placement: "M4 4V28M4 9H14V19H21M21 13H29V25H21Z",
  recordedPlacement: "M4 4H28V28H4ZM10 9V23M10 16H18M18 12H24V20H18Z",
  party: "M27 3V29M24 6H30M24 26H30",
  statusAssignment: "M3 9V23M3 16H15V7H26V19M22 15 26 19 30 15M21 19V28H30V19",
  binding: "M5 27V5H15M10 11H22V22H28M18 18 22 22 26 18M10 27H20",
  issuedPermission: "M4 5H14V27M4 13H14M14 20H27M23 16 27 20 23 24M22 5H28V11",
  permittedRealization: "M3 5H10M3 5V15M3 26H10V17H18V7H28M24 4 28 7 24 10M24 18H29V29H18",
  ruleCoupling: "M4 5V27M4 8H12V15H21M4 24H12V15M21 9V21M21 15H29",
  assignedBundle: "M4 5H28M7 5V25H12M16 5V18H21M25 5V28",
  continuingOrder: "M7 3V29M25 3V29M3 10H12V16H20V23H29M3 23H12M20 10H29",
  personRecord: "M5 5V27H27V5M5 5H10M22 5H27",
  portableRecord: "M7 3H25V25L20 29 16 25 11 29 7 25ZM2 12H12V18H21M12 8V12",
  assertion: "M4 27V7H12M4 17H12M16 7H27V18H16Z",
  registration: "M3 7H9V24H29M13 4H28V18H13ZM9 12H13",
  conditionI: "M19 9 24 12 19 16",
  conditionII: "M19 10Q27 8 24 16",
  scopedWorld: "M3 11V28H28M8 8H15V18H25V5M8 22V18H15M25 18V24",
  feedingSource: "M3 5H13M3 12H13M3 19H13M3 26H13M13 5V26M13 12H21L28 6M21 12V23H28",
  admittedOther: "M3 7V25M3 16H12M17 4V11M17 21V28M12 16H25M22 13 25 16 22 19",
  correspondence: "M3 24H11V17H19M23 4V12H29M15 8H23M19 17 23 12",
  knowledgePath: "M3 5H17V27H3ZM7 20V12H13M13 20H27M22 15 27 20 22 25",
  factive: "M25 3 29 7 25 11 21 7ZM25 2V12M17 7H21",
  warranted: "M20 28H30V14",
  enforcedBoundary: "M3 3V29M29 3V29M3 16H14M14 16 23 7M14 16 23 25M17 5 25 13M18 25H23V20",
  recordedExchange: "M4 4H28V28H4ZM8 9H14V15H8ZM20 18H25V24H20ZM14 12H22V18",
  participants: "M3 5V12H10M22 20H29V28",
  constituents: "M5 3V29M5 7H13V12H22M5 17H15M15 14H22V20H15ZM5 27H27V24",
  tracking: "M4 7H11V14H21M4 25H11V18H21M25 9V23",
  adjustedAction: "M11 18V26H28M24 22 28 26 24 30",
  constrainedAction: "M23 5H29V12H23ZM23 9H15V28M3 23H26M22 19 26 23 22 27",
  // Approved process and preservation drawings. Node motifs are mnemonics,
  // not abbreviated State, Transformation or Configuration glyphs.
  // Two disjoint equilateral node triangles; one bridge joins the first's
  // right base node to the second's apex.
  memberBridge: graph(feedsNodes, [[0, 1], [1, 2], [2, 0], [3, 4], [4, 5], [5, 3], [2, 4]]),
  // Three horizontal nodes, the last solid, with a rightward arrowhead.
  directedChain: `${graphRow(16, [2])} M23 12 27 16 23 20`,
  // Two parallel same-direction chains: the upper hollow throughout, the
  // lower with solid first and last nodes. The upper arrowhead stops outside
  // its hollow end node.
  comparisonLanes: [
    graphRow(8),
    graphRow(24, [0, 2]),
    `M23 5 ${stopOutside([23, 5], [27, 8], [28, 8])}M23 11 ${stopOutside([23, 11], [27, 8], [28, 8])}`,
    "M23 21 27 24 23 27",
  ].join(" "),
  // Two and three open 60-degree sectors around one filled pivot.
  twoPivotSectors: pivotSectors(2),
  threePivotSectors: pivotSectors(3),
  // One input continues to a corner arrowhead; the other meets a transverse stop.
  selectiveBranch: "M3 16H12L24 6M12 16 24 26M21 29 27 23M19 6H24V11",
  // Approved identity, applicability and expression drawings. These are
  // term-specific mnemonics, not a compositional grammar.
  // Entity completes the open pivot fan: six sectors, six distinct hollow
  // endpoints, no closing edges.
  sixPivotSectors: graph([[16, 16], ...sixSpokeEnds], sixSpokeEnds.map((_, i) => [0, i + 1]), [0]),
  // A box with a solid node, an unarrowed connector, and a separate bracket
  // grouping three hollow outside members.
  externalSet: [
    "M3 10H15V22H3Z",
    solidNode([9, 16]),
    "M15 16H24.5M21 6V26M21 6H24.5M21 26H24.5",
    ...[[27, 6], [27, 16], [27, 26]].map(hollowNode),
  ].join(" "),
  // Upper and lower spans over three solid member dots.
  coverageSpan: ["M4 10V5H28V10M4 22V27H28V22", ...[[7, 16], [16, 16], [25, 16]].map(solidNode)].join(" "),
  // A sheet with a condition line, a route and a transverse result mark.
  testSheet: `${sheet}M9 10H23M9 16H16M16 16L23 22M20 25L26 19`,
  // A sheet containing a maps-to expression.
  mappingSheet: `${sheet} M8 10V22M8 16H23${arrowHead([8, 16], [23, 16])}`,
  // A trace from a hollow target node into a separate token box.
  traceToken: `${hollowNode([4, 16])} M7 16H21${arrowHead([7, 16], [21, 16])} M22 9H29V23H22Z`,
};

const alphabet = {
  // Standalone conventional name, not a slot, ground or relation.
  Absence: ["foot"],
  Presence: ["ring", "dot"],
  Missingness: ["ring"],
  Reality: ["inversePresence"],
  Difference: ["bars", "slash"],
  Relation: ["bars", "association"],
  Denotation: ["denotes"],
  Configuration: ["members", "memberLinks"],
  State: ["stateOverlap"],
  Direction: ["up", "foot"],
  Transformation: ["transformationEdge"],
  // Plain delta: the conventional finite-change cue, without a slash.
  Change: ["triangle"],
  Feeds: ["memberBridge"],
  CausalPath: ["directedChain"],
  CausalContribution: ["comparisonLanes"],
  Invariant: ["twoPivotSectors"],
  Persistence: ["threePivotSectors"],
  Constraint: ["selectiveBranch"],
  Entity: ["sixPivotSectors"],
  Boundary: ["diamond", "echo"],
  Environment: ["externalSet"],
  Representation: ["square", "dot"],
  Scope: ["coverageSpan"],
  Specification: ["testSheet"],
  Rule: ["mappingSheet"],
  Sign: ["traceToken"],
  Symbol: ["diamond", "star"],
  Language: ["rails", "cross", "cap"],
  Map: ["partialMap"],
  Reference: ["partialMap", "comparison"],
  Sense: ["uptake"],
  Perception: ["eye", "dot"],
  Record: ["square", "step"],
  Observation: ["tracedRecord"],
  Memory: ["vessel", "bars"],
  Model: ["structuredModel"],
  Action: ["arrow", "roots"],
  Consequence: ["endpoint"],
  Interpretation: ["eye", "chevron"],
  Agent: ["triangle", "axis"],
  Agency: ["interpretedAction"],
  Tool: ["rails", "bar", "hooks"],
  Capability: ["realizable"],
  Interior: ["vessel", "dot"],
  Exposure: ["open", "wings"],
  Flow: ["wave", "rails"],
  Interface: ["portFrame", "ordered"],
  Claim: ["gate", "dot"],
  Witness: ["eye", "foot"],
  Control: ["routing"],
  Order: ["rails", "bar", "cap", "foot"],
  Standing: ["placement"],
  Recognition: ["recordedPlacement"],
  Principal: ["ring", "axis", "party"],
  ActsFor: ["triangle", "arrow"],
  CountsAs: ["statusAssignment"],
  Authority: ["binding"],
  PermissionClaim: ["gate", "dot", "wings"],
  Declaration: ["tree", "cap"],
  Grant: ["issuedPermission"],
  Admission: ["gate", "chevron"],
  Permission: ["gate", "up"],
  Revocation: ["gate", "slash"],
  PermissionExercise: ["gate", "arrow"],
  Exercisability: ["permittedRealization"],
  Enforcement: ["ruleCoupling"],
  Role: ["assignedBundle"],
  AdmissibilityRule: ["gate", "chevron", "foot"],
  IndependentFor: ["rails", "dot", "wings"],
  Evidence: ["tracedRecord", "admittedRecord"],
  EvidentialBearing: ["eye", "arrow"],
  Attestation: ["eye", "cap", "foot"],
  Institution: ["continuingOrder"],
  Center: ["ring", "star"],
  Organ: ["ring", "cross", "ticks"],
  CanonicalSystem: ["square", "tree"],
  ShadowSystem: ["frame", "tree"],
  Person: ["ring", "axis", "personRecord"],
  Receipt: ["portableRecord"],
  Ledger: ["square", "rails", "bars"],
  Polity: ["arch", "tree", "foot"],
  ConstituentExercise: ["gate", "arrow", "roots"],
  ConstituentPower: ["realizable", "echo"],
  ConsciousnessAttribution: ["assertion", "conditionI"],
  ConsciousnessDesignation: ["registration", "conditionI"],
  Operationalization: ["square", "arrow", "seed"],
  World: ["scopedWorld"],
  Substrate: ["feedingSource"],
  Truth: ["diamond", "axis", "dot"],
  Trust: ["admittedOther"],
  Alignment: ["correspondence"],
  Intelligence: ["eye", "fork"],
  OperativeKnowledge: ["knowledgePath"],
  KnowledgeTransmission: ["square", "wave", "arrow"],
  FactiveOperativeKnowledge: ["knowledgePath", "factive"],
  WarrantedKnowledge: ["knowledgePath", "factive", "warranted"],
  MoralStatusAttribution: ["assertion", "conditionII"],
  MoralPersonhoodDesignation: ["registration", "conditionII"],
  ConstituentSovereignty: ["gate", "crown", "roots"],
  ConstitutedSovereignty: ["gate", "crown", "foot"],
  BoundarySovereignty: ["enforcedBoundary"],
  ExternalSovereignty: ["open", "crown", "wings"],
  Preference: ["chevron", "axis", "wings"],
  UtilityMeasure: ["rails", "step", "foot"],
  Price: ["recordedExchange"],
  Ritual: ["double", "axis"],
  Meaning: ["double", "participants"],
  Body: ["constituents"],
  BodilyOrganization: ["vessel", "tree", "bars"],
  EmbodiedPerspective: ["vessel", "eye", "axis"],
  RecurrentIntegration: ["double", "bar", "echo"],
  InternalActivitySelection: ["vessel", "fork", "dot"],
  Attention: ["tracking"],
  Care: ["tracking", "adjustedAction"],
  Respect: ["constrainedAction"],
  // Append the slot; the registry places Identity immediately after Presence.
  Identity: ["bars"],
  // Append the slot; the registry places Set before Configuration.
  Set: ["members"],
  // The legacy Order key/slot still denotes Coordination Order.
  MathematicalOrder: ["members", "partialOrder"],
};

// Private-use slots are font-local, not Unicode assignments. Preserve this
// catalog's order; append new entries rather than reassigning existing slots.
// Organon IDs, not code points, remain the interchange identity.
export const glyphs = Object.entries(alphabet).map(([term, motifs], index) => ({
  term,
  id: `organon:${term}`,
  codepoint: 0xe000 + index,
  motifs,
  path: motifs.map((motif) => strokes[motif]).join(" "),
}));
