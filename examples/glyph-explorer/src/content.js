// A link is navigation, not an assertion that a term's dependencies obtain.
export function termMatcher(terms) {
  const aliases = new Map();
  for (const term of terms) {
    const names = [
      term.label,
      term.id.slice(8).replace(/([a-z])([A-Z])/g, "$1 $2"),
    ];
    for (const name of names) {
      aliases.set(name.toLowerCase(), term);
      aliases.set(
        (name.endsWith("y")
          ? name.slice(0, -1) + "ies"
          : name + "s"
        ).toLowerCase(),
        term,
      );
    }
  }
  const escape = (value) => value.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
  const pattern = [...aliases.keys()]
    .sort((a, b) => b.length - a.length)
    .map(escape)
    .join("|");
  return (text) => {
    const regex = new RegExp(`\\b(${pattern})\\b`, "gi");
    const parts = [];
    let start = 0;
    for (const match of text.matchAll(regex)) {
      if (match.index > start)
        parts.push({ text: text.slice(start, match.index) });
      parts.push({ text: match[0], term: aliases.get(match[0].toLowerCase()) });
      start = match.index + match[0].length;
    }
    if (start < text.length) parts.push({ text: text.slice(start) });
    return parts;
  };
}

export function linkTerms(terms) {
  const match = termMatcher(terms);
  return () => (tree) => {
    const walk = (node) => {
      if (!node.children || ["link", "code", "inlineCode"].includes(node.type))
        return;
      node.children = node.children.flatMap((child) => {
        if (child.type !== "text") {
          walk(child);
          return [child];
        }
        return match(child.value).map((part) =>
          part.term
            ? {
                type: "link",
                url: `#/term/${part.term.slug}`,
                children: [{ type: "text", value: part.text }],
              }
            : { type: "text", value: part.text },
        );
      });
    };
    walk(tree);
  };
}

const mathText = (value) => `\\mathsf{${value.replace(/[^A-Za-z0-9]/g, "")}}`;

export function mathFor(term, terms) {
  if (!term.form) {
    if (!term.depends_on.length)
      return `\\text{${term.claim_type === "primitive" ? "Primitive" : "Foundation"}} \\quad ${mathText(term.label)}`;
    const names = term.depends_on.map(
      (id) => terms.find((t) => t.id === id)?.label || id,
    );
    return `\\begin{gathered}\\operatorname{vocab}(${mathText(term.label)}) = \\\\ \\left\\{\\begin{gathered}${names.map(mathText).join(" \\\\ ")}\\end{gathered}\\right\\}\\end{gathered}`;
  }
  const form = term.form;
  const variables = Object.keys(form.variables);
  const atom = (a) =>
    `${mathText(a.predicate)}(${a.args.map((v) => `x_{${variables.indexOf(v) + 1}}`).join(",")})`;
  const atoms = [...form.premises, ...form.witnesses];
  return `\\begin{gathered}${atoms.map(atom).join(" \\;\\land\\; \\\\ ")} \\\\ \\Downarrow \\\\ ${atom(form.result)}\\end{gathered}`;
}

export function locality(term, terms) {
  return {
    dependencies: term.depends_on
      .map((id) => terms.find((t) => t.id === id))
      .filter(Boolean),
    dependents: terms.filter((t) => t.depends_on.includes(term.id)),
  };
}
