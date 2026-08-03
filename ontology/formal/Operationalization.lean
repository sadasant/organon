import DanielOntology

/-!
# Operationalization: formal shadow

This file formalizes the seam proposed by D082 and C11. It distinguishes a
Representation operating through a discriminating selection Rule from a
physical carrier that merely occurs somewhere in a Causal path. It does not
formalize semantic truth, universal causal efficacy, or the complete Interface
and Evidence regions of the Markdown ontology.
-/

universe u v

namespace DanielOntology

structure OperationalInterface
    {Carrier : Type u}
    (direction : Direction Carrier) where
  exposes : Transformation direction → Prop

structure SelectionRule
    (Representation : Type v)
    {Carrier : Type u}
    (direction : Direction Carrier) where
  selects : Representation → Transformation direction → Prop

structure Operationalization
    (Representation : Type v)
    {Carrier : Type u}
    (direction : Direction Carrier)
    (feeding : FeedRelation Carrier) where
  representation : Representation
  rule : SelectionRule Representation direction
  interface : OperationalInterface direction
  scope : Scope (Representation × Transformation direction)
  path : CausalPath direction feeding
  selected : Transformation direction
  selectedByRule : rule.selects representation selected
  exposedByInterface : interface.exposes selected
  inScope : scope.includes (representation, selected)
  occursInPath : selected ∈ path.steps
  discriminating :
    ∃ alternative,
      alternative ≠ representation ∧
      scope.includes (alternative, selected) ∧
      ¬ rule.selects alternative selected

theorem operationalizationHasRuleMediatedPathWitness
    {Representation : Type v}
    {Carrier : Type u}
    {direction : Direction Carrier}
    {feeding : FeedRelation Carrier}
    (operationalization :
      Operationalization Representation direction feeding) :
    ∃ selected,
      operationalization.rule.selects
        operationalization.representation selected ∧
      operationalization.interface.exposes selected ∧
      operationalization.scope.includes
        (operationalization.representation, selected) ∧
      selected ∈ operationalization.path.steps := by
  exact ⟨
    operationalization.selected,
    operationalization.selectedByRule,
    operationalization.exposedByInterface,
    operationalization.inScope,
    operationalization.occursInPath
  ⟩

theorem operationalizationRequiresDiscrimination
    {Representation : Type v}
    {Carrier : Type u}
    {direction : Direction Carrier}
    {feeding : FeedRelation Carrier}
    (operationalization :
      Operationalization Representation direction feeding) :
    ∃ alternative,
      alternative ≠ operationalization.representation ∧
      operationalization.scope.includes
        (alternative, operationalization.selected) ∧
      ¬ operationalization.rule.selects
        alternative operationalization.selected :=
  operationalization.discriminating

end DanielOntology
