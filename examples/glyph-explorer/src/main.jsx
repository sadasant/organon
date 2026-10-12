import React from "react";
import { createRoot } from "react-dom/client";
import { HashRouter } from "react-router-dom";
import "katex/dist/katex.min.css";
import "@fontsource-variable/inter";
import "@fontsource-variable/newsreader";
import "./style.css";
import App from "./App.jsx";

createRoot(document.getElementById("root")).render(
  <HashRouter>
    <App />
  </HashRouter>,
);
