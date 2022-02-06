class SpentMagDrop extends RWOSupport.ReactiveStaticMesh
    config(SwatEquipment);

var vector CurrentVelocity;
var vector CurrentAngular;

var int FallCount;

simulated event FellOutOfWorld(eKillZType KillType)
{
	local Vector NewLocation;
	local Vector NewVelocity;

	log("---LightstickProjectile "$self$" fell out of world. Its owner was "$Owner);
	if(FallCount >= 6)
	{
		Super.FellOutOfWorld(KillType);
	}

	// Try giving it a nudge upwards in a random direction depending on the current FallCount and set its havok velocity to 0
	NewLocation = Location;

	if(FallCount == 0)
	{
		NewLocation.Z = Location.Z + 2.0;
	}
	else if(FallCount == 1)
	{
		NewLocation.Z = Location.Z - 2.0;
	}
	else if(FallCount == 2)
	{
		NewLocation.X = Location.X + 2.0;
	}
	else if(FallCount == 3)
	{
		NewLocation.X = Location.X - 2.0;
	}
	else if(FallCount == 4)
	{
		NewLocation.Y = Location.Y + 2.0;
	}
	else if(FallCount == 5)
	{
		NewLocation.Y = Location.Y - 2.0;
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

defaultproperties
{
    StaticMesh=StaticMesh'SwatGear_sm.SMG_mp5clip'
	Physics=PHYS_Havok
	bNoDelete=false
	bAlwaysRelevant=false
	bUpdateSimulatedPosition=false
    hkActive=true
	hkMass=0.05
	hkFriction=0.1
	hkRestitution=0.3
	hkStabilizedInertia=true
	CollisionHeight=2
	CollisionRadius=2

	RemoteRole = ROLE_SimulatedProxy
}
