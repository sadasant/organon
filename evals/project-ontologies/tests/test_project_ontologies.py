import importlib.util
import json
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location("organon_project_ontology_eval", ROOT / "run.py")
assert SPEC and SPEC.loader
MODULE = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = MODULE
SPEC.loader.exec_module(MODULE)


def sample_ontology() -> str:
    headings = "\n\n".join(f"## {heading}\n\nText." for heading in sorted(MODULE.REQUIRED_HEADINGS))
    return f'''---
project: Engram
repository: https://github.com/idolum-ai/engram
branch: main
commit: abc
organon_version: 0.17.0
status: generated-candidate
---
# Engram Project Ontology

{headings}

<!-- organon:mapping-manifest -->
```yaml
schema_version: 1
project: Engram
commit: abc
mappings:
  - local_term: session
    organon_id: organon:Entity
    classification: refinement
    evidence:
      - sources/engram/README.md:1-2
```
'''


def target() -> dict:
    return {
        "project": "Engram",
        "organon_version": "0.17.0",
        "source_provenance": {
            "repository": "https://github.com/idolum-ai/engram",
            "ref": "main",
            "commit": "abc",
        },
    }


def test_deterministic_contract_accepts_exact_mapping_manifest():
    result = MODULE.deterministic_checks(
        target(), sample_ontology(), {"organon:Entity"},
        {"sources/engram/README.md": 2}, {"sources/engram/README.md": [[1, 2]]}
    )
    assert result["passed"]
    assert result["mapping_count"] == 1


def test_mapping_manifest_rejects_unknown_term_and_out_of_range_evidence():
    text = sample_ontology().replace("organon:Entity", "organon:Imaginary")
    result = MODULE.deterministic_checks(
        target(), text, {"organon:Entity"},
        {"sources/engram/README.md": 1}, {"sources/engram/README.md": [[1, 1]]}
    )
    assert not result["passed"]
    assert not result["checks"]["mapping_registered_ids"]
    assert not result["checks"]["mapping_evidence_valid"]


def test_source_dossier_is_digest_pinned_and_confined(tmp_path, monkeypatch):
    source = tmp_path / "source.md"
    source.write_text("source\n")
    monkeypatch.setattr(MODULE, "ROOT", tmp_path)
    relative = "source.md"
    index = tmp_path / "index.json"
    index.write_text(json.dumps({
        "schema_version": 1,
        "project": "Test",
        "commit": "abc",
        "files": {"README.md": {"line_count": 1, "covered_ranges": [[1, 1]]}},
    }))
    good = {
        "id": "test",
        "project": "Test",
        "source_provenance": {"commit": "abc"},
        "source_files": [relative],
        "source_digests": {relative: MODULE.sha256_text("source\n")},
        "source_index_file": "index.json",
        "source_index_sha256": MODULE.sha256_path(index),
    }
    dossier, digests, lines, covered = MODULE.source_dossier(good)
    assert "source" in dossier
    assert digests[relative] == good["source_digests"][relative]
    assert lines["README.md"] == 1
    assert covered["README.md"] == [[1, 1]]

    bad = {
        "id": "bad",
        "project": "Test",
        "source_provenance": {"commit": "abc"},
        "source_files": ["../outside.md"],
        "source_digests": {"../outside.md": "0" * 64},
        "source_index_file": "index.json",
        "source_index_sha256": MODULE.sha256_path(index),
    }
    try:
        MODULE.source_dossier(bad)
    except ValueError:
        pass
    else:
        raise AssertionError("traversal must fail closed")


def test_default_judge_and_prompt_contract(monkeypatch):
    monkeypatch.setattr(sys, "argv", ["run.py", "--run-dir", "result"])
    args = MODULE.parse_args()
    assert args.judge_model == "gpt-5.6-sol"
    assert args.judge_reasoning_effort == "high"
    assert args.request_timeout == 600.0
    assert MODULE.PROMPT_CONTRACT_VERSION == "gpt-5.6-project-ontology-v1"


def test_registered_targets_pass_exact_deterministic_contract():
    targets = json.loads((ROOT / "inputs" / "targets.json").read_text())["targets"]
    known_ids = MODULE.registry_ids(MODULE.DEFAULT_REGISTRY)
    assert {target["project"] for target in targets} == {"Engram", "Kenogram"}
    for target in targets:
        ontology_path = MODULE.resolve_within(
            MODULE.ROOT, target["ontology_file"], label="project ontology selector"
        )
        ontology_text = ontology_path.read_text()
        assert MODULE.sha256_text(ontology_text) == target["ontology_sha256"]
        _, _, line_counts, covered_ranges = MODULE.source_dossier(target)
        result = MODULE.deterministic_checks(
            target, ontology_text, known_ids, line_counts, covered_ranges
        )
        assert result["passed"], {
            key: value for key, value in result["checks"].items() if not value
        }
