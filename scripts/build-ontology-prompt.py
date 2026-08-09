#!/usr/bin/env python3
"""Build a compact, deterministic prompt projection of the binding ontology."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
ONTOLOGY = ROOT / "ontology" / "ontology.md"
REGISTRY = ROOT / "ontology" / "terms.yaml"
DEFAULT_OUTPUT = ROOT / "ontology" / "prompt.md"
DEFAULT_MANIFEST = ROOT / "ontology" / "prompt-manifest.json"
CLAIM_SOURCES = (ONTOLOGY, ROOT / "editorial" / "long-form.md", ROOT / "editorial" / "short-form.md")
CLAIM_MARKER = re.compile(r"<!-- organon:claim ([A-Za-z0-9]+) -->")
HTML_MARKER = re.compile(r"<!--.*?-->")
ANCHOR = re.compile(r"<a\s+id=\"[^\"]+\"></a>")
LIST_PREFIX = re.compile(r"^\d+\.\s+")


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def sha256_path(path: Path) -> str:
    return sha256_bytes(path.read_bytes())


def normalize_block(block: str) -> str:
    lines: list[str] = []
    for raw in block.splitlines():
        line = HTML_MARKER.sub("", raw)
        line = ANCHOR.sub("", line).strip()
        if not line or line.startswith("#"):
            continue
        line = LIST_PREFIX.sub("", line)
        lines.append(line)
    return " ".join(lines).strip()


def first_prose_block(text: str, marker: str, *, required_prefix: str | None = None) -> str:
    if text.count(marker) != 1:
        raise ValueError(f"expected exactly one marker: {marker}")
    tail = text.split(marker, 1)[1]
    for block in re.split(r"\n\s*\n", tail):
        normalized = normalize_block(block)
        if not normalized:
            continue
        if required_prefix is None or normalized.startswith(required_prefix):
            return normalized
    raise ValueError(f"no prose found after marker: {marker}")


def section_body(text: str, heading: str) -> str:
    marker = f"## {heading}\n"
    if text.count(marker) != 1:
        raise ValueError(f"expected exactly one section: {heading}")
    body = text.split(marker, 1)[1]
    body = re.split(r"\n## ", body, maxsplit=1)[0]
    paragraphs = [normalize_block(block) for block in re.split(r"\n\s*\n", body)]
    return "\n\n".join(paragraph for paragraph in paragraphs if paragraph)


def dependency_closure(terms: list[dict], selected_ids: list[str]) -> list[dict]:
    by_id = {term["id"]: term for term in terms}
    unknown = sorted(set(selected_ids) - set(by_id))
    if unknown:
        raise ValueError("unknown selected term(s): " + ", ".join(unknown))
    wanted: set[str] = set()

    def add(term_id: str) -> None:
        if term_id in wanted:
            return
        for dependency in by_id[term_id]["depends_on"]:
            add(dependency)
        wanted.add(term_id)

    for term_id in selected_ids:
        add(term_id)
    return [term for term in terms if term["id"] in wanted]


def selected_commitments(
    commitments: list[dict], selected_terms: list[dict], requested_ids: list[str]
) -> list[dict]:
    if not requested_ids:
        return commitments
    term_ids = {term["id"] for term in selected_terms}
    requested = set(requested_ids)
    always = {"A1", "A2", "A3", "A4", "A5", "C1", "C2"}
    chosen: set[str] = set(always)
    changed = True
    while changed:
        changed = False
        for commitment in commitments:
            dependencies = set(commitment["depends_on"])
            term_dependencies = {item for item in dependencies if item.startswith("organon:")}
            claim_dependencies = dependencies - term_dependencies
            relevant = bool(term_dependencies & requested) or commitment["id"] in always
            closed = term_dependencies <= term_ids and claim_dependencies <= chosen
            if relevant and closed and commitment["id"] not in chosen:
                chosen.add(commitment["id"])
                changed = True
    return [commitment for commitment in commitments if commitment["id"] in chosen]


def extract_terms(ontology: str, terms: list[dict]) -> list[dict]:
    extracted: list[dict] = []
    for term in terms:
        marker = f'<!-- organon:term {term["id"]} claim={term["claim_id"]} -->'
        statement = first_prose_block(
            ontology,
            marker,
            required_prefix=f'**{term["label"]}**',
        )
        extracted.append({**term, "statement": statement})
    return extracted


def extract_commitments(commitments: list[dict]) -> list[dict]:
    source_text = "\n\n".join(path.read_text(encoding="utf-8") for path in CLAIM_SOURCES)
    extracted: list[dict] = []
    for commitment in commitments:
        marker = f'<!-- organon:claim {commitment["id"]} -->'
        extracted.append({**commitment, "statement": first_prose_block(source_text, marker)})
    return extracted


def dependency_text(dependencies: list[str]) -> str:
    return ", ".join(dependencies) if dependencies else "none"


def render_prompt(
    registry: dict,
    ontology: str,
    terms: list[dict],
    commitments: list[dict],
    requested_ids: list[str],
) -> str:
    foundational = [item for item in commitments if item["id"] in {"A1", "A2", "A3", "A4", "A5"}]
    remaining = [item for item in commitments if item not in foundational]
    mode = "full" if not requested_ids else "dependency-closed selection"
    requested = ", ".join(requested_ids) if requested_ids else "all registered terms"
    lines = [
        "---",
        "type: ontology-prompt-projection",
        "status: generated-noncanonical",
        f'ontology_version: "{registry["ontology_version"]}"',
        f'projection_mode: "{mode}"',
        "binding_source: ontology.md",
        "---",
        "# Organon Prompt Projection",
        "",
        "> This is a deterministic, lossy projection of the binding Markdown ontology.",
        "> It preserves registered primary statements, dependency order, and selected",
        "> commitments. When precision depends on omitted explanation, consult",
        "> `ontology/ontology.md`; this projection cannot amend or overrule it.",
        "",
        "## Operating contract",
        "",
        "- Use a registered term only with the meaning recorded below.",
        "- Treat every named dependency as lexical vocabulary required to state the complete definition; do not assume that it obtains in every instance.",
        "- Infer a term only when one type- and index-consistent interpretation satisfies its complete logical form, including every applicable premise, quantifier, alternative, exclusion, and required witness.",
        "- Ordinary vocabulary and capitalization do not constitute an Organon mapping.",
        "- Keep ontological, causal, epistemic, and institutional relations distinct unless an explicit Rule joins them.",
        "- Treat quarantined terms as undefined except for the protocol explicitly recorded for them.",
        "- Treat generated classifications as Claims, not Truth, Evidence, adoption, or promotion.",
        "- Prefer an explicit unmapped or underdetermined result to a resemblance-based promotion.",
        "",
        "## Projection scope",
        "",
        f"- Mode: {mode}",
        f"- Requested: {requested}",
        f"- Terms carried: {len(terms)} of {len(registry['terms'])}",
        f"- Commitments carried: {len(commitments)} of {len(registry['commitments'])}",
        "",
        "## Metalanguage boundary",
        "",
        section_body(ontology, "The closure boundary"),
        "",
        "## Foundational commitments",
        "",
    ]
    for item in foundational:
        lines.extend(
            [
                f'### `{item["id"]}` · {item["claim_type"]}',
                "",
                item["statement"],
                "",
                f'Depends: {dependency_text(item["depends_on"])}.',
                "",
            ]
        )
    lines.extend(["## Registered terms", ""])
    for term in terms:
        lines.extend(
            [
                f'### `{term["id"]}` · {term["label"]}',
                "",
                term["statement"],
                "",
                f'Claim: `{term["claim_id"]}` ({term["claim_type"]}).',
                f'Depends: {dependency_text(term["depends_on"])}.',
                "",
            ]
        )
    lines.extend(["## Other binding commitments", ""])
    for item in remaining:
        lines.extend(
            [
                f'### `{item["id"]}` · {item["claim_type"]}',
                "",
                item["statement"],
                "",
                f'Depends: {dependency_text(item["depends_on"])}.',
                "",
            ]
        )
    lines.extend(
        [
            "## Declared omissions",
            "",
            "This projection omits extended explanations, examples, boundary cases,",
            "philosophical shadows, provenance arguments, proposal dossiers, Lean proofs and",
            "countermodels, and the editorial instruments. Their omission is compression, not",
            "rejection. Resolve ambiguity against the binding Markdown source.",
            "",
        ]
    )
    return "\n".join(lines)


def build(selected_ids: list[str]) -> tuple[str, dict]:
    registry = json.loads(REGISTRY.read_text(encoding="utf-8"))
    ontology = ONTOLOGY.read_text(encoding="utf-8")
    base_terms = registry["terms"] if not selected_ids else dependency_closure(registry["terms"], selected_ids)
    base_commitments = selected_commitments(registry["commitments"], base_terms, selected_ids)
    terms = extract_terms(ontology, base_terms)
    commitments = extract_commitments(base_commitments)
    prompt = render_prompt(registry, ontology, terms, commitments, selected_ids)
    prompt_bytes = prompt.encode("utf-8")
    manifest = {
        "schema_version": 1,
        "artifact": "ontology-prompt-projection",
        "canonical": False,
        "ontology_version": registry["ontology_version"],
        "projection_mode": "full" if not selected_ids else "dependency-closed-selection",
        "requested_terms": selected_ids,
        "term_count": len(terms),
        "registry_term_count": len(registry["terms"]),
        "commitment_count": len(commitments),
        "registry_commitment_count": len(registry["commitments"]),
        "sources_sha256": {
            str(ONTOLOGY.relative_to(ROOT)): sha256_path(ONTOLOGY),
            str(REGISTRY.relative_to(ROOT)): sha256_path(REGISTRY),
            str((ROOT / "editorial" / "long-form.md").relative_to(ROOT)): sha256_path(ROOT / "editorial" / "long-form.md"),
            str((ROOT / "editorial" / "short-form.md").relative_to(ROOT)): sha256_path(ROOT / "editorial" / "short-form.md"),
        },
        "generator_sha256": sha256_path(Path(__file__).resolve()),
        "prompt_sha256": sha256_bytes(prompt_bytes),
        "prompt_bytes": len(prompt_bytes),
        "extraction": "exact primary statement after each registered term or claim marker",
        "omissions": [
            "extended explanations and examples",
            "boundary cases and philosophical shadows",
            "provenance arguments and proposal dossiers",
            "Lean proofs, witnesses, and countermodels",
            "editorial instruments",
        ],
    }
    return prompt, manifest


def write_or_check(path: Path, content: str, *, check: bool) -> None:
    if check:
        if not path.is_file() or path.read_text(encoding="utf-8") != content:
            try:
                display = path.relative_to(ROOT)
            except ValueError:
                display = path
            raise ValueError(f"generated artifact is stale: {display}")
        return
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--term", action="append", default=[], help="Include a term and its transitive dependency closure")
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    parser.add_argument("--manifest", type=Path, default=DEFAULT_MANIFEST)
    parser.add_argument("--check", action="store_true", help="Fail unless the named outputs match a fresh projection")
    args = parser.parse_args()
    try:
        prompt, manifest = build(args.term)
        write_or_check(args.output, prompt, check=args.check)
        write_or_check(args.manifest, json.dumps(manifest, indent=2) + "\n", check=args.check)
    except ValueError as error:
        print(f"Ontology prompt projection failed: {error}", file=sys.stderr)
        return 1
    if args.check:
        print(f"Ontology prompt projection is current: {len(prompt.encode('utf-8'))} bytes")
    else:
        print(f"Wrote {args.output} and {args.manifest}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
