import React, {
  lazy,
  Suspense,
  useEffect,
  useLayoutEffect,
  useMemo,
  useRef,
  useState,
} from "react";
import { createRoot } from "react-dom/client";
import {
  HashRouter,
  Link,
  useLocation,
  useSearchParams,
} from "react-router-dom";
import Markdown from "react-markdown";
import katex from "katex";
import "katex/dist/katex.min.css";
import "@fontsource-variable/inter";
import "@fontsource-variable/newsreader";
import "./style.css";
import data from "./data.json";
import { linkTerms, mathFor } from "./content.js";
import Graph from "./Graph.jsx";

const Sky = lazy(() => import("./Sky.jsx"));
const { terms, version } = data;
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
              {glyphs ? (
                <span className={linked.glyph ? "" : "fallback-inline"}>
                  {linked.glyph || `[${linked.claim_id}]`}
                </span>
              ) : (
                children
              )}
            </Link>
          );
        },
      }}
    >
      {text}
    </Markdown>
  );
}

function Formula({ term }) {
  const html = useMemo(
    () =>
      katex.renderToString(mathFor(term, terms), {
        displayMode: true,
        throwOnError: true,
        output: "htmlAndMathml",
      }),
    [term],
  );
  return (
    <div className="formula-wrap">
      <div className="formula-meta">
        {term.form
          ? "Candidate witness form"
          : term.depends_on.length
            ? "Lexical dependency signature"
            : "Retained foundation"}
      </div>
      <div className="formula" dangerouslySetInnerHTML={{ __html: html }} />
      <p className="math-note">
        {term.form
          ? "An existing nonbinding construction. All premises and witnesses share the variables below."
          : term.depends_on.length
            ? "Vocabulary required to state this definition. Not a logical equivalence; no complete algebraic form is supplied by the current experiment."
            : "A foundational commitment, not an algebraic derivation."}
      </p>
      {term.form && (
        <details className="variables">
          <summary>Variables & limits</summary>
          <dl>
            {Object.entries(term.form.variables).map(([key, kind], index) => (
              <div key={key}>
                <dt>
                  x<sub>{index + 1}</sub>
                </dt>
                <dd>
                  {key} · {kind}
                </dd>
              </div>
            ))}
          </dl>
          {term.form.anti_entailments.map((item, i) => (
            <p key={i}>{item.statement}</p>
          ))}
        </details>
      )}
    </div>
  );
}

function App() {
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
      {graph && selected && (
        <Suspense fallback={null}>
          <Sky paused={paused} />
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
          Organon <span className="brand-divider">/</span>
        </Link>
        <span className="byline">
          by{" "}
          <a
            href="https://github.com/sadasant"
            target="_blank"
            rel="noreferrer"
          >
            sadasant.ai ↗
          </a>
        </span>
        <nav>
          <button onClick={goIndex}>
            Index <span>↗</span>
          </button>
          <a href={source} target="_blank" rel="noreferrer">
            Repository ↗
          </a>
        </nav>
      </header>
      <main>
        <section className="intro">
          <div className="intro-mark" aria-hidden="true">
            ◎
          </div>
          <div>
            <p className="edition">An experimental atlas · v{version}</p>
            <h1>
              A vocabulary
              <br />
              of relations.
            </h1>
            <p className="intro-copy">
              Every definition opens onto another.
              <br />
              Choose a mark. Follow the connections.
            </p>
          </div>
          <div className="intro-end">
            <span>115 terms</span>
            <span>One connected vocabulary</span>
          </div>
        </section>
        <div id="atlas" className="atlas-toolbar">
          <span>In the order of Organon</span>
          <label>
            <span className="sr-only">Find a term</span>
            <span aria-hidden="true">⌕</span>
            <input
              type="search"
              placeholder="Find a term"
              value={query}
              onChange={(e) => setQuery(e.target.value)}
            />
          </label>
        </div>
        <div className="glyph-grid">
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
          {visible.map((term, index) => (
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
                <span className="tile-number">
                  {String(terms.indexOf(term) + 1).padStart(3, "0")}
                </span>
                <span className={term.glyph ? "tile-glyph" : "tile-fallback"}>
                  {term.glyph || term.claim_id}
                </span>
                <span className="tile-label">{term.label}</span>
              </Link>
              {selected?.id === term.id && (
                <article
                  ref={panel}
                  className="term-panel"
                  aria-label={`${term.label} definition`}
                >
                  <div className="panel-tools">
                    <span>
                      {term.claim_id} <span className="tool-divider">/</span>{" "}
                      {String(terms.indexOf(term) + 1).padStart(3, "0")} of 115
                    </span>
                    <Link
                      to={`/${location.search}`}
                      aria-label="Close definition"
                    >
                      Close ×
                    </Link>
                  </div>
                  <div className="definition-block">
                    <div className="term-heading">
                      <span
                        className={
                          term.glyph ? "heading-glyph" : "heading-fallback"
                        }
                        aria-hidden="true"
                      >
                        {term.glyph || term.claim_id}
                      </span>
                      <h1 tabIndex={-1}>{term.label}</h1>
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
                    {glyphs && (
                      <p className="notation-note">
                        Trial glyphs; bracketed IDs mark unassigned terms.
                      </p>
                    )}
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
                      {graph && (
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
                      <Formula term={term} />
                    )}
                  </div>
                  <div className="entry-notes">
                    <details key={term.id}>
                      <summary>
                        Full entry & notation notes <span>+</span>
                      </summary>
                      <div className="full-entry">
                        <Definition
                          term={term}
                          glyphs={false}
                          search={location.search}
                          full
                        />
                      </div>
                      <p className="notation-note">
                        {term.glyph ? "Trial glyph. " : "No glyph assigned. "}
                        {term.glyphNote}
                      </p>
                      <a
                        href={`${source}/blob/main/ontology/ontology.md#${term.anchor}`}
                        target="_blank"
                        rel="noreferrer"
                      >
                        Read the canonical source ↗
                      </a>
                    </details>
                    <div className="term-pagination">
                      {terms.indexOf(term) > 0 ? (
                        <Link
                          to={`/term/${terms[terms.indexOf(term) - 1].slug}${location.search}`}
                        >
                          ← {terms[terms.indexOf(term) - 1].label}
                        </Link>
                      ) : (
                        <span />
                      )}
                      {terms.indexOf(term) < terms.length - 1 && (
                        <Link
                          to={`/term/${terms[terms.indexOf(term) + 1].slug}${location.search}`}
                        >
                          {terms[terms.indexOf(term) + 1].label} →
                        </Link>
                      )}
                    </div>
                  </div>
                </article>
              )}
            </React.Fragment>
          ))}
        </div>
        <footer>
          <p>A notation experiment, not a new ontology.</p>
          <p>
            Trial glyphs are provisional. IDs fill the gaps.
            <br />
            Definitions remain the source of meaning.
          </p>
          <a href={`${source}/pull/20`} target="_blank" rel="noreferrer">
            About the glyph study ↗
          </a>
        </footer>
      </main>
    </div>
  );
}

createRoot(document.getElementById("root")).render(
  <HashRouter>
    <App />
  </HashRouter>,
);
