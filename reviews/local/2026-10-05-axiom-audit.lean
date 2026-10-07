import Lean
import Model
import PR18ReviewDraft
import DanielOntology
open Lean Elab Command
run_cmd do
  let env ← getEnv
  let mut checked := 0
  let mut declared := 0
  for (name, info) in env.constants.toList do
    if name.toString.startsWith "DanielOntology." then
      if info.isAxiom then
        declared := declared + 1
        throwError "Forbidden declared project axiom: {name}"
      if info.isTheorem then
        let axioms ← collectAxioms name
        for axiomName in axioms do
          unless #[``propext, ``Classical.choice, ``Quot.sound].contains axiomName do
            throwError "Unapproved axiom dependency {axiomName} in {name}"
        checked := checked + 1
  logInfo m!"PROJECT_AXIOM_AUDIT: {checked} project theorems checked; {declared} declared project axioms; allowed only propext, Classical.choice, Quot.sound."
