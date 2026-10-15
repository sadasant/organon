// Capitalized registered names are links; lowercase metalanguage stays literal.
// A link is navigation, not an assertion that a term's dependencies obtain.
export function termMatcher(terms) {
  const aliases = new Map();
  const labels = new Map(terms.map((term) => [term.label, term.id]));
  for (const term of terms) {
    const names = [
      term.label,
      term.id.slice(8).replace(/([a-z])([A-Z])/g, "$1 $2"),
    ];
    for (const name of names) {
      // A retained identifier alias must not steal another term's current label.
      if (labels.has(name) && labels.get(name) !== term.id) continue;
      aliases.set(name, term);
      aliases.set(
        name.endsWith("y")
          ? name.slice(0, -1) + "ies"
          : name + "s",
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
    const regex = new RegExp(`\\b(${pattern})\\b`, "g");
    const parts = [];
    let start = 0;
    for (const match of text.matchAll(regex)) {
      if (match.index > start)
        parts.push({ text: text.slice(start, match.index) });
      parts.push({ text: match[0], term: aliases.get(match[0]) });
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

export function ontologyGraph(terms) {
  // A3's reference to Absence is contrast in the metalanguage, not an edge
  // within Presence. Preserve the source registry; exclude it in this view.
  const nodes = terms.filter((t) => t.id !== "organon:Absence");
  const ids = new Set(nodes.map((t) => t.id));
  const edges = nodes.flatMap((t) =>
    t.depends_on
      .filter((id) => ids.has(id))
      .map((id) => ({ source: id, target: t.id })),
  );
  return { nodes, edges };
}

export function locality(term, terms) {
  const graph = ontologyGraph(terms);
  if (term.id === "organon:Absence") return { nodes: [term], edges: [] };
  const ids = new Set([term.id]);
  for (const edge of graph.edges) {
    if (edge.source === term.id) ids.add(edge.target);
    if (edge.target === term.id) ids.add(edge.source);
  }
  // An induced subgraph keeps every actual edge between visible neighbours.
  return {
    nodes: graph.nodes.filter((t) => ids.has(t.id)),
    edges: graph.edges.filter((e) => ids.has(e.source) && ids.has(e.target)),
  };
}
