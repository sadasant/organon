"""Project existing definitions and candidate forms into a nonbinding static preview."""

import importlib.util
import json
from pathlib import Path
import re

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
spec = importlib.util.spec_from_file_location("prompt_builder", ROOT / "scripts/build-ontology-prompt.py")
builder = importlib.util.module_from_spec(spec)
spec.loader.exec_module(builder)

registry = json.loads((ROOT / "ontology/terms.yaml").read_text())
ontology = (ROOT / "ontology/ontology.md").read_text()
glyphs = {row["term"]: row for row in json.loads((ROOT / "proposals/unicode-vocabulary-candidates.json").read_text())["candidates"]}
forms = {row["term_id"]: row for row in json.loads((ROOT / "ontology/algebra/normal-forms.yaml").read_text())["cards"]}
terms = builder.extract_terms(ontology, registry["terms"])
for term in terms:
    key = term["id"].split(":")[1]
    candidate = glyphs[key]
    term["slug"] = term["anchor"].removeprefix("organon-")
    term["glyph"] = candidate["glyph"] if candidate["verdict"] == "trial" else None
    term["glyphNote"] = candidate["reason"]
    term["glyphVerdict"] = candidate["verdict"]
    term["form"] = forms.get(term["id"])
    marker = f'<!-- organon:term {term["id"]} claim={term["claim_id"]} -->'
    tail = ontology.split(marker, 1)[1]
    term["fullEntry"] = re.split(r'\n(?:<a id=|#{1,6} |<!-- organon:term)', tail, maxsplit=1)[0].strip()
    term["fullEntry"] = re.sub(r"<!--.*?-->", "", term["fullEntry"], flags=re.S).strip()
output = HERE / "src/data.json"
output.parent.mkdir(exist_ok=True)
output.write_text(json.dumps({"version": registry["ontology_version"], "terms": terms}, ensure_ascii=False) + "\n")
print(f"Projected {len(terms)} definitions and {len(forms)} candidate forms; no canonical files changed.")
