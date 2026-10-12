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
import { linkTerms, mathFor } from "./content.js";
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
      <details className="notation-details" key={term.id}>
        <summary>Notation</summary>
        <p className="math-note">
          {term.form
            ? "An existing nonbinding construction. All premises and witnesses share the variables below."
            : term.depends_on.length
              ? "Vocabulary required to state this definition. Not a logical equivalence; no complete algebraic form is supplied by the current experiment."
              : "A foundational commitment, not an algebraic derivation."}
        </p>
        {term.form && (
          <div className="variables">
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
          </div>
        )}
      </details>
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
                            : "mnemonic trial"}.
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
