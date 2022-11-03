///////////////////////////////////////////////////////////////////////////////
// CheckCornerAction.uc - CheckCornerAction class
// The Action that causes the Officers to mirror a corner

class CheckCornerAction extends SwatCharacterAction;
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
//
// Variables

// copied to our action
var(parameters) Actor					TargetMirrorPoint;
var(parameters) vector					CommandOrigin;

// behaviors we use
var private MoveToLocationGoal			CurrentMoveToLocationGoal;
var private RotateTowardRotationGoal	CurrentRotateTowardRotationGoal;
var private CoverGoal                     CurrentCoverGoal;

// direction we mirror in
var private Rotator						MirrorCornerRotation;
var private vector MirrorToPoint;

///////////////////////////////////////////////////////////////////////////////
//
// Cleanup

function cleanup()
{
	super.cleanup();

	if (CurrentMoveToLocationGoal != None)
	{
		CurrentMoveToLocationGoal.Release();
		CurrentMoveToLocationGoal = None;
	}

	if (CurrentRotateTowardRotationGoal != None)
	{
		CurrentRotateTowardRotationGoal.Release();
		CurrentRotateTowardRotationGoal = None;
	}
	
	if (CurrentCoverGoal != None)
	{
		CurrentCoverGoal.Release();
		CurrentCoverGoal = None;
	}

	// unlock aim
	ISwatAI(m_Pawn).UnlockAim();

	// make sure we re-enable collision avoidance
	m_Pawn.EnableCollisionAvoidance();
}

function goalNotAchievedCB( AI_Goal goal, AI_Action child, ACT_ErrorCodes errorCode )
{
	super.goalNotAchievedCB(goal, child, errorCode);

	if (m_Pawn.logTyrion)
		log(goal.name $ " was not achieved.  failing.");

		ISwatOfficer(m_Pawn).GetOfficerSpeechManagerAction().TriggerCouldntCompleteMoveSpeech();


	// just fail
	InstantFail(errorCode);
}

///////////////////////////////////////////////////////////////////////////////
//
// State Code

latent function MoveToMirrorPoint()
{
	// move the officer to the location
	CurrentMoveToLocationGoal = new class'MoveToLocationGoal'(movementResource(), achievingGoal.priority, ( IMirrorPoint(TargetMirrorPoint).GetMirroringFromPoint() + IMirrorPoint(TargetMirrorPoint).GetMirroringToPoint()) /2 );
	assert(CurrentMoveToLocationGoal != None);
	CurrentMoveToLocationGoal.AddRef();

	CurrentMoveToLocationGoal.SetRotateTowardsPointsDuringMovement(true);
	CurrentMoveToLocationGoal.SetShouldSucceedWhenDestinationBlocked(true);

	CurrentMoveToLocationGoal.PostGoal(self);
	WaitForGoal(CurrentMoveToLocationGoal);
	CurrentMoveToLocationGoal.unPostGoal(self);

	CurrentMoveToLocationGoal.Release();
	CurrentMoveToLocationGoal = None;
}

latent function RotateToMirrorCorner()
{

	MirrorToPoint        = IMirrorPoint(TargetMirrorPoint).GetMirroringToPoint();
	MirrorCornerRotation = rotator(TargetMirrorPoint.Location - m_Pawn.Location);


	//debug
	//m_Pawn.Level.GetLocalPlayerController().myHUD.AddDebugLine(IMirrorPoint(TargetMirrorPoint).GetMirroringFromPoint(), IMirrorPoint(TargetMirrorPoint).GetMirroringToPoint(), class'Engine.Canvas'.Static.MakeColor(255,200,200));

	CurrentRotateTowardRotationGoal = new class'RotateTowardRotationGoal'(movementResource(), achievingGoal.priority, MirrorCornerRotation);
	assert(CurrentRotateTowardRotationGoal != None);
	CurrentRotateTowardRotationGoal.AddRef();

	CurrentRotateTowardRotationGoal.postGoal(self);
	WaitForGoal(CurrentRotateTowardRotationGoal);
	CurrentRotateTowardRotationGoal.unPostGoal(self);

	CurrentRotateTowardRotationGoal.Release();
	CurrentRotateTowardRotationGoal = None;

	ISwatAI(m_Pawn).AimToRotation(MirrorCornerRotation);
	ISwatAI(m_Pawn).LockAim();
	ISwatAI(m_Pawn).AnimSnapBaseToAim();
}

latent function CoverAroundCorner()
{
	CurrentCoverGoal = new class'CoverGoal'(AI_Resource(m_Pawn.CharacterAI), IMirrorPoint(TargetMirrorPoint).GetMirroringToPoint(), m_pawn.Location, IMirrorPoint(TargetMirrorPoint).GetMirroringFromPoint(), true);
	CurrentCoverGoal.AddRef();
	CurrentCoverGoal.postGoal(self);
}




state Running
{
Begin:
	
	useResources(class'AI_Resource'.const.RU_ARMS);


	MoveToMirrorPoint();

	// disable collision avoidance while we're mirroring
	m_Pawn.DisableCollisionAvoidance();

	
	RotateToMirrorCorner();

	useResources(class'AI_Resource'.const.RU_LEGS);

	clearDummyWeaponGoal();
	//MirrorAroundCorner();
	
	m_Pawn.ShouldCrouch(true);
	
	CoverAroundCorner();
	
	succeed();
}

///////////////////////////////////////////////////////////////////////////////
defaultproperties
{
    satisfiesGoal = class'CheckCornerGoal'
}
