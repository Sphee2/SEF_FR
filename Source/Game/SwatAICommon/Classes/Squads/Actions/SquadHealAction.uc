///////////////////////////////////////////////////////////////////////////////
// SquadShareEquipmentAction.uc - SquadShareEquipmentAction class
// this action is used to organize the Officer's Share Equipment behavior

class SquadHealAction extends OfficerSquadAction;
import enum EquipmentSlot from Engine.HandheldEquipment;
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
//
// Variables

// copied from our goal
var(parameters) EquipmentSlot Slot;
var(parameters) Pawn InjuredTarget;

// determined during state code
var private ISwatOfficer GivingOfficer;
var private Pawn GivingPawn;

///////////////////////////////////////////////////////////////////////////////
//
// Tyrion callbacks

function goalNotAchievedCB( AI_Goal goal, AI_Action child, ACT_ErrorCodes errorCode )
{
	super.goalNotAchievedCB(goal, child, errorCode);

	// if any of our goals fail, we succeed so we don't get reposted!
	if (goal.IsA('HealGoal'))
	{
		instantSucceed();
	}
}

///////////////////////////////////////////////////////////////////////////////
//
// State code

// Find which officer is the closest to the player
function DetermineGivingOfficer()
{
	GivingPawn = GetClosestOfficerWithEquipmentTo(Slot_Bandage, CommandOrigin, true);
	GivingOfficer = ISwatOfficer(GivingPawn);
}

// Tell the officer to heal someone
latent function HealPawn()
{
	local HealGoal CurrentGoal;
	log("HealPawn() Target:" $ InjuredTarget.name );
	
	CurrentGoal = new class'HealGoal'(AI_Resource(GivingPawn.characterAI), InjuredTarget );
	CurrentGoal.AddRef();
	CurrentGoal.PostGoal(self);
	WaitForGoal(CurrentGoal);
	CurrentGoal.Release();
}

// Tell the officer to say "Roger" etc
function TriggerSpeech()
{
	GivingOfficer.GetOfficerSpeechManagerAction().TriggerGenericOrderReplySpeech();
}

state Running
{
Begin:
	DetermineGivingOfficer();
	TriggerSpeech();
	WaitForZulu();
	HealPawn();
	succeed();
}

///////////////////////////////////////////////////////////////////////////////
defaultproperties
{
	satisfiesGoal = class'SquadHealGoal'
}
