#!/usr/bin/env python3
"""Build and verify the nonbinding Organon algebra experiment."""

from __future__ import annotations

import argparse
import copy
import hashlib
import json
import subprocess
import sys
from collections import Counter, defaultdict
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
ALGEBRA = ROOT / "ontology" / "algebra"
NORMAL_FORMS = ALGEBRA / "normal-forms.yaml"
PREDICATE_SIGNATURES = ALGEBRA / "predicate-signatures.yaml"
LAWS = ALGEBRA / "candidate-laws.yaml"
CONNECTIVES = ALGEBRA / "connective-audit.yaml"
CLAIM_COVERAGE = ALGEBRA / "claim-coverage.yaml"
LOCK = ALGEBRA / "source-lock.json"
CHALLENGES = ALGEBRA / "fixtures" / "challenges.yaml"
HOLDOUTS = ALGEBRA / "fixtures" / "holdouts.yaml"
CIRCUITS = ALGEBRA / "fixtures" / "circuits.yaml"
WITNESSES = ALGEBRA / "fixtures" / "witnesses.yaml"
COUNTERMODELS = ALGEBRA / "fixtures" / "countermodels.yaml"
MUTATIONS = ALGEBRA / "mutations.yaml"
COVERAGE = ALGEBRA / "coverage.md"
REGISTRY = ROOT / "ontology" / "terms.yaml"


class AlgebraError(ValueError):
    pass


def load(path: Path) -> dict[str, Any]:
    try:
        value = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as error:
        raise AlgebraError(f"cannot load {path.relative_to(ROOT)}: {error}") from error
    if not isinstance(value, dict):
        raise AlgebraError(f"{path.relative_to(ROOT)} must contain one object")
    return value


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def sha256_path(path: Path) -> str:
    return sha256_bytes(path.read_bytes())


def atom_key(atom: dict[str, Any]) -> tuple[str, tuple[str, ...]]:
    return atom["predicate"], tuple(atom["args"])


def validate_atom(
    atom: dict[str, Any],
    variables: dict[str, str],
    signatures: dict[str, list[list[str]]],
    *,
    label: str,
) -> None:
    if set(atom) - {"id", "predicate", "args"}:
        raise AlgebraError(f"{label}: unknown atom field")
    if not isinstance(atom.get("predicate"), str) or not atom["predicate"]:
        raise AlgebraError(f"{label}: predicate is required")
    if not isinstance(atom.get("args"), list) or not atom["args"]:
        raise AlgebraError(f"{label}: nonempty args are required")
    unknown = [arg for arg in atom["args"] if arg not in variables]
    if unknown:
        raise AlgebraError(f"{label}: undeclared variables {unknown}")
    actual = [variables[arg] for arg in atom["args"]]
    allowed = signatures.get(atom["predicate"])
    if allowed is None or actual not in allowed:
        raise AlgebraError(
            f"{label}: predicate signature mismatch for {atom['predicate']}: "
            f"actual={actual}, allowed={allowed}"
        )


def validate_signatures(data: dict[str, Any]) -> dict[str, list[list[str]]]:
    signatures = data.get("signatures")
    if not isinstance(signatures, dict) or not signatures:
        raise AlgebraError("predicate signatures must be a nonempty object")
    for predicate, variants in signatures.items():
        if not isinstance(predicate, str) or not isinstance(variants, list) or not variants:
            raise AlgebraError("invalid predicate signature declaration")
        if any(not isinstance(variant, list) or not variant for variant in variants):
            raise AlgebraError(f"{predicate}: invalid signature variant")
    return signatures


def validate_ground_fact(
    fact: dict[str, Any],
    signatures: dict[str, list[list[str]]],
    *,
    label: str,
) -> None:
    kinds = [value.split(":", 1)[0] for value in fact.get("args", [])]
    allowed = signatures.get(fact.get("predicate"))
    if allowed is None or kinds not in allowed:
        raise AlgebraError(
            f"{label}: ground predicate signature mismatch for "
            f"{fact.get('predicate')}: actual={kinds}, allowed={allowed}"
        )


def unify_atom(
    atom: dict[str, Any],
    fact: dict[str, Any],
    binding: dict[str, str],
) -> dict[str, str] | None:
    if atom["predicate"] != fact["predicate"] or len(atom["args"]) != len(fact["args"]):
        return None
    result = dict(binding)
    for variable, value in zip(atom["args"], fact["args"], strict=True):
        existing = result.get(variable)
        if existing is not None and existing != value:
            return None
        result[variable] = value
    return result


def satisfying_bindings(atoms: list[dict[str, Any]], facts: list[dict[str, Any]]) -> list[dict[str, str]]:
    bindings: list[dict[str, str]] = [{}]
    for atom in atoms:
        candidates: list[dict[str, str]] = []
        for binding in bindings:
            for fact in facts:
                matched = unify_atom(atom, fact, binding)
                if matched is not None:
                    candidates.append(matched)
        bindings = candidates
        if not bindings:
            return []
    return bindings


def derives(atoms: list[dict[str, Any]], facts: list[dict[str, Any]]) -> bool:
    return bool(satisfying_bindings(atoms, facts))


def derived_results(card: dict[str, Any], facts: list[dict[str, Any]]) -> list[dict[str, Any]]:
    results: list[dict[str, Any]] = []
    for binding in satisfying_bindings(card_atoms(card), facts):
        try:
            args = [binding[variable] for variable in card["result"]["args"]]
        except KeyError as error:
            raise AlgebraError(f"{card['id']}: unsafe result variable {error.args[0]}") from error
        result = {"predicate": card["result"]["predicate"], "args": args}
        if atom_key(result) not in {atom_key(item) for item in results}:
            results.append(result)
    return results


def canonical_constants(variables: dict[str, str]) -> dict[str, str]:
    return {name: f"{kind}:{name}-a" for name, kind in variables.items()}


def ground_atoms(atoms: list[dict[str, Any]], variables: dict[str, str]) -> list[dict[str, Any]]:
    constants = canonical_constants(variables)
    return [
        {"predicate": atom["predicate"], "args": [constants[arg] for arg in atom["args"]]}
        for atom in atoms
    ]


def card_atoms(card: dict[str, Any]) -> list[dict[str, Any]]:
    return card["premises"] + card["witnesses"]


def validate_source_lock(lock: dict[str, Any]) -> None:
    commit = lock.get("repository_commit")
    if not isinstance(commit, str) or len(commit) != 40:
        raise AlgebraError("source lock requires a full repository_commit")
    for relative, expected in lock.get("sources_sha256", {}).items():
        path = ROOT / relative
        if not path.is_file() or sha256_path(path) != expected:
            raise AlgebraError(f"source lock mismatch in worktree: {relative}")
        archived = subprocess.run(
            ["git", "show", f"{commit}:{relative}"],
            cwd=ROOT,
            capture_output=True,
            check=False,
        )
        if archived.returncode != 0 or sha256_bytes(archived.stdout) != expected:
            raise AlgebraError(f"source lock mismatch at {commit[:8]}: {relative}")


def validate_cards(
    data: dict[str, Any],
    registry: dict[str, Any],
    signatures: dict[str, list[list[str]]],
) -> list[dict[str, Any]]:
    cards = data.get("cards")
    if not isinstance(cards, list) or not cards:
        raise AlgebraError("normal forms require cards")
    by_term = {term["id"]: term for term in registry["terms"]}
    ids = [card.get("id") for card in cards]
    if len(ids) != len(set(ids)):
        raise AlgebraError("duplicate normal-form card ID")
    for card in cards:
        label = card["id"]
        term = by_term.get(card.get("term_id"))
        if term is None:
            raise AlgebraError(f"{label}: unknown term_id")
        if card["result"]["predicate"] != term["label"].replace(" ", ""):
            raise AlgebraError(f"{label}: result predicate does not match registered label")
        variables = card.get("variables", {})
        if not variables or not all(isinstance(name, str) and isinstance(kind, str) for name, kind in variables.items()):
            raise AlgebraError(f"{label}: typed variables are required")
        validate_atom(card["result"], variables, signatures, label=f"{label}.result")
        participants = card.get("participants", [])
        participant_roles = card.get("participant_roles", {})
        if set(participants) != set(participant_roles) or not all(participant_roles.values()):
            raise AlgebraError(f"{label}: every participant requires one explicit role")
        if any(participant not in variables for participant in participants):
            raise AlgebraError(f"{label}: participant role references an undeclared variable")
        atom_ids: list[str] = []
        for role in ("premises", "witnesses"):
            atoms = card.get(role)
            if not isinstance(atoms, list):
                raise AlgebraError(f"{label}: {role} must be a list")
            for atom in atoms:
                if not isinstance(atom.get("id"), str):
                    raise AlgebraError(f"{label}.{role}: atom id is required")
                atom_ids.append(atom["id"])
                validate_atom(atom, variables, signatures, label=f"{label}.{atom['id']}")
        if len(atom_ids) != len(set(atom_ids)):
            raise AlgebraError(f"{label}: duplicate atom ID")
        if not card.get("positive_entailments") or not card.get("anti_entailments"):
            raise AlgebraError(f"{label}: positive and anti-entailments are required")
        allowed_negative = {
            "non_identity", "one_way_anti_entailment", "bidirectional_independence",
            "insufficiency", "index_sensitivity", "incompatibility", "missingness_without_negation",
        }
        for item in card["anti_entailments"]:
            if item.get("kind") not in allowed_negative:
                raise AlgebraError(f"{label}: unknown anti-entailment kind {item.get('kind')}")
        occurrences = Counter(arg for atom in card_atoms(card) for arg in atom["args"])
        for variable in card.get("shared_variables", []):
            if variable not in variables or occurrences[variable] < 2:
                raise AlgebraError(f"{label}: shared variable {variable} is not load-bearing in two atoms")
        policy = card.get("mutation_policy", {})
        for variable in policy.get("split_variables", []):
            if occurrences[variable] < 2:
                raise AlgebraError(f"{label}: split variable {variable} has fewer than two occurrences")
        known_atoms = set(atom_ids)
        for atom_id in policy.get("reverse_atoms", []):
            if atom_id not in known_atoms:
                raise AlgebraError(f"{label}: unknown reverse atom {atom_id}")
        for atom_id, alternatives in policy.get("substitute_atoms", {}).items():
            if atom_id not in known_atoms or not alternatives:
                raise AlgebraError(f"{label}: invalid substitution target {atom_id}")
            for alternative in alternatives:
                if not alternative.get("predicate") or not alternative.get("shape"):
                    raise AlgebraError(f"{label}: incomplete substitution for {atom_id}")
                original = next(atom for atom in card["premises"] + card["witnesses"] if atom["id"] == atom_id)
                validate_atom(
                    {"predicate": alternative["predicate"], "args": original["args"]},
                    variables,
                    signatures,
                    label=f"{label}.{atom_id}.{alternative['predicate']}",
                )
    return cards


def mutation_record(
    card: dict[str, Any],
    mutation_id: str,
    operator: str,
    shape: str,
    atoms: list[dict[str, Any]],
    variables: dict[str, str] | None = None,
) -> dict[str, Any]:
    variables = variables or card["variables"]
    facts = ground_atoms(atoms, variables)
    original_atoms = card_atoms(card)
    mutated_derives = derives(atoms, facts)
    original_derives = derives(original_atoms, facts)
    if not mutated_derives or original_derives:
        raise AlgebraError(
            f"{card['id']}/{mutation_id}: fixture must satisfy the mutation and reject the original"
        )
    return {
        "id": f"M-{card['id'][3:]}-{mutation_id}",
        "card": card["id"],
        "operator": operator,
        "failure_shapes": [shape],
        "outcome": "countermodel",
        "mutated_atoms": [{"predicate": atom["predicate"], "args": atom["args"]} for atom in atoms],
        "facts": facts,
        "mutated_derives": True,
        "original_derives": False,
    }


def generate_mutations(cards: list[dict[str, Any]]) -> list[dict[str, Any]]:
    mutations: list[dict[str, Any]] = []
    for card in cards:
        original = card_atoms(card)
        for atom in card["premises"]:
            atoms = [copy.deepcopy(item) for item in original if item["id"] != atom["id"]]
            mutations.append(mutation_record(card, f"remove-{atom['id']}", "remove_premise", "premise_omission", atoms))
        for atom in card["witnesses"]:
            atoms = [copy.deepcopy(item) for item in original if item["id"] != atom["id"]]
            mutations.append(mutation_record(card, f"remove-{atom['id']}", "remove_witness", "witness_omission", atoms))
        for variable in card["mutation_policy"].get("split_variables", []):
            atoms = copy.deepcopy(original)
            occurrences = [
                (atom_index, arg_index)
                for atom_index, atom in enumerate(atoms)
                for arg_index, argument in enumerate(atom["args"])
                if argument == variable
            ]
            split_name = f"{variable}__split"
            atom_index, arg_index = occurrences[-1]
            atoms[atom_index]["args"][arg_index] = split_name
            variables = {**card["variables"], split_name: card["variables"][variable]}
            mutations.append(mutation_record(card, f"split-{variable}", "change_shared_variable", "index_change", atoms, variables))
        by_id = {atom["id"]: atom for atom in original}
        for atom_id in card["mutation_policy"].get("reverse_atoms", []):
            atoms = copy.deepcopy(original)
            target = next(atom for atom in atoms if atom["id"] == atom_id)
            target["predicate"] = f"ReverseOf{target['predicate']}"
            target["args"] = list(reversed(target["args"]))
            mutations.append(mutation_record(card, f"reverse-{atom_id}", "reverse_relation", "role_reversal", atoms))
        for atom_id, alternatives in card["mutation_policy"].get("substitute_atoms", {}).items():
            if atom_id not in by_id:
                raise AlgebraError(f"{card['id']}: substitution references missing atom {atom_id}")
            for alternative in alternatives:
                atoms = copy.deepcopy(original)
                target = next(atom for atom in atoms if atom["id"] == atom_id)
                target["predicate"] = alternative["predicate"]
                slug = alternative["predicate"].lower().replace("_", "-")
                mutations.append(
                    mutation_record(card, f"substitute-{atom_id}-{slug}", "substitute_relation", alternative["shape"], atoms)
                )
    ids = [item["id"] for item in mutations]
    if len(ids) != len(set(ids)):
        raise AlgebraError("generated duplicate mutation IDs")
    return mutations


def validate_laws(data: dict[str, Any], cards: list[dict[str, Any]], registry: dict[str, Any]) -> list[dict[str, Any]]:
    laws = data.get("laws")
    if not isinstance(laws, list) or not laws or len(laws) > 6:
        raise AlgebraError("candidate discipline set must contain one to six entries")
    law_ids = [law.get("id") for law in laws]
    if len(law_ids) != len(set(law_ids)):
        raise AlgebraError("duplicate candidate law ID")
    card_ids = {card["id"] for card in cards}
    if set(data.get("derived_from_cards", [])) != card_ids:
        raise AlgebraError("candidate discipline training-card list must match normal forms")
    known_claims = {item["id"] for item in registry["commitments"]}
    for law in laws:
        if not law.get("blocks_shapes") or not law.get("isolating_case"):
            raise AlgebraError(f"{law['id']}: shapes and isolating case are required")
        unknown = set(law.get("candidate_claim_coverage", [])) - known_claims
        if unknown:
            raise AlgebraError(f"{law['id']}: unknown covered claims {sorted(unknown)}")
    return laws


def validate_connectives(data: dict[str, Any], registry: dict[str, Any]) -> None:
    required = data.get("required_connectives", [])
    resolutions = data.get("resolutions", [])
    names = [item.get("connective") for item in resolutions]
    if set(required) != set(names) or len(names) != len(set(names)):
        raise AlgebraError("connective audit must resolve every required connective exactly once")
    outcomes = {"existing_typed_relation", "composition", "declared_metalanguage", "new_bridge_candidate"}
    known_terms = {term["id"] for term in registry["terms"]}
    for item in resolutions:
        if item.get("resolution") not in outcomes or not item.get("constraint"):
            raise AlgebraError(f"connective {item.get('connective')}: incomplete resolution")
        unknown = set(item.get("target", [])) - known_terms
        if unknown:
            raise AlgebraError(f"connective {item['connective']}: unknown target {sorted(unknown)}")


def validate_claim_coverage(
    data: dict[str, Any],
    laws: list[dict[str, Any]],
    registry: dict[str, Any],
    evidence_ids: set[str],
) -> list[dict[str, Any]]:
    entries = data.get("entries", [])
    claims = [entry.get("claim") for entry in entries]
    if not entries or len(claims) != len(set(claims)):
        raise AlgebraError("claim coverage requires unique entries")
    known_claims = {item["id"] for item in registry["commitments"]}
    known_laws = {law["id"] for law in laws}
    by_law: dict[str, set[str]] = defaultdict(set)
    for entry in entries:
        if entry["claim"] not in known_claims or not entry.get("clause"):
            raise AlgebraError(f"claim coverage has unknown or empty entry {entry.get('claim')}")
        if not entry.get("laws") or set(entry["laws"]) - known_laws:
            raise AlgebraError(f"{entry['claim']}: invalid candidate law mapping")
        unknown_evidence = set(entry.get("evidence", [])) - evidence_ids
        if unknown_evidence:
            raise AlgebraError(f"{entry['claim']}: unknown coverage evidence {sorted(unknown_evidence)}")
        for law_id in entry["laws"]:
            by_law[law_id].add(entry["claim"])
    for law in laws:
        declared = set(law.get("candidate_claim_coverage", []))
        if declared != by_law[law["id"]]:
            raise AlgebraError(
                f"{law['id']}: claim coverage drift; declared={sorted(declared)}, "
                f"mapped={sorted(by_law[law['id']])}"
            )
    return entries


def blockers(shapes: list[str], laws: list[dict[str, Any]]) -> list[str]:
    shape_set = set(shapes)
    return [law["id"] for law in laws if shape_set & set(law["blocks_shapes"])]


def validate_challenges(data: dict[str, Any], laws: list[dict[str, Any]]) -> list[dict[str, Any]]:
    cases = data.get("cases", [])
    for case in cases:
        fact_keys = {atom_key(fact) for fact in case["facts"]}
        if atom_key(case["source"]) not in fact_keys or atom_key(case["target"]) in fact_keys:
            raise AlgebraError(f"{case['id']}: not a source-without-target labeled fixture")
        case_blockers = blockers(case["failure_shapes"], laws)
        if not case_blockers:
            raise AlgebraError(f"{case['id']}: no candidate discipline covers its assigned shape")
        case["blocked_by"] = case_blockers
    return cases


def validate_holdouts(data: dict[str, Any], laws: list[dict[str, Any]], expected_domains: list[str]) -> list[dict[str, Any]]:
    if data.get("basis_frozen_before_holdouts") is not True:
        raise AlgebraError("holdout fixture must attest basis_frozen_before_holdouts")
    if data.get("freeze_kind") != "procedural-attestation-with-current-digest":
        raise AlgebraError("holdout freeze must state its procedural evidence boundary")
    if data.get("candidate_laws_sha256") != sha256_path(LAWS):
        raise AlgebraError("holdout fixture candidate-law digest is stale")
    cases = data.get("cases", [])
    if {case["domain"] for case in cases} != set(expected_domains):
        raise AlgebraError("holdout domains do not match candidate-law declaration")
    for case in cases:
        fact_keys = {atom_key(fact) for fact in case.get("facts", [])}
        source_present = atom_key(case["source"]) in fact_keys
        target_present = atom_key(case["target"]) in fact_keys
        if not source_present:
            raise AlgebraError(f"{case['id']}: held-out source is absent from finite model")
        case_blockers = blockers(case["failure_shapes"], laws)
        expected = case["expect"]
        if expected == "blocked" and not case_blockers:
            raise AlgebraError(f"{case['id']}: unchanged basis failed to block holdout")
        if expected == "blocked" and target_present:
            raise AlgebraError(f"{case['id']}: blocked holdout already contains target")
        if expected == "licensed" and case_blockers:
            raise AlgebraError(f"{case['id']}: candidate discipline annotations cover a licensed holdout")
        if expected == "licensed" and not target_present:
            raise AlgebraError(f"{case['id']}: licensed holdout lacks target witness")
        case["blocked_by"] = case_blockers
    return cases


def validate_circuits(
    data: dict[str, Any],
    cards: list[dict[str, Any]],
    signatures: dict[str, list[list[str]]],
) -> list[dict[str, Any]]:
    circuits = data.get("circuits", [])
    by_id = {card["id"]: card for card in cards}
    ids = [circuit.get("id") for circuit in circuits]
    if len(circuits) != 3 or len(ids) != len(set(ids)):
        raise AlgebraError("exactly three unique joined circuit witnesses are required")
    for circuit in circuits:
        facts = copy.deepcopy(circuit.get("facts", []))
        for index, fact in enumerate(facts):
            validate_ground_fact(
                fact, signatures, label=f"{circuit['id']}.facts[{index}]"
            )
        for index, result in enumerate(circuit.get("expected_results", [])):
            validate_ground_fact(
                result, signatures, label=f"{circuit['id']}.expected[{index}]"
            )
        produced: list[dict[str, Any]] = []
        for step in circuit.get("steps", []):
            card = by_id.get(step)
            if card is None:
                raise AlgebraError(f"{circuit['id']}: unknown circuit step {step}")
            results = derived_results(card, facts)
            if not results:
                raise AlgebraError(f"{circuit['id']}: step {step} does not derive")
            for result in results:
                if atom_key(result) not in {atom_key(item) for item in facts}:
                    facts.append(result)
                    produced.append(result)
        expected = {atom_key(item) for item in circuit.get("expected_results", [])}
        actual = {atom_key(item) for item in produced}
        if expected != actual:
            raise AlgebraError(
                f"{circuit['id']}: circuit results differ; "
                f"missing={sorted(expected - actual)}, extra={sorted(actual - expected)}"
            )
        circuit["derived_results"] = produced
    return circuits


def validate_unique_fixtures(laws: list[dict[str, Any]], cases: list[dict[str, Any]]) -> dict[str, str]:
    by_id = {case["id"]: case for case in cases}
    results: dict[str, str] = {}
    for law in laws:
        case = by_id.get(law["isolating_case"])
        if case is None:
            raise AlgebraError(f"{law['id']}: missing isolating case {law['isolating_case']}")
        if case["blocked_by"] != [law["id"]]:
            raise AlgebraError(f"{law['id']}: isolating case is also blocked by {case['blocked_by']}")
        remaining = [candidate for candidate in laws if candidate["id"] != law["id"]]
        if blockers(case["failure_shapes"], remaining):
            raise AlgebraError(f"{law['id']}: fixture is still covered after discipline deletion")
        results[law["id"]] = f"{case['id']} is uniquely annotated by {law['id']}"
    return results


def render_coverage(
    cards: list[dict[str, Any]],
    mutations: list[dict[str, Any]],
    laws: list[dict[str, Any]],
    challenges: list[dict[str, Any]],
    holdouts: list[dict[str, Any]],
    circuits: list[dict[str, Any]],
    claim_coverage: list[dict[str, Any]],
    unique_fixtures: dict[str, str],
) -> str:
    by_card = Counter(item["card"] for item in mutations)
    by_shape = Counter(shape for item in mutations for shape in item["failure_shapes"])
    lines = [
        "# Candidate algebra coverage",
        "",
        "> Generated by `scripts/build-algebra.py`. This is nonbinding experimental evidence, not promotion of the candidate disciplines.",
        "",
        "## Frozen training surface",
        "",
        f"- Witness normal forms: {len(cards)}",
        f"- Generated one-step mutations: {len(mutations)}",
        f"- Explicit labeled inference fixtures: {len(challenges)}",
        f"- Held-out challenges: {len(holdouts)}",
        f"- Joined positive circuits: {len(circuits)}",
        "",
        "| Normal form | Mutations |",
        "|---|---:|",
    ]
    for card in cards:
        lines.append(f"| `{card['id']}` / `{card['term_id']}` | {by_card[card['id']]} |")
    lines.extend(["", "## Failure clusters", "", "| Structural shape | Generated mutations |", "|---|---:|"])
    for shape, count in sorted(by_shape.items()):
        lines.append(f"| `{shape}` | {count} |")
    lines.extend(["", "## Joined positive circuits", "", "| Circuit | Ordered cards |", "|---|---|"])
    for circuit in circuits:
        lines.append(f"| `{circuit['id']}` | {' → '.join(f'`{step}`' for step in circuit['steps'])} |")
    lines.extend(["", "## Candidate discipline taxonomy and deletion test", "", "| Discipline | Labeled shapes | Candidate consistency-rule coverage | Unique fixture |", "|---|---|---|---|"])
    for law in laws:
        lines.append(
            f"| `{law['id']}` {law['name']} | "
            f"{', '.join(f'`{shape}`' for shape in law['blocks_shapes'])} | "
            f"{', '.join(f'`{claim}`' for claim in law['candidate_claim_coverage'])} | "
            f"{unique_fixtures[law['id']]} |"
        )
    lines.extend(["", "## Clause-level candidate annotations", "", "| Claim | Candidate clause | Disciplines | Fixtures |", "|---|---|---|---|"])
    for entry in claim_coverage:
        lines.append(
            f"| `{entry['claim']}` | {entry['clause']} | "
            f"{', '.join(f'`{item}`' for item in entry['laws'])} | "
            f"{', '.join(f'`{item}`' for item in entry['evidence'])} |"
        )
    lines.extend(["", "Coverage is clause-level and annotation-based, not a proof that each consistency paragraph follows from an executable law.", "", "## Labeled inference fixtures", "", "| Case | Logical kind | Annotation maps to |", "|---|---|---|"])
    for case in challenges:
        lines.append(f"| `{case['id']}` | `{case['logical_kind']}` | {', '.join(f'`{item}`' for item in case['blocked_by'])} |")
    lines.extend(["", "## Unchanged-taxonomy holdouts", "", "| Case | Domain | Expected | Result |", "|---|---|---|---|"])
    for case in holdouts:
        result = "uncovered by taxonomy" if not case["blocked_by"] else "annotation maps to " + ", ".join(case["blocked_by"])
        lines.append(f"| `{case['id']}` | {case['domain']} | {case['expect']} | {result} |")
    lines.extend(
        [
            "",
            "The complete CountsAs holdout remains uncovered by the failure-shape taxonomy, while prohibited holdouts map to candidate disciplines without changing that taxonomy. This is annotation coverage, not independent inference execution.",
            "",
        ]
    )
    return "\n".join(lines)


def write_or_check(path: Path, content: str, *, check: bool) -> None:
    if check:
        if not path.is_file() or path.read_text(encoding="utf-8") != content:
            raise AlgebraError(f"generated algebra artifact is stale: {path.relative_to(ROOT)}")
    else:
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(content, encoding="utf-8")


def run(*, check: bool) -> dict[str, int]:
    registry = load(REGISTRY)
    lock = load(LOCK)
    validate_source_lock(lock)
    signatures = validate_signatures(load(PREDICATE_SIGNATURES))
    cards = validate_cards(load(NORMAL_FORMS), registry, signatures)
    laws_data = load(LAWS)
    laws = validate_laws(laws_data, cards, registry)
    validate_connectives(load(CONNECTIVES), registry)
    mutations = generate_mutations(cards)
    challenges = validate_challenges(load(CHALLENGES), laws)
    holdouts = validate_holdouts(load(HOLDOUTS), laws, laws_data["held_out_domains"])
    circuits = validate_circuits(load(CIRCUITS), cards, signatures)
    evidence_ids = (
        {card["id"] for card in cards}
        | {item["id"] for item in mutations}
        | {item["id"] for item in challenges}
        | {item["id"] for item in holdouts}
        | {item["id"] for item in circuits}
    )
    claim_coverage = validate_claim_coverage(
        load(CLAIM_COVERAGE), laws, registry, evidence_ids
    )
    unique_fixtures = validate_unique_fixtures(laws, challenges)

    witness_models = []
    for card in cards:
        facts = ground_atoms(card_atoms(card), card["variables"])
        if not derives(card_atoms(card), facts):
            raise AlgebraError(f"{card['id']}: canonical witness does not derive")
        witness_models.append(
            {
                "id": f"W-{card['id'][3:]}",
                "card": card["id"],
                "facts": facts,
                "result": {
                    "predicate": card["result"]["predicate"],
                    "args": [canonical_constants(card["variables"])[arg] for arg in card["result"]["args"]],
                },
                "derives": True,
            }
        )

    mutation_output = {
        "schema_version": 1,
        "status": "generated-nonbinding-syntactic-constructor-mutations",
        "source_normal_forms_sha256": sha256_path(NORMAL_FORMS),
        "generator_sha256": sha256_path(Path(__file__).resolve()),
        "mutation_count": len(mutations),
        "mutations": [
            {key: value for key, value in item.items() if key != "facts"}
            for item in mutations
        ],
    }
    witness_output = {
        "schema_version": 1,
        "status": "generated-nonbinding-positive-witnesses",
        "source_normal_forms_sha256": sha256_path(NORMAL_FORMS),
        "source_circuits_sha256": sha256_path(CIRCUITS),
        "generator_sha256": sha256_path(Path(__file__).resolve()),
        "models": witness_models,
        "joined_circuits": circuits,
    }
    countermodel_output = {
        "schema_version": 1,
        "status": "generated-nonbinding-structural-near-miss-models",
        "source_normal_forms_sha256": sha256_path(NORMAL_FORMS),
        "source_challenges_sha256": sha256_path(CHALLENGES),
        "generator_sha256": sha256_path(Path(__file__).resolve()),
        "structural_mutations": mutations,
        "labeled_inference_fixtures": challenges,
    }
    coverage = render_coverage(
        cards, mutations, laws, challenges, holdouts, circuits, claim_coverage, unique_fixtures
    )
    write_or_check(MUTATIONS, json.dumps(mutation_output, indent=2) + "\n", check=check)
    write_or_check(WITNESSES, json.dumps(witness_output, indent=2) + "\n", check=check)
    write_or_check(COUNTERMODELS, json.dumps(countermodel_output, indent=2) + "\n", check=check)
    write_or_check(COVERAGE, coverage, check=check)
    return {
        "cards": len(cards),
        "mutations": len(mutations),
        "witnesses": len(witness_models),
        "countermodels": len(mutations) + len(challenges),
        "holdouts": len(holdouts),
        "circuits": len(circuits),
        "laws": len(laws),
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true", help="fail unless generated artifacts match")
    args = parser.parse_args()
    try:
        counts = run(check=args.check)
    except AlgebraError as error:
        print(f"Algebra experiment failed: {error}", file=sys.stderr)
        return 1
    mode = "verified" if args.check else "generated"
    print(
        f"Algebra experiment {mode}: {counts['cards']} cards, {counts['mutations']} mutations, "
        f"{counts['witnesses']} witnesses, {counts['countermodels']} structural fixtures, "
        f"{counts['holdouts']} holdouts, {counts['circuits']} joined circuits, "
        f"{counts['laws']} candidate disciplines uniquely represented in the labeled suite."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
