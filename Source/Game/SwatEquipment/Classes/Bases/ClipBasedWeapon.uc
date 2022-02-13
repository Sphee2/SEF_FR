class ClipBasedWeapon extends Engine.SwatWeapon;

var SpentMagDrop SpentMag; //static mesh of the spent mag to be dropped


//simulated function UnEquippedHook();  //TMC do we want to blank the HUD's ammo count?

simulated function OnReloadMagDump() //overrided function from FiredWeapon
{	
	log("ClipBasedWeapon::OnReloadMagDump()");
	if (IsInState('BeingReloadedQuick'))
	{
		
		//make clip unusable!
		Ammo.SetClip(Ammo.GetCurrentClip(), 0 );
		
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
			SpentMag = Owner.Spawn( class'SpentMagDrop', Owner,
			,                   //tag: default
			Owner.GetBoneCoords('GripRHand').Origin, 
			Owner.GetBoneRotation('GripRHand'),
			true);              //bNoCollisionFail
		}
		
		SpentMag.SetInitialVelocity(Vect(0,0,0));	
	}
}





