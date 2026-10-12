import React, { useEffect, useRef, useState } from "react";
import { locality } from "./content.js";

function labelLines(label) {
  const lines = [""];
  for (const word of label.split(" ")) {
    const last = lines.length - 1;
    if (lines[last] && lines[last].length + word.length > 17) lines.push(word);
    else lines[last] += `${lines[last] ? " " : ""}${word}`;
  }
  return lines;
}

export default function Graph({ term, terms, search }) {
  const { dependencies, dependents } = locality(term, terms);
  const viewport = useRef(null);
  const [availableWidth, setAvailableWidth] = useState(1000);
  useEffect(() => {
    const observer = new ResizeObserver(([entry]) =>
      setAvailableWidth(entry.contentRect.width),
    );
    observer.observe(viewport.current);
    return () => observer.disconnect();
  }, []);
  const narrow = availableWidth < 600;
  const width = narrow ? Math.max(280, availableWidth) : 1000;
  const rows = Math.max(
    4,
    Math.ceil(Math.max(dependencies.length, dependents.length) / 3),
  );
  const inputRows = Math.ceil(dependencies.length / 2);
  const outputRows = Math.ceil(dependents.length / 2);
  const height = narrow ? (inputRows + outputRows) * 76 + 130 : rows * 76 + 70;
  const center = {
    x: width / 2,
    y: narrow ? inputRows * 76 + 45 : height / 2,
    term,
    center: true,
  };
  const place = (items, side) =>
    items.map((item, i) => {
      const column = Math.floor(i / rows);
      const inColumn = Math.min(rows, items.length - column * rows);
      if (narrow)
        return {
          term: item,
          side,
          x:
            items.length === 1
              ? width / 2
              : width * (i % 2 === 0 ? 0.24 : 0.76),
          y:
            side === "left"
              ? 30 + Math.floor(i / 2) * 76
              : center.y + 85 + Math.floor(i / 2) * 76,
        };
      return {
        term: item,
        x:
          side === "left"
            ? 115 + column * 125 + Math.sin(i * 1.7) * 18
            : 885 - column * 125 + Math.cos(i * 1.3) * 18,
        y: (height - (inColumn - 1) * 76) / 2 + (i % rows) * 76,
        side,
      };
    });
  const nodes = [
    ...place(dependencies, "left"),
    center,
    ...place(dependents, "right"),
  ];
  useEffect(() => {
    const el = viewport.current;
    el.scrollLeft = (el.scrollWidth - el.clientWidth) / 2;
    el.scrollTop = Math.max(
      0,
      (center.y * el.clientWidth) / width - el.clientHeight / 2,
    );
  }, [term.id, width, availableWidth, center.y]);
  return (
    <div className="graph-section">
      <div className="graph-key">
        <span>{dependencies.length} prerequisites</span>
        <span>Vocabulary flows {narrow ? "↓" : "→"}</span>
        <span>{dependents.length} dependents</span>
      </div>
      <div
        className="graph-viewport"
        ref={viewport}
        tabIndex={0}
        aria-label="Local dependency graph. Scroll to explore all nodes."
      >
        <svg
          className="constellation"
          viewBox={`0 0 ${width} ${height}`}
          style={{ aspectRatio: `${width}/${height}` }}
          role="group"
          aria-label={`Local vocabulary of ${term.label}`}
        >
          <defs>
            <marker
              id="arrow"
              viewBox="0 0 10 10"
              refX="10"
              refY="5"
              markerWidth="5"
              markerHeight="5"
              orient="auto-start-reverse"
            >
              <path d="M 0 0 L 10 5 L 0 10" fill="none" stroke="#858585" />
            </marker>
          </defs>
          {nodes
            .filter((n) => !n.center)
            .map((n) => {
              const from = n.side === "left" ? n : center;
              const to = n.side === "left" ? center : n;
              const dx = to.x - from.x,
                dy = to.y - from.y,
                distance = Math.hypot(dx, dy);
              return (
                <line
                  key={`edge-${n.term.id}`}
                  x1={from.x + (dx / distance) * 25}
                  y1={from.y + (dy / distance) * 25}
                  x2={to.x - (dx / distance) * 25}
                  y2={to.y - (dy / distance) * 25}
                  markerEnd="url(#arrow)"
                  className="graph-edge"
                />
              );
            })}
          {nodes.map((n) => (
            <a
              key={n.term.id}
              href={`#/term/${n.term.slug}${search}`}
              aria-label={`Open ${n.term.label}`}
              className={n.center ? "star-node selected" : "star-node"}
            >
              <title>
                {n.term.label} — {n.term.claim_id}
              </title>
              <circle
                cx={n.x}
                cy={n.y}
                r={n.center ? 30 : 23}
                className="node-hit"
              />
              <circle
                cx={n.x}
                cy={n.y}
                r={n.center ? 4 : 2}
                className="node-star"
              />
              <text
                x={n.x}
                y={n.y + (n.center ? -14 : -10)}
                textAnchor="middle"
                className={n.term.glyph ? "node-glyph" : "node-code"}
              >
                {n.term.glyph || n.term.claim_id}
              </text>
              <text
                x={n.x}
                y={n.y + (n.center ? 32 : 24)}
                textAnchor="middle"
                className="node-label"
              >
                {labelLines(n.term.label).map((line, i) => (
                  <tspan key={i} x={n.x} dy={i ? 14 : 0}>
                    {line}
                  </tspan>
                ))}
              </text>
            </a>
          ))}
        </svg>
      </div>
      <p className="graph-note">
        One hop in either direction. Arrows mean “used to define,” not
        causation.
        <span className="mobile-hint"> Scroll to explore.</span>
      </p>
    </div>
  );
}
