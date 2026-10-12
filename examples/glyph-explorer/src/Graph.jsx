import React, { useEffect, useMemo, useRef, useState } from "react";
import {
  forceCollide,
  forceLink,
  forceManyBody,
  forceSimulation,
} from "d3-force";
import { locality, ontologyGraph } from "./content.js";
import Glyph from "./Glyph.jsx";

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
  const graph = useMemo(() => ontologyGraph(terms), [terms]);
  const positions = useMemo(() => {
    const nodes = graph.nodes.map((t) => ({ id: t.id }));
    // Lay out the entire DAG once, deterministically. Navigation moves the
    // viewport; it never gives shared terms a different place in the graph.
    const simulation = forceSimulation(nodes)
      .force(
        "links",
        forceLink(graph.edges.map((e) => ({ ...e })))
          .id((n) => n.id)
          .distance(150)
          .strength(0.15),
      )
      .force("charge", forceManyBody().strength(-900))
      .force("collision", forceCollide(65))
      .stop();
    simulation.tick(350);
    return new Map(nodes.map((n) => [n.id, n]));
  }, [graph]);
  const [whole, setWhole] = useState(false);
  const [camera, setCamera] = useState({ x: 0, y: 0, zoom: 1 });
  const [cameraTarget, setCameraTarget] = useState(camera);
  const cameraPosition = useRef(camera);
  const [reducedMotion, setReducedMotion] = useState(
    () => matchMedia("(prefers-reduced-motion: reduce)").matches,
  );
  const viewport = useRef(null);
  const drag = useRef(null);
  const [width, setWidth] = useState(1000);
  const absence = term.id === "organon:Absence";
  const visible = absence
    ? { nodes: [term], edges: [] }
    : whole
      ? graph
      : locality(term, terms);
  const nodes = visible.nodes.map((t) => ({
    term: t,
    ...(positions.get(t.id) || { x: 0, y: 0 }),
  }));
  const height = width < 600 ? 420 : 500;
  const minX = Math.min(...nodes.map((n) => n.x));
  const maxX = Math.max(...nodes.map((n) => n.x));
  const minY = Math.min(...nodes.map((n) => n.y));
  const maxY = Math.max(...nodes.map((n) => n.y));
  const fit = Math.max(
    (maxX - minX) / (width - 150),
    (maxY - minY) / (height - 140),
    0.8,
  );
  const scale = fit / camera.zoom;
  const nodeScale = Math.max(1, scale * (whole ? 0.65 : 1));
  const viewWidth = width * scale;
  const viewHeight = height * scale;
  const centerX = (minX + maxX) / 2 + camera.x;
  const centerY = (minY + maxY) / 2 + camera.y;
  // Stable, decorative depth, unrelated to term order or importance. Project
  // nodes and edge endpoints together so connections never detach during pan.
  const projected = new Map(
    nodes.map((n) => {
      const seed = [...n.term.id].reduce(
        (hash, char) => (hash * 31 + char.charCodeAt(0)) >>> 0,
        0,
      );
      const depth = reducedMotion ? 1 : 0.99 + (seed % 1000) / 50000;
      return [
        n.term.id,
        {
          ...n,
          depth,
          x: n.x - camera.x * (depth - 1),
          y: n.y - camera.y * (depth - 1),
        },
      ];
    }),
  );
  const reset = () => {
    const next = { x: 0, y: 0, zoom: 1 };
    cameraPosition.current = next;
    setCamera(next);
    setCameraTarget(next);
  };
  const zoom = (factor) =>
    setCameraTarget((c) => ({
      ...c,
      zoom: Math.max(0.5, Math.min(8, c.zoom * factor)),
    }));

  useEffect(() => {
    if (reducedMotion) {
      cameraPosition.current = cameraTarget;
      setCamera(cameraTarget);
      return;
    }
    // Ease toward a bounded target, not a fling: no accumulating velocity or
    // endless drift after release. Stop drawing once the view has settled.
    let frame;
    let last = performance.now();
    const settle = (now) => {
      const fraction = 1 - Math.exp(-(now - last) / 240);
      last = now;
      const current = cameraPosition.current;
      const next = Object.fromEntries(
        Object.keys(current).map((key) => [
          key,
          current[key] + (cameraTarget[key] - current[key]) * fraction,
        ]),
      );
      const arrived =
        Math.hypot(next.x - cameraTarget.x, next.y - cameraTarget.y) < 0.01 &&
        Math.abs(next.zoom - cameraTarget.zoom) < 0.0001;
      cameraPosition.current = arrived ? cameraTarget : next;
      setCamera(cameraPosition.current);
      if (!arrived) frame = requestAnimationFrame(settle);
    };
    frame = requestAnimationFrame(settle);
    return () => cancelAnimationFrame(frame);
  }, [cameraTarget, reducedMotion]);

  useEffect(() => {
    const observer = new ResizeObserver(([entry]) =>
      setWidth(entry.contentRect.width),
    );
    observer.observe(viewport.current);
    return () => observer.disconnect();
  }, []);
  useEffect(reset, [term.id, whole]);
  useEffect(() => {
    const media = matchMedia("(prefers-reduced-motion: reduce)");
    const update = () => setReducedMotion(media.matches);
    media.addEventListener("change", update);
    return () => media.removeEventListener("change", update);
  }, []);

  return (
    <div className="graph-section">
      <div className="graph-key">
        <div className="segments" role="group" aria-label="Graph extent">
          <button
            aria-pressed={!whole}
            disabled={absence}
            onClick={() => setWhole(false)}
          >
            Local
          </button>
          <button
            aria-pressed={whole}
            disabled={absence}
            onClick={() => setWhole(true)}
          >
            Whole DAG
          </button>
        </div>
        <div className="graph-camera" role="group" aria-label="Graph camera">
          <button aria-label="Zoom out" onClick={() => zoom(1 / 1.18)}>
            −
          </button>
          <button onClick={reset}>Fit</button>
          <button aria-label="Zoom in" onClick={() => zoom(1.18)}>
            +
          </button>
        </div>
      </div>
      <div className="graph-viewport" ref={viewport}>
        <svg
          className={`constellation${whole ? " whole-graph" : ""}`}
          viewBox={`${centerX - viewWidth / 2} ${centerY - viewHeight / 2} ${viewWidth} ${viewHeight}`}
          style={{ height }}
          role="group"
          tabIndex={0}
          aria-label={`${absence ? "Absence outside the DAG" : `${whole ? "Whole" : "Local"} ontology DAG: ${term.label}`}. Drag to pan; use arrow keys and zoom controls.`}
          onDragStart={(event) => event.preventDefault()}
          onKeyDown={(event) => {
            const movement = {
              ArrowLeft: [-12, 0],
              ArrowRight: [12, 0],
              ArrowUp: [0, -12],
              ArrowDown: [0, 12],
            }[event.key];
            if (movement) {
              event.preventDefault();
              setCameraTarget((c) => ({
                ...c,
                x: c.x + movement[0] * scale,
                y: c.y + movement[1] * scale,
              }));
            }
          }}
          onPointerDown={(event) => {
            if (event.button !== 0) return;
            drag.current = {
              x: event.clientX,
              y: event.clientY,
              camera,
              scale,
              moved: false,
            };
          }}
          onPointerMove={(event) => {
            const start = drag.current;
            if (!start || event.buttons === 0) return;
            const dx = event.clientX - start.x,
              dy = event.clientY - start.y;
            if (!start.moved && Math.hypot(dx, dy) < 5) return;
            start.moved = true;
            event.currentTarget.setPointerCapture(event.pointerId);
            setCameraTarget({
              ...start.camera,
              x: start.camera.x - dx * start.scale * 0.055,
              y: start.camera.y - dy * start.scale * 0.055,
            });
          }}
          onPointerUp={() => {
            // Keep moved until the ensuing click has been suppressed.
            if (drag.current && !drag.current.moved) drag.current = null;
          }}
          onPointerCancel={() => {
            drag.current = null;
          }}
          onClickCapture={(event) => {
            if (drag.current?.moved) {
              event.preventDefault();
              event.stopPropagation();
            }
            drag.current = null;
          }}
        >
          <defs>
            <marker
              id="arrow"
              viewBox="0 0 10 10"
              refX="10"
              refY="5"
              markerWidth="6"
              markerHeight="6"
              orient="auto"
            >
              <path d="M 0 0 L 10 5 L 0 10" fill="none" stroke="#aaa" />
            </marker>
          </defs>
          {visible.edges.map((edge) => {
            const from = projected.get(edge.source),
              to = projected.get(edge.target);
            const dx = to.x - from.x,
              dy = to.y - from.y;
            const distance = Math.hypot(dx, dy);
            // Two depth planes can overlap at a particular camera position.
            if (distance === 0) return null;
            const inset = Math.min(24 * nodeScale, distance * 0.3);
            const selected = edge.source === term.id || edge.target === term.id;
            return (
              <line
                key={`${edge.source}-${edge.target}`}
                data-source={edge.source}
                data-target={edge.target}
                x1={from.x + (dx / distance) * inset}
                y1={from.y + (dy / distance) * inset}
                x2={to.x - (dx / distance) * inset}
                y2={to.y - (dy / distance) * inset}
                markerEnd="url(#arrow)"
                className={`graph-edge${selected ? " incident" : ""}`}
              />
            );
          })}
          {[...projected.values()]
            .sort((a, b) => a.depth - b.depth)
            .map((n) => {
              const selected = n.term.id === term.id;
              return (
                <a
                  key={n.term.id}
                  href={`#/term/${n.term.slug}${search}`}
                  aria-label={`Open ${n.term.label}`}
                  aria-current={selected ? "true" : undefined}
                  className={selected ? "star-node selected" : "star-node"}
                  transform={`translate(${n.x} ${n.y}) scale(${nodeScale * n.depth})`}
                >
                  <title>{n.term.label}</title>
                  <circle r={22} className="node-hit" />
                  {!absence && (
                    <circle r={selected ? 4 : 2} className="node-star" />
                  )}
                  <Glyph
                    term={n.term}
                    x={-8.5}
                    y={-25}
                    width={17}
                    height={17}
                    className="node-glyph"
                  />
                  <text x={0} y={18} textAnchor="middle" className="node-label">
                    {labelLines(n.term.label).map((line, i) => (
                      <tspan key={i} x={0} dy={i ? 14 : 0}>
                        {line}
                      </tspan>
                    ))}
                  </text>
                </a>
              );
            })}
        </svg>
      </div>
      <p className="graph-note">
        {absence
          ? "Absence is not a node within Presence. A3’s contrast belongs to the metalanguage."
          : `${nodes.length} terms · ${visible.edges.length} connections · Arrows: used to define, not causation. Depth is decorative. Drag to explore.`}
      </p>
    </div>
  );
}
