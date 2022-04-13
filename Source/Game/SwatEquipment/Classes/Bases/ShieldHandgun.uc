///////////////////////////////////////////////////////////////////////////////
class ShieldHandgun extends Handgun;


///////////////////////////////////////////////////////////////////////////////
var config bool HasShield;
var ShieldEquip ShieldModel_TP; //thirdperson model

var(Viewmodel) config class<HandheldEquipmentModel> ShieldModel;
var HandheldEquipmentModel ShieldModel_FP;
///////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////

simulated function EquippedHook()
{
	Super.EquippedHook();
	
	if(HasShield)
	{		
		ShieldModel_TP.Equip();
		ShieldModel_TP.Show();
		
		if ( Pawn(Owner).GetHands() != None )
		{
			ShieldModel_FP.Show();
			ShieldModel_FP.OnEquipKeyFrame();
		}
	}
}

simulated function UnequippedHook()
{
	Super.UnequippedHook();
	
	if(HasShield)
	{
		ShieldModel_TP.Unequip();
		ShieldModel_TP.Show();
		
		if ( Pawn(Owner).GetHands() != None )
		{
		ShieldModel_FP.Hide();
		ShieldModel_FP.OnUnequipKeyFrame();
		}
	}
}

simulated function CreateModels()
{
	Super.CreateModels();
	
	//SHIELD
	if(HasShield)
	{	

		//humans only
		if ( Pawn(Owner).GetHands() != None && Level.NetMode != NM_DedicatedServer)
		{
		ShieldModel_FP= Spawn ( ShieldModel, Pawn(Owner).GetHands() , , , , true);
		
		ShieldModel_FP.bNeedPostRenderCallback = true;
		ShieldModel_FP.Show();
		ShieldModel_FP.OnUnEquipKeyFrame();
		}
		
		ShieldModel_TP= Spawn ( class'ShieldEquip', Owner , , , , true);
		
		ShieldModel_TP.Unequip();
		ShieldModel_TP.Show();
		ShieldModel_TP.SetCollision(true, false, false);
	}
		
}


/*
simulated function OnHolderDesiredFlashlightStateChanged()
{
	local Material FlashlightMaterial;
	local bool PawnWantsFlashlightOn;
	local String FlashlightTextureName;
	
	Super.OnHolderDesiredFlashlightStateChanged();
	
	//SHIELD
	if(HasShield)
	{	
	    PawnWantsFlashlightOn = ICanToggleWeaponFlashlight(Owner).GetDesiredFlashlightState();
		
		// change texture on 3rd person model
	    if (! InFirstPersonView() )
	    {
			if (PawnWantsFlashlightOn)
			{
		    FlashlightTextureName = "SWATgearTex.FlashlightLensOnShader";
			}
			else
			{
		    FlashlightTextureName = "SWATgearTex.FlashlightLensOff";
			}
			
			if (PawnWantsFlashlightOn) // turn on the glow texture on the flashlight bulb
			{
				FlashlightMaterial = Material(DynamicLoadObject( FlashlightTextureName, class'Material'));
				AssertWithDescription(FlashlightMaterial != None, "[ckline]: Couldn't DLO flashlight lens texture "$FlashlightTextureName);
			}
			else // turn off the glow texture
			{
				// hack.. force the skin to None so that GetCurrentMaterial will pull from
				// the default materials array instead of the skin
				ShieldModel_TP.Skins[1] = None;

				FlashlightMaterial = ShieldModel_TP.GetCurrentMaterial(3);
			}

			ShieldModel_TP.Skins[1] = FlashlightMaterial;
	    }
		
	}
	
}

simulated function InitFlashlight()
{
	Super.InitFlashlight();
	//SHIELD
	if(HasShield)
	{
		Owner.DetachFromBone(FlashlightDynamicLight);
		Owner.DetachFromBone(FlashlightReferenceActor);
		
		// Set up flashlight for first person model if it is weapon is held by the player's pawn.
		if (InFirstPersonView())
		{
			Owner.AttachToBone(FlashlightDynamicLight,ShieldModel_FP.AttachmentBone);
			Owner.AttachToBone(FlashlightReferenceActor,ShieldModel_FP.AttachmentBone);
		}
		else
		{
			Owner.AttachToBone(FlashlightDynamicLight,ShieldModel_TP.AttachmentBone);
			Owner.AttachToBone(FlashlightReferenceActor,ShieldModel_TP.AttachmentBone);
		}
	}
	
	
	
}
*/
	


defaultproperties
{
	HasShield=false
}