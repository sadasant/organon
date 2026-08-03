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

structure AdaptiveRule (Situation : Type u) where
  enumerates : Situation → Prop

structure CognitivePipeline
    (Situation Perception Memory Model Interpretation Action Consequence : Type u) where
  perceive : Situation → Perception
  remember : Situation → Memory
  constructModel : Perception → Memory → Model
  interpret : Perception → Memory → Model → Interpretation
  selectAction : Interpretation → Action
  consequence : Situation → Action → Consequence

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
    (rule : AdaptiveRule Situation)
    (pipeline : CognitivePipeline
      Situation Perception Memory Model Interpretation Action Consequence)
    (first second : Situation) : Prop :=
  ¬ rule.enumerates first ∧
    ¬ rule.enumerates second ∧
    pipeline.modelFor first ≠ pipeline.modelFor second ∧
    pipeline.interpretationFor first ≠ pipeline.interpretationFor second

structure Intelligence
    (Agent Situation Perception Memory Model Interpretation Action Consequence : Type u) where
  agent : Agent
  rule : AdaptiveRule Situation
  pipeline : CognitivePipeline
    Situation Perception Memory Model Interpretation Action Consequence
  scope : Scope Situation
  consequenceSpecification : Specification Consequence
  adaptiveWitness :
    ∃ first second,
      scope.includes first ∧
      scope.includes second ∧
      AdaptiveAcross rule pipeline first second
  novelConsequencesConform :
    ∀ situation,
      scope.includes situation →
      ¬ rule.enumerates situation →
      consequenceSpecification.conforms (pipeline.consequenceFor situation)

structure InterpretiveContext (Agent : Type u) where
  capable : Agent → Prop

structure OperativeKnowledge
    (Record Agent Model Interpretation Action Effect : Type u)
    (context : InterpretiveContext Agent) where
  record : Record
  interpreter : Agent
  interpreterCapable : context.capable interpreter
  scope : Scope Record
  recordInScope : scope.includes record
  modelFrom : Agent → Record → Model
  interpretationFrom : Agent → Record → Model → Interpretation
  actionFrom : Agent → Interpretation → Action
  effectFrom : Agent → Record → Action → Effect
  effectSpecification : Specification Effect
  alternativeRecord : Record
  alternativeInScope : scope.includes alternativeRecord
  discriminates :
    interpretationFrom interpreter record (modelFrom interpreter record) ≠
      interpretationFrom interpreter alternativeRecord
        (modelFrom interpreter alternativeRecord)
  operative :
    effectSpecification.conforms
      (effectFrom interpreter record
        (actionFrom interpreter
          (interpretationFrom interpreter record
            (modelFrom interpreter record))))

def OperativeKnowledge.realizedEffect
    {Record Agent Model Interpretation Action Effect : Type u}
    {context : InterpretiveContext Agent}
    (knowledge : OperativeKnowledge
      Record Agent Model Interpretation Action Effect context) : Effect :=
  knowledge.effectFrom knowledge.interpreter knowledge.record
    (knowledge.actionFrom knowledge.interpreter
      (knowledge.interpretationFrom knowledge.interpreter knowledge.record
        (knowledge.modelFrom knowledge.interpreter knowledge.record)))

structure KnowledgeTransmission
    {Record Agent Model Interpretation Action Effect : Type u}
    {sourceContext recipientContext : InterpretiveContext Agent}
    (source : OperativeKnowledge
      Record Agent Model Interpretation Action Effect sourceContext)
    (recipient : OperativeKnowledge
      Record Agent Model Interpretation Action Effect recipientContext) where
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

def toyAdaptiveRule : AdaptiveRule ToySituation where
  enumerates
    | .enumerated => True
    | _ => False

def adaptivePipeline : CognitivePipeline
    ToySituation ToyPerception ToyMemory ToyModel ToyInterpretation ToyAction ToyEffect where
  perceive
    | .enumerated => .familiar
    | .novelA => .signalA
    | .novelB => .signalB
  remember := fun _ => .retained
  constructModel
    | .familiar, _ => .baseline
    | .signalA, _ => .generalizationA
    | .signalB, _ => .generalizationB
  interpret
    | .familiar, _, _ => .repeat
    | .signalA, _, _ => .adaptA
    | .signalB, _, _ => .adaptB
  selectAction
    | .repeat => .routine
    | .adaptA => .handleA
    | .adaptB => .handleB
  consequence
    | .novelA, .handleA => .success
    | .novelB, .handleB => .success
    | .enumerated, .routine => .success
    | _, _ => .failure

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
  pipeline := adaptivePipeline
  scope := ⟨fun _ => True⟩
  consequenceSpecification := successfulEffect
  adaptiveWitness := by
    refine ⟨.novelA, .novelB, trivial, trivial, ?_⟩
    simp [AdaptiveAcross, toyAdaptiveRule, adaptivePipeline,
      CognitivePipeline.modelFor, CognitivePipeline.interpretationFor]
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

theorem fixedInterpretationDoesNotAdapt :
    ∀ first second,
      ¬ AdaptiveAcross toyAdaptiveRule fixedPipeline first second := by
  intro first second adaptive
  exact adaptive.2.2.2 (by
    simp [fixedPipeline, CognitivePipeline.interpretationFor,
      CognitivePipeline.modelFor])

/-! ## Finite Operative Knowledge and Transmission witnesses -/

def activeContext : InterpretiveContext ToyAgent where
  capable := fun _ => True

def dormantContext : InterpretiveContext ToyAgent where
  capable := fun _ => False

def recordScope : Scope ToyClaim := ⟨fun _ => True⟩

def claimModel : ToyAgent → ToyClaim → ToyModel
  | _, .accurate => .generalizationA
  | _, .mistaken => .generalizationB

def claimInterpretation : ToyAgent → ToyClaim → ToyModel → ToyInterpretation
  | _, .accurate, _ => .adaptA
  | _, .mistaken, _ => .adaptB

def claimAction : ToyAgent → ToyInterpretation → ToyAction
  | _, .adaptA => .handleA
  | _, .adaptB => .handleB
  | _, .repeat => .routine

def claimEffect : ToyAgent → ToyClaim → ToyAction → ToyEffect
  | _, .accurate, .handleA => .success
  | _, .mistaken, .handleB => .success
  | _, _, _ => .failure

def mistakenOperativeKnowledge : OperativeKnowledge
    ToyClaim ToyAgent ToyModel ToyInterpretation ToyAction ToyEffect activeContext where
  record := .mistaken
  interpreter := .source
  interpreterCapable := trivial
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
    ToyClaim ToyAgent ToyModel ToyInterpretation ToyAction ToyEffect activeContext where
  record := .accurate
  interpreter := .recipient
  interpreterCapable := trivial
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

theorem noOperativeKnowledgeWithoutCapableInterpreter :
    ¬ Nonempty (OperativeKnowledge
      ToyClaim ToyAgent ToyModel ToyInterpretation ToyAction ToyEffect dormantContext) := by
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
        ToyClaim ToyAgent ToyModel ToyInterpretation ToyAction ToyEffect dormantContext) := by
  exact ⟨⟨copiedRecord⟩, noOperativeKnowledgeWithoutCapableInterpreter⟩

theorem transmissionDoesNotRequireIdenticalRecordsOrModels :
    mistakenOperativeKnowledge.record ≠ accurateOperativeKnowledge.record ∧
      mistakenOperativeKnowledge.modelFrom
          mistakenOperativeKnowledge.interpreter
          mistakenOperativeKnowledge.record ≠
        accurateOperativeKnowledge.modelFrom
          accurateOperativeKnowledge.interpreter
          accurateOperativeKnowledge.record ∧
      preservedSuccess.conforms
        (mistakenOperativeKnowledge.realizedEffect,
          accurateOperativeKnowledge.realizedEffect) := by
  simp [mistakenOperativeKnowledge, accurateOperativeKnowledge, claimModel,
    preservedSuccess, OperativeKnowledge.realizedEffect, claimEffect,
    claimAction, claimInterpretation]

end DanielOntology
