---
proposal: unicode-vocabulary
status: ready-for-review
binding: false
---

# Organon's symbolic vocabulary: Unicode study and custom typeface

**Current direction: one provisional typeface shared by the study and website.** The [Organon Symbols catalog](./glyph-catalog.mjs) now supplies all 115 marks, the installable font, and the website. The [symbol review](./glyph-atlas.md) shows the same marks with per-term judgments: **49 revised trials and 66 retained trials**. None is certified as semantically equivalent to its definition. The earlier Unicode assessment below remains a record of alternatives, not a second active assignment system. **Publication accepts this experimental vocabulary for use with labels; it does not promote the glyphs into binding definitions or close the reader-testing gates.**

## Shared typeface and semantic review

The [review data](./glyph-semantic-review.json) records each mark's visual cue, risky readings, and recommendation against the binding definition. Its source pin preserves the originally assessed SVG alphabet. The review distinguishes a learned name from a compositional expression: a glyph need not contain all the definition's witnesses, but should not systematically suggest an excluded meaning. Reused components currently have no formal grammar. A crown, eye, dot, or bar must not silently introduce sovereignty, sight, truth, or another entailment.

Priority concerns include Absence/partial missingness, Relation/ordered roles, Agent/Agency, Capability/Permission, Observation/Perception, attribution/obtainment, and Care/benevolence. This revision redraws all 43 originally flagged marks plus six linked family members: State, Interface, Constituent Power, Operative Knowledge, Warranted Knowledge, and Attention. The other 66 paths and all private-use assignments remain unchanged. The judgments are proposals for design review, not measured reader outcomes. `trial` and `revised` do not mean approved; `revise` does not make the underlying definition defective. The previous audit remains pinned in the review data.

### A constrained drawing system, not a semantic grammar

The [geometric rules](./glyph-geometry.json) specify a 32-unit cell, integer path parameters, a uniform 1.1-unit stroke, square caps, miter joins limited to four stroke radii, and at least one unit of ink margin on every side. The font build enforces these bounds after stroke expansion and rejects duplicate outlines. The font and specimen use the same settings.

Within that envelope, prefer centered axes, two-unit clear gaps, and 0°/45°/90°/135° strokes where appropriate. The golden divisions of 32 are approximately 12.22 and 19.78; the snapped guides at 12 and 20 offer a repeatable proportion. These are **advisory composition guides**, not universal requirements: curves, joins, and semantic distinctions may need other proportions. The system does not claim that the golden ratio guarantees beauty or meaning.

Motif reuse may suggest a family but does not prove ontological inclusion. Do not distinguish opposing meanings only by rotation, scale, or a tiny dot. Inspect related marks at actual text sizes: distinct outlines alone are insufficient. These editorial rules constrain future revisions without changing the ontology's definitions.

The font uses private-use slots U+E000–U+E072, not newly standardized Unicode characters. These characters have no portable meaning without this font and catalog. Organon IDs remain machine identity, and accessible term labels remain attached to website links. Prose and mathematical typesetting retain their existing fonts; Organon Symbols is a symbol typeface, not a replacement Latin alphabet.

GitHub and ordinary Markdown readers cannot load our webfont. The study therefore embeds a labelled SVG specimen generated from the same catalog; the website renders the corresponding font glyphs. Historical Unicode alternatives are not rendered alongside them as competing assignments.

Regenerate the TTF, WOFF2, specimen, and review table with Node, Python 3.11+, and uv:

```sh
uv run scripts/build-glyph-font.py
uv run scripts/build-glyph-font.py --check
```

The build checks registry/review coverage, unique paths, outlines and private-use slots, geometric bounds, and the reviewed ontology, catalog and geometry hashes. `--check` additionally rebuilds in a temporary directory and rejects stale font or study artifacts without changing the repository. It does not establish perceptual distinctness, semantic fidelity, accessibility with an actual screen reader, or cross-cultural neutrality. Those remain review and reader-testing obligations. The already approved wall/paper/sky layout does not settle any of those questions.

## Original Unicode investigation

**A small labelled notation is worth testing; an inherited one-character equivalent for every definition has not been established.** This study assesses all 115 active registered entries in Organon v0.20.0: 112 definitions and three foundational entries. The [candidate atlas](./unicode-vocabulary-atlas.md) contains a rationale for every entry: **34 trial mnemonics, 33 rejected candidates, and 48 composition-first assessments**.

No definition, registry ID, Lean construction or official spelling changes. Merging this dossier would accept a research record, not adopt its glyphs. The [candidate data](./unicode-vocabulary-candidates.json) pins the assessed ontology and registry to the commit that merged PR #18. Historical definitions, withdrawn terms, local example constructions and unpromoted proposal definitions are outside this first pass. In particular, the institutional revision's Power and Successful Succession candidates are not silently counted as active terms.

## What kind of match are we looking for?

Unicode supplies **characters**, UTF-8 encodes them as bytes, and fonts/shaping produce **glyphs**. One character need not yield exactly one glyph, and the same character can look different in different contexts. Unicode assigns character properties and semantics, but does not assign every application-specific mathematical meaning [1, 2]. The data field `glyph` is shorthand for the candidate character string, not a font image.

There are three different ambitions:

1. **Discover an inherited semantic equivalent.** The established use would have to preserve the full definition, not just suggest its name. No row in this study claims this result.
2. **Assign a memorable alias.** A legend can stipulate that a mark denotes a term. This is feasible even when inherited meanings differ, but the assignment is new and must be learned.
3. **Compose an inspectable notation.** A smaller repertoire could show participants, relations and shared indices. This needs a grammar and interpretation rules, not just icons.

One character per concept would be closer to a logographic notation than a phonetic alphabet. An alphabet-like set of reusable components is a separate possibility. Neither requires revising the ontology simply to fit the available shapes.

## Method and judgment boundary

Each active term was compared with a plausible familiar mathematical, diagrammatic or pictographic candidate, or assessed as requiring explicit composition. The assessment uses the definition's ontological type, participant roles, Scope, causal joins and anti-entailments—not just its English label. Candidate selection is a curated first pass, **not an exhaustive search of Unicode or a cross-cultural recognition study**. Existing writing systems have not been mined for aesthetically convenient characters stripped of their meanings.

- **Trial:** test this mark alongside the term's label. Its rationale names the lost conditions and competing readings. It is not approved as a standalone replacement.
- **Reject:** reject this particular association as a first-line mnemonic. This does not prove that another glyph could not work, nor prevent a deliberately learned arbitrary alias.
- **Compose:** retain the full term name and consider showing its indexed construction. No composition syntax is defined yet. This is a notation recommendation, **not a recommendation to withdraw the registered term**.

These classifications are editorial judgments, not measured scores. The standard is whether the cue is useful enough to test despite its misleading associations. Reviewers may reasonably reject some trial marks, especially `⊞` Configuration and `⊣` Constraint, whose mathematical readings compete strongly with the proposed visual cue.

## Promising cues and useful counterexamples

| Term | Candidate | What it preserves | What still has to be said |
| --- | --- | --- | --- |
| Difference | ≠ | Nonidentity | Compared Presences or configurations; not numerical subtraction |
| Direction | → | Orientation | Asymmetry; not automatically Time, causality or implication |
| Transformation | ↦ | Input/output distinction | States, Direction and relation type; competes with Denotation |
| Change | Δ | A change cue | Actual Transformation joining the different States |
| Boundary | ∂ | A boundary analogy | Identity-indexed Constraints, not necessarily a geometric boundary |
| Attention | ◎ | Directed focus | Causal organization across target State changes, not an eye or truth guarantee |

Counterexamples are at least as important:

- **Absence ≠ empty set:** `∅` denotes a mathematical object, whereas Organon's Absence excludes a containing field and missing items.
- **Care ≠ benevolence:** `♥` makes harmful or interrogative Care look like a contradiction, undoing the distinction retained in PR #18.
- **Evidence ≠ truth or approval:** `✓` erases independent production and Admission, and suggests a positive outcome even when Evidence defeats a Claim.
- **Capability ≠ bare possibility:** `◇` omits the constructive witness and Constraint-admitted production path.
- **CountsAs ≠ identity:** `≡` hides the Order, Rule and Scope under which institutional counting occurs.

A compact label never contains a full definition by itself; English names also depend on a glossary. The question is not whether a mark independently proves its definition, but whether a documented notation retains access to the definition and does not encourage systematic false inferences.

## A two-layer experiment is the smallest useful next step

<!-- organon:proposal-statement UG-H1 type=hypothesis -->
**Hypothesis:** a small repertoire of labelled glyphs can make some Organon diagrams easier to scan without reducing readers' ability to distinguish adjacent terms.

Keep `organon:*` identifiers as machine identity. Display optional glyphs with human labels; do not replace identifiers or make meaning depend on font choice. For example, `↦ Transformation` and `↦ Denotation` can be separate labelled entries in an exploratory legend. They cannot both be decoded from the bare mark `↦`.

<!-- organon:proposal-statement UG-C1 type=anti_collapse_constraint -->
**Anti-collapse constraint:** shared or similar glyphs do not establish equivalent definitions. Conversely, distinct glyphs do not establish an ontological distinction. Organon's consolidation rule concerns meaning-preserving isomorphism across declared Scope, not typography.

The trial list deliberately retains two exact collisions: Denotation/Transformation (`↦`) and Missingness/Scope (`□`). It also contains visually close candidates: Entity/Perception/Attention/Center (`●`, `◉`, `◎`, `⊙`) and Interface/Recurrent Integration (`⇄`, `⇆`). An eventual standalone codebook must resolve these; a labelled exploratory legend need not pretend they are resolved already.

For composition, start with one real relation and its typed participants rather than inventing 115 opaque marks. Causal path is a useful case: show a sequence of Transformations and the Feeds joins, and test whether the notation retains the shared Direction. A generic arrow chain alone must not count as a valid Causal path.

## Unicode constraints are testable, but not sufficient

The [audit](../scripts/check-unicode-vocabulary.py) verifies exact registry coverage, source hashes, assigned/named characters, UTF-8 round trips and reproduction of the atlas. It reports candidate reuse and normalization changes, including deliberately chosen boundary probes:

- NFC merges Greek capital omega `Ω` with ohm sign `Ω`; byte or code-point inequality is not enough.
- NFKC additionally folds double-struck `ℝ` into `R` and subscript `₁` into `1`.
- Precomposed `≠` and `=` followed by COMBINING LONG SOLIDUS OVERLAY normalize together.

NFC handles canonical equivalence; NFKC also removes compatibility distinctions [3]. No candidate string in this ledger changes under NFC. NFKC changes the rejected Utility Measure candidate `ℝ` to `R`. This result is not a general safety guarantee for future mathematical alphabets or index syntax.

Text/emoji presentation can vary, particularly for pictographs such as tools and gears. Variation selectors request supported presentations; they are not a general-purpose way to give the same character two new Organon meanings [2, 5]. Distinct code points and normalization-stable strings can still be visually confusable, depending on fonts and context [4].

<!-- organon:proposal-statement UG-G1 type=open_formalization_gate -->
**Open formalization gate:** before adopting compositional notation, specify its grammar, typed interpretation, Scope and index preservation. Demonstrate decoding and reject ill-typed or ambiguously joined expressions. Lean could check such interpretation laws, but a theorem that an alias decodes to its ID would prove only the lookup convention—not an inherited semantic match or reader comprehension.

This study introduces no Lean model. The manifest's `formal_shadow` points to the computational audit solely to satisfy the dossier's artifact contract; it is not a Lean proof or semantic-equivalence certificate.

<!-- organon:proposal-statement UG-E1 type=open_evidence_gate -->
**Open evidence gate:** compare labelled symbols against plain labels on realistic reading tasks before adopting them. Test recognition, mistaken entailments, keyboard entry, copy/paste, screen-reader output, font fallback and text/emoji rendering. No such user or renderer study has been performed here.

A small follow-up experiment should include:

1. Six labelled trial cues from the table above, plus their plain-label controls.
2. Adjacent-term distinctions: Denotation/Transformation, Sense/Perception/Observation, Attention/Care and Claim/Evidence/Truth. Test incorrect interpretations, not just recall of names.
3. GitHub and Obsidian at ordinary text sizes, light and dark themes, and at least two operating-system/font environments. Check every retained candidate, not only attractive screenshots.
4. A screen reader and text-only export. If a mark is announced as an unrelated operation or disappears, the label must still carry the intended reference.

Adopt only if the experiment improves the selected reading task without concealing distinctions. An inconclusive or negative result supports keeping prose and using symbols only in local diagrams. The custom typeface follow-up above now explores SVG-derived private-use characters; its font, distribution, and accessibility costs do not disappear merely because we control the drawings.

## Reproducing the computational checks

```sh
python3 scripts/check-unicode-vocabulary.py
python3 scripts/check-unicode-vocabulary.py --write
```

The default command is read-only; `--write` regenerates the atlas after an intentional candidate edit. Both read the pinned source commit through Git and verify its SHA-256 digests. A shallow checkout lacking it needs its history fetched first. Later ontology revisions do not silently change this historical assessment; a new assessment must deliberately update its source pin and judgments.

The command reports the runtime Unicode database version (initially Python's UCD 14.0.0). The standards discussion uses Unicode 17.0 documentation; it does not claim the runtime validates the whole 17.0 repertoire. All current candidates have names in the tested runtime. Generated output contains character names and normalization results rather than a machine-specific runtime-version header.

## Statement registry

| ID | Type | Claim | Remaining boundary |
| --- | --- | --- | --- |
| UG-H1 | hypothesis | Labelled glyphs may improve diagram reading | Reader comparison not performed |
| UG-C1 | anti_collapse_constraint | Typography neither proves nor refutes definition equivalence | No semantic correspondence proved |
| UG-G1 | open_formalization_gate | Define and check a compositional grammar before adoption | No notation grammar or Lean interpretation yet |
| UG-E1 | open_evidence_gate | Test usability, rendering and accessibility | No user or renderer validation yet |

## Sources

1. [Unicode 17.0, chapter 2, especially §§2.2.3–2.2.4](https://www.unicode.org/versions/Unicode17.0.0/core-spec/chapter-2/): characters versus glyphs and character semantics.
2. [Unicode Technical Report #25, revision 15, especially §§2.7 and 2.18](https://www.unicode.org/reports/tr25/tr25-15.pdf): context-dependent mathematical meanings, mathematical alphabet distinctions and variation selectors.
3. [Unicode Standard Annex #15](https://www.unicode.org/reports/tr15/): canonical and compatibility normalization.
4. [Unicode Technical Standard #39](https://www.unicode.org/reports/tr39/): confusability and the limits of confusable detection.
5. [Unicode Technical Standard #51](https://www.unicode.org/reports/tr51/): emoji and text presentation sequences.
