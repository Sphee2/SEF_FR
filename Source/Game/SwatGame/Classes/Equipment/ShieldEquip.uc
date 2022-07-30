class ShieldEquip extends SimpleEquipment
		implements  Engine.IAmShield ,Engine.IHaveSkeletalRegions;
		
import enum ESkeletalRegion from Actor;		
					
enum ProtectionLevel
{
  Level_0,            // Doesn't stop anything (AKA gas mask, night vision, no armor)
  Level_1,            // Stops .380 ACP FMJ (AKA Nothing)
  Level_2a,           // Stops .45 from pistols (AKA Glock, M1911)
  Level_2,            // Stops 9mm and .45 from SMGs (AKA MP5, UMP)
  Level_3a,           // Stops .357 and remaining pistol calibers (AKA Python, Desert Eagle)
  Level_3,            // Stops rifle calibers up to .308 (AKA 5.56 JHP, 7.62 FMJ)
  Level_3X,           // Stops rifle calibers and armor piercing calibers up to .308 (AKA 5.56 FMJ, 7.62 AP)
  Level_4             // Stops .308 AP (AKA Nothing yet)
};


var() name UnequipSocket;
var(ArmorPenetration) config ProtectionLevel ArmorProtection "What level of armor I represent?";
var (ArmorPenetration) int ProtectionType "Internal measure to know the BulletClass";
var protected int Health;
var(ArmorPenetration) float MomentumToPenetrate "A bullet will penetrate this material if-and-only-if it impacts with more than this Momentum.  A bullet's Momentum is its Mass times the MuzzleVelocity of the FiredWeapon from which it was fired, minus any Momentum that the bullet has already lost (due to prior impact(s)).  The bullet will impart 10% of its Momentum to a KActor it hits if it penetrates the KActor, or 100% of its Momentum if it doesn't penetrate the KActor.";

var protected int Damage_level;


replication
{

/*
	 // replicated functions sent to server by owning client
    reliable if( Role < ROLE_Authority ) //server-functions
		ServerShieldTakeDamage;
*/

	// replicated functions sent to client by server
    reliable if( Role == ROLE_Authority ) //client-functions
		ClientShieldTakeDamage;
	
}


simulated function Equip()
{	
	//log("Shield TP equip");
	Pawn(Owner).AttachToBone(self, AttachmentBone);
	
}

simulated function UnEquip()
{
			
	//log("Shield TP Unequip");
	Pawn(Owner).DetachFromBone(self);
	Pawn(Owner).AttachToBone(self, UnequipSocket);

}

simulated function int GetProtectionType() 
{			
	switch(ArmorProtection) 
		{				
		case Level_0:
			ProtectionType = 1;
			break;
		case Level_1:
			ProtectionType = 2;
			break;
		case Level_2a:
			ProtectionType = 3;
			break;
		case Level_2:
			ProtectionType = 4;
			break;
		case Level_3a:
			ProtectionType = 5;
			break;
		case Level_3:
			ProtectionType = 6;
			break;
		case Level_3X:
			ProtectionType = 7;
			break;		
		case Level_4:
			ProtectionType = 8;
			break;
		default:
			ProtectionType = 1;
		}
	return ProtectionType;
}

simulated function int GetProtectionLevel() 
 {
   return ArmorProtection;
 }

simulated function float GetMtP() {
  return MomentumToPenetrate;
}



simulated function ClientShieldTakeDamage( int DamageS )
{
			
		Health = Health - DamageS;
		if ( Health < 888 && Health  >= 555 && Damage_level == 0 )
		{
			//glass 1st damage state
			Damage_level=1;
			IShieldHandgun(Pawn(Owner).GetActiveItem()).SetShieldDamage(damage_level);
		}
		else if ( Health < 555 && Damage_level == 1 )
		{
			//glass 2nd damage state
			Damage_level=2;	
			IShieldHandgun(Pawn(Owner).GetActiveItem()).SetShieldDamage(damage_level);
		}
		else if ( Health < 333 && Damage_level == 2 )
		{
			//glass 3rd damage state
			Damage_level=3;	
			IShieldHandgun(Pawn(Owner).GetActiveItem()).SetShieldDamage(damage_level);
		}
		
			
		SwatPlayer(Owner).ApplyHitEffect(1.0, 1.0, 1.0);
		
		log("ClientShieldTakeDamage " $ self.name $ " Owner " $ Owner.name $ " got hit - health " $ Health $ " Damage level" $ damage_level);
	
	
}

/*
function ServerShieldTakeDamage( int DamageS, ShieldEquip SE)
{
	local ShieldEquip SD;
	
	if ( Level.NetMode == NM_DedicatedServer || Level.NetMode == NM_ListenServer)
	{
	
	ForEach DynamicActors(class'ShieldEquip',SD)
	{
		if ( SE == SD )
		{	
			log("ServerShieldTakeDamage call Shield " $ SD.name $ " Damage " $ DamageS $ " .");
	
			SD.ClientShieldTakeDamage(DamageS);
			return;
		}
	}
	
	}
}
*/


simulated function ShieldTakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
		
	Health = Health - Damage;
	
	if ( Health < 888 && Health  >= 555 && Damage_level == 0 )
	{
		//glass 1st damage state
		Damage_level=1;
		IShieldHandgun(Pawn(Owner).GetActiveItem()).SetShieldDamage(damage_level);
	}
	else if ( Health < 555 && Damage_level == 1 )
	{
		//glass 2nd damage state
		Damage_level=2;	
		IShieldHandgun(Pawn(Owner).GetActiveItem()).SetShieldDamage(damage_level);
	}
	else if ( Health < 333 && Damage_level == 2 )
	{
		//glass 3rd damage state
		Damage_level=3;	
		IShieldHandgun(Pawn(Owner).GetActiveItem()).SetShieldDamage(damage_level);
	}
	
	log("ShieldTakeDamage " $ self.name $ " Owner " $ Owner.name $ " got hit - health " $ Health $ " Damage level" $ damage_level);

		SwatPlayer(Owner).ApplyHitEffect(1.0, 1.0, 1.0);
	
	
}

// Notification that we were hit
simulated function OnSkeletalRegionHit(ESkeletalRegion RegionHit, vector HitLocation, vector HitNormal, int Damage, class<DamageType> DamageType, Actor Instigator)
{
    log("ShieldEquip::OnSkeletalRegionHit() Region:" $RegionHit );    
}

simulated function int GetShieldState()
{
	return Health;
}

defaultproperties
{
 
	//this class defaults
	DrawType=DT_Mesh
	Mesh=SkeletalMesh'Shield_model.Shield_mesh_2'
	//DrawType=DT_StaticMesh
	//StaticMesh=StaticMesh'Shield_static.Shield_static'
	bActorShadows=true
	
	AttachmentBone=Shield
	UnequipSocket=ShieldUnequip
	
	bUseCollisionBoneBoundingBox = false
	bCollideActors=true
	bCollideWorld=true
	bProjTarget=true
	
	ArmorProtection=Level_3
	Health=1000
	MomentumToPenetrate=400.0
}