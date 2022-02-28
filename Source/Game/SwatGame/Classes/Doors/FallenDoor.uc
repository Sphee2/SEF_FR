class FallenDoor extends RWOSupport.ReactiveStaticMesh;

var vector CurrentVelocity;
var vector CurrentAngular;
var Rotator BackwardVectorOffset;

var int FallCount;

simulated event FellOutOfWorld(eKillZType KillType)
{
	local Vector NewLocation;
	local Vector NewVelocity;

	log("---FallenDoor "$self$" fell out of world. Its owner was "$Owner);
	if(FallCount >= 6)
	{
		Super.FellOutOfWorld(KillType);
	}

	// Try giving it a nudge upwards in a random direction depending on the current FallCount and set its havok velocity to 0
	NewLocation = Location;

	if(FallCount < 6)
	{
		SetPhysics(PHYS_None);
		NewLocation.Z = Location.Z + 2.0;
	}

	SetLocation(NewLocation);
	SetInitialVelocity(NewVelocity);
	FallCount++;
}

simulated function SetInitialVelocity(vector Velocity)
{
  CurrentVelocity = Velocity;
  HavokSetLinearVelocity(CurrentVelocity);
}

auto simulated state Dropped
{

	simulated function ApplyHavok()
	{
		if (Role != ROLE_Authority && CurrentVelocity != Vect(0,0,0))
		{
			HavokSetLinearVelocity(CurrentVelocity);
			HavokSetAngularVelocity(CurrentAngular);
		}
	}

Begin:
	ApplyHavok();
}

simulated function getImpulse(bool DirectionLeft)
{
	if ( DirectionLeft )
		HavokImpartCOMImpulse( ( Location >> (Rotation - BackwardVectorOffset ) )*10);
	else
		HavokImpartCOMImpulse( ( Location >> (Rotation  ) )*10);
	
}


function ChangeDoorMesh(StaticMesh SM)
{
	SetStaticMesh(SM);
}

defaultproperties
{
    StaticMesh=StaticMesh'Doors_sm.TestDoorKarma78Wide'
	BackwardVectorOffset=(Yaw=16384)
	Physics=PHYS_Havok
	bNoDelete=false
	bAlwaysRelevant=false
	bUpdateSimulatedPosition=false
    hkActive=true
	hkMass=75000.0
	hkFriction=1.0
	hkRestitution=0.0
	hkLinearDamping=0.0
	hkAngularDamping=0.05
	hkStabilizedInertia=true
	//CollisionHeight=5.0
	//CollisionRadius=5.0
	
	bCollideWorld=true
	
	hkKeyframed=false

	RemoteRole = ROLE_SimulatedProxy
}
