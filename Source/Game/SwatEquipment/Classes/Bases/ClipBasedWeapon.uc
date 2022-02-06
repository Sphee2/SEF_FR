class ClipBasedWeapon extends Engine.SwatWeapon;

var SpentMagDrop SpentMag; //static mesh of the spent mag to be dropped
var config StaticMesh SpentMagMesh;

//simulated function UnEquippedHook();  //TMC do we want to blank the HUD's ammo count?

simulated function OnReloadMagDump() //overrided function from FiredWeapon
{
	
	log("ClipBasedWeapon::OnReloadMagDump()");
	if (IsInState('BeingReloadedQuick'))
	{
		
		//make clip unusable!
		Ammo.SetClip(Ammo.GetCurrentClip(), 0 );
		
		SpentMag = Owner.Spawn( class'SpentMagDrop', Owner,
            ,                   //tag: default
            Owner.GetBoneCoords('GripRHand').Origin,
            ,                   //SpawnRotation: default
            true);              //bNoCollisionFail
			
			SpentMag.SetStaticMesh(SpentMagMesh);

		SpentMag.SetInitialVelocity(Vect(0,0,0));
		
	}
}


defaultproperties
{
	SpentMagMesh=StaticMesh'SwatGear_sm.SMG_mp5clip' //to be overriden by weapon's config!
}
