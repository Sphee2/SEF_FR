///////////////////////////////////////////////////////////////////////////////
// RestrainedFloorAction.uc - CowerAction class

class RestrainedFloorAction extends LookAtOfficersActionBase;
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
//
// Variables
var(parameters)	Pawn	Restrainer;	// pawn that we will be working with

// config variables
const kPostRestrainedGoalPriority      = 94;

///////////////////////////////////////////////////////////////////////////////
//
// State code


latent function PlayFloorAnimation()
{
	local int IdleChannel;
	
	IdleChannel = m_Pawn.AnimPlaySpecial('CuffedFloor', 0.2);    
	
	m_Pawn.FinishAnim(IdleChannel);
	
	ISwatAI(m_Pawn).SetIdleCategory('RestrainedFloorFidget');
	
	// swap in the restrained anim set
	ISwatAI(m_Pawn).SwapInRestrainedFloorAnimSet();
	
	m_Pawn.ChangeAnimation();
	
	StopLookingAtOfficers();
	
	while (class'Pawn'.static.checkConscious(m_Pawn))
	{
		sleep(1.0);
		// don't move while being restrained
		m_Pawn.DisableCollisionAvoidance();
	}
}


state Running
{
 Begin:
	 
	// don't move while being restrained
	m_Pawn.DisableCollisionAvoidance();
	
	
	if (achievingGoal.priority != kPostRestrainedGoalPriority)
	{
		// set the priority lower now so that any higher priority goal 
		// (incapacitation, stunned, injury) will take over
		achievingGoal.changePriority(kPostRestrainedGoalPriority);
		ClearDummyGoals();
	}
	 
	while (! resource.requiredResourcesAvailable(achievingGoal.priority, achievingGoal.priority))
		yield();

	useResources(class'AI_Resource'.const.RU_ARMS | class'AI_Resource'.const.RU_LEGS);

	PlayFloorAnimation();
	
	succeed();
	
}

///////////////////////////////////////////////////////////////////////////////
defaultproperties
{
    satisfiesGoal = class'RestrainedFloorGoal'
}
