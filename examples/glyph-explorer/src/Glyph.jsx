import React from "react";
import { runes } from "./runes.js";

export default function Glyph({ term, className = "", ...props }) {
  return (
    <svg
      viewBox="0 0 32 32"
      className={`rune ${className}`}
      aria-hidden="true"
      focusable="false"
      {...props}
    >
      <path d={runes[term.id]} />
    </svg>
  );
}
