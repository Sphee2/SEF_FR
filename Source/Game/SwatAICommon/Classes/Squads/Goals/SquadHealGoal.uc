///////////////////////////////////////////////////////////////////////////////
// SquadShareEquipmentGoal.uc - SquadShareEquipmentGoal class
// this goal is used when ordering an officer to share a piece of equipment with the player

class SquadHealGoal extends SquadCommandGoal;
import enum EquipmentSlot from Engine.HandheldEquipment;
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
//
// Variables

// copied to our action
var(parameters) EquipmentSlot Slot;
var(parameters) Pawn InjuredTarget;

///////////////////////////////////////////////////////////////////////////////
//
// Constructors

// Use this constructor
overloaded function construct( AI_Resource r, Pawn inInjuredTarget, vector inCommandOrigin )
{
	super.construct(r, inInjuredTarget, inCommandOrigin);
	
	InjuredTarget = inInjuredTarget;
	log("New SquadHealGoal posted. Target:" $ InjuredTarget.name );
	Slot = Slot_Bandage;
}

///////////////////////////////////////////////////////////////////////////////
defaultproperties
{
	goalName = "SquadHealGoal"
	bRepostElementGoalOnSubElementSquad = true
}
