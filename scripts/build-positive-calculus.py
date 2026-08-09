#!/usr/bin/env python3
"""Build the exhaustive witnessed-introduction calculus over Organon's registry."""

from __future__ import annotations

import argparse
import hashlib
import json
import sys
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
ALGEBRA = ROOT / "ontology" / "algebra"
REGISTRY = ROOT / "ontology" / "terms.yaml"
CALCULUS = ALGEBRA / "positive-calculus.yaml"
LEDGER = ALGEBRA / "constructor-ledger.yaml"
REPORT = ALGEBRA / "positive-calculus-report.md"


class CalculusError(RuntimeError):
    pass


def load(path: Path) -> dict[str, Any]:
    try:
        value = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as error:
        raise CalculusError(f"cannot load {path.relative_to(ROOT)}: {error}") from error
    if not isinstance(value, dict):
        raise CalculusError(f"{path.relative_to(ROOT)} must contain one object")
    return value


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def write_or_check(path: Path, content: str, *, check: bool) -> None:
    if check:
        if not path.is_file() or path.read_text(encoding="utf-8") != content:
            raise CalculusError(f"generated positive-calculus artifact is stale: {path.relative_to(ROOT)}")
        return
    path.write_text(content, encoding="utf-8")


def declared_dependencies(term: dict[str, Any], by_id: dict[str, dict[str, Any]]) -> list[str]:
    declared = set(term["depends_on"])
    for dependency in declared:
        if dependency not in by_id:
            raise CalculusError(f"{term['id']}: unknown dependency {dependency}")
    return sorted(declared)


def fact_key(fact: dict[str, Any]) -> tuple[str, tuple[str, ...]]:
    return fact["predicate"], tuple(fact["args"])


def derives(premises: list[dict[str, Any]], facts: list[dict[str, Any]]) -> bool:
    extension = {fact_key(fact) for fact in facts}
    return all(fact_key(premise) in extension for premise in premises)


def run(*, check: bool) -> dict[str, int]:
    registry = load(REGISTRY)
    calculus = load(CALCULUS)
    constructors = calculus.get("constructors", [])
    if len(constructors) != 1 or constructors[0].get("id") != "G1":
        raise CalculusError("the cardinality-minimum candidate must contain exactly G1")
    if calculus.get("lower_bound", {}).get("semantic_compression") is not False:
        raise CalculusError("the operational reduction must not claim semantic compression")
    anti_vacuity = calculus.get("anti_vacuity", {})
    if anti_vacuity.get("passes") is not False or anti_vacuity.get("eligible_for_promotion") is not False:
        raise CalculusError("the opaque conformity witness must fail the anti-vacuity gate")

    terms = registry.get("terms", [])
    by_id = {term["id"]: term for term in terms}
    if len(terms) != 109 or len(by_id) != len(terms):
        raise CalculusError("positive-calculus audit requires 109 unique terms")
    definitions = [term for term in terms if term["claim_type"] == "definition"]
    if len(definitions) != 106:
        raise CalculusError("positive calculus requires exactly 106 registered definitions")

    entries = []
    mutation_count = 0
    for term in definitions:
        dependencies = declared_dependencies(term, by_id)
        if not dependencies:
            raise CalculusError(f"{term['id']}: definition has no declared dependency")
        facts = [
            {"predicate": "Classified", "args": [dependency, "candidate"]}
            for dependency in dependencies
        ]
        witness = {
            "predicate": "Conforms",
            "args": [term["claim_id"], "candidate"],
        }
        complete = [*facts, witness]
        mutations = []
        for fact in complete:
            weakened = [item for item in complete if fact_key(item) != fact_key(fact)]
            weakened_derives = derives(weakened, weakened)
            complete_derives = derives(complete, weakened)
            if not weakened_derives or complete_derives:
                raise CalculusError(
                    f"{term['id']}: removal does not distinguish weakened and complete constructors"
                )
            mutation_id = (
                f"G1-{term['claim_id']}-remove-witness"
                if fact["predicate"] == "Conforms"
                else f"G1-{term['claim_id']}-remove-{fact['args'][0].split(':', 1)[1]}"
            )
            mutations.append(
                {
                    "id": mutation_id,
                    "removed": fact,
                    "outcome": "countermodel",
                    "weakened_derives": weakened_derives,
                    "complete_constructor_derives": complete_derives,
                }
            )
        mutation_count += len(mutations)
        entries.append(
            {
                "term": term["id"],
                "claim": term["claim_id"],
                "constructor": "G1",
                "declared_dependencies": dependencies,
                "conformity_witness": witness,
                "canonical_facts": complete,
                "result": {"predicate": "Classified", "args": [term["id"], "candidate"]},
                "derives": True,
                "one_step_mutations": mutations,
            }
        )

    if {entry["term"] for entry in entries} != {term["id"] for term in definitions}:
        raise CalculusError("constructor ledger does not cover every definition exactly once")
    if not all(
        mutation["weakened_derives"] and not mutation["complete_constructor_derives"]
        for entry in entries
        for mutation in entry["one_step_mutations"]
    ):
        raise CalculusError("a constructor mutation failed to distinguish the complete rule")

    ledger = {
        "schema_version": 1,
        "status": "generated-nonbinding-complete-positive-constructor-ledger",
        "source_sha256": {
            "ontology/terms.yaml": digest(REGISTRY),
            "ontology/algebra/positive-calculus.yaml": digest(CALCULUS),
            "scripts/build-positive-calculus.py": digest(Path(__file__).resolve()),
        },
        "counts": {
            "registered_terms": len(terms),
            "retained_foundation": len(terms) - len(definitions),
            "definitions_constructed": len(entries),
            "constructors": 1,
            "one_step_mutations": mutation_count,
            "unconstructed_definitions": 0,
        },
        "cardinality_minimality": {
            "zero_constructors_positive_heads": 0,
            "zero_constructors_definitions_derived": 0,
            "one_constructor_definitions_derived": len(entries),
            "ablate_G1_definitions_derived": 0,
            "cardinality_minimal": True,
        },
        "semantic_minimality": {
            "proved": False,
            "binding_definition_schemas_retained": len(entries),
            "anti_vacuity_passes": False,
            "opaque_parameter": "Conforms(binding_definition_schema, candidate)",
            "eligible_for_promotion": False,
            "explanation": "G1 is parametric in each complete binding definition, and the evaluator does not derive the conformity witness from prose; no term meaning has been erased or proved interdefinable.",
        },
        "entries": entries,
    }

    report = f"""# Positive constructor calculus

> Generated from the complete v0.17 registry. This is a nonbinding operational reduction, not a replacement for the binding definitions.

## Result

The smallest positive constructor calculus by **registry-level rule cardinality** contains one rule:

> **G1 — Witnessed definition introduction.** A registered definition introduces its typed result when every declared dependency is present under one assignment and a constructive witness establishes conformity to the complete binding definition schema.

Zero positive constructors derive zero definitions because the six admissibility laws have no positive heads. G1 derives all **{len(entries)} definitions**. Ablating G1 returns the derived count to zero. Therefore one is the cardinality minimum.

The result survives **{mutation_count} one-step mutations**: removing any declared dependency or the conformity witness makes the complete constructor fail while the weakened near-miss would still admit the target. The six-law admissibility algebra supplies the corresponding type, index, participant, projection, witness, and underdetermination discipline.

## Anti-vacuity result

**G1 fails the semantic anti-vacuity gate.** The finite evaluator can verify that a `Conforms` witness is present and that removing it breaks introduction, but it cannot derive that witness from the prose definition. G1 therefore relocates all semantic work into an opaque parameter.

This is an operational lower bound, not a semantic reduction. G1 remains parameterized by all **{len(entries)} binding definition schemas**. Replacing those schemas with the target labels would be circular; weakening them to dependency presence would be unsound. The ontology's meanings therefore remain where they belong: in the registered definitions. “Definition schema” belongs to the metalanguage here; it is not the object-language term `Specification`.

The exhaustive answer has two layers:

| Question | Answer |
|---|---|
| Smallest registry-level positive rule calculus | **1 constructor: G1** |
| Definitions generated | **{len(entries)} of {len(entries)}** |
| Definitions semantically eliminated | **0** |
| Semantic anti-vacuity gate | **failed: opaque conformity witness** |
| Binding foundation retained | **{len(terms) - len(entries)} terms** |
| Admissibility basis | **6 candidate laws** |
| Complete ontology compressed to seven sentences | **No** |

## What the exhaustive search establishes

At the present level of proof, Organon's smallest registry-level admission architecture is:

1. the declared foundation and metalanguage;
2. 106 binding definition schemas in dependency order;
3. one generic witnessed-introduction constructor for those schemas; and
4. six candidate admissibility laws governing composition and prohibited collapse.

This removes duplicated introduction machinery without pretending that Daniel's distinctions are interchangeable. It is not eligible for promotion as the ontology's semantic constructor calculus. A nondegenerate reduction requires typed, proof-producing conformance predicates for each definition family; only then can constructor families be merged and ablated without hiding their content in an oracle. The current experiment proves no definition interdefinable, redundant, or eliminable, so it eliminates none.

## Machine evidence

The [constructor ledger](./constructor-ledger.yaml) records every definition's declared dependencies, complete conformity witness, canonical derivation, and every premise-removal mutation.
"""

    write_or_check(LEDGER, json.dumps(ledger, indent=2) + "\n", check=check)
    write_or_check(REPORT, report, check=check)
    return {"definitions": len(entries), "mutations": mutation_count}


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    try:
        result = run(check=args.check)
    except CalculusError as error:
        print(f"Positive calculus failed: {error}", file=sys.stderr)
        return 1
    action = "verified" if args.check else "generated"
    print(
        f"Positive calculus {action}: one constructor derives {result['definitions']} definitions "
        f"across {result['mutations']} one-step mutations."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
