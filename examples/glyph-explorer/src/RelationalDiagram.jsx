import React, { useId } from "react";

function Label({ x, y, lines, className = "" }) {
  return (
    <text x={x} y={y} className={className}>
      {lines.map((line, i) => (
        <tspan key={i} x={x} dy={i ? 20 : 0}>
          {line}
        </tspan>
      ))}
    </text>
  );
}

function Node({ x, y, width, lines, dashed = false }) {
  return (
    <g>
      <rect
        x={x}
        y={y}
        width={width}
        height="70"
        className={dashed ? "relation-node relation-possible" : "relation-node"}
      />
      <Label x={x + width / 2} y={y + 29} lines={lines} />
    </g>
  );
}

function Arrowhead({ id }) {
  return (
    <defs>
      <marker
        id={id}
        viewBox="0 0 10 10"
        refX="9"
        refY="5"
        markerWidth="6"
        markerHeight="6"
        orient="auto-start-reverse"
      >
        <path d="M 1 1 L 9 5 L 1 9" className="relation-line" />
      </marker>
    </defs>
  );
}

function ComparisonDrawing({ compact, prefix, from, to, upstream }) {
  const id = useId();
  const arrow = `url(#${id}-arrow)`;
  const subscript = (i) => (i === 0 ? "₁" : "₂");
  const pathLabels = (i) => [
    `${prefix}p${subscript(i)}`,
    from ? `first T in family ${from}` : "nonempty path",
  ];
  return (
    <svg
      className={`relation-svg comparison-${compact ? "compact" : "wide"}`}
      viewBox={compact ? "0 0 340 450" : "0 0 800 310"}
      role="img"
      aria-labelledby={`${id}-title ${id}-desc`}
    >
      <title id={`${id}-title`}>{`${prefix}Two comparison paths`}</title>
      <desc id={`${id}-desc`}>
        Two nonempty Causal paths share Direction d. Their stated input
        positions match except for {upstream}. Their endpoint States exhibit the
        named downstream Change.
        {from &&
          ` Both paths start with Transformations in family ${from}; the downstream Change belongs to family ${to}.`}
      </desc>
      <Arrowhead id={`${id}-arrow`} />
      {compact ? (
        <>
          {[12, 190].map((x, i) => (
            <g key={x}>
              <Node
                x={x}
                y={34}
                width={138}
                lines={[
                  `input ${prefix}x${subscript(i)}`,
                  `upstream ${i ? "u′" : "u"}`,
                ]}
              />
              <path
                d={`M ${x + 69} 104 V 186`}
                className="relation-line"
                markerEnd={arrow}
              />
              <Node x={x} y={186} width={138} lines={pathLabels(i)} />
              <path
                d={`M ${x + 69} 256 V 344`}
                className="relation-line"
                markerEnd={arrow}
              />
              <Node
                x={x}
                y={344}
                width={138}
                lines={[
                  `State ${prefix}y${subscript(i)}`,
                  to ? `Change in family ${to}` : "endpoint",
                ]}
              />
            </g>
          ))}
          <path
            d="M 150 69 H 190 M 150 379 H 190"
            className="relation-comparison"
          />
          <Label x={170} y={22} lines={["Δin"]} className="relation-accent" />
          <Label
            x={170}
            y={438}
            lines={["Δout · named Change"]}
            className="relation-accent"
          />
          <path
            d="M 170 26 V 69 M 170 379 V 419"
            className="relation-comparison"
          />
        </>
      ) : (
        <>
          {[30, 210].map((y, i) => (
            <g key={y}>
              <Node
                x={12}
                y={y}
                width={180}
                lines={[
                  `input ${prefix}x${subscript(i)}`,
                  `upstream ${i ? "u′" : "u"}`,
                ]}
              />
              <path
                d={`M 192 ${y + 35} H 310`}
                className="relation-line"
                markerEnd={arrow}
              />
              <Node x={310} y={y} width={180} lines={pathLabels(i)} />
              <path
                d={`M 490 ${y + 35} H 608`}
                className="relation-line"
                markerEnd={arrow}
              />
              <Node
                x={608}
                y={y}
                width={180}
                lines={[
                  `State ${prefix}y${subscript(i)}`,
                  to ? `Change in family ${to}` : "endpoint",
                ]}
              />
            </g>
          ))}
          <path
            d="M 102 100 V 140 M 102 170 V 210 M 698 100 V 140 M 698 170 V 210"
            className="relation-comparison"
          />
          <Label
            x={102}
            y={161}
            lines={["Δin · Difference"]}
            className="relation-accent"
          />
          <Label
            x={698}
            y={161}
            lines={["Δout · Change"]}
            className="relation-accent"
          />
          <Label
            x={400}
            y={150}
            lines={["Match at every other", "stated input position"]}
            className="relation-muted"
          />
        </>
      )}
    </svg>
  );
}

function Comparison({
  prefix = "",
  from,
  to,
  upstream = "the named upstream Difference Δin",
}) {
  return (
    <div className="comparison-witness">
      <p className="relation-context">
        Same Direction d · two nonempty paths · all other stated inputs match
      </p>
      <ComparisonDrawing {...{ prefix, from, to, upstream }} compact={false} />
      <ComparisonDrawing {...{ prefix, from, to, upstream }} compact />
      <p className="relation-foot">
        Each path retains its Transformations and explicit Feeds accounts. Path
        length is unspecified; an arrow here abbreviates traversal, not a single
        Transformation.
      </p>
    </div>
  );
}

function Recurrence() {
  const id = useId();
  return (
    <>
      <div className="relation-context">
        Shared Direction d · A and B are distinct, named, nonempty families
      </div>
      <svg
        className="relation-svg recurrence-map"
        viewBox="0 0 340 220"
        role="img"
        aria-labelledby={`${id}-title ${id}-desc`}
      >
        <title id={`${id}-title`}>
          Two family-bound contributions with a later return
        </title>
        <desc id={`${id}-desc`}>
          C₁ contributes from family A to family B. C₂ contributes from family B
          back to family A and begins later than C₁'s downstream Change. The
          repeated families are not identical States or a closed time loop.
        </desc>
        <Arrowhead id={`${id}-arrow`} />
        <Node
          x={10}
          y={75}
          width={120}
          lines={["Family A", "Transformations"]}
        />
        <Node
          x={210}
          y={75}
          width={120}
          lines={["Family B", "Transformations"]}
        />
        <path
          d="M 70 75 V 40 H 270 V 75"
          className="relation-line"
          markerEnd={`url(#${id}-arrow)`}
        />
        <path
          d="M 270 145 V 185 H 70 V 145"
          className="relation-line"
          markerEnd={`url(#${id}-arrow)`}
        />
        <Label
          x={170}
          y={27}
          lines={["C₁ · first contribution"]}
          className="relation-accent"
        />
        <Label
          x={170}
          y={210}
          lines={["C₂ · later return contribution"]}
          className="relation-accent"
        />
      </svg>
      <p className="relation-foot">
        Family-level relations, not a closed time loop. The two required
        contribution witnesses are expanded below.
      </p>
      <div className="relation-pair">
        <section
          className="relation-scope"
          aria-label="First contribution witness"
        >
          <h3>
            C₁ <span>A → B</span>
          </h3>
          <Comparison prefix="1·" from="A" to="B" />
        </section>
        <section
          className="relation-scope"
          aria-label="Return contribution witness"
        >
          <h3>
            C₂ <span>B → A</span>
          </h3>
          <Comparison prefix="2·" from="B" to="A" />
        </section>
      </div>
      <p className="relation-obligation">
        <strong>Ordering obligation</strong> C₂ begins later than C₁’s
        downstream Change. This is an additional condition, not an extra Feeds
        edge or an identity between their endpoint States.
      </p>
    </>
  );
}

function Selection() {
  return (
    <div className="relation-scope selection-scope">
      <div className="relation-context">
        One Entity · one Body Relation · its Interior and Scope
      </div>
      <p className="relation-condition">
        One represented condition retains every Difference used to determine the
        outcome.
      </p>
      <div
        className="representation-comparison"
        role="group"
        aria-label="Outcome and admissible contrast Representations"
      >
        <div className="relation-card">
          <strong>Rout</strong>
          <span>outcome Representation</span>
        </div>
        <div className="relation-difference">
          <span>Difference</span>
          <strong>ΔR</strong>
          <span>Rout ≠ Rcontrast</span>
        </div>
        <div className="relation-card">
          <strong>Rcontrast</strong>
          <span>admissible contrast Representation</span>
        </div>
      </div>
      <div className="relation-join">
        <span>ΔR is the named upstream Difference Δin of C</span>
        <span aria-hidden="true">│</span>
      </div>
      <section
        className="relation-scope"
        aria-label="Selection causal comparison witness"
      >
        <h3>
          C <span>Causal Contribution</span>
        </h3>
        <Comparison upstream="ΔR, the Difference between Rout and Rcontrast" />
      </section>
      <div
        className="relation-options"
        role="group"
        aria-label="Available internal Transformations"
      >
        <p>
          Availability Specification ↔ exactly the declared options
          <br />
          <span>
            At least two · related by the same Body · within its Interior and
            Scope
          </span>
        </p>
        <div className="relation-pair">
          <div className="relation-card">
            <strong>Tselected</strong>
            <span>selected internal Transformation</span>
          </div>
          <div className="relation-card relation-possible">
            <strong>Talternative …</strong>
            <span>contrasting possibilities, not asserted executions</span>
          </div>
        </div>
      </div>
      <div
        className="selection-identities"
        role="group"
        aria-label="Required Denotation and output identity"
      >
        <div>
          <strong>Rout</strong>
          <span>Denotation →</span>
          <strong>out(Tselected)</strong>
        </div>
        <div>
          <strong>C’s downstream output y₁</strong>
          <span>Identity =</span>
          <strong>out(Tselected)</strong>
        </div>
      </div>
      <p className="relation-foot">
        C discriminates among the available options. Its comparison path p₂ is
        not an assertion that Talternative occurs. Denotation is not a causal
        arrow; output identity is not merely resemblance.
      </p>
    </div>
  );
}

export default function RelationalDiagram({ term }) {
  return (
    <div className="relational-diagram">
      <p className="relation-key">
        Solid arrows: path traversal or labelled contribution · unarrowed
        connectors: comparison · dashed boxes: alternatives, not asserted
        executions
      </p>
      {term.id === "organon:CausalContribution" ? (
        <Comparison />
      ) : term.id === "organon:RecurrentIntegration" ? (
        <Recurrence />
      ) : (
        <Selection />
      )}
    </div>
  );
}
