import TruthTrustAlignment

/-!
# Intelligence, Operative Knowledge, and Knowledge Transmission

This file tests D088-D090. Intelligence belongs to an Agent-level pipeline,
not to one Model or stored parameter set. Operative Knowledge requires a
Record to discriminate within a capable interpreter's action-producing
configuration. Knowledge Transmission requires a recipient to reconstruct
Operative Knowledge while preserving a declared functional Specification;
copying a Record is insufficient.

The file does not formalize a universal measure of intelligence, optimality,
semantic equivalence, learning across every State, or a canonical encoding of
Records.
-/

universe u

namespace DanielOntology

structure CognitivePipeline
    (Situation Perception Memory Model Interpretation Action Consequence : Type u) where
  perceive : Situation → Perception
  remember : Situation → Memory
  constructModel : Perception → Memory → Model
  interpret : Perception → Memory → Model → Interpretation
  selectAction : Interpretation → Action
  consequence : Situation → Action → Consequence

/-!
`RuleEncoding` is an explicit but supplied representation of individually named
cases. Lean proves list membership; it does not prove that this list completely
describes an external executable or natural-language Rule.
-/
structure RuleEncoding (Situation : Type u) where
  individuallyNamed : List Situation

structure AdaptiveRule
    (Situation Perception Memory Model Interpretation Action Consequence : Type u) where
  encoding : RuleEncoding Situation
  pipeline : CognitivePipeline
    Situation Perception Memory Model Interpretation Action Consequence

def AdaptiveRule.enumerates
    {Situation Perception Memory Model Interpretation Action Consequence : Type u}
    [DecidableEq Situation]
    (rule : AdaptiveRule
      Situation Perception Memory Model Interpretation Action Consequence)
    (situation : Situation) : Prop :=
  situation ∈ rule.encoding.individuallyNamed

def CognitivePipeline.modelFor
    {Situation Perception Memory Model Interpretation Action Consequence : Type u}
    (pipeline : CognitivePipeline
      Situation Perception Memory Model Interpretation Action Consequence)
    (situation : Situation) : Model :=
  pipeline.constructModel
    (pipeline.perceive situation)
    (pipeline.remember situation)

def CognitivePipeline.interpretationFor
    {Situation Perception Memory Model Interpretation Action Consequence : Type u}
    (pipeline : CognitivePipeline
      Situation Perception Memory Model Interpretation Action Consequence)
    (situation : Situation) : Interpretation :=
  pipeline.interpret
    (pipeline.perceive situation)
    (pipeline.remember situation)
    (pipeline.modelFor situation)

def CognitivePipeline.actionFor
    {Situation Perception Memory Model Interpretation Action Consequence : Type u}
    (pipeline : CognitivePipeline
      Situation Perception Memory Model Interpretation Action Consequence)
    (situation : Situation) : Action :=
  pipeline.selectAction (pipeline.interpretationFor situation)

def CognitivePipeline.consequenceFor
    {Situation Perception Memory Model Interpretation Action Consequence : Type u}
    (pipeline : CognitivePipeline
      Situation Perception Memory Model Interpretation Action Consequence)
    (situation : Situation) : Consequence :=
  pipeline.consequence situation (pipeline.actionFor situation)

def AdaptiveAcross
    {Situation Perception Memory Model Interpretation Action Consequence : Type u}
    [DecidableEq Situation]
    (rule : AdaptiveRule
      Situation Perception Memory Model Interpretation Action Consequence)
    (first second : Situation) : Prop :=
  ¬ rule.enumerates first ∧
    ¬ rule.enumerates second ∧
    rule.pipeline.modelFor first ≠ rule.pipeline.modelFor second ∧
    rule.pipeline.interpretationFor first ≠
      rule.pipeline.interpretationFor second

structure JoinedAdaptiveCase
    {Situation Perception Memory Model Interpretation Action Consequence : Type u}
    [DecidableEq Situation]
    (rule : AdaptiveRule
      Situation Perception Memory Model Interpretation Action Consequence)
    (scope : Scope Situation)
    (specification : Specification Consequence) where
  first : Situation
  second : Situation
  firstInScope : scope.includes first
  secondInScope : scope.includes second
  adaptiveAcross : AdaptiveAcross rule first second
  alternativePerception : Perception
  alternativeMemory : Memory
  perceptionChangesModel :
    rule.pipeline.modelFor first ≠
      rule.pipeline.constructModel alternativePerception
        (rule.pipeline.remember first)
  memoryChangesModel :
    rule.pipeline.modelFor first ≠
      rule.pipeline.constructModel
        (rule.pipeline.perceive first) alternativeMemory
  alternativeModel : Model
  modelChangesInterpretation :
    rule.pipeline.interpretationFor first ≠
      rule.pipeline.interpret
        (rule.pipeline.perceive first)
        (rule.pipeline.remember first)
        alternativeModel
  alternativeInterpretation : Interpretation
  interpretationChangesAction :
    rule.pipeline.actionFor first ≠
      rule.pipeline.selectAction alternativeInterpretation
  alternativeAction : Action
  actionChangesConsequence :
    rule.pipeline.consequenceFor first ≠
      rule.pipeline.consequence first alternativeAction
  firstConforms :
    specification.conforms (rule.pipeline.consequenceFor first)
  secondConforms :
    specification.conforms (rule.pipeline.consequenceFor second)

structure Intelligence
    (Agent Situation Perception Memory Model Interpretation Action Consequence : Type u)
    [DecidableEq Situation] where
  agent : Agent
  rule : AdaptiveRule
    Situation Perception Memory Model Interpretation Action Consequence
  scope : Scope Situation
  consequenceSpecification : Specification Consequence
  joinedAdaptiveCase : JoinedAdaptiveCase rule scope consequenceSpecification
  novelConsequencesConform :
    ∀ situation,
      scope.includes situation →
      ¬ rule.enumerates situation →
      consequenceSpecification.conforms (rule.pipeline.consequenceFor situation)

structure InterpretiveContext (Agent : Type u) where
  capable : Agent → Prop

structure OperativeKnowledge
    (Record Agent Rule Model Interpretation Action Effect : Type u)
    (context : InterpretiveContext Agent) where
  record : Record
  interpreter : Agent
  interpreterCapable : context.capable interpreter
  rule : Rule
  scope : Scope Record
  recordInScope : scope.includes record
  modelFrom : Rule → Agent → Record → Model
  interpretationFrom : Rule → Agent → Record → Model → Interpretation
  actionFrom : Rule → Agent → Interpretation → Action
  effectFrom : Rule → Agent → Action → Effect
  effectSpecification : Specification Effect
  alternativeRecord : Record
  alternativeInScope : scope.includes alternativeRecord
  modelDiscriminates :
    modelFrom rule interpreter record ≠
      modelFrom rule interpreter alternativeRecord
  interpretationDiscriminates :
    interpretationFrom rule interpreter record
        (modelFrom rule interpreter record) ≠
      interpretationFrom rule interpreter alternativeRecord
        (modelFrom rule interpreter alternativeRecord)
  actionDiscriminates :
    actionFrom rule interpreter
        (interpretationFrom rule interpreter record
          (modelFrom rule interpreter record)) ≠
      actionFrom rule interpreter
        (interpretationFrom rule interpreter alternativeRecord
          (modelFrom rule interpreter alternativeRecord))
  operative :
    effectSpecification.conforms
      (effectFrom rule interpreter
        (actionFrom rule interpreter
          (interpretationFrom rule interpreter record
            (modelFrom rule interpreter record))))

def OperativeKnowledge.realizedEffect
    {Record Agent Rule Model Interpretation Action Effect : Type u}
    {context : InterpretiveContext Agent}
    (knowledge : OperativeKnowledge
      Record Agent Rule Model Interpretation Action Effect context) : Effect :=
  knowledge.effectFrom knowledge.rule knowledge.interpreter
    (knowledge.actionFrom knowledge.rule knowledge.interpreter
      (knowledge.interpretationFrom knowledge.rule knowledge.interpreter
        knowledge.record
        (knowledge.modelFrom knowledge.rule knowledge.interpreter
          knowledge.record)))

structure KnowledgeTransmission
    {Record Agent Rule Model Interpretation Action Effect Stage : Type u}
    {sourceContext recipientContext : InterpretiveContext Agent}
    (source : OperativeKnowledge
      Record Agent Rule Model Interpretation Action Effect sourceContext)
    (recipient : OperativeKnowledge
      Record Agent Rule Model Interpretation Action Effect recipientContext) where
  sourceStage : Stage
  recipientStage : Stage
  distinctStages : sourceStage ≠ recipientStage
  medium : Record
  encode : Record → Record
  encodedFromSource : medium = encode source.record
  reconstruct : Agent → Record → Record
  recipientReconstructed :
    recipient.record = reconstruct recipient.interpreter medium
  preservationSpecification : Specification (Effect × Effect)
  functionPreserved :
    preservationSpecification.conforms
      (source.realizedEffect, recipient.realizedEffect)

/-! ## Finite intelligence witness -/

inductive ToySituation where
  | enumerated
  | novelA
  | novelB
  deriving DecidableEq

inductive ToyPerception where
  | familiar
  | signalA
  | signalB
  deriving DecidableEq

inductive ToyMemory where
  | retained
  | empty
  deriving DecidableEq

inductive ToyModel where
  | baseline
  | generalizationA
  | generalizationB
  deriving DecidableEq

inductive ToyInterpretation where
  | repeat
  | adaptA
  | adaptB
  deriving DecidableEq

inductive ToyAction where
  | routine
  | handleA
  | handleB
  deriving DecidableEq

inductive ToyEffect where
  | success
  | failure
  deriving DecidableEq

inductive ToyAgent where
  | source
  | recipient
  deriving DecidableEq

def adaptivePipeline : CognitivePipeline
    ToySituation ToyPerception ToyMemory ToyModel ToyInterpretation ToyAction ToyEffect where
  perceive
    | .enumerated => .familiar
    | .novelA => .signalA
    | .novelB => .signalB
  remember := fun _ => .retained
  constructModel
    | .signalA, .retained => .generalizationA
    | .signalB, .retained => .generalizationB
    | _, _ => .baseline
  interpret
    | .signalA, .retained, .generalizationA => .adaptA
    | .signalB, .retained, .generalizationB => .adaptB
    | _, _, _ => .repeat
  selectAction
    | .repeat => .routine
    | .adaptA => .handleA
    | .adaptB => .handleB
  consequence
    | .novelA, .handleA => .success
    | .novelB, .handleB => .success
    | .enumerated, .routine => .success
    | _, _ => .failure

def toyAdaptiveRule : AdaptiveRule
    ToySituation ToyPerception ToyMemory ToyModel ToyInterpretation ToyAction ToyEffect where
  encoding := ⟨[.enumerated]⟩
  pipeline := adaptivePipeline

def successfulEffect : Specification ToyEffect where
  scope := ⟨fun _ => True⟩
  conforms := fun effect => effect = .success
  decideConformity := fun effect => effect == .success
  conformityCorrect := by intro effect; cases effect <;> simp
  conformityWithinScope := by simp

def adaptiveIntelligence : Intelligence
    ToyAgent ToySituation ToyPerception ToyMemory ToyModel ToyInterpretation
      ToyAction ToyEffect where
  agent := .source
  rule := toyAdaptiveRule
  scope := ⟨fun _ => True⟩
  consequenceSpecification := successfulEffect
  joinedAdaptiveCase := {
    first := .novelA
    second := .novelB
    firstInScope := trivial
    secondInScope := trivial
    adaptiveAcross := by
      simp [AdaptiveAcross, AdaptiveRule.enumerates, toyAdaptiveRule,
        adaptivePipeline, CognitivePipeline.modelFor,
        CognitivePipeline.interpretationFor]
    alternativePerception := .familiar
    alternativeMemory := .empty
    perceptionChangesModel := by
      simp [toyAdaptiveRule, adaptivePipeline, CognitivePipeline.modelFor]
    memoryChangesModel := by
      simp [toyAdaptiveRule, adaptivePipeline, CognitivePipeline.modelFor]
    alternativeModel := .baseline
    modelChangesInterpretation := by
      simp [toyAdaptiveRule, adaptivePipeline,
        CognitivePipeline.interpretationFor, CognitivePipeline.modelFor]
    alternativeInterpretation := .repeat
    interpretationChangesAction := by
      simp [toyAdaptiveRule, adaptivePipeline, CognitivePipeline.actionFor,
        CognitivePipeline.interpretationFor, CognitivePipeline.modelFor]
    alternativeAction := .routine
    actionChangesConsequence := by
      simp [toyAdaptiveRule, adaptivePipeline,
        CognitivePipeline.consequenceFor, CognitivePipeline.actionFor,
        CognitivePipeline.interpretationFor, CognitivePipeline.modelFor]
    firstConforms := by
      simp [toyAdaptiveRule, adaptivePipeline, successfulEffect,
        CognitivePipeline.consequenceFor, CognitivePipeline.actionFor,
        CognitivePipeline.interpretationFor, CognitivePipeline.modelFor]
    secondConforms := by
      simp [toyAdaptiveRule, adaptivePipeline, successfulEffect,
        CognitivePipeline.consequenceFor, CognitivePipeline.actionFor,
        CognitivePipeline.interpretationFor, CognitivePipeline.modelFor]
  }
  novelConsequencesConform := by
    intro situation _ novel
    cases situation <;>
      simp_all [AdaptiveRule.enumerates, toyAdaptiveRule, successfulEffect,
        adaptivePipeline,
        CognitivePipeline.consequenceFor, CognitivePipeline.actionFor,
        CognitivePipeline.interpretationFor, CognitivePipeline.modelFor]

def fixedPipeline : CognitivePipeline
    ToySituation ToyPerception ToyMemory ToyModel ToyInterpretation ToyAction ToyEffect where
  perceive := fun _ => .familiar
  remember := fun _ => .retained
  constructModel := fun _ _ => .baseline
  interpret := fun _ _ _ => .repeat
  selectAction := fun _ => .routine
  consequence := fun _ _ => .success

def fixedRule : AdaptiveRule
    ToySituation ToyPerception ToyMemory ToyModel ToyInterpretation ToyAction ToyEffect where
  encoding := toyAdaptiveRule.encoding
  pipeline := fixedPipeline

theorem fixedInterpretationDoesNotAdapt :
    ∀ first second,
      ¬ AdaptiveAcross fixedRule first second := by
  intro first second adaptive
  exact adaptive.2.2.2 (by
    simp [fixedRule, fixedPipeline, CognitivePipeline.interpretationFor,
      CognitivePipeline.modelFor])

/-! ## Finite Operative Knowledge and Transmission witnesses -/

def activeContext : InterpretiveContext ToyAgent where
  capable := fun _ => True

def dormantContext : InterpretiveContext ToyAgent where
  capable := fun _ => False

def recordScope : Scope ToyClaim := ⟨fun _ => True⟩

def knowledgePipeline : CognitivePipeline
    ToySituation ToyPerception ToyClaim ToyModel ToyInterpretation ToyAction ToyEffect where
  perceive := fun _ => .familiar
  remember := fun _ => .mistaken
  constructModel
    | _, .accurate => .generalizationA
    | _, .mistaken => .generalizationB
  interpret
    | _, .accurate, .generalizationA => .adaptA
    | _, .mistaken, .generalizationB => .adaptB
    | _, _, _ => .repeat
  selectAction
    | .repeat => .routine
    | .adaptA => .handleA
    | .adaptB => .handleB
  consequence
    | _, .handleA => .success
    | _, .handleB => .success
    | _, .routine => .failure

abbrev ToyOperativeRule := AdaptiveRule
  ToySituation ToyPerception ToyClaim ToyModel ToyInterpretation ToyAction ToyEffect

def fixedKnowledgeRule : ToyOperativeRule where
  encoding := ⟨[.enumerated, .novelA, .novelB]⟩
  pipeline := knowledgePipeline

def knowledgeModel : ToyOperativeRule → ToyAgent → ToyClaim → ToyModel :=
  fun rule _ record => rule.pipeline.constructModel .familiar record

def knowledgeInterpretation :
    ToyOperativeRule → ToyAgent → ToyClaim → ToyModel → ToyInterpretation :=
  fun rule _ record model =>
    rule.pipeline.interpret .familiar record model

def knowledgeAction : ToyOperativeRule → ToyAgent → ToyInterpretation → ToyAction :=
  fun rule _ interpretation => rule.pipeline.selectAction interpretation

def knowledgeEffect : ToyOperativeRule → ToyAgent → ToyAction → ToyEffect :=
  fun rule _ action => rule.pipeline.consequence .enumerated action

def mistakenOperativeKnowledge : OperativeKnowledge
    ToyClaim ToyAgent ToyOperativeRule ToyModel ToyInterpretation ToyAction ToyEffect
      activeContext where
  record := .mistaken
  interpreter := .source
  interpreterCapable := trivial
  rule := fixedKnowledgeRule
  scope := recordScope
  recordInScope := trivial
  modelFrom := knowledgeModel
  interpretationFrom := knowledgeInterpretation
  actionFrom := knowledgeAction
  effectFrom := knowledgeEffect
  effectSpecification := successfulEffect
  alternativeRecord := .accurate
  alternativeInScope := trivial
  modelDiscriminates := by
    simp [knowledgeModel, fixedKnowledgeRule, knowledgePipeline]
  interpretationDiscriminates := by
    simp [knowledgeInterpretation, knowledgeModel, fixedKnowledgeRule,
      knowledgePipeline]
  actionDiscriminates := by
    simp [knowledgeAction, knowledgeInterpretation, knowledgeModel,
      fixedKnowledgeRule, knowledgePipeline]
  operative := by
    simp [successfulEffect, knowledgeEffect, knowledgeAction,
      knowledgeInterpretation, knowledgeModel, fixedKnowledgeRule,
      knowledgePipeline]

def accurateOperativeKnowledge : OperativeKnowledge
    ToyClaim ToyAgent ToyOperativeRule ToyModel ToyInterpretation ToyAction ToyEffect
      activeContext where
  record := .accurate
  interpreter := .recipient
  interpreterCapable := trivial
  rule := fixedKnowledgeRule
  scope := recordScope
  recordInScope := trivial
  modelFrom := knowledgeModel
  interpretationFrom := knowledgeInterpretation
  actionFrom := knowledgeAction
  effectFrom := knowledgeEffect
  effectSpecification := successfulEffect
  alternativeRecord := .mistaken
  alternativeInScope := trivial
  modelDiscriminates := by
    simp [knowledgeModel, fixedKnowledgeRule, knowledgePipeline]
  interpretationDiscriminates := by
    simp [knowledgeInterpretation, knowledgeModel, fixedKnowledgeRule,
      knowledgePipeline]
  actionDiscriminates := by
    simp [knowledgeAction, knowledgeInterpretation, knowledgeModel,
      fixedKnowledgeRule, knowledgePipeline]
  operative := by
    simp [successfulEffect, knowledgeEffect, knowledgeAction,
      knowledgeInterpretation, knowledgeModel, fixedKnowledgeRule,
      knowledgePipeline]

def selfRestoredOperativeKnowledge : OperativeKnowledge
    ToyClaim ToyAgent ToyOperativeRule ToyModel ToyInterpretation ToyAction ToyEffect
      activeContext :=
  { accurateOperativeKnowledge with interpreter := .source }

theorem operativeKnowledgeDoesNotEntailTruth :
    ¬ toyTruthSemantics.isTrue mistakenOperativeKnowledge.record := by
  simp [mistakenOperativeKnowledge, TruthSemantics.isTrue,
    toyTruthSemantics, toyTruthSpecification]

theorem operativeKnowledgeDoesNotEntailIntelligence :
    Nonempty (OperativeKnowledge
      ToyClaim ToyAgent ToyOperativeRule ToyModel ToyInterpretation ToyAction ToyEffect
        activeContext) ∧
      ¬ ∃ intelligence : Intelligence
          ToyAgent ToySituation ToyPerception ToyClaim ToyModel ToyInterpretation
            ToyAction ToyEffect,
        intelligence.agent = mistakenOperativeKnowledge.interpreter ∧
        intelligence.rule = mistakenOperativeKnowledge.rule := by
  constructor
  · exact ⟨mistakenOperativeKnowledge⟩
  · rintro ⟨intelligence, _, sameRule⟩
    let first : ToySituation := intelligence.joinedAdaptiveCase.first
    have firstNotNamed : ¬ intelligence.rule.enumerates first :=
      intelligence.joinedAdaptiveCase.adaptiveAcross.1
    have fixedNamesFirst : mistakenOperativeKnowledge.rule.enumerates first := by
      cases first <;>
      simp [mistakenOperativeKnowledge, fixedKnowledgeRule,
        AdaptiveRule.enumerates]
    exact firstNotNamed (sameRule.symm ▸ fixedNamesFirst)

theorem noOperativeKnowledgeWithoutCapableInterpreter :
    ¬ Nonempty (OperativeKnowledge
      ToyClaim ToyAgent ToyOperativeRule ToyModel ToyInterpretation ToyAction ToyEffect
        dormantContext) := by
  intro inhabited
  rcases inhabited with ⟨knowledge⟩
  exact knowledge.interpreterCapable

def preservedSuccess : Specification (ToyEffect × ToyEffect) where
  scope := ⟨fun _ => True⟩
  conforms := fun effects => effects.1 = .success ∧ effects.2 = .success
  decideConformity := fun effects =>
    (effects.1 == .success) && (effects.2 == .success)
  conformityCorrect := by
    intro effects
    rcases effects with ⟨source, recipient⟩
    cases source <;> cases recipient <;> simp
  conformityWithinScope := by simp

def reconstructedTransmission : KnowledgeTransmission (Stage := Bool)
    mistakenOperativeKnowledge accurateOperativeKnowledge where
  sourceStage := false
  recipientStage := true
  distinctStages := by decide
  medium := .mistaken
  encode := id
  encodedFromSource := rfl
  reconstruct := fun receivingAgent record =>
    match receivingAgent, record with
    | .recipient, .mistaken => .accurate
    | _, other => other
  recipientReconstructed := rfl
  preservationSpecification := preservedSuccess
  functionPreserved := by
    simp [preservedSuccess, OperativeKnowledge.realizedEffect,
      mistakenOperativeKnowledge, accurateOperativeKnowledge, knowledgeEffect,
      knowledgeAction, knowledgeInterpretation, knowledgeModel,
      fixedKnowledgeRule, knowledgePipeline]

def selfTransmission : KnowledgeTransmission (Stage := Bool)
    mistakenOperativeKnowledge selfRestoredOperativeKnowledge where
  sourceStage := false
  recipientStage := true
  distinctStages := by decide
  medium := .mistaken
  encode := id
  encodedFromSource := rfl
  reconstruct := fun _ record =>
    match record with
    | .mistaken => .accurate
    | other => other
  recipientReconstructed := rfl
  preservationSpecification := preservedSuccess
  functionPreserved := by
    simp [preservedSuccess, OperativeKnowledge.realizedEffect,
      mistakenOperativeKnowledge, selfRestoredOperativeKnowledge,
      accurateOperativeKnowledge, knowledgeEffect, knowledgeAction,
      knowledgeInterpretation, knowledgeModel, fixedKnowledgeRule,
      knowledgePipeline]

structure RecordTransfer (Record Agent : Type u) where
  record : Record
  source : Agent
  recipient : Agent

def copiedRecord : RecordTransfer ToyClaim ToyAgent where
  record := .mistaken
  source := .source
  recipient := .recipient

theorem copiedRecordDoesNotSupplyRecipientKnowledge :
    Nonempty (RecordTransfer ToyClaim ToyAgent) ∧
      ¬ Nonempty (OperativeKnowledge
        ToyClaim ToyAgent ToyOperativeRule ToyModel ToyInterpretation ToyAction ToyEffect
          dormantContext) := by
  exact ⟨⟨copiedRecord⟩, noOperativeKnowledgeWithoutCapableInterpreter⟩

theorem transmissionDoesNotRequireIdenticalRecordsOrModels :
    mistakenOperativeKnowledge.record ≠ accurateOperativeKnowledge.record ∧
      mistakenOperativeKnowledge.modelFrom
          mistakenOperativeKnowledge.rule
          mistakenOperativeKnowledge.interpreter
          mistakenOperativeKnowledge.record ≠
        accurateOperativeKnowledge.modelFrom
          accurateOperativeKnowledge.rule
          accurateOperativeKnowledge.interpreter
          accurateOperativeKnowledge.record ∧
      preservedSuccess.conforms
        (mistakenOperativeKnowledge.realizedEffect,
          accurateOperativeKnowledge.realizedEffect) := by
  simp [mistakenOperativeKnowledge, accurateOperativeKnowledge,
    preservedSuccess, OperativeKnowledge.realizedEffect, knowledgeEffect,
    knowledgeAction, knowledgeInterpretation, knowledgeModel,
      fixedKnowledgeRule, knowledgePipeline]

theorem knowledgeTransmissionPermitsSameAgent :
    mistakenOperativeKnowledge.interpreter =
      selfRestoredOperativeKnowledge.interpreter := by
  rfl

end DanielOntology
