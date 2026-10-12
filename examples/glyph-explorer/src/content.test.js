import { test } from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";
import { termMatcher, mathFor, locality } from "./content.js";

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

test("all 115 definitions preserve source ordering and only trial glyphs display", () => {
  assert.equal(terms.length, 115);
  assert.equal(terms[0].id, "organon:Absence");
  assert.equal(terms.at(-1).id, "organon:Respect");
  assert.ok(terms.every((t) => t.statement.startsWith(`**${t.label}**`)));
  assert.ok(terms.every((t) => !t.glyph || t.glyphVerdict === "trial"));
  assert.equal(terms.filter((t) => t.form).length, 9);
});
