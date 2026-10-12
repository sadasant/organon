"""Extract reviewed Lean declarations verbatim; never infer a term from its name.

This deliberately handles the source forms used by the catalog, not arbitrary
Lean. Unexpected syntax fails the build instead of silently dropping a field.
Compilation is checked separately with --check-lean; normal Pages builds only
need Python and use these same source declarations.
"""

import json
from pathlib import Path
import re
import subprocess
import tempfile

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
FORMAL = ROOT / "ontology/formal"


def without_comments(source):
    # Keep offsets and line numbers, including nested Lean block comments.
    chars = list(source)
    i, depth = 0, 0
    while i < len(source):
        if source.startswith("/-", i):
            depth += 1
            chars[i:i + 2] = "  "
            i += 2
        elif depth and source.startswith("-/", i):
            depth -= 1
            chars[i:i + 2] = "  "
            i += 2
        elif depth:
            if source[i] != "\n":
                chars[i] = " "
            i += 1
        elif source.startswith("--", i):
            end = source.find("\n", i)
            end = len(source) if end < 0 else end
            chars[i:end] = " " * (end - i)
            i = end
        else:
            i += 1
    if depth:
        raise ValueError("Unclosed Lean comment")
    return "".join(chars)


def declaration(module, name):
    path = FORMAL / f"{module}.lean"
    source = path.read_text()
    clean = without_comments(source)
    pattern = rf"^(structure|def|abbrev) {re.escape(name)}(?=\s|[(:])"
    matches = list(re.finditer(pattern, clean, re.M))
    if len(matches) != 1:
        raise ValueError(f"Expected exactly one declaration: {module}.{name}")
    match = matches[0]
    following = re.search(r"^\S", clean[match.end():], re.M)
    end = match.end() + following.start() if following else len(clean)
    text = clean[match.start():end].strip()
    # The catalog selects declarations in one explicitly named namespace.
    namespace = re.findall(r"^namespace (\S+)", clean[:match.start()], re.M)
    if len(namespace) != 1:
        raise ValueError(f"Review namespace nesting for {module}.{name}")
    result = {
        "module": module, "name": name, "symbol": f"{namespace[0]}.{name}",
        "path": str(path.relative_to(ROOT)),
        "line": source[:match.start()].count("\n") + 1,
        "endLine": source[:match.start() + len(text)].count("\n") + 1,
        "kind": match[1], "source": source[match.start():match.start() + len(text)],
    }
    if match[1] == "structure":
        header, separator, body = text.partition(" where")
        if not separator:
            raise ValueError(f"Expected record fields: {module}.{name}")
        field_matches = list(re.finditer(r"^  (\w+)\s*:", body, re.M))
        if not field_matches or body[:field_matches[0].start()].strip():
            raise ValueError(f"Unsupported record syntax: {module}.{name}")
        fields = []
        for index, field in enumerate(field_matches):
            stop = field_matches[index + 1].start() if index + 1 < len(field_matches) else len(body)
            value = body[field.end():stop].strip()
            if re.search(r"\n  \S", value):
                raise ValueError(f"Unparsed record field: {module}.{name}.{field[1]}")
            fields.append({"name": field[1], "type": value})
        result.update(header=header, fields=fields)
    else:
        depth, separator = 0, None
        for index, char in enumerate(text):
            if char in "({[":
                depth += 1
            elif char in ")}]":
                depth -= 1
            elif depth == 0 and text.startswith(":=", index):
                separator = index
                break
        if separator is not None:
            header, body = text[:separator], text[separator + 2:]
        else:
            # Pattern-matching definitions (Chains, OrderedBy, ExactChains).
            split = re.search(r"\n  \|", text)
            if not split:
                raise ValueError(f"Unsupported definition: {module}.{name}")
            header, body = text[:split.start()], text[split.start():]
        if re.search(r"\b(by|sorry|admit)\b", body):
            raise ValueError(f"Do not render a proof as a definition: {module}.{name}")
        result.update(header=header.strip(), body=body.strip())
    header_tail = result["header"].split(name, 1)[1].strip()
    binders = []
    while header_tail.startswith(("(", "{")):
        stack = []
        for index, char in enumerate(header_tail):
            if char in "({[":
                stack.append(char)
            elif char in ")}]":
                if not stack or stack.pop() != {")": "(", "}": "{", "]": "["}[char]:
                    raise ValueError(f"Unbalanced binder: {module}.{name}")
                if not stack:
                    break
        else:
            raise ValueError(f"Unclosed binder: {module}.{name}")
        raw = header_tail[:index + 1]
        names, colon, value = raw[1:-1].partition(":")
        if not colon or not re.fullmatch(r"[\w\s]+", names):
            raise ValueError(f"Unsupported binder: {module}.{name}: {raw}")
        binders.append({"names": names.split(), "type": value.strip(), "implicit": raw[0] == "{"})
        header_tail = header_tail[index + 1:].strip()
    result["binders"] = binders
    result["resultType"] = header_tail.removeprefix(":").strip()
    return result


def catalog_for(terms):
    catalog = json.loads((HERE / "lean-math.json").read_text())
    keys = {term["id"].removeprefix("organon:") for term in terms}
    if keys != set(catalog):
        raise ValueError(f"Math catalog drift: {keys ^ set(catalog)}")
    for key, entry in catalog.items():
        if entry.get("status") == "unencoded":
            if not entry.get("note") or "module" in entry:
                raise ValueError(f"Invalid unencoded disposition: {key}")
            entry["declarations"] = []
            continue
        primary = declaration(entry["module"], entry["name"])
        if "fields" in entry:
            available = {field["name"] for field in primary.get("fields", [])}
            if not set(entry["fields"]) <= available:
                raise ValueError(f"Unknown fields for {key}: {set(entry['fields']) - available}")
        if "parameters" in entry:
            for param in entry["parameters"]:
                if not re.search(rf"\b{re.escape(param)}\b", primary["header"]):
                    raise ValueError(f"Unknown parameter {key}: {param}")
        entry.setdefault("status", "projection" if "fields" in entry or "parameters" in entry else "construction")
        entry["declarations"] = [primary] + [declaration(*item) for item in entry.get("support", [])]
    return catalog


if __name__ == "__main__":
    import sys
    terms = json.loads((ROOT / "ontology/terms.yaml").read_text())["terms"]
    catalog = catalog_for(terms)
    if "--check-lean" in sys.argv:
        declarations = {d["symbol"]: d for entry in catalog.values() for d in entry["declarations"]}
        modules = sorted({d["module"] for d in declarations.values()})
        subprocess.run(["lake", "build", *modules], cwd=FORMAL, check=True)
        checks = "\n".join(f"#check {name}" for name in declarations)
        text = "\n".join(f"import {module}" for module in modules) + "\n" + checks + "\n"
        with tempfile.NamedTemporaryFile(mode="w", suffix=".lean", dir=FORMAL) as scratch:
            scratch.write(text)
            scratch.flush()
            subprocess.run(["lake", "env", "lean", scratch.name], cwd=FORMAL, check=True, stdout=subprocess.PIPE)
        print(f"Lean resolved {len(declarations)} mapped declarations.")
    for status in ("construction", "projection", "unencoded"):
        print(f"{status}: {sum(e['status'] == status for e in catalog.values())}")
