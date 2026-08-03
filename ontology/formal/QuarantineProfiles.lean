import Consciousness
import IntelligenceKnowledge

/-!
# Epistemic, moral, sovereign, and valuation profiles

This file tests D091-D101 and Pj4 without defining bare Knowledge, an
underlying moral condition, generic Sovereignty, generic Value, or moral
worth. Its finite models establish only the named entailments and
anti-entailments.
-/

universe u

namespace DanielOntology.QuarantineProfiles

/-! ## Factive and warranted operative knowledge -/

structure RecordClaimSemantics (Record Claim : Type u) where
  carries : Record → Claim → Prop

structure FactiveOperativeKnowledge
    (Record Agent OperativeRule Model Interpretation Action Effect : Type u)
    (context : InterpretiveContext Agent)
    (Claim Representation MeaningRule Target : Type u)
    (carrier : RecordClaimSemantics Record Claim)
    (truthSemantics : TruthSemantics Claim Representation MeaningRule Target) where
  operative : OperativeKnowledge
    Record Agent OperativeRule Model Interpretation Action Effect context
  claim : Claim
  carried : carrier.carries operative.record claim
  trueClaim : truthSemantics.isTrue claim

structure EvidenceSemantics
    (Agent Claim Evidence Observation Witness Order Rule : Type u) where
  observes : Witness → Observation → Prop
  supports : Evidence → Observation → Claim → Prop
  independentFor : Witness → Agent → Claim → Observation → Order → Prop
  admits : Order → Rule → Evidence → Claim → Prop

structure EvidenceAdmission
    {Agent Claim Evidence Observation Witness Order Rule : Type u}
    (semantics : EvidenceSemantics
      Agent Claim Evidence Observation Witness Order Rule)
    (claim : Claim) where
  claimant : Agent
  evidence : Evidence
  observation : Observation
  witness : Witness
  order : Order
  rule : Rule
  observed : semantics.observes witness observation
  supportsClaim : semantics.supports evidence observation claim
  independent :
    semantics.independentFor witness claimant claim observation order
  admitted : semantics.admits order rule evidence claim

structure WarrantedKnowledge
    {Record Agent OperativeRule Model Interpretation Action Effect : Type u}
    {context : InterpretiveContext Agent}
    {Claim Representation MeaningRule Target : Type u}
    {carrier : RecordClaimSemantics Record Claim}
    {truthSemantics : TruthSemantics Claim Representation MeaningRule Target}
    (factive : FactiveOperativeKnowledge
      Record Agent OperativeRule Model Interpretation Action Effect context
      Claim Representation MeaningRule Target carrier truthSemantics)
    (Evidence Observation Witness Order EvidenceRule : Type u)
    (evidenceSemantics : EvidenceSemantics
      Agent Claim Evidence Observation Witness Order EvidenceRule) where
  admission : EvidenceAdmission evidenceSemantics factive.claim
  claimantMatches : admission.claimant = factive.operative.interpreter

def toyRecordClaims : RecordClaimSemantics ToyClaim ToyClaim where
  carries := Eq

def accurateFactiveKnowledge : FactiveOperativeKnowledge
    ToyClaim ToyAgent ToyOperativeRule ToyModel ToyInterpretation ToyAction
      ToyEffect activeContext
    ToyClaim ToyAlignmentPresence ToyMeaningRule ToyFact
      toyRecordClaims toyTruthSemantics where
  operative := accurateOperativeKnowledge
  claim := .accurate
  carried := rfl
  trueClaim := by
    simp [TruthSemantics.isTrue, toyTruthSemantics, toyTruthSpecification]

inductive ToyEvidence where | report deriving DecidableEq
inductive ToyObservation where | observed deriving DecidableEq
inductive ToyWitness where | independent deriving DecidableEq
inductive ToyOrder where | reviewing deriving DecidableEq
inductive ToyEvidenceRule where | admitIndependent deriving DecidableEq

def openEvidenceSemantics : EvidenceSemantics
    ToyAgent ToyClaim ToyEvidence ToyObservation ToyWitness ToyOrder
      ToyEvidenceRule where
  observes := fun _ _ => True
  supports := fun evidence observation claim =>
    evidence = .report ∧ observation = .observed ∧ claim = .accurate
  independentFor := fun _ _ _ _ _ => True
  admits := fun _ _ evidence claim =>
    evidence = .report ∧ claim = .accurate

def warrantedAccurateKnowledge : WarrantedKnowledge
    accurateFactiveKnowledge ToyEvidence ToyObservation ToyWitness ToyOrder
      ToyEvidenceRule openEvidenceSemantics where
  admission := {
    claimant := .recipient
    evidence := .report
    observation := .observed
    witness := .independent
    order := .reviewing
    rule := .admitIndependent
    observed := trivial
    supportsClaim := by
      simp [openEvidenceSemantics, accurateFactiveKnowledge]
    independent := trivial
    admitted := by
      simp [openEvidenceSemantics, accurateFactiveKnowledge]
  }
  claimantMatches := rfl

def closedEvidenceSemantics : EvidenceSemantics
    ToyAgent ToyClaim ToyEvidence ToyObservation ToyWitness ToyOrder
      ToyEvidenceRule where
  observes := fun _ _ => True
  supports := fun _ _ _ => True
  independentFor := fun _ _ _ _ _ => True
  admits := fun _ _ _ _ => False

theorem operativeKnowledgeDoesNotEntailFactiveKnowledge :
    ¬ ∃ factive : FactiveOperativeKnowledge
        ToyClaim ToyAgent ToyOperativeRule ToyModel ToyInterpretation ToyAction
          ToyEffect activeContext
        ToyClaim ToyAlignmentPresence ToyMeaningRule ToyFact
          toyRecordClaims toyTruthSemantics,
      factive.operative = mistakenOperativeKnowledge := by
  rintro ⟨factive, sameOperative⟩
  have carried : factive.operative.record = factive.claim := factive.carried
  rw [sameOperative] at carried
  have claimMistaken : factive.claim = .mistaken := carried.symm
  have trueMistaken : toyTruthSemantics.isTrue .mistaken :=
    claimMistaken ▸ factive.trueClaim
  exact operativeKnowledgeDoesNotEntailTruth trueMistaken

theorem truthDoesNotEntailFactiveKnowledgeWithoutOperativePath :
    toyTruthSemantics.isTrue ToyClaim.accurate ∧
      ¬ Nonempty (OperativeKnowledge
        ToyClaim ToyAgent ToyOperativeRule ToyModel ToyInterpretation ToyAction
          ToyEffect dormantContext) := by
  constructor
  · simp [TruthSemantics.isTrue, toyTruthSemantics, toyTruthSpecification]
  · exact noOperativeKnowledgeWithoutCapableInterpreter

theorem factiveKnowledgeDoesNotEntailWarrant :
    ¬ Nonempty (WarrantedKnowledge
      accurateFactiveKnowledge ToyEvidence ToyObservation ToyWitness ToyOrder
        ToyEvidenceRule closedEvidenceSemantics) := by
  rintro ⟨warranted⟩
  exact warranted.admission.admitted

theorem warrantedKnowledgeEntailsFactiveKnowledge :
    Nonempty (WarrantedKnowledge
      accurateFactiveKnowledge ToyEvidence ToyObservation ToyWitness ToyOrder
        ToyEvidenceRule openEvidenceSemantics) ∧
      toyTruthSemantics.isTrue accurateFactiveKnowledge.claim := by
  exact ⟨⟨warrantedAccurateKnowledge⟩,
    accurateFactiveKnowledge.trueClaim⟩

/-! ## Moral candidate, Attribution, and Designation -/

structure MoralCandidateCondition
    (Entity State Condition : Type u) where
  condition : Condition
  obtains : Condition → Entity → State → Prop
  specification : Specification (Entity × State)
  specificationCorrect :
    ∀ entity state,
      specification.conforms (entity, state) ↔ obtains condition entity state

def MoralCandidateCondition.holds
    {Entity State Condition : Type u}
    (candidate : MoralCandidateCondition Entity State Condition)
    (entity : Entity) (state : State) : Prop :=
  candidate.obtains candidate.condition entity state

inductive AttributionPerspective where
  | firstPerson
  | thirdPerson
deriving DecidableEq

structure MoralReferenceMap (Agent Entity : Type u) where
  asEntity : Agent → Entity
  sameUnder : Entity → Entity → Prop

structure MoralAttributionSemantics
    (Representation Language MeaningRule Candidate : Type u) where
  meansCandidate : MeaningRule → Language → Representation → Candidate → Prop

structure MoralStatusAttribution
    (Agent Entity State Condition Representation Language MeaningRule : Type u)
    (referenceMap : MoralReferenceMap Agent Entity)
    (semantics : MoralAttributionSemantics Representation Language MeaningRule
      (MoralCandidateCondition Entity State Condition)) where
  claimId : Nat
  claimant : Agent
  target : Entity
  state : State
  candidate : MoralCandidateCondition Entity State Condition
  representation : Representation
  claimScope : Scope (Entity × State)
  language : Language
  meaningRule : MeaningRule
  meaningHolds :
    semantics.meansCandidate meaningRule language representation candidate
  targetInClaimScope : claimScope.includes (target, state)
  candidateInScope : candidate.specification.scope.includes (target, state)
  perspective : AttributionPerspective
  perspectiveCorrect :
    perspective = .firstPerson ↔
      referenceMap.sameUnder (referenceMap.asEntity claimant) target

structure MoralDesignationOrder
    (Attribution Entity State Rule Purpose : Type u) where
  admits : Rule → Purpose → Attribution → Prop
  countsAsMoralPerson :
    Rule → Purpose → Attribution → Scope (Entity × State) → Prop
  countingRequiresAdmission :
    ∀ rule purpose attribution scope,
      countsAsMoralPerson rule purpose attribution scope →
        admits rule purpose attribution

structure MoralPersonhoodDesignation
    {Agent Entity State Condition Representation Language MeaningRule : Type u}
    {referenceMap : MoralReferenceMap Agent Entity}
    {semantics : MoralAttributionSemantics Representation Language MeaningRule
      (MoralCandidateCondition Entity State Condition)}
    {Purpose : Type u}
    (order : MoralDesignationOrder
      (MoralStatusAttribution Agent Entity State Condition Representation
        Language MeaningRule referenceMap semantics)
      Entity State MeaningRule Purpose) where
  attribution : MoralStatusAttribution Agent Entity State Condition
    Representation Language MeaningRule referenceMap semantics
  rule : MeaningRule
  purpose : Purpose
  scope : Scope (Entity × State)
  targetInScope : scope.includes (attribution.target, attribution.state)
  counted : order.countsAsMoralPerson rule purpose attribution scope

inductive MoralEntity where | subject deriving DecidableEq
inductive MoralState where | present deriving DecidableEq
inductive MoralCondition where | affirmed | denied deriving DecidableEq
inductive MoralRepresentation where | assertion deriving DecidableEq
inductive MoralLanguage where | ordinary deriving DecidableEq
inductive MoralRule where | interpret | designate deriving DecidableEq
inductive MoralPurpose where | protectionReview deriving DecidableEq

def moralScope : Scope (MoralEntity × MoralState) := ⟨fun _ => True⟩

def moralObtains : MoralCondition → MoralEntity → MoralState → Prop
  | .affirmed, _, _ => True
  | .denied, _, _ => False

def deniedMoralCandidate : MoralCandidateCondition
    MoralEntity MoralState MoralCondition where
  condition := .denied
  obtains := moralObtains
  specification := {
    scope := moralScope
    conforms := fun _ => False
    decideConformity := fun _ => false
    conformityCorrect := by simp
    conformityWithinScope := by simp
  }
  specificationCorrect := by intro entity state; cases entity <;> cases state <;> simp [moralObtains]

def affirmedMoralCandidate : MoralCandidateCondition
    MoralEntity MoralState MoralCondition where
  condition := .affirmed
  obtains := moralObtains
  specification := {
    scope := moralScope
    conforms := fun _ => True
    decideConformity := fun _ => true
    conformityCorrect := by simp
    conformityWithinScope := by simp [moralScope]
  }
  specificationCorrect := by intro entity state; cases entity <;> cases state <;> simp [moralObtains]

def moralReferenceMap : MoralReferenceMap MoralEntity MoralEntity where
  asEntity := id
  sameUnder := Eq

def moralSemantics : MoralAttributionSemantics MoralRepresentation MoralLanguage
    MoralRule (MoralCandidateCondition MoralEntity MoralState MoralCondition) where
  meansCandidate := fun _ _ _ _ => True

def deniedMoralAttribution : MoralStatusAttribution MoralEntity MoralEntity
    MoralState MoralCondition MoralRepresentation MoralLanguage MoralRule
      moralReferenceMap moralSemantics where
  claimId := 1
  claimant := .subject
  target := .subject
  state := .present
  candidate := deniedMoralCandidate
  representation := .assertion
  claimScope := moralScope
  language := .ordinary
  meaningRule := .interpret
  meaningHolds := trivial
  targetInClaimScope := trivial
  candidateInScope := trivial
  perspective := .firstPerson
  perspectiveCorrect := by simp [moralReferenceMap]

def affirmedMoralAttribution : MoralStatusAttribution MoralEntity MoralEntity
    MoralState MoralCondition MoralRepresentation MoralLanguage MoralRule
      moralReferenceMap moralSemantics :=
  { deniedMoralAttribution with claimId := 2, candidate := affirmedMoralCandidate }

def designatingMoralOrder : MoralDesignationOrder
    (MoralStatusAttribution MoralEntity MoralEntity MoralState MoralCondition
      MoralRepresentation MoralLanguage MoralRule moralReferenceMap moralSemantics)
    MoralEntity MoralState MoralRule MoralPurpose where
  admits := fun rule purpose _ =>
    rule = .designate ∧ purpose = .protectionReview
  countsAsMoralPerson := fun rule purpose _ _ =>
    rule = .designate ∧ purpose = .protectionReview
  countingRequiresAdmission := by intro rule purpose attribution scope counted; exact counted

def silentMoralOrder : MoralDesignationOrder
    (MoralStatusAttribution MoralEntity MoralEntity MoralState MoralCondition
      MoralRepresentation MoralLanguage MoralRule moralReferenceMap moralSemantics)
    MoralEntity MoralState MoralRule MoralPurpose where
  admits := fun _ _ _ => False
  countsAsMoralPerson := fun _ _ _ _ => False
  countingRequiresAdmission := by simp

def deniedMoralDesignation : MoralPersonhoodDesignation designatingMoralOrder where
  attribution := deniedMoralAttribution
  rule := .designate
  purpose := .protectionReview
  scope := moralScope
  targetInScope := trivial
  counted := by simp [designatingMoralOrder]

theorem moralAttributionDoesNotEntailCandidate :
    ¬ deniedMoralAttribution.candidate.holds
      deniedMoralAttribution.target deniedMoralAttribution.state := by
  simp [MoralCandidateCondition.holds, deniedMoralAttribution,
    deniedMoralCandidate, moralObtains]

theorem moralDesignationDoesNotEntailCandidate :
    ¬ deniedMoralDesignation.attribution.candidate.holds
      deniedMoralDesignation.attribution.target
      deniedMoralDesignation.attribution.state :=
  moralAttributionDoesNotEntailCandidate

def designationGrantsProtection
    (_ : MoralPersonhoodDesignation designatingMoralOrder) : Prop := False

theorem moralDesignationDoesNotEntailProtection :
    Nonempty (MoralPersonhoodDesignation designatingMoralOrder) ∧
      ¬ designationGrantsProtection deniedMoralDesignation := by
  exact ⟨⟨deniedMoralDesignation⟩, by simp [designationGrantsProtection]⟩

theorem nonDesignationDoesNotDecideCandidate :
    (¬ silentMoralOrder.countsAsMoralPerson .designate .protectionReview
      affirmedMoralAttribution moralScope) ∧
    affirmedMoralAttribution.candidate.holds
      affirmedMoralAttribution.target affirmedMoralAttribution.state ∧
    (¬ silentMoralOrder.countsAsMoralPerson .designate .protectionReview
      deniedMoralAttribution moralScope) ∧
    ¬ deniedMoralAttribution.candidate.holds
      deniedMoralAttribution.target deniedMoralAttribution.state := by
  simp [silentMoralOrder, MoralCandidateCondition.holds,
    affirmedMoralAttribution, affirmedMoralCandidate, deniedMoralAttribution,
    deniedMoralCandidate, moralObtains]

/-! ## Four noncomposing sovereignty profiles -/

structure SovereigntySemantics
    (Polity Entity Order Action Crossing Outcome : Type u) where
  Rule : Type u
  hasConstituentPower : Polity → Order → Prop
  constitutes : Polity → Order → Action → Prop
  hasStanding : Order → Entity → Prop
  hasAuthority : Order → Entity → Action → Prop
  superior : Order → Entity → Entity → Action → Prop
  controlsCrossing : Entity → Crossing → Prop
  admitsCrossing : Crossing → Prop
  blocksCrossing : Crossing → Prop
  enforcementChanges : Order → Crossing → Outcome → Outcome → Prop
  externallyRecognizes : Order → Order → Entity → Rule → Prop
  actsAsOwnPrincipal : Order → Entity → Rule → Action → Prop
  actsFor : Order → Entity → Entity → Rule → Action → Prop

structure ConstituentSovereignty
    {Polity Entity Order Action Crossing Outcome : Type u}
    (semantics : SovereigntySemantics Polity Entity Order Action Crossing Outcome) where
  polity : Polity
  order : Order
  scope : Scope Action
  exercise : Action
  power : semantics.hasConstituentPower polity order
  exerciseInScope : scope.includes exercise
  exercised : semantics.constitutes polity order exercise

structure ConstitutedSovereignty
    {Polity Entity Order Action Crossing Outcome : Type u}
    (semantics : SovereigntySemantics Polity Entity Order Action Crossing Outcome) where
  order : Order
  holder : Entity
  scope : Scope Action
  representativeAction : Action
  representativeInScope : scope.includes representativeAction
  standing : semantics.hasStanding order holder
  authority : ∀ action, scope.includes action →
    semantics.hasAuthority order holder action
  maximal : ∀ candidate action,
    scope.includes action →
      semantics.hasStanding order candidate →
        ¬ semantics.superior order candidate holder action

structure BoundarySovereignty
    {Polity Entity Order Action Crossing Outcome : Type u}
    (semantics : SovereigntySemantics Polity Entity Order Action Crossing Outcome) where
  holder : Entity
  order : Order
  scope : Scope Crossing
  admittedCrossing : Crossing
  blockedCrossing : Crossing
  differentCrossings : admittedCrossing ≠ blockedCrossing
  admittedInScope : scope.includes admittedCrossing
  blockedInScope : scope.includes blockedCrossing
  controlsAdmitted : semantics.controlsCrossing holder admittedCrossing
  controlsBlocked : semantics.controlsCrossing holder blockedCrossing
  admitted : semantics.admitsCrossing admittedCrossing
  blocked : semantics.blocksCrossing blockedCrossing
  unenforcedOutcome : Outcome
  enforcedOutcome : Outcome
  differentOutcomes : unenforcedOutcome ≠ enforcedOutcome
  enforcementDifference :
    semantics.enforcementChanges order blockedCrossing
      unenforcedOutcome enforcedOutcome

structure ExternalSovereignty
    {Polity Entity Order Action Crossing Outcome : Type u}
    (semantics : SovereigntySemantics Polity Entity Order Action Crossing Outcome) where
  internalOrder : Order
  recognizingOrder : Order
  target : Entity
  rule : semantics.Rule
  action : Action
  scope : Scope Action
  distinctOrders : internalOrder ≠ recognizingOrder
  actionInScope : scope.includes action
  standing : semantics.hasStanding recognizingOrder target
  recognized :
    semantics.externallyRecognizes recognizingOrder internalOrder target rule
  ownPrincipal :
    semantics.actsAsOwnPrincipal recognizingOrder target rule action
  notDelegated : ∀ otherPrincipal,
    otherPrincipal ≠ target →
      ¬ semantics.actsFor recognizingOrder target otherPrincipal rule action

inductive ToyPolity where | people deriving DecidableEq
inductive SovereignEntity where | assembly | governor deriving DecidableEq
inductive SovereignOrder where | internal | foreign deriving DecidableEq
inductive SovereignRule where | internalAuthority | externalRecognition deriving DecidableEq
inductive SovereignAction where | refound | administer deriving DecidableEq
inductive Crossing where | admitted | blocked deriving DecidableEq
inductive BoundaryOutcome where | unchanged | prevented deriving DecidableEq

def toySovereignty : SovereigntySemantics ToyPolity SovereignEntity
    SovereignOrder SovereignAction Crossing BoundaryOutcome where
  Rule := SovereignRule
  hasConstituentPower := fun polity order =>
    polity = .people ∧ order = .internal
  constitutes := fun polity order action =>
    polity = .people ∧ order = .internal ∧ action = .refound
  hasStanding := fun order entity =>
    (order = .internal ∧ entity = .governor) ∨
      (order = .foreign ∧ entity = .assembly)
  hasAuthority := fun order entity action =>
    order = .internal ∧ entity = .governor ∧ action = .administer
  superior := fun _ _ _ _ => False
  controlsCrossing := fun entity _ => entity = .assembly
  admitsCrossing := fun crossing => crossing = .admitted
  blocksCrossing := fun crossing => crossing = .blocked
  enforcementChanges := fun order crossing before after =>
    order = .internal ∧ crossing = .blocked ∧
      before = .unchanged ∧ after = .prevented
  externallyRecognizes := fun externalOrder internalOrder target rule =>
    externalOrder = .foreign ∧ internalOrder = .internal ∧
      target = .assembly ∧ rule = .externalRecognition
  actsAsOwnPrincipal := fun order entity rule action =>
    order = .foreign ∧ entity = .assembly ∧
      rule = .externalRecognition ∧ action = .administer
  actsFor := fun _ _ _ _ _ => False

def constituentWitness : ConstituentSovereignty toySovereignty where
  polity := .people
  order := .internal
  scope := ⟨fun action => action = .refound⟩
  exercise := .refound
  power := by simp [toySovereignty]
  exerciseInScope := by simp
  exercised := by simp [toySovereignty]

def constitutedWitness : ConstitutedSovereignty toySovereignty where
  order := .internal
  holder := .governor
  scope := ⟨fun action => action = .administer⟩
  representativeAction := .administer
  representativeInScope := by simp
  standing := by simp [toySovereignty]
  authority := by
    intro action inScope
    simp at inScope
    subst action
    simp [toySovereignty]
  maximal := by intro candidate action _ _; simp [toySovereignty]

def boundaryWitness : BoundarySovereignty toySovereignty where
  holder := .assembly
  order := .internal
  scope := ⟨fun _ => True⟩
  admittedCrossing := .admitted
  blockedCrossing := .blocked
  differentCrossings := by decide
  admittedInScope := trivial
  blockedInScope := trivial
  controlsAdmitted := by simp [toySovereignty]
  controlsBlocked := by simp [toySovereignty]
  admitted := by simp [toySovereignty]
  blocked := by simp [toySovereignty]
  unenforcedOutcome := .unchanged
  enforcedOutcome := .prevented
  differentOutcomes := by decide
  enforcementDifference := by simp [toySovereignty]

def externalWitness : ExternalSovereignty toySovereignty where
  internalOrder := .internal
  recognizingOrder := .foreign
  target := .assembly
  rule := .externalRecognition
  action := .administer
  scope := ⟨fun action => action = .administer⟩
  distinctOrders := by decide
  actionInScope := by simp
  standing := by simp [toySovereignty]
  recognized := by simp [toySovereignty]
  ownPrincipal := by simp [toySovereignty]
  notDelegated := by simp [toySovereignty]

def constituentOnlySemantics : SovereigntySemantics ToyPolity SovereignEntity
    SovereignOrder SovereignAction Crossing BoundaryOutcome :=
  { toySovereignty with
    hasStanding := fun _ _ => False
    hasAuthority := fun _ _ _ => False
    superior := fun _ _ _ _ => False
    controlsCrossing := fun _ _ => False
    admitsCrossing := fun _ => False
    blocksCrossing := fun _ => False
    enforcementChanges := fun _ _ _ _ => False
    externallyRecognizes := fun _ _ _ _ => False
    actsAsOwnPrincipal := fun _ _ _ _ => False
    actsFor := fun _ _ _ _ _ => False }

def constitutedOnlySemantics : SovereigntySemantics ToyPolity SovereignEntity
    SovereignOrder SovereignAction Crossing BoundaryOutcome :=
  { toySovereignty with
    hasConstituentPower := fun _ _ => False
    constitutes := fun _ _ _ => False
    controlsCrossing := fun _ _ => False
    admitsCrossing := fun _ => False
    blocksCrossing := fun _ => False
    enforcementChanges := fun _ _ _ _ => False
    externallyRecognizes := fun _ _ _ _ => False
    actsAsOwnPrincipal := fun _ _ _ _ => False
    actsFor := fun _ _ _ _ _ => False }

def boundaryOnlySemantics : SovereigntySemantics ToyPolity SovereignEntity
    SovereignOrder SovereignAction Crossing BoundaryOutcome :=
  { toySovereignty with
    hasConstituentPower := fun _ _ => False
    constitutes := fun _ _ _ => False
    hasStanding := fun _ _ => False
    hasAuthority := fun _ _ _ => False
    superior := fun _ _ _ _ => False
    externallyRecognizes := fun _ _ _ _ => False
    actsAsOwnPrincipal := fun _ _ _ _ => False
    actsFor := fun _ _ _ _ _ => False }

def externalOnlySemantics : SovereigntySemantics ToyPolity SovereignEntity
    SovereignOrder SovereignAction Crossing BoundaryOutcome :=
  { toySovereignty with
    hasConstituentPower := fun _ _ => False
    constitutes := fun _ _ _ => False
    hasAuthority := fun _ _ _ => False
    superior := fun _ _ _ _ => False
    controlsCrossing := fun _ _ => False
    admitsCrossing := fun _ => False
    blocksCrossing := fun _ => False
    enforcementChanges := fun _ _ _ _ => False }

def constituentOnlyWitness : ConstituentSovereignty constituentOnlySemantics where
  polity := .people
  order := .internal
  scope := ⟨fun action => action = .refound⟩
  exercise := .refound
  power := by simp [constituentOnlySemantics, toySovereignty]
  exerciseInScope := by simp
  exercised := by simp [constituentOnlySemantics, toySovereignty]

def constitutedOnlyWitness : ConstitutedSovereignty constitutedOnlySemantics where
  order := .internal
  holder := .governor
  scope := ⟨fun action => action = .administer⟩
  representativeAction := .administer
  representativeInScope := by simp
  standing := by simp [constitutedOnlySemantics, toySovereignty]
  authority := by
    intro action inScope
    simp at inScope
    subst action
    simp [constitutedOnlySemantics, toySovereignty]
  maximal := by
    intro candidate action _ _
    simp [constitutedOnlySemantics, toySovereignty]

def boundaryOnlyWitness : BoundarySovereignty boundaryOnlySemantics where
  holder := .assembly
  order := .internal
  scope := ⟨fun _ => True⟩
  admittedCrossing := .admitted
  blockedCrossing := .blocked
  differentCrossings := by decide
  admittedInScope := trivial
  blockedInScope := trivial
  controlsAdmitted := by simp [boundaryOnlySemantics, toySovereignty]
  controlsBlocked := by simp [boundaryOnlySemantics, toySovereignty]
  admitted := by simp [boundaryOnlySemantics, toySovereignty]
  blocked := by simp [boundaryOnlySemantics, toySovereignty]
  unenforcedOutcome := .unchanged
  enforcedOutcome := .prevented
  differentOutcomes := by decide
  enforcementDifference := by simp [boundaryOnlySemantics, toySovereignty]

def externalOnlyWitness : ExternalSovereignty externalOnlySemantics where
  internalOrder := .internal
  recognizingOrder := .foreign
  target := .assembly
  rule := .externalRecognition
  action := .administer
  scope := ⟨fun action => action = .administer⟩
  distinctOrders := by decide
  actionInScope := by simp
  standing := by simp [externalOnlySemantics, toySovereignty]
  recognized := by simp [externalOnlySemantics, toySovereignty]
  ownPrincipal := by simp [externalOnlySemantics, toySovereignty]
  notDelegated := by simp [externalOnlySemantics, toySovereignty]

theorem constituentDoesNotEntailOtherSovereigntyProfiles :
    Nonempty (ConstituentSovereignty constituentOnlySemantics) ∧
    ¬ Nonempty (ConstitutedSovereignty constituentOnlySemantics) ∧
    ¬ Nonempty (BoundarySovereignty constituentOnlySemantics) ∧
    ¬ Nonempty (ExternalSovereignty constituentOnlySemantics) := by
  refine ⟨⟨constituentOnlyWitness⟩, ?_, ?_, ?_⟩
  · rintro ⟨profile⟩
    simpa [constituentOnlySemantics] using profile.standing
  · rintro ⟨profile⟩
    simpa [constituentOnlySemantics] using profile.controlsAdmitted
  · rintro ⟨profile⟩
    simpa [constituentOnlySemantics] using profile.recognized

theorem constitutedDoesNotEntailOtherSovereigntyProfiles :
    Nonempty (ConstitutedSovereignty constitutedOnlySemantics) ∧
    ¬ Nonempty (ConstituentSovereignty constitutedOnlySemantics) ∧
    ¬ Nonempty (BoundarySovereignty constitutedOnlySemantics) ∧
    ¬ Nonempty (ExternalSovereignty constitutedOnlySemantics) := by
  refine ⟨⟨constitutedOnlyWitness⟩, ?_, ?_, ?_⟩
  · rintro ⟨profile⟩
    simpa [constitutedOnlySemantics] using profile.power
  · rintro ⟨profile⟩
    simpa [constitutedOnlySemantics] using profile.controlsAdmitted
  · rintro ⟨profile⟩
    simpa [constitutedOnlySemantics] using profile.recognized

theorem boundaryDoesNotEntailOtherSovereigntyProfiles :
    Nonempty (BoundarySovereignty boundaryOnlySemantics) ∧
    ¬ Nonempty (ConstituentSovereignty boundaryOnlySemantics) ∧
    ¬ Nonempty (ConstitutedSovereignty boundaryOnlySemantics) ∧
    ¬ Nonempty (ExternalSovereignty boundaryOnlySemantics) := by
  refine ⟨⟨boundaryOnlyWitness⟩, ?_, ?_, ?_⟩
  · rintro ⟨profile⟩
    simpa [boundaryOnlySemantics] using profile.power
  · rintro ⟨profile⟩
    simpa [boundaryOnlySemantics] using profile.standing
  · rintro ⟨profile⟩
    simpa [boundaryOnlySemantics] using profile.recognized

theorem externalDoesNotEntailOtherSovereigntyProfiles :
    Nonempty (ExternalSovereignty externalOnlySemantics) ∧
    ¬ Nonempty (ConstituentSovereignty externalOnlySemantics) ∧
    ¬ Nonempty (ConstitutedSovereignty externalOnlySemantics) ∧
    ¬ Nonempty (BoundarySovereignty externalOnlySemantics) := by
  refine ⟨⟨externalOnlyWitness⟩, ?_, ?_, ?_⟩
  · rintro ⟨profile⟩
    simpa [externalOnlySemantics] using profile.power
  · rintro ⟨profile⟩
    have authority :=
      profile.authority profile.representativeAction profile.representativeInScope
    simp [externalOnlySemantics] at authority
  · rintro ⟨profile⟩
    simpa [externalOnlySemantics] using profile.controlsAdmitted

/-! ## Preference, Utility Measure, Price, and institutional valuation -/

structure Preference (Agent Candidate Rule : Type u) where
  agent : Agent
  rule : Rule
  scope : Scope Candidate
  prefers : Candidate → Candidate → Prop
  asymmetric : ∀ {first second}, prefers first second → ¬ prefers second first
  preferred : Candidate
  deferred : Candidate
  preferredInScope : scope.includes preferred
  deferredInScope : scope.includes deferred
  ordersPair : prefers preferred deferred

structure UtilityMeasure (Candidate Measure Rule : Type u) where
  rule : Rule
  specification : Specification Candidate
  measure : Candidate → Measure
  less : Measure → Measure → Prop
  asymmetric : ∀ {first second}, less first second → ¬ less second first

def UtilityMeasure.ranks
    {Candidate Measure Rule : Type u}
    (utility : UtilityMeasure Candidate Measure Rule)
    (first second : Candidate) : Prop :=
  utility.less (utility.measure second) (utility.measure first)

structure PriceSemantics
    (LedgerRecord Order Rule Item Consideration State : Type u) where
  recordedInLedger : LedgerRecord → Prop
  admittedBy : Order → Rule → LedgerRecord → Prop
  statesExchangeCondition :
    LedgerRecord → Item → Consideration → State → Prop

structure Price
    {LedgerRecord Order Rule Item Consideration State : Type u}
    (semantics : PriceSemantics LedgerRecord Order Rule Item Consideration State) where
  record : LedgerRecord
  order : Order
  rule : Rule
  item : Item
  consideration : Consideration
  state : State
  recorded : semantics.recordedInLedger record
  admitted : semantics.admittedBy order rule record
  statesCondition :
    semantics.statesExchangeCondition record item consideration state

structure InstitutionalValuation
    (Order Rule Subject Status : Type u) where
  order : Order
  rule : Rule
  subject : Subject
  status : Status
  countsAs : Order → Rule → Subject → Status → Prop
  counted : countsAs order rule subject status

inductive ValuingAgent where | evaluator deriving DecidableEq
inductive Option where | first | second deriving DecidableEq
inductive ValuationRule where | choose | measure | price | designate deriving DecidableEq
inductive LedgerRecord where | offer deriving DecidableEq
inductive ValuationOrder where | market deriving DecidableEq
inductive Item where | object deriving DecidableEq
inductive Consideration where | amount deriving DecidableEq
inductive ExchangeState where | open deriving DecidableEq
inductive ValueStatus where | favored deriving DecidableEq

def toyPreference : Preference ValuingAgent Option ValuationRule where
  agent := .evaluator
  rule := .choose
  scope := ⟨fun _ => True⟩
  prefers := fun firstOption secondOption =>
    firstOption = .first ∧ secondOption = .second
  asymmetric := by
    intro firstOption secondOption forward reverse
    simp_all
  preferred := .first
  deferred := .second
  preferredInScope := trivial
  deferredInScope := trivial
  ordersPair := by simp

def flatUtility : UtilityMeasure Option Nat ValuationRule where
  rule := .measure
  specification := {
    scope := ⟨fun _ => True⟩
    conforms := fun _ => True
    decideConformity := fun _ => true
    conformityCorrect := by simp
    conformityWithinScope := by simp
  }
  measure := fun _ => 0
  less := Nat.lt
  asymmetric := by
    intro first second forward
    exact Nat.not_lt_of_ge (Nat.le_of_lt forward)

def toyPriceSemantics : PriceSemantics LedgerRecord ValuationOrder
    ValuationRule Item Consideration ExchangeState where
  recordedInLedger := fun record => record = .offer
  admittedBy := fun order rule record =>
    order = .market ∧ rule = .price ∧ record = .offer
  statesExchangeCondition := fun record item consideration state =>
    record = .offer ∧ item = .object ∧ consideration = .amount ∧ state = .open

def toyPrice : Price toyPriceSemantics where
  record := .offer
  order := .market
  rule := .price
  item := .object
  consideration := .amount
  state := .open
  recorded := by simp [toyPriceSemantics]
  admitted := by simp [toyPriceSemantics]
  statesCondition := by simp [toyPriceSemantics]

def toyInstitutionalValuation : InstitutionalValuation
    ValuationOrder ValuationRule Item ValueStatus where
  order := .market
  rule := .designate
  subject := .object
  status := .favored
  countsAs := fun order rule subject status =>
    order = .market ∧ rule = .designate ∧
      subject = .object ∧ status = .favored
  counted := by simp

def moralWorth (_ : Item) : Prop := False
def exchangeOccurs (_ : LedgerRecord) : Prop := False
def modeledPreference (_ : ValuingAgent) (_ _ : Option) : Prop := False
def observedChoice (_ : ValuingAgent) : Option := .second

theorem preferenceDoesNotRequireUtilityRepresentation :
    toyPreference.prefers .first .second ∧
      ¬ flatUtility.ranks .first .second := by
  simp [toyPreference, UtilityMeasure.ranks, flatUtility]

theorem observedChoiceDoesNotRevealPreference :
    toyPreference.prefers .first .second ∧
      observedChoice .evaluator = .second := by
  simp [toyPreference, observedChoice]

theorem utilityMeasureDoesNotEntailPreference :
    Nonempty (UtilityMeasure Option Nat ValuationRule) ∧
      ¬ modeledPreference .evaluator .first .second := by
  exact ⟨⟨flatUtility⟩, by simp [modeledPreference]⟩

theorem priceDoesNotEntailExchangeOrMoralWorth :
    Nonempty (Price toyPriceSemantics) ∧
      ¬ exchangeOccurs toyPrice.record ∧
      ¬ moralWorth toyPrice.item := by
  exact ⟨⟨toyPrice⟩, by simp [exchangeOccurs], by simp [moralWorth]⟩

theorem institutionalValuationDoesNotEntailMoralWorth :
    Nonempty (InstitutionalValuation
      ValuationOrder ValuationRule Item ValueStatus) ∧
      ¬ moralWorth toyInstitutionalValuation.subject := by
  exact ⟨⟨toyInstitutionalValuation⟩, by simp [moralWorth]⟩

theorem profileModelIsInhabited :
    Nonempty (FactiveOperativeKnowledge
      ToyClaim ToyAgent ToyOperativeRule ToyModel ToyInterpretation ToyAction
        ToyEffect activeContext
      ToyClaim ToyAlignmentPresence ToyMeaningRule ToyFact
        toyRecordClaims toyTruthSemantics) ∧
    Nonempty (MoralPersonhoodDesignation designatingMoralOrder) ∧
    Nonempty (ConstituentSovereignty toySovereignty) ∧
    Nonempty (ConstitutedSovereignty toySovereignty) ∧
    Nonempty (BoundarySovereignty toySovereignty) ∧
    Nonempty (ExternalSovereignty toySovereignty) ∧
    Nonempty (Preference ValuingAgent Option ValuationRule) ∧
    Nonempty (UtilityMeasure Option Nat ValuationRule) ∧
    Nonempty (Price toyPriceSemantics) := by
  exact ⟨⟨accurateFactiveKnowledge⟩, ⟨deniedMoralDesignation⟩,
    ⟨constituentWitness⟩, ⟨constitutedWitness⟩, ⟨boundaryWitness⟩,
    ⟨externalWitness⟩, ⟨toyPreference⟩, ⟨flatUtility⟩, ⟨toyPrice⟩⟩

end DanielOntology.QuarantineProfiles
