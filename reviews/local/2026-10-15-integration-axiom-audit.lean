import Lean
import Model
import OrderConfigurationContracts

/-! Audit the current Model plus the Order/Configuration modules omitted by the
October 7 audit. This is executable evidence, not a prose-parity assertion. -/
open Lean Elab Command

run_cmd do
  let env ← getEnv
  let mut checked := 0
  for (name, info) in env.constants.toList do
    if name.toString.startsWith "DanielOntology." then
      if info.isAxiom then
        throwError "Forbidden declared project axiom: {name}"
      if info.isTheorem then
        let axioms ← collectAxioms name
        for axiomName in axioms do
          unless #[``propext, ``Classical.choice, ``Quot.sound].contains axiomName do
            throwError "Unapproved axiom dependency {axiomName} in {name}"
        let noChoice := name.toString.startsWith "DanielOntology.ConfigurationIntegration." ||
          name.toString.startsWith "DanielOntology.SetConfiguration." ||
          (name.toString.startsWith "DanielOntology.OrderConfigurationContracts." &&
            name != ``DanielOntology.OrderConfigurationContracts.orderDefinitionContract)
        if noChoice && axioms.contains ``Classical.choice then
          throwError "No-choice claim violated by {name}"
        checked := checked + 1
  logInfo m!"INTEGRATION_AXIOM_AUDIT: {checked} project theorems checked; 0 declared project axioms; allowed only propext, Classical.choice, Quot.sound; module no-choice claims checked."
