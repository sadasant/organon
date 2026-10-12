import React, {
  lazy,
  Suspense,
  useEffect,
  useLayoutEffect,
  useMemo,
  useRef,
  useState,
} from "react";
import { Link, useLocation, useSearchParams } from "react-router-dom";
import Markdown from "react-markdown";
import katex from "katex";
import data from "./data.json";
import { linkTerms } from "./content.js";
import {
  declarationMath,
  parameterMath,
  mathRenderOptions,
} from "./lean-math.js";
import Graph from "./Graph.jsx";
import Glyph from "./Glyph.jsx";

const Sky = lazy(() => import("./Sky.jsx"));
const { terms } = data;
const plugins = [linkTerms(terms)];
const source = "https://github.com/sadasant/organon";
const termBySlug = new Map(terms.map((t) => [t.slug, t]));

function Segments({ label, value, options, onChange }) {
  return (
    <div className="segments" role="group" aria-label={label}>
      {options.map((option) => (
        <button
          key={option.value}
          aria-pressed={value === option.value}
          onClick={() => onChange(option.value)}
        >
          {option.label}
        </button>
      ))}
    </div>
  );
}

function Definition({ term, glyphs, search, full = false }) {
  const text = full
    ? term.fullEntry
    : term.statement.replace(`**${term.label}**`, "").trimStart();
  return (
    <Markdown
      remarkPlugins={plugins}
      components={{
        a: ({ href, children }) => {
          const linked = termBySlug.get(href?.replace("#/term/", ""));
          if (!linked) return <a href={href}>{children}</a>;
          return (
            <Link
              to={`/term/${linked.slug}${search}`}
              title={linked.label}
              aria-label={linked.label}
              className={glyphs ? "inline-glyph" : ""}
            >
              {glyphs ? <Glyph term={linked} /> : children}
            </Link>
          );
        },
      }}
    >
      {text}
    </Markdown>
  );
}

function MathExpression({ expression, englishExpression }) {
  const html = useMemo(
    () =>
      expression
        ? katex.renderToString(expression, {
            ...mathRenderOptions,
            output: englishExpression ? "html" : "htmlAndMathml",
          })
        : null,
    [expression, englishExpression],
  );
  const accessible = useMemo(
    () =>
      englishExpression
        ? katex.renderToString(englishExpression, {
            displayMode: true,
            throwOnError: true,
            output: "mathml",
          })
        : null,
    [englishExpression],
  );
  return html ? (
    <div
      className="formula"
      tabIndex={0}
      aria-label="Mathematical expression; scroll horizontally if needed"
    >
      <span
        aria-hidden={accessible ? true : undefined}
        dangerouslySetInnerHTML={{ __html: html }}
      />
      {accessible && (
        <span
          className="sr-only"
          dangerouslySetInnerHTML={{ __html: accessible }}
        />
      )}
    </div>
  ) : null;
}

function LeanDeclaration({ declaration, selection = {}, glyphs = false }) {
  return (
    <section
      className="lean-declaration"
      aria-label={`${declaration.name} formal declaration`}
    >
      <MathExpression
        expression={declarationMath(declaration, selection, glyphs)}
        englishExpression={
          glyphs ? declarationMath(declaration, selection) : null
        }
      />
      <details className="notation-details">
        <summary>Parameters, notation & Lean source</summary>
        <MathExpression
          expression={parameterMath(declaration, glyphs)}
          englishExpression={glyphs ? parameterMath(declaration) : null}
        />
        <p className="math-note">
          Record braces specify typed fields in order, not a set of
          dependencies. Proposition-valued fields require proofs; later fields
          may refer to earlier ones. Names, application order and grouping
          follow Lean. Juxtaposition applies a function; a dot selects a field.
          Braces in the parameter signature mark implicit arguments. Type u
          names a universe; Prop names propositions. All displayed parameters
          are fixed for the construction below that signature. Glyphs abbreviate
          named types using the shared Organon Symbols catalog; variables and
          field names stay distinct. English notation and the Lean source retain
          the original names. Glyphs do not assert equivalence with prose.
        </p>
        {(selection.fields || selection.parameters) && (
          <>
            <p className="math-note">
              The excerpt above belongs to this full parent declaration; its
              other fields are not implied by the excerpt alone.
            </p>
            <MathExpression
              expression={declarationMath(declaration, {}, glyphs)}
              englishExpression={glyphs ? declarationMath(declaration) : null}
            />
          </>
        )}
        <pre className="lean-source">
          <code>{declaration.source}</code>
        </pre>
        <a
          className="math-source"
          href={`${source}/blob/main/${declaration.path}#L${declaration.line}-L${declaration.endLine}`}
          target="_blank"
          rel="noreferrer"
        >
          {declaration.symbol} ↗
        </a>
      </details>
    </section>
  );
}

function Formula({ term, glyphs }) {
  const math = term.math;
  const [primary, ...support] = math.declarations;
  return (
    <div className="formula-wrap" key={term.id}>
      <div className="formula-meta">
        {math.status === "unencoded"
          ? "No corresponding Lean encoding"
          : math.parameters
            ? "Supplied Lean parameter · not a definition"
            : math.fields
              ? "Lean field projection · partial encoding"
              : math.status === "projection"
                ? "Lean construction · scoped projection"
                : "Lean construction · noncanonical"}
      </div>
      {primary && (
        <LeanDeclaration
          declaration={primary}
          selection={math}
          glyphs={glyphs}
        />
      )}
      {math.note && <p className="math-note formal-boundary">{math.note}</p>}
      {support.length > 0 && (
        <details className="supporting-math">
          <summary>Supporting definitions ({support.length})</summary>
          {support.map((declaration) => (
            <LeanDeclaration
              key={declaration.symbol}
              declaration={declaration}
              glyphs={glyphs}
            />
          ))}
        </details>
      )}
      {!primary && math.reference && (
        <a
          className="math-source"
          href={`${source}/blob/main/${math.reference}`}
          target="_blank"
          rel="noreferrer"
        >
          Formalization decisions ↗
        </a>
      )}
      <p className="math-note formal-status">
        The Lean encoding is shown as written; equivalence with the full prose
        definition is not asserted.
      </p>
    </div>
  );
}

export default function App() {
  const location = useLocation();
  const [params, setParams] = useSearchParams();
  const [query, setQuery] = useState("");
  const [paused, setPaused] = useState(false);
  const panel = useRef(null);
  const slug = location.pathname.startsWith("/term/")
    ? location.pathname.slice(6)
    : null;
  const selected = termBySlug.get(slug);
  const unknown = location.pathname !== "/" && !selected;
  const graph = params.get("view") === "graph";
  const glyphs = params.get("text") === "glyphs";
  // Canonical position, not the filtered wall or the selected graph extent.
  const starDensity = selected
    ? terms.indexOf(selected) / (terms.length - 1)
    : 0;
  const setOption = (key, value) => {
    const next = new URLSearchParams(params);
    next.set(key, value);
    setParams(next, { replace: true, preventScrollReset: true });
  };
  useEffect(() => {
    document.title = selected
      ? `${selected.label} — Organon`
      : "Organon — a vocabulary of relations";
  }, [selected]);
  useEffect(() => {
    const previous = history.scrollRestoration;
    history.scrollRestoration = "manual";
    return () => {
      history.scrollRestoration = previous;
    };
  }, []);
  useLayoutEffect(() => {
    if (!selected) return;
    setQuery("");
    let cancelled = false;
    // Fonts can change every preceding grid row's height on a direct link.
    document.fonts.ready.then(() => {
      requestAnimationFrame(() => {
        if (cancelled) return;
        panel.current?.scrollIntoView({ block: "start", behavior: "instant" });
        panel.current?.querySelector("h1")?.focus({ preventScroll: true });
      });
    });
    return () => {
      cancelled = true;
    };
  }, [selected?.id]);
  const visible = terms.filter(
    (t) =>
      !query ||
      t.label.toLowerCase().includes(query.toLowerCase()) ||
      t.claim_id.toLowerCase().includes(query.toLowerCase()),
  );
  const goIndex = () => {
    setQuery("");
    document.getElementById("atlas")?.scrollIntoView({
      behavior: matchMedia("(prefers-reduced-motion: reduce)").matches
        ? "instant"
        : "smooth",
    });
  };
  return (
    <div className={`app ${graph && selected ? "graph-mode" : ""}`}>
      {graph && starDensity > 0 && (
        <Suspense fallback={null}>
          <Sky paused={paused} density={starDensity} />
        </Suspense>
      )}
      <header className="topbar">
        <Link
          to="/"
          className="wordmark"
          onClick={() => {
            setQuery("");
            window.scrollTo(0, 0);
          }}
        >
          Organon
        </Link>
        <span className="byline">
          by{" "}
          <a
            href="https://github.com/sadasant"
            target="_blank"
            rel="noreferrer"
          >
            sadasant.ai
          </a>
        </span>
        <nav>
          <button onClick={goIndex}>Index</button>
          <a href={source} target="_blank" rel="noreferrer">
            Repo
          </a>
        </nav>
      </header>
      <main>
        <div id="atlas" className="atlas-toolbar">
          <label>
            <span className="sr-only">Find a term</span>
            <svg viewBox="0 0 24 24" aria-hidden="true">
              <circle cx="10" cy="10" r="6" />
              <path d="m15 15 5 5" />
            </svg>
            <input
              type="search"
              placeholder="Find a term"
              value={query}
              onChange={(e) => setQuery(e.target.value)}
            />
          </label>
        </div>
        <div className={`glyph-grid ${query ? "searching" : ""}`}>
          {unknown && (
            <section className="not-found">
              <h1>That term isn’t in this atlas.</h1>
              <Link to="/">Return to the index</Link>
            </section>
          )}
          {!visible.length && (
            <p className="no-results">
              No matching term.{" "}
              <button onClick={() => setQuery("")}>Clear search</button>
            </p>
          )}
          {visible.map((term) => (
            <React.Fragment key={term.id}>
              <Link
                to={
                  selected?.id === term.id
                    ? `/${location.search}`
                    : `/term/${term.slug}${location.search}`
                }
                className={`glyph-tile ${term.id === selected?.id ? "active" : ""}`}
                aria-label={`Open ${term.label}`}
                aria-expanded={term.id === selected?.id}
                title={term.label}
              >
                <Glyph term={term} className="tile-glyph" />
                <span className="tile-label">{term.label}</span>
              </Link>
              {selected?.id === term.id && (
                <article
                  ref={panel}
                  className="term-panel"
                  aria-label={`${term.label} definition`}
                >
                  <div className="definition-block">
                    <div className="term-heading">
                      <Glyph term={term} className="heading-glyph" />
                      <h1 tabIndex={-1}>{term.label}</h1>
                      <Link
                        className="close-definition"
                        to={`/${location.search}`}
                        aria-label="Close definition"
                      >
                        ×
                      </Link>
                    </div>
                    <div className="definition-copy">
                      <Definition
                        term={term}
                        glyphs={glyphs}
                        search={location.search}
                      />
                    </div>
                    <Segments
                      label="Definition notation"
                      value={glyphs ? "glyphs" : "english"}
                      options={[
                        { value: "english", label: "English" },
                        { value: "glyphs", label: "Glyphs" },
                      ]}
                      onChange={(value) => setOption("text", value)}
                    />
                  </div>
                  <div className="representation">
                    <div className="representation-tools">
                      <Segments
                        label="Formal view"
                        value={graph ? "graph" : "algebra"}
                        options={[
                          { value: "algebra", label: "Algebra" },
                          { value: "graph", label: "Graph" },
                        ]}
                        onChange={(value) => setOption("view", value)}
                      />
                      {graph && starDensity > 0 && (
                        <button
                          className="motion-toggle"
                          aria-pressed={paused}
                          onClick={() => setPaused(!paused)}
                        >
                          {paused ? "Resume stars" : "Pause stars"}
                        </button>
                      )}
                    </div>
                    {graph ? (
                      <Graph
                        term={term}
                        terms={terms}
                        search={location.search}
                      />
                    ) : (
                      <Formula term={term} glyphs={glyphs} />
                    )}
                  </div>
                  <div className="entry-notes">
                    <details key={term.id}>
                      <summary>Notes</summary>
                      <div className="full-entry">
                        <Definition
                          term={term}
                          glyphs={false}
                          search={location.search}
                          full
                        />
                      </div>
                      <p className="notation-note">
                        Organon Symbols · provisional. Glyph review:{" "}
                        {term.glyphReview.verdict === "revise"
                          ? "needs revision"
                          : term.glyphReview.verdict === "revised"
                            ? "revised trial — awaiting review"
                            : "mnemonic trial"}
                        .
                      </p>
                      <p className="notation-note">{term.glyphReview.cue}</p>
                      <p className="notation-note">{term.glyphReview.risk}</p>
                      <p className="notation-note">
                        {term.glyphReview.recommendation}
                      </p>
                      <a
                        href={`${source}/blob/main/ontology/ontology.md#${term.anchor}`}
                        target="_blank"
                        rel="noreferrer"
                      >
                        Source
                      </a>
                    </details>
                  </div>
                </article>
              )}
            </React.Fragment>
          ))}
        </div>
      </main>
    </div>
  );
}
