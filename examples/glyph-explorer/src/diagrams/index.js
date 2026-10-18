import foundations from "./foundations.js";
import coordination from "./coordination.js";
import knowledge from "./knowledge.js";

// Explicit, nonbinding readings of the definitions, not inferred dependency edges.
export default { ...foundations, ...coordination, ...knowledge };
