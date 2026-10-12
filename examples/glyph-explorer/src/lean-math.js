// A conservative notation projection, not a Lean evaluator. Logical operators,
// binders, field names, application order and all parentheses are retained.
import { glyphs } from "../../../proposals/glyph-catalog.mjs";
import catalog from "../lean-math.json" with { type: "json" };

export const mathRenderOptions = {
  displayMode: true,
  throwOnError: true,
  trust: (context) => context.command === "\\htmlClass",
  // The custom font supplies PUA metrics; KaTeX supplies the formula layout.
  strict: (code) =>
    ["htmlExtension", "symbolNotInFont"].includes(code) ? "ignore" : "error",
};

// The same codepoints/font used by the wall and study. Only whole type names
// and explicitly catalogued declarations qualify; never replace word fragments
// or lowercase field/variable names (which would erase participant identity).
const glyphNames = new Map(glyphs.map((g) => [g.id.slice(8), g]));
for (const [term, entry] of Object.entries(catalog)) {
  if (!entry.name || entry.fields || entry.parameters) continue;
  const matches = Object.values(catalog).filter((e) => e.name === entry.name);
  if (
    matches.length === 1 &&
    !entry.name.includes(".") &&
    /^[A-Z]/.test(entry.name)
  )
    glyphNames.set(entry.name, glyphNames.get(term));
}

const symbols = {
  "→": "\\to",
  "↔": "\\leftrightarrow",
  "∀": "\\forall",
  "∃": "\\exists",
  "∧": "\\land",
  "∨": "\\lor",
  "¬": "\\neg",
  "≠": "\\ne",
  "≤": "\\le",
  "∈": "\\in",
  "×": "\\times",
  α: "\\alpha",
  "·": "\\cdot",
  ":=": "\\coloneqq",
  "=>": "\\mapsto",
  "::": "\\mathbin{::}",
  "++": "\\mathbin{+\\!+}",
  "{": "\\{",
  "}": "\\}",
  Nat: "\\mathbb{N}",
  Bool: "\\mathbb{B}",
  False: "\\bot",
  True: "\\top",
  fun: "\\lambda",
};

export function leanTex(source, useGlyphs = false) {
  const tokens =
    source.match(/:=|=>|::|\+\+|[\p{L}_][\p{L}\p{N}_']*|\s+|./gu) || [];
  return tokens
    .map((token) => {
      if (/^\s+$/u.test(token)) return "\\,";
      if (symbols[token]) return `${symbols[token]} `;
      const glyph = useGlyphs && glyphNames.get(token);
      if (glyph)
        return `\\htmlClass{math-glyph}{\\text{\\char"${glyph.codepoint.toString(16)}}}\\vphantom{\\rule{0pt}{1em}}`;
      if (/^[\p{L}_][\p{L}\p{N}_']*$/u.test(token)) {
        return `\\mathit{${token.replaceAll("_", "\\_")}}`;
      }
      if (/^[0-9()[\],.:<=>?+|]$/.test(token)) return token;
      throw new Error(`Unreviewed Lean notation: ${token}`);
    })
    .join("");
}

// Break only whitespace, never change grouping or drop a clause. Each source
// line remains ordered; wrapping is typographic, not another logical operator.
function lines(source, width = 52, useGlyphs = false) {
  const length = (text) =>
    useGlyphs
      ? text.replace(/[A-Za-z][A-Za-z0-9]*/g, (name) =>
          glyphNames.has(name) ? "◊" : name,
        ).length
      : text.length;
  return source.split("\n").flatMap((line) => {
    const result = [""];
    for (const word of line.trim().split(/\s+/)) {
      const last = result.length - 1;
      if (result[last] && length(`${result[last]} ${word}`) > width)
        result.push(word);
      else result[last] += `${result[last] ? " " : ""}${word}`;
    }
    return result.filter(Boolean).map((line) => leanTex(line, useGlyphs));
  });
}

export function declarationMath(
  declaration,
  selection = {},
  useGlyphs = false,
) {
  const tex = (source) => leanTex(source, useGlyphs);
  if (selection.parameters) {
    // Show the actual parameter binder, not an invented definition of its type.
    const selected = declaration.binders.filter((b) =>
      selection.parameters.some((p) => b.names.includes(p)),
    );
    if (!selected.length)
      throw new Error(`Missing parameter binder: ${declaration.symbol}`);
    return `\\begin{gathered}${selected.map((b) => tex(`${b.names.filter((p) => selection.parameters.includes(p)).join(" ")} : ${b.type}`)).join("\\\\")}\\end{gathered}`;
  }
  const args = declaration.binders
    .filter((b) => !b.implicit)
    .flatMap((b) => b.names);
  const head = `${tex(declaration.name)}${args.length ? `(${args.map(tex).join(",")})` : ""}`;
  if (declaration.kind === "structure") {
    const fields = declaration.fields.filter(
      (f) => !selection.fields || selection.fields.includes(f.name),
    );
    const rows = fields.flatMap((field) => {
      if (useGlyphs) {
        const [first, ...rest] = lines(field.type, 34, true);
        // A single left-aligned column avoids reserving a second, wide label
        // column on phones. Field names remain verbatim, even if capitalized.
        return [
          `&${leanTex(field.name)} :`,
          `&\\quad ${first}`,
          ...rest.map((line) => `&\\quad ${line}`),
        ];
      }
      const [first, ...rest] = lines(field.type, 45, useGlyphs);
      return [
        `${leanTex(field.name)} &: ${first}`,
        ...rest.map((line) => `&\\quad ${line}`),
      ];
    });
    const record = `\\begin{aligned}${rows.join("\\\\[3pt]")}\\end{aligned}`;
    // A field excerpt is not the definition of the whole parent record.
    return selection.fields
      ? record
      : `\\begin{gathered}${head}\\\\[5pt]\\cong\\;\\left\\{${record}\\right\\}\\end{gathered}`;
  }
  return `\\begin{gathered}${head}\\\\[5pt]\\coloneqq\\;\\begin{aligned}${lines(
    declaration.body,
    52,
    useGlyphs,
  )
    .map((line) => `&${line}`)
    .join("\\\\[3pt]")}\\end{aligned}\\end{gathered}`;
}

export function parameterMath(declaration, useGlyphs = false) {
  // Preserve the full signature, including implicit parameters and result type.
  const signature = declaration.header
    .slice(
      declaration.header.indexOf(declaration.name) + declaration.name.length,
    )
    .trim();
  return signature
    ? `\\begin{aligned}${lines(signature, 52, useGlyphs)
        .map((line) => `&${line}`)
        .join("\\\\")}\\end{aligned}`
    : null;
}
