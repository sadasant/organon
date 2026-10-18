import { test } from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";
import katex from "katex";
import React from "react";
import { renderToStaticMarkup } from "react-dom/server";
import { MemoryRouter } from "react-router-dom";
import { createServer } from "vite";
import { termMatcher, locality, ontologyGraph } from "./content.js";
import {
  leanTex,
  declarationMath,
  parameterMath,
  mathRenderOptions,
} from "./lean-math.js";
import { glyphs } from "../../../proposals/glyph-catalog.mjs";
import diagrams from "./diagrams/index.js";

const { terms } = JSON.parse(
  fs.readFileSync(new URL("./data.json", import.meta.url)),
);
const agency = terms.find((t) => t.id === "organon:Agency");

test("every term has a nonbinding diagram and working, notation-preserving review navigation", async () => {
  const custom = [
    "organon:Transformation",
    "organon:Feeds",
    "organon:CausalPath",
  ];
  assert.deepEqual(
    Object.keys(diagrams).sort(),
    terms
      .map((t) => t.id)
      .filter((id) => !custom.includes(id))
      .sort(),
  );
  const ids = new Set(terms.map((t) => t.id));
  for (const card of Object.values(diagrams)) {
    assert.ok(
      ["specification", "relational", "foundation"].includes(card.kind),
    );
    assert.ok(
      card.title && card.reading && card.note && card.conditions.length,
    );
    assert.ok(
      card.kind === "foundation"
        ? card.ports.length === 0
        : card.ports.length >= 2,
    );
    for (const port of card.ports) {
      assert.ok(port.label && (!port.term || ids.has(port.term)));
    }
    if (card.kind === "specification") {
      assert.ok(card.structure.context && card.structure.edges.length);
      const participants = new Set(card.structure.nodes.map((node) => node.id));
      assert.equal(participants.size, card.structure.nodes.length);
      for (const edge of card.structure.edges) {
        assert.ok(participants.has(edge.from) && participants.has(edge.to));
        assert.ok(
          edge.label &&
            [
              "role",
              "causal",
              "denotation",
              "identity",
              "membership",
              "comparison",
              "constraint",
            ].includes(edge.kind),
        );
      }
    }
  }
  const server = await createServer({
    server: { middlewareMode: true },
    appType: "custom",
    optimizeDeps: { noDiscovery: true, include: [] },
  });
  try {
    const { default: StringDiagram } = await server.ssrLoadModule(
      "/src/StringDiagram.jsx",
    );
    const render = (term, notation) =>
      renderToStaticMarkup(
        React.createElement(
          MemoryRouter,
          null,
          React.createElement(StringDiagram, {
            term,
            terms,
            search: `?text=${notation}&view=string`,
          }),
        ),
      );
    for (const [index, term] of terms.entries()) {
      for (const notation of ["english", "glyphs"]) {
        const html = render(term, notation);
        assert.match(html, /<figure>/, term.id);
        assert.doesNotMatch(
          html,
          /No string diagram modeled|undefined|NaN/,
          term.id,
        );
        assert.match(html, /Illustrative notation · nonbinding/);
        assert.ok(html.includes(`Diagram ${index + 1} of ${terms.length}`));
        assert.equal([...html.matchAll(/<option /g)].length, terms.length);
        const previous = terms[(index + terms.length - 1) % terms.length];
        const next = terms[(index + 1) % terms.length];
        for (const target of [previous, next]) {
          assert.ok(
            html.includes(
              `/term/${target.slug}?text=${notation}&amp;view=string`,
            ),
          );
        }
        for (const match of html.matchAll(
          /href="\/term\/([^?]+)\?([^\"]+)"/g,
        )) {
          assert.ok(
            terms.some((t) => t.slug === match[1]),
            match[1],
          );
          assert.ok(
            match[2].includes(`text=${notation}`) &&
              match[2].includes("view=string"),
          );
        }
      }
    }
    for (const [id, meaning] of [
      [
        "Transformation",
        /T maps input State s₀ to output State s₁ under Direction d/,
      ],
      ["Feeds", /The States need not be equal/],
      ["CausalPath", /Both Transformations share Direction d/],
    ]) {
      const html = render(
        terms.find((t) => t.id === `organon:${id}`),
        "english",
      );
      assert.match(html, /role="img" aria-labelledby="[^"]+"/);
      assert.match(html, meaning);
    }
    const absence = render(
      terms.find((t) => t.id === "organon:Absence"),
      "english",
    );
    assert.match(absence, /foundational distinction, no process asserted/);
    assert.doesNotMatch(absence, /roles joined|stated sequence/);
    for (const [id, obligations] of [
      [
        "CausalContribution",
        [
          /Two comparison paths/,
          /all other stated inputs match/,
          /named downstream Change/,
        ],
      ],
      [
        "RecurrentIntegration",
        [
          /First contribution witness/,
          /Return contribution witness/,
          /C₂ begins later than C₁’s downstream Change/,
          /not a closed time loop/,
        ],
      ],
      [
        "InternalActivitySelection",
        [
          /ΔR is the named upstream Difference Δin of C/,
          /Denotation →/,
          /Identity =/,
          /contrasting possibilities, not asserted executions/,
        ],
      ],
      [
        "Configuration",
        [
          /participants and labelled relationships/,
          /the same relationships in a narrow layout/,
          /All accompanying conditions still apply/,
        ],
      ],
    ]) {
      const html = render(
        terms.find((t) => t.id === `organon:${id}`),
        "english",
      );
      for (const obligation of obligations) assert.match(html, obligation, id);
      assert.doesNotMatch(html, /Role wires · associations/);
    }
  } finally {
    await server.close();
  }
});

test("longest term wins; plurals link without matching word fragments", () => {
  const parts = termMatcher(terms)(
    "Permission Claim and Entities have Actions, not actionable fractions.",
  );
  assert.deepEqual(
    parts.filter((p) => p.term).map((p) => p.term.id),
    ["organon:PermissionClaim", "organon:Entity", "organon:Action"],
  );
});

test("current labels outrank legacy IDs and lowercase metalanguage stays literal", () => {
  const source =
    "Order, Orders, Coordination Order, Coordination Orders; binary relation on a set, not Relation or Set.";
  for (const catalog of [terms, [...terms].reverse()]) {
    const parts = termMatcher(catalog)(source);
    assert.equal(parts.map((p) => p.text).join(""), source);
    assert.deepEqual(
      parts.filter((p) => p.term).map((p) => p.term.id),
      [
        "organon:MathematicalOrder",
        "organon:MathematicalOrder",
        "organon:Order",
        "organon:Order",
        "organon:Relation",
        "organon:Set",
      ],
    );
  }
});

test("every catalog expression renders, with full signatures and source excerpts", () => {
  for (const term of terms) {
    const math = term.math;
    if (math.status === "unencoded") {
      assert.equal(math.declarations.length, 0);
      assert.ok(math.note);
      continue;
    }
    assert.ok(math.declarations.length > 0);
    for (const declaration of math.declarations) {
      const source = fs.readFileSync(
        new URL(`../../../${declaration.path}`, import.meta.url),
        "utf8",
      );
      assert.equal(
        source
          .split("\n")
          .slice(declaration.line - 1, declaration.endLine)
          .join("\n")
          .trimEnd(),
        declaration.source,
      );
      for (const expression of [
        declarationMath(declaration),
        parameterMath(declaration),
      ]) {
        if (expression)
          assert.doesNotThrow(
            () =>
              katex.renderToString(expression, {
                throwOnError: true,
                strict: "error",
              }),
            term.id,
          );
      }
    }
    assert.doesNotThrow(
      () =>
        katex.renderToString(declarationMath(math.declarations[0], math), {
          throwOnError: true,
          strict: "error",
        }),
      term.id,
    );
  }
});

test("math preserves exact joins and current revision predicates rather than historical names", () => {
  const expression = declarationMath(agency.math.declarations[0]);
  const visible = katex
    .renderToString(expression, { output: "mathml" })
    .replace(/<annotation[\s\S]*?<\/annotation>/g, "")
    .replace(/<[^>]+>|\s/g, "");
  assert.ok(
    visible.includes("contribution=agent.interpretation.actionContribution"),
  );
  assert.ok(
    visible.includes(
      "contribution.rightEndpoints.last=agent.action.transformation",
    ),
  );
  for (const [name, module, predicate] of [
    ["Attention", "AttentionRevision", "tracks"],
    ["Care", "CareRevision", "responsive"],
    ["Respect", "RespectRevision", "admitted"],
  ]) {
    const math = terms.find((t) => t.id === `organon:${name}`).math;
    assert.equal(math.module, module);
    assert.equal(math.name, predicate);
    assert.equal(math.status, "projection");
  }
  const attention = declarationMath(
    terms.find((t) => t.id === "organon:Attention").math.declarations[0],
  );
  for (const token of ["\\exists", "\\forall", "\\ne", "\\land", "\\to"])
    assert.ok(attention.includes(token));
  const language = terms.find((t) => t.id === "organon:Language").math;
  const parameter = declarationMath(language.declarations[0], language);
  assert.ok(parameter.includes(leanTex("Language : Type v")));
  assert.ok(!parameter.includes("\\coloneqq"));
  const configuration = terms.find(
    (t) => t.id === "organon:Configuration",
  ).math;
  const structure = declarationMath(
    configuration.declarations[0],
    configuration,
  );
  for (const datum of ["members", "associations", "realizes"])
    assert.ok(
      structure.includes(leanTex(datum)),
      `Configuration must display ${datum}`,
    );
  assert.throws(() => leanTex("x ⊗ y"), /Unreviewed/);
});

test("glyph mathematics uses the shared alphabet without collapsing variable identities", () => {
  const source = "Agent agent agent2 actionContribution Agentive ∧ Action";
  const html = katex.renderToString(leanTex(source, true), mathRenderOptions);
  for (const id of ["Agent", "Action"]) {
    const glyph = glyphs.find((g) => g.id === `organon:${id}`);
    assert.ok(html.includes(String.fromCodePoint(glyph.codepoint)));
  }
  for (const name of ["agent", "agent2", "actionContribution", "Agentive"])
    assert.ok(leanTex(source, true).includes(`\\mathit{${name}}`));
  assert.ok(!leanTex(source).includes("math-glyph"));
  for (const term of terms) {
    for (const [index, declaration] of term.math.declarations.entries()) {
      for (const expression of [
        declarationMath(declaration, index === 0 ? term.math : {}, true),
        parameterMath(declaration, true),
      ]) {
        if (expression)
          assert.doesNotThrow(
            () => katex.renderToString(expression, mathRenderOptions),
            term.id,
          );
      }
    }
  }
});

test("local graph retains cross-links, not just edges incident on the selected term", () => {
  const graph = locality(agency, terms);
  const hasEdge = (from, to) =>
    graph.edges.some(
      (e) => e.source === `organon:${from}` && e.target === `organon:${to}`,
    );
  assert.ok(hasEdge("Action", "Agency"));
  assert.ok(hasEdge("Agency", "Respect"));
  assert.ok(hasEdge("Action", "Interpretation"));
  assert.ok(hasEdge("Interpretation", "Agent"));
  assert.ok(!hasEdge("Agency", "Action"));
  assert.ok(!hasEdge("Relation", "Action"));
  assert.ok(!graph.nodes.some((t) => t.id === "organon:Absence"));
});

test("the full view is one acyclic connected graph within Presence; Absence stays outside", () => {
  const { nodes, edges } = ontologyGraph(terms);
  assert.equal(nodes.length, terms.length - 1);
  const seen = new Set(["organon:Presence"]);
  // The repository's order is topological. This also rejects reversed edges
  // and accidental disconnected terms, rather than assuming the DAG claim.
  for (const node of nodes) {
    const incoming = edges.filter((e) => e.target === node.id);
    assert.ok(incoming.every((e) => seen.has(e.source)));
    if (node.id !== "organon:Presence") assert.ok(incoming.length > 0);
    seen.add(node.id);
    const local = locality(node, terms);
    const ids = new Set(local.nodes.map((t) => t.id));
    assert.deepEqual(
      local.edges,
      edges.filter((e) => ids.has(e.source) && ids.has(e.target)),
    );
  }
  const absence = terms.find((t) => t.id === "organon:Absence");
  assert.deepEqual(locality(absence, terms), { nodes: [absence], edges: [] });
  assert.ok(
    terms
      .find((t) => t.id === "organon:Presence")
      .depends_on.includes(absence.id),
  );
});

test("all definitions preserve source ordering and carry a glyph assessment", () => {
  assert.equal(terms.length, 118);
  assert.equal(terms[0].id, "organon:Absence");
  assert.equal(terms[2].id, "organon:Identity");
  assert.equal(terms[8].id, "organon:Set");
  assert.equal(terms[9].id, "organon:MathematicalOrder");
  assert.equal(terms[9].label, "Order");
  assert.equal(terms[10].id, "organon:Configuration");
  assert.equal(
    terms.find((t) => t.id === "organon:Order").label,
    "Coordination Order",
  );
  assert.equal(terms.at(-1).id, "organon:Respect");
  assert.ok(terms.every((t) => t.statement.startsWith(`**${t.label}**`)));
  assert.ok(terms.every((t) => `organon:${t.glyphReview.term}` === t.id));
  assert.ok(
    terms.every((t) =>
      ["trial", "revised", "revise"].includes(t.glyphReview.verdict),
    ),
  );
  assert.ok(terms.every((t) => t.math));
});

test("every term has its own shared glyph and private-use font slot", () => {
  assert.deepEqual(
    glyphs.map((g) => g.id).sort(),
    terms.map((t) => t.id).sort(),
  );
  // New terms in canonical order must not shift already published font slots.
  for (const [name, codepoint] of [
    ["Presence", 0xe001],
    ["Missingness", 0xe002],
    ["Respect", 0xe072],
    ["Identity", 0xe073],
    ["Set", 0xe074],
    ["MathematicalOrder", 0xe075],
  ])
    assert.equal(glyphs.find((g) => g.term === name).codepoint, codepoint);
  assert.equal(new Set(glyphs.map((g) => g.path)).size, terms.length);
  assert.equal(new Set(glyphs.map((g) => g.codepoint)).size, terms.length);
  assert.ok(
    glyphs.every((g) => g.codepoint >= 0xe000 && g.codepoint <= 0xf8ff),
  );
  assert.ok(
    glyphs.every(
      (g) => g.path.startsWith("M") && !g.path.includes("undefined"),
    ),
  );
});
