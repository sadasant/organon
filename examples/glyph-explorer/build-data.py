"""Project prose and source-backed Lean mathematics into the static reader."""

import importlib.util
import json
from pathlib import Path
import re
from lean_math import catalog_for

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
spec = importlib.util.spec_from_file_location("prompt_builder", ROOT / "scripts/build-ontology-prompt.py")
builder = importlib.util.module_from_spec(spec)
spec.loader.exec_module(builder)

registry = json.loads((ROOT / "ontology/terms.yaml").read_text())
ontology = (ROOT / "ontology/ontology.md").read_text()
review_rows = json.loads((ROOT / "proposals/glyph-semantic-review.json").read_text())["entries"]
reviews = {row["term"]: row for row in review_rows}
# The study and explorer must share one complete per-term review.
if len(reviews) != len(review_rows) or set(reviews) != {t["id"].removeprefix("organon:") for t in registry["terms"]}:
    raise ValueError("Glyph semantic review must cover each registry term exactly once")
terms = builder.extract_terms(ontology, registry["terms"])
mathematics = catalog_for(terms)
for term in terms:
    key = term["id"].split(":")[1]
    term["slug"] = term["anchor"].removeprefix("organon-")
    term["glyphReview"] = reviews[key]
    term["math"] = mathematics[key]
    marker = f'<!-- organon:term {term["id"]} claim={term["claim_id"]} -->'
    tail = ontology.split(marker, 1)[1]
    term["fullEntry"] = re.split(r'\n(?:<a id=|#{1,6} |<!-- organon:term)', tail, maxsplit=1)[0].strip()
    term["fullEntry"] = re.sub(r"<!--.*?-->", "", term["fullEntry"], flags=re.S).strip()
output = HERE / "src/data.json"
output.parent.mkdir(exist_ok=True)
output.write_text(json.dumps({"version": registry["ontology_version"], "terms": terms}, ensure_ascii=False) + "\n")
print(f"Projected {len(terms)} definitions with audited Lean mappings; no canonical files changed.")
