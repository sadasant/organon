import importlib.util
import json
import subprocess
import sys
from pathlib import Path

import pytest


ROOT = Path(__file__).resolve().parents[2]
SCRIPT = ROOT / "scripts" / "build-algebra.py"
ALGEBRA = ROOT / "ontology" / "algebra"


def load_builder():
    spec = importlib.util.spec_from_file_location("build_algebra", SCRIPT)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def test_all_declared_mutations_have_structural_near_misses():
    subprocess.run([sys.executable, str(SCRIPT), "--check"], cwd=ROOT, check=True)
    mutations = json.loads((ALGEBRA / "mutations.yaml").read_text())
    countermodels = json.loads((ALGEBRA / "fixtures" / "countermodels.yaml").read_text())
    assert mutations["mutation_count"] == 138
    assert len(countermodels["structural_mutations"]) == mutations["mutation_count"]
    assert all(item["mutated_derives"] and not item["original_derives"] for item in countermodels["structural_mutations"])


def test_every_candidate_discipline_has_one_unique_labeled_fixture():
    builder = load_builder()
    laws = builder.load(builder.LAWS)["laws"]
    signatures = builder.validate_signatures(builder.load(builder.PREDICATE_SIGNATURES))
    challenges = builder.validate_challenges(builder.load(builder.CHALLENGES), laws, signatures)
    unique_fixtures = builder.validate_unique_fixtures(laws, challenges)
    assert len(laws) == len(unique_fixtures) == 6


def test_predicate_signatures_reject_malformed_truth_denotation():
    builder = load_builder()
    signatures = builder.validate_signatures(builder.load(builder.PREDICATE_SIGNATURES))
    variables = {
        "claim": "Claim",
        "representation": "Representation",
        "presence": "Presence",
        "rule": "Rule",
        "scope": "Scope",
    }
    malformed = {
        "predicate": "Denotation",
        "args": ["claim", "representation", "presence", "rule", "scope"],
    }
    with pytest.raises(builder.AlgebraError, match="predicate signature mismatch"):
        builder.validate_atom(
            malformed,
            variables,
            signatures,
            label="malformed-truth-denotation",
        )


def test_unification_rejects_implicit_entity_kind_promotion():
    builder = load_builder()
    signatures = builder.validate_signatures(builder.load(builder.PREDICATE_SIGNATURES))
    atom = {"predicate": "Entity", "args": ["entity"]}
    fact = {"predicate": "Entity", "args": ["Configuration:e"]}
    assert builder.unify_atom(
        atom,
        fact,
        {},
        {"entity": "Entity"},
        signatures,
    ) is None
    assert signatures["Entity"] == [["Configuration"]]


def test_mutations_use_declared_typed_substitutions_and_inverses():
    builder = load_builder()
    signatures = builder.validate_signatures(builder.load(builder.PREDICATE_SIGNATURES))
    countermodels = json.loads((ALGEBRA / "fixtures" / "countermodels.yaml").read_text())
    mutations = countermodels["structural_mutations"]
    facts = [fact for mutation in mutations for fact in mutation["facts"]]
    for index, fact in enumerate(facts):
        builder.validate_ground_fact(fact, signatures, label=f"generated-fact[{index}]")
    assert not any(fact["predicate"].startswith("ReverseOf") for fact in facts)
    authority = next(item for item in mutations if item["id"].endswith("substitute-capability-authority"))
    authority_fact = next(fact for fact in authority["facts"] if fact["predicate"] == "Authority")
    assert [part.split(":", 1)[0] for part in authority_fact["args"]] == [
        "Order", "Agent", "Principal", "Scope"
    ]
    permission_claim = next(item for item in mutations if item["id"].endswith("substitute-permission-permissionclaim"))
    claim_fact = next(fact for fact in permission_claim["facts"] if fact["predicate"] == "PermissionClaim")
    assert [part.split(":", 1)[0] for part in claim_fact["args"]] == [
        "Claim", "Order", "Agent", "Action", "Scope", "Principal", "Interval"
    ]


def test_unchanged_taxonomy_covers_holdouts_without_covering_counts_as():
    builder = load_builder()
    laws_data = builder.load(builder.LAWS)
    laws = laws_data["laws"]
    signatures = builder.validate_signatures(builder.load(builder.PREDICATE_SIGNATURES))
    holdouts = builder.validate_holdouts(
        builder.load(builder.HOLDOUTS), laws, laws_data["held_out_domains"], signatures
    )
    by_id = {item["id"]: item for item in holdouts}
    assert by_id["H-COUNTS-AS-INSTITUTIONAL"]["blocked_by"] == []
    assert all(
        item["blocked_by"]
        for item in holdouts
        if item["id"] != "H-COUNTS-AS-INSTITUTIONAL"
    )


def test_joined_circuits_derive_their_declared_results_in_order():
    witnesses = json.loads(
        (ALGEBRA / "fixtures" / "witnesses.yaml").read_text()
    )
    circuits = witnesses["joined_circuits"]
    assert [item["id"] for item in circuits] == [
        "CIRCUIT-IDENTITY",
        "CIRCUIT-INSTITUTIONAL-ACTION",
        "CIRCUIT-EPISTEMIC-STATUS",
    ]
    assert all(
        item["derived_results"] == item["expected_results"]
        for item in circuits
    )
    assert [len(item["derived_results"]) for item in circuits] == [1, 2, 3]


def test_complete_reduction_audit_accounts_for_registry_and_refutes_completeness():
    script = ROOT / "scripts" / "build-reduction-audit.py"
    subprocess.run([sys.executable, str(script), "--check"], cwd=ROOT, check=True)
    ledger = json.loads((ALGEBRA / "reduction-ledger.yaml").read_text())
    assert ledger["answer"] == "no"
    assert len(ledger["terms"]) == ledger["counts"]["registered_terms"] == 109
    assert len(ledger["consistency_rules"]) == 31
    assert len(ledger["other_commitments"]) == 11
    assert ledger["counts"]["constructively_encoded"] == 9
    assert ledger["counts"]["positively_underdetermined"] == 97
    pairs = [
        item["paired_target_extension_sketch"]
        for item in ledger["terms"]
        if item["disposition"] == "positively_underdetermined"
    ]
    assert len(pairs) == 97
    assert all(pair["classification_differs"] for pair in pairs)
    assert all(pair["all_declared_dependencies_present"] for pair in pairs)
    assert all(
        item["paired_target_extension_sketch"]["shared_dependency_extensions"]
        == item["depends_on"]
        for item in ledger["terms"]
        if item["disposition"] == "positively_underdetermined"
    )


def test_degenerate_reflection_control_is_not_a_semantic_reduction():
    script = ROOT / "scripts" / "build-positive-calculus.py"
    subprocess.run([sys.executable, str(script), "--check"], cwd=ROOT, check=True)
    ledger = json.loads((ALGEBRA / "constructor-ledger.yaml").read_text())
    assert ledger["counts"] == {
        "registered_terms": 109,
        "retained_foundation": 3,
        "definitions_reflected": 106,
        "constructors": 1,
        "dependency_removal_fixtures": 825,
        "unreflected_definitions": 0,
    }
    assert ledger["degenerate_control_comparison"]["constructor_minimum_proved"] is False
    assert ledger["degenerate_control_comparison"]["zero_constructors_definitions_derived"] == 0
    assert ledger["degenerate_control_comparison"]["one_constructor_definitions_derived"] == 106
    assert ledger["semantic_minimality"]["proved"] is False
    assert ledger["semantic_minimality"]["binding_definition_schemas_retained"] == 106
    assert ledger["semantic_minimality"]["anti_vacuity_passes"] is False
    assert ledger["semantic_minimality"]["eligible_for_promotion"] is False
    assert all(entry["derives"] for entry in ledger["entries"])
    mutation_ids = [
        mutation_id
        for entry in ledger["entries"]
        for mutation_id in entry["one_step_mutations"]
    ]
    assert len(mutation_ids) == len(set(mutation_ids)) == 825
