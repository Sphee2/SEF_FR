class SpentMagDrop extends RWOSupport.ReactiveStaticMesh
    config(SwatEquipment);

var vector CurrentVelocity;
var vector CurrentAngular;

var int FallCount;

simulated event FellOutOfWorld(eKillZType KillType)
{
	local Vector NewLocation;
	local Vector NewVelocity;

	log("---SpentMagDrop "$self$" fell out of world. Its owner was "$Owner);
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

simulated function PostNetBeginPlay()
{
	Super.PostNetBeginPlay();

	ChangeMagMesh();
}

simulated function ChangeMagMesh()
{
	local SwatWeapon SW;
	
	//the weapon we are linked with
	SW = SwatWeapon(Pawn(Owner).GetActiveItem());
	assert(SW != None);
	
	//change the mesh
	SetStaticMesh(SW.SpentmagMesh);
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
	CollisionHeight=5.0
	CollisionRadius=5.0
	
	bCollideWorld=true
	
	hkKeyframed=false
	hkForceUpright=HKOC_Free
	hkForceUprightStrength = 0.3
	hkForceUprightDamping = 0.9
	

	RemoteRole = ROLE_DumbProxy
}
