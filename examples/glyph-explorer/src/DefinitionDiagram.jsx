import React from "react";
import Glyph from "./Glyph.jsx";
import RelationalDiagram from "./RelationalDiagram.jsx";
import SpecificationDiagram from "./SpecificationDiagram.jsx";

export default function DefinitionDiagram({ term, card }) {
  if (card.kind === "relational") return <RelationalDiagram term={term} />;
  if (card.kind === "specification")
    return <SpecificationDiagram term={term} structure={card.structure} />;
  return (
    <div
      className="foundation-diagram"
      role="group"
      aria-label={`${term.label}: foundational distinction, no process asserted`}
    >
      <div className="diagram-subject">
        <Glyph term={term} />
        <span>{term.label}</span>
      </div>
    </div>
  );
}
