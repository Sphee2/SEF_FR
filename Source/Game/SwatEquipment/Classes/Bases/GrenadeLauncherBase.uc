class GrenadeLauncherBase extends RoundBasedWeapon;

function BallisticFire(vector StartTrace, vector EndTrace)
{
    local vector ShotVector;
    local SwatProjectile Grenade;
    local vector GrenadeStart;

	// Don't spawn projectiles on a client
	if (Level.NetMode == NM_Client)
		return;

    ShotVector = Normal(EndTrace - StartTrace);

    GrenadeStart = StartTrace + ShotVector * 20.0;     //push grenade away from the camera a bit

	assertWithDescription(Ammo.ProjectileClass != None,
        "[ryan] The HK69GrenadeLauncher's Ammo.ProjectileClass was None for Ammo class " $ Ammo.class $ ".");

    Grenade = Spawn(
        Ammo.ProjectileClass,	//SpawnClass
        Owner,					//SpawnOwner
        ,						//SpawnTag
        GrenadeStart,			//SpawnLocation
        ,						//SpawnRotation
        true);					//bNoCollisionFail

    assert(Grenade != None);

	if (Grenade.IsA('SwatGrenadeProjectile'))
	{
		SwatGrenadeProjectile(Grenade).Launcher = self;
		SwatGrenadeProjectile(Grenade).bWasFired = true;
		RegisterInterestedGrenadeRegistrantWithProjectile(SwatGrenadeProjectile(Grenade));
	}

    Grenade.Velocity = ShotVector * MuzzleVelocity;
}

function EquipmentSlot GetFiredGrenadeEquipmentSlot()
{
	if(Ammo == None)
	{
		return Slot_Invalid;
	}
	// HACK here
	else if(Ammo.IsA('HK69GL_CSGasGrenadeAmmo'))
	{
		return Slot_CSGasGrenade;
	}
	else if(Ammo.IsA('HK69GL_FlashbangGrenadeAmmo'))
	{
		return Slot_Flashbang;
	}
	else if(Ammo.IsA('HK69GL_StingerGrenadeAmmo'))
	{
		return Slot_StingGrenade;
	}
	else
	{
		return Slot_PrimaryWeapon;
	}
}


simulated function OnReloadMagDump()
{
local SpentMagDrop SpentMag;

if ( MagazineSize == 1) //quick hack for HK69... Arwen doesnt need it
{
	if ( Level.NetMode == NM_Standalone )
		{
			if ( inFirstPersonView() )
			{	
				SpentMag = Owner.Spawn( class'SpentMagDrop', Owner,
				,                   //tag: default
				GetHands().GetBoneCoords('GripRHand').Origin, //translation,
				GetHands().GetBoneRotation('GripRHand'), //rotTransl,
				true);              //bNoCollisionFail
			}
			else
			{
				SpentMag = Owner.Spawn( class'SpentMagDrop', Owner,
				,                   //tag: default
				ThirdPersonModel.Location, //translation,
				ThirdPersonModel.Rotation, //rotTransl,
				true);              //bNoCollisionFail
			}
		}
		else
		{
			
			if ( Level.NetMode != NM_DedicatedServer ) //we dont need that on server
			{
			SpentMag = Owner.Spawn( class'SpentMagDrop', Owner,
			,                   //tag: default
			Owner.GetBoneCoords('GripRHand').Origin, 
			Owner.GetBoneRotation('GripRHand'),
			true);              //bNoCollisionFail
			}
		}
		
		SpentMag.SetInitialVelocity(Vect(0,0,0));	
}
	
}




defaultproperties
{
  bPenetratesDoors=false
}
