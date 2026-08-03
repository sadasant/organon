import TruthTrustAlignment

/-!
# Intelligence, Operative Knowledge, and Knowledge Transmission

This file tests D088-D090. Intelligence belongs to an Agent-level pipeline,
not to one Model or stored parameter set. Operative Knowledge requires a
Record to discriminate within an available interpreter's action-producing
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

structure AdaptiveRule
    (Situation Perception Memory Model Interpretation Action Consequence : Type u) where
  enumerates : Situation → Prop
  pipeline : CognitivePipeline
    Situation Perception Memory Model Interpretation Action Consequence

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
    (rule : AdaptiveRule
      Situation Perception Memory Model Interpretation Action Consequence)
    (first second : Situation) : Prop :=
  ¬ rule.enumerates first ∧
    ¬ rule.enumerates second ∧
    rule.pipeline.modelFor first ≠ rule.pipeline.modelFor second ∧
    rule.pipeline.interpretationFor first ≠
      rule.pipeline.interpretationFor second

structure Intelligence
    (Agent Situation Perception Memory Model Interpretation Action Consequence : Type u) where
  agent : Agent
  rule : AdaptiveRule
    Situation Perception Memory Model Interpretation Action Consequence
  scope : Scope Situation
  consequenceSpecification : Specification Consequence
  adaptiveWitness :
    ∃ first second,
      scope.includes first ∧
      scope.includes second ∧
      AdaptiveAcross rule first second
  perceptionAndMemoryDiscriminate :
    ∃ situation alternativePerception alternativeMemory,
      scope.includes situation ∧
      rule.pipeline.modelFor situation ≠
        rule.pipeline.constructModel alternativePerception
          (rule.pipeline.remember situation) ∧
      rule.pipeline.modelFor situation ≠
        rule.pipeline.constructModel
          (rule.pipeline.perceive situation) alternativeMemory
  modelDiscriminatesInterpretation :
    ∃ situation alternativeModel,
      scope.includes situation ∧
      rule.pipeline.interpretationFor situation ≠
        rule.pipeline.interpret
          (rule.pipeline.perceive situation)
          (rule.pipeline.remember situation)
          alternativeModel
  interpretationDiscriminatesAction :
    ∃ situation alternativeInterpretation,
      scope.includes situation ∧
      rule.pipeline.actionFor situation ≠
        rule.pipeline.selectAction alternativeInterpretation
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
  effectFrom : Rule → Agent → Record → Action → Effect
  effectSpecification : Specification Effect
  alternativeRecord : Record
  alternativeInScope : scope.includes alternativeRecord
  discriminates :
    interpretationFrom rule interpreter record
        (modelFrom rule interpreter record) ≠
      interpretationFrom rule interpreter alternativeRecord
        (modelFrom rule interpreter alternativeRecord)
  operative :
    effectSpecification.conforms
      (effectFrom rule interpreter record
        (actionFrom rule interpreter
          (interpretationFrom rule interpreter record
            (modelFrom rule interpreter record))))

def OperativeKnowledge.realizedEffect
    {Record Agent Rule Model Interpretation Action Effect : Type u}
    {context : InterpretiveContext Agent}
    (knowledge : OperativeKnowledge
      Record Agent Rule Model Interpretation Action Effect context) : Effect :=
  knowledge.effectFrom knowledge.rule knowledge.interpreter knowledge.record
    (knowledge.actionFrom knowledge.rule knowledge.interpreter
      (knowledge.interpretationFrom knowledge.rule knowledge.interpreter
        knowledge.record
        (knowledge.modelFrom knowledge.rule knowledge.interpreter
          knowledge.record)))

structure KnowledgeTransmission
    {Record Agent Rule Model Interpretation Action Effect : Type u}
    {sourceContext recipientContext : InterpretiveContext Agent}
    (source : OperativeKnowledge
      Record Agent Rule Model Interpretation Action Effect sourceContext)
    (recipient : OperativeKnowledge
      Record Agent Rule Model Interpretation Action Effect recipientContext) where
  distinctInterpreters : source.interpreter ≠ recipient.interpreter
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
  enumerates
    | .enumerated => True
    | _ => False
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
  adaptiveWitness := by
    refine ⟨.novelA, .novelB, trivial, trivial, ?_⟩
    simp [AdaptiveAcross, toyAdaptiveRule, adaptivePipeline,
      CognitivePipeline.modelFor, CognitivePipeline.interpretationFor]
  perceptionAndMemoryDiscriminate := by
    refine ⟨.novelA, .familiar, .empty, trivial, ?_, ?_⟩ <;>
      simp [toyAdaptiveRule, adaptivePipeline, CognitivePipeline.modelFor]
  modelDiscriminatesInterpretation := by
    refine ⟨.novelA, .baseline, trivial, ?_⟩
    simp [toyAdaptiveRule, adaptivePipeline,
      CognitivePipeline.interpretationFor, CognitivePipeline.modelFor]
  interpretationDiscriminatesAction := by
    refine ⟨.novelA, .repeat, trivial, ?_⟩
    simp [toyAdaptiveRule, adaptivePipeline, CognitivePipeline.actionFor,
      CognitivePipeline.interpretationFor, CognitivePipeline.modelFor]
  novelConsequencesConform := by
    intro situation _ novel
    cases situation <;>
      simp_all [toyAdaptiveRule, successfulEffect, adaptivePipeline,
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
  enumerates := toyAdaptiveRule.enumerates
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

inductive ToyKnowledgeRule where
  | interpretRecord
  deriving DecidableEq

def claimModel : ToyKnowledgeRule → ToyAgent → ToyClaim → ToyModel
  | _, _, .accurate => .generalizationA
  | _, _, .mistaken => .generalizationB

def claimInterpretation :
    ToyKnowledgeRule → ToyAgent → ToyClaim → ToyModel → ToyInterpretation
  | _, _, .accurate, _ => .adaptA
  | _, _, .mistaken, _ => .adaptB

def claimAction : ToyKnowledgeRule → ToyAgent → ToyInterpretation → ToyAction
  | _, _, .adaptA => .handleA
  | _, _, .adaptB => .handleB
  | _, _, .repeat => .routine

def claimEffect :
    ToyKnowledgeRule → ToyAgent → ToyClaim → ToyAction → ToyEffect
  | _, _, .accurate, .handleA => .success
  | _, _, .mistaken, .handleB => .success
  | _, _, _, _ => .failure

def mistakenOperativeKnowledge : OperativeKnowledge
    ToyClaim ToyAgent ToyKnowledgeRule ToyModel ToyInterpretation ToyAction ToyEffect
      activeContext where
  record := .mistaken
  interpreter := .source
  interpreterCapable := trivial
  rule := .interpretRecord
  scope := recordScope
  recordInScope := trivial
  modelFrom := claimModel
  interpretationFrom := claimInterpretation
  actionFrom := claimAction
  effectFrom := claimEffect
  effectSpecification := successfulEffect
  alternativeRecord := .accurate
  alternativeInScope := trivial
  discriminates := by simp [claimInterpretation]
  operative := by simp [successfulEffect, claimEffect, claimAction,
    claimInterpretation]

def accurateOperativeKnowledge : OperativeKnowledge
    ToyClaim ToyAgent ToyKnowledgeRule ToyModel ToyInterpretation ToyAction ToyEffect
      activeContext where
  record := .accurate
  interpreter := .recipient
  interpreterCapable := trivial
  rule := .interpretRecord
  scope := recordScope
  recordInScope := trivial
  modelFrom := claimModel
  interpretationFrom := claimInterpretation
  actionFrom := claimAction
  effectFrom := claimEffect
  effectSpecification := successfulEffect
  alternativeRecord := .mistaken
  alternativeInScope := trivial
  discriminates := by simp [claimInterpretation]
  operative := by simp [successfulEffect, claimEffect, claimAction,
    claimInterpretation]

theorem operativeKnowledgeDoesNotEntailTruth :
    ¬ toyTruthSemantics.isTrue mistakenOperativeKnowledge.record := by
  simp [mistakenOperativeKnowledge, TruthSemantics.isTrue,
    toyTruthSemantics, toyTruthSpecification]

theorem operativeKnowledgeDoesNotEntailIntelligence :
    Nonempty (OperativeKnowledge
      ToyClaim ToyAgent ToyKnowledgeRule ToyModel ToyInterpretation ToyAction ToyEffect
        activeContext) ∧
      ∀ first second,
        ¬ AdaptiveAcross fixedRule first second := by
  exact ⟨⟨mistakenOperativeKnowledge⟩,
    fixedInterpretationDoesNotAdapt⟩

theorem noOperativeKnowledgeWithoutCapableInterpreter :
    ¬ Nonempty (OperativeKnowledge
      ToyClaim ToyAgent ToyKnowledgeRule ToyModel ToyInterpretation ToyAction ToyEffect
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

def reconstructedTransmission : KnowledgeTransmission
    mistakenOperativeKnowledge accurateOperativeKnowledge where
  distinctInterpreters := by simp [mistakenOperativeKnowledge,
    accurateOperativeKnowledge]
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
      mistakenOperativeKnowledge, accurateOperativeKnowledge, claimEffect,
      claimAction, claimInterpretation, claimModel]

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
        ToyClaim ToyAgent ToyKnowledgeRule ToyModel ToyInterpretation ToyAction ToyEffect
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
  simp [mistakenOperativeKnowledge, accurateOperativeKnowledge, claimModel,
    preservedSuccess, OperativeKnowledge.realizedEffect, claimEffect,
    claimAction, claimInterpretation]

end DanielOntology
