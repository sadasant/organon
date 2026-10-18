import React, { useId } from "react";
import { Link, useNavigate } from "react-router-dom";
import Glyph from "./Glyph.jsx";
import DefinitionDiagram from "./DefinitionDiagram.jsx";
import diagrams from "./diagrams/index.js";

const readings = {
  "organon:Transformation": {
    title: "One transformation, two States",
    description: "T maps input State s₀ to output State s₁ under Direction d.",
    note: "The wire labels name States, not terms in the dependency graph. Direction d belongs to this Transformation; the reading direction does not assert chronological order.",
  },
  "organon:Feeds": {
    title: "An explicit account of supply",
    description:
      "A specified part a of State s₁ supplies a specified part b of State s₂. The States need not be equal.",
    note: "The highlighted connection illustrates one part-to-part account. The other dots indicate context left unspecified, not discarded resources. Feeds alone asserts neither equality of the States nor a Transformation between them.",
  },
  "organon:CausalPath": {
    title: "Two transformations, one Direction",
    description:
      "T₁ maps State s₀ to State s₁. State s₁ Feeds State s₂ under an explicit part-to-part account. T₂ maps State s₂ to State s₃. Both Transformations share Direction d.",
    note: "This is a two-step example, not a fixed path length. Feeds is a separate relation, not a third Transformation. The path does not assert that s₁ and s₂ are equal or that the sequence collapses into one Transformation.",
  },
};

function Box({ x, y = 88, vertical = false, label, term, detail }) {
  return (
    <g>
      <rect className="string-box" x={x} y={y} width="120" height="76" />
      <Glyph
        term={term}
        x={x + 14}
        y={y + (vertical ? 9 : 22)}
        width="28"
        height="28"
      />
      <text
        x={x + 78}
        y={y + (vertical ? 31 : 44)}
        className="string-operation"
      >
        {label}
      </text>
      <text x={x + 60} y={y + (vertical ? 62 : 106)} className="string-muted">
        {detail}
      </text>
    </g>
  );
}

function Drawing({ term, terms, reading, vertical }) {
  const id = useId();
  const transformation = terms.find((t) => t.id === "organon:Transformation");
  const feeds = terms.find((t) => t.id === "organon:Feeds");
  const path = term.id === "organon:CausalPath";
  const feeding = term.id === "organon:Feeds";
  const width = vertical ? 320 : path ? 860 : 640;
  const height = vertical ? (path ? 540 : feeding ? 380 : 290) : 230;
  const wire = (start, end, label) => (
    <g>
      <path
        className="string-wire"
        d={vertical ? `M 160 ${start} V ${end}` : `M ${start} 126 H ${end}`}
        markerEnd={`url(#${id}-arrow)`}
      />
      <text
        x={vertical ? 146 : (start + end) / 2}
        y={vertical ? (start + end) / 2 + 4 : 108}
        textAnchor={vertical ? "end" : "middle"}
      >
        {label}
      </text>
    </g>
  );

  return (
    <svg
      className={`string-diagram ${vertical ? "string-vertical" : "string-horizontal"}`}
      viewBox={`0 0 ${width} ${height}`}
      role="img"
      aria-labelledby={`${id}-title ${id}-description`}
    >
      <title id={`${id}-title`}>{reading.title}</title>
      <desc id={`${id}-description`}>{reading.description}</desc>
      <defs>
        <marker
          id={`${id}-arrow`}
          viewBox="0 0 10 10"
          refX="9"
          refY="5"
          markerWidth="6"
          markerHeight="6"
          orient="auto-start-reverse"
        >
          <path d="M 1 1 L 9 5 L 1 9" className="string-wire" />
        </marker>
      </defs>
      {vertical ? (
        feeding ? (
          <>
            <rect
              className="string-state"
              x="75"
              y="10"
              width="170"
              height="115"
            />
            <rect
              className="string-state"
              x="75"
              y="245"
              width="170"
              height="115"
            />
            <text x="160" y="36">
              State s₁
            </text>
            <text x="160" y="338">
              State s₂
            </text>
            <circle className="string-part" cx="140" cy="100" r="4" />
            <circle className="string-part" cx="180" cy="270" r="4" />
            <circle className="string-context" cx="205" cy="68" r="3" />
            <circle className="string-context" cx="110" cy="300" r="3" />
            <text x="120" y="104">
              a
            </text>
            <text x="200" y="274">
              b
            </text>
            <path
              className="string-wire"
              d="M 140 105 C 140 170 180 200 180 263"
              markerEnd={`url(#${id}-arrow)`}
            />
            <text x="145" y="187" textAnchor="end">
              supplies
            </text>
          </>
        ) : path ? (
          <>
            <text x="160" y="22">
              T₁ and T₂ share Direction d
            </text>
            <path className="string-scope" d="M 230 70 H 255 V 474 H 230" />
            {wire(38, 70, "State s₀")}
            <Box
              x={100}
              y={70}
              vertical
              label="T₁"
              term={transformation}
              detail="Transformation"
            />
            {wire(146, 234, "State s₁")}
            <Box
              x={100}
              y={234}
              vertical
              label="Feeds"
              term={feeds}
              detail="explicit account"
            />
            {wire(310, 398, "State s₂")}
            <Box
              x={100}
              y={398}
              vertical
              label="T₂"
              term={transformation}
              detail="Transformation"
            />
            {wire(474, 526, "State s₃")}
          </>
        ) : (
          <>
            <text x="160" y="24">
              Direction d
            </text>
            {wire(40, 108, "input State s₀")}
            <Box
              x={100}
              y={108}
              vertical
              label="T"
              term={transformation}
              detail="Transformation"
            />
            {wire(184, 270, "output State s₁")}
          </>
        )
      ) : feeding ? (
        <>
          <rect
            className="string-state"
            x="40"
            y="55"
            width="170"
            height="140"
          />
          <rect
            className="string-state"
            x="430"
            y="55"
            width="170"
            height="140"
          />
          <text x="125" y="82">
            State s₁
          </text>
          <text x="515" y="82">
            State s₂
          </text>
          <circle className="string-part" cx="175" cy="116" r="4" />
          <circle className="string-part" cx="465" cy="156" r="4" />
          <circle className="string-context" cx="85" cy="155" r="3" />
          <circle className="string-context" cx="550" cy="115" r="3" />
          <text x="140" y="121">
            a
          </text>
          <text x="500" y="161">
            b
          </text>
          <path
            className="string-wire"
            d="M 180 116 C 290 116 350 156 458 156"
            markerEnd={`url(#${id}-arrow)`}
          />
          <text x="320" y="110">
            supplies
          </text>
          <text x="320" y="192" className="string-muted">
            specified part-to-part account
          </text>
        </>
      ) : path ? (
        <>
          <path className="string-scope" d="M 140 66 V 46 H 720 V 66" />
          <text x="430" y="31">
            shared Direction d
          </text>
          {wire(20, 140, "State s₀")}
          <Box
            x={140}
            label="T₁"
            term={transformation}
            detail="Transformation"
          />
          {wire(260, 370, "State s₁")}
          <Box x={370} label="Feeds" term={feeds} detail="explicit account" />
          {wire(490, 600, "State s₂")}
          <Box
            x={600}
            label="T₂"
            term={transformation}
            detail="Transformation"
          />
          {wire(720, 840, "State s₃")}
        </>
      ) : (
        <>
          <text x="320" y="48">
            Direction d
          </text>
          {wire(60, 260, "input State s₀")}
          <Box
            x={260}
            label="T"
            term={transformation}
            detail="Transformation"
          />
          {wire(380, 580, "output State s₁")}
        </>
      )}
    </svg>
  );
}

export default function StringDiagram({ term, terms, search }) {
  const navigate = useNavigate();
  const custom = readings[term.id];
  const card = diagrams[term.id];
  const reading = custom || card;
  const index = terms.findIndex((t) => t.id === term.id);
  const params = new URLSearchParams(search);
  params.set("view", "string");
  const diagramSearch = `?${params}`;
  const route = (t) => `/term/${t.slug}${diagramSearch}`;
  const previous = terms[(index + terms.length - 1) % terms.length];
  const next = terms[(index + 1) % terms.length];

  return (
    <section
      className={`string-section${term.id === "organon:CausalPath" ? " string-path" : ""}`}
      aria-label="String diagram"
    >
      {reading ? (
        <figure>
          <div className="string-meta">Illustrative notation · nonbinding</div>
          <h2>{reading.title}</h2>
          {custom ? (
            <>
              <Drawing
                term={term}
                terms={terms}
                reading={reading}
                vertical={false}
              />
              <Drawing term={term} terms={terms} reading={reading} vertical />
            </>
          ) : (
            <>
              <p className="diagram-legend">
                {["relational", "specification"].includes(card.kind)
                  ? "Relational specification · shared participants, comparison witnesses and explicit obligations"
                  : "Foundational distinction · no process or construction asserted"}
              </p>
              <DefinitionDiagram term={term} card={card} />
            </>
          )}
          <figcaption>
            <p>{reading.description || reading.reading}</p>
            {card && (
              <ul
                className="diagram-conditions"
                aria-label="Conditions retained in this sketch"
              >
                {card.conditions.map((condition) => (
                  <li key={condition}>{condition}</li>
                ))}
              </ul>
            )}
            <p className="string-note">{reading.note}</p>
            {card && (
              <p className="string-note">
                A review sketch, not a complete formal encoding. The full
                definition remains in Notes below.
              </p>
            )}
          </figcaption>
          {card?.ports.some((port) => port.term) && (
            <nav className="diagram-related" aria-label="Related term diagrams">
              {[
                ...new Set(card.ports.map((port) => port.term).filter(Boolean)),
              ].map((id) => {
                const related = terms.find((t) => t.id === id);
                return (
                  <Link key={id} to={route(related)}>
                    {related.label}
                  </Link>
                );
              })}
            </nav>
          )}
        </figure>
      ) : (
        <p className="string-empty">
          No string diagram modeled for {term.label} yet.
        </p>
      )}
      <nav className="diagram-review" aria-label="Browse diagrams">
        <label className="diagram-picker">
          <span>
            Diagram {index + 1} of {terms.length}
          </span>
          <select
            aria-label="Choose a diagram"
            value={term.id}
            onChange={(event) =>
              navigate(route(terms.find((t) => t.id === event.target.value)))
            }
          >
            {terms.map((t) => (
              <option key={t.id} value={t.id}>
                {t.label}
              </option>
            ))}
          </select>
        </label>
        <Link to={route(previous)} rel="prev">
          ← {previous.label}
        </Link>
        <Link to={route(next)} rel="next">
          {next.label} →
        </Link>
      </nav>
    </section>
  );
}
