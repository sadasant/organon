import React from "react";
import { glyphs } from "../../../proposals/glyph-catalog.mjs";

const characters = new Map(
  glyphs.map((glyph) => [glyph.id, String.fromCodePoint(glyph.codepoint)]),
);

export default function Glyph({ term, className = "", ...props }) {
  return (
    <svg
      viewBox="0 0 32 32"
      className={`rune ${className}`}
      aria-hidden="true"
      focusable="false"
      {...props}
    >
      <text className="rune-letter" x="0" y="32" fontSize="32">
        {characters.get(term.id)}
      </text>
    </svg>
  );
}
