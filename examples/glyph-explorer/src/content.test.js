import { test } from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";
import { termMatcher, mathFor, locality } from "./content.js";
import { glyphs } from "../../../proposals/glyph-catalog.mjs";

const { terms } = JSON.parse(
  fs.readFileSync(new URL("./data.json", import.meta.url)),
);
const agency = terms.find((t) => t.id === "organon:Agency");

test("longest term wins; plurals link without matching word fragments", () => {
  const parts = termMatcher(terms)(
    "Permission Claim and Entities have Actions, not actionable fractions.",
  );
  assert.deepEqual(
    parts.filter((p) => p.term).map((p) => p.term.id),
    ["organon:PermissionClaim", "organon:Entity", "organon:Action"],
  );
});

test("missing algebra never becomes an invented equivalence or conjunction", () => {
  const expression = mathFor(agency, terms);
  assert.ok(expression.includes("operatorname{vocab}"));
  assert.ok(!expression.includes("land") && !expression.includes("iff"));
  const entity = terms.find((t) => t.id === "organon:Entity");
  assert.ok(mathFor(entity, terms).includes("PersistenceWitness"));
});

test("local graph has both incoming prerequisites and outgoing dependents", () => {
  const graph = locality(agency, terms);
  assert.deepEqual(
    graph.dependencies.map((t) => t.id),
    [
      "organon:Relation",
      "organon:Agent",
      "organon:Interpretation",
      "organon:Action",
    ],
  );
  assert.ok(graph.dependents.some((t) => t.id === "organon:Respect"));
  assert.ok(!graph.dependents.some((t) => t.id === "organon:Relation"));
});

test("all 115 definitions preserve source ordering and carry a glyph assessment", () => {
  assert.equal(terms.length, 115);
  assert.equal(terms[0].id, "organon:Absence");
  assert.equal(terms.at(-1).id, "organon:Respect");
  assert.ok(terms.every((t) => t.statement.startsWith(`**${t.label}**`)));
  assert.ok(terms.every((t) => `organon:${t.glyphReview.term}` === t.id));
  assert.ok(terms.every((t) => ["trial", "revise"].includes(t.glyphReview.verdict)));
  assert.equal(terms.filter((t) => t.form).length, 9);
});

test("every term has its own shared glyph and private-use font slot", () => {
  assert.deepEqual(glyphs.map((g) => g.id), terms.map((t) => t.id));
  assert.equal(new Set(glyphs.map((g) => g.path)).size, terms.length);
  assert.equal(new Set(glyphs.map((g) => g.codepoint)).size, terms.length);
  assert.ok(glyphs.every((g) => g.codepoint >= 0xe000 && g.codepoint <= 0xf8ff));
  assert.ok(glyphs.every((g) => g.path.startsWith("M") && !g.path.includes("undefined")));
});
