import React, { useId, useMemo } from "react";
import dagre from "@dagrejs/dagre";
import DiagramViewport from "./DiagramViewport.jsx";

const unordered = (edge) => ["identity", "comparison"].includes(edge.kind);
const lines = (text) => text.split("\n");

export function specificationLayout(structure) {
  const graph = new dagre.graphlib.Graph({ multigraph: true });
  graph.setGraph({
    rankdir: "TB",
    nodesep: 30,
    ranksep: 42,
    edgesep: 20,
    marginx: 20,
    marginy: 20,
  });
  graph.setDefaultEdgeLabel(() => ({}));
  for (const node of structure.nodes) {
    graph.setNode(node.id, {
      ...node,
      width: Math.max(
        130,
        ...lines(node.label).map((line) => line.length * 8 + 24),
      ),
      height: lines(node.label).length * 20 + 26,
    });
  }
  structure.edges.forEach((edge, i) =>
    graph.setEdge(
      edge.from,
      edge.to,
      {
        ...edge,
        width: Math.max(
          ...lines(edge.label).map((line) => line.length * 8 + 16),
        ),
        height: lines(edge.label).length * 18 + 10,
        labelpos: "c",
      },
      String(i),
    ),
  );
  dagre.layout(graph);
  return {
    ...graph.graph(),
    nodes: graph.nodes().map((id) => graph.node(id)),
    edges: graph.edges().map((edge) => graph.edge(edge)),
  };
}

function Text({ x, y, text, step }) {
  const rows = lines(text);
  return (
    <text
      x={x}
      y={y - ((rows.length - 1) * step) / 2}
      dominantBaseline="middle"
      textAnchor="middle"
    >
      {rows.map((line, i) => (
        <tspan key={i} x={x} dy={i ? step : 0}>
          {line}
        </tspan>
      ))}
    </text>
  );
}

export default function SpecificationDiagram({ term, structure }) {
  const id = useId();
  const layout = useMemo(() => specificationLayout(structure), [structure]);
  const names = new Map(structure.nodes.map((node) => [node.id, node.label]));
  return (
    <div className="specification-diagram">
      <p className="relation-context">{structure.context}</p>
      <p className="relation-key">
        Shared boxes identify the same participants. Arrows order the labelled
        relation, not time or causation unless stated. Possibilities, examples
        and exclusions are qualified in their labels.
      </p>
      <DiagramViewport
        key={term.id}
        width={layout.width}
        height={layout.height}
        label={term.label}
        labelledBy={`${id}-title ${id}-desc`}
      >
        <title
          id={`${id}-title`}
        >{`${term.label}: participants and labelled relationships`}</title>
        <desc id={`${id}-desc`}>
          {structure.context}.{" "}
          {structure.edges
            .map(
              (edge) =>
                `${names.get(edge.from).replaceAll("\n", " ")} — ${edge.label.replaceAll("\n", " ")} — ${names.get(edge.to).replaceAll("\n", " ")}.`,
            )
            .join(" ")}{" "}
          All accompanying conditions still apply.
        </desc>
        <defs>
          <marker
            id={`${id}-arrow`}
            viewBox="0 0 10 10"
            refX="9"
            refY="5"
            markerWidth="6"
            markerHeight="6"
            orient="auto"
          >
            <path d="M 1 1 L 9 5 L 1 9" className="specification-edge" />
          </marker>
        </defs>
        {layout.edges.map((edge, i) => (
          <g
            key={i}
            className={`specification-link specification-${edge.kind}`}
          >
            <path
              d={edge.points
                .map((point, j) => `${j ? "L" : "M"} ${point.x} ${point.y}`)
                .join(" ")}
              className="specification-edge"
              markerEnd={unordered(edge) ? undefined : `url(#${id}-arrow)`}
            />
            <rect
              x={edge.x - edge.width / 2}
              y={edge.y - edge.height / 2}
              width={edge.width}
              height={edge.height}
              className="specification-label-background"
            />
            <Text x={edge.x} y={edge.y} text={edge.label} step={18} />
          </g>
        ))}
        {layout.nodes.map((node) => (
          <g key={node.id} className="specification-node">
            <rect
              x={node.x - node.width / 2}
              y={node.y - node.height / 2}
              width={node.width}
              height={node.height}
            />
            <Text x={node.x} y={node.y} text={node.label} step={20} />
          </g>
        ))}
      </DiagramViewport>
    </div>
  );
}
