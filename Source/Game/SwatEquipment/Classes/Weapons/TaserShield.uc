class TaserShield extends Taser;

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
		
		if ( Pawn(Owner).GetHands() != None)
		{
		ShieldModel_FP.Hide();
		ShieldModel_FP.OnUnequipKeyFrame();
		}
	}
}

simulated function CreateModels()
{
	local int i;
	
	Super.CreateModels();
	
	//SHIELD
	if(HasShield)
	{	
		
		for(i=0; i<=Pawn(Owner).Attached.length ; i++)
		{
			if (Pawn(Owner).Attached[i].isa('Shieldequip'))
			{
				Pawn(Owner).Attached[i].Destroy(); //prevent doubling shields - happens in training cabinet mostly
			}
		}
		
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

simulated function HandheldEquipmentModel GetShieldModelFP()
{
	return ShieldModel_FP;
}

simulated function SetShieldDamage(int damage)
{

	if (damage == 1)	
	{
		
		ShieldModel_TP.Skins[0]= Material(DynamicLoadObject( "Shield_tex.Shield_glass_1", class'Material'));
		ShieldModel_FP.Skins[0]=Material(DynamicLoadObject( "Shield_tex.Shield_glass_1", class'Material'));
	
	}
	else if (damage == 2)
	{
		ShieldModel_TP.Skins[0]= Material(DynamicLoadObject( "Shield_tex.Shield_glass_2", class'Material'));
		ShieldModel_FP.Skins[0]=Material(DynamicLoadObject( "Shield_tex.Shield_glass_2", class'Material'));
	}
	else if (damage == 3)
	{
		ShieldModel_TP.Skins[0]= Material(DynamicLoadObject( "Shield_tex.Shield_glass_3", class'Material'));
		ShieldModel_FP.Skins[0]=Material(DynamicLoadObject( "Shield_tex.Shield_glass_3", class'Material'));
	}
}

/*
simulated function OnHolderDesiredFlashlightStateChanged()
{
	local Material FlashlightMaterial;
	local String FlashlightTextureName;
	local bool PawnWantsFlashlightOn;
	
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
				ShieldModel_TP.Skins[2] = None;

				FlashlightMaterial = ShieldModel_TP.GetCurrentMaterial(2);
			}

			ShieldModel_TP.Skins[2] = FlashlightMaterial;
	    }
		
		if (! InFirstPersonView() )
	    {
			if (PawnWantsFlashlightOn)
			{
				Owner.DetachFromBone(FlashlightDynamicLight);
				Owner.AttachToBone(FlashlightDynamicLight,ShieldModel_TP.AttachmentBone);
			}
			
		}
		else
		{
			if (PawnWantsFlashlightOn)
			{
			Pawn(Owner).GetHands().DetachFromBone(FlashlightDynamicLight);
			Pawn(Owner).GetHands().AttachToBone(FlashlightDynamicLight,ShieldModel_FP.AttachmentBone);
			}
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
/*
//FiredWeapon function override
simulated function UpdateFlashlightLighting(optional float dTime)
{
#if ENABLE_FLASHLIGHT_PROJECTION_VISIBILITY_TESTING
    local bool bIsFlashlightProjectionVisible;
#endif
    local HandheldEquipmentModel WeaponModel;
    local Vector  PositionOffset;
    local Rotator RotationOffset, rayDirection;
	local Vector  hitLocation, hitNormal;
	local Vector  traceStart, traceEnd, PointLightPos, delta;
	local Actor   hitActor;
	local float   oldDistance, newDistance;
	//local float    maxDistance, angle;
	//local int     ind;

    if( Level.NetMode == NM_DedicatedServer )
        return;

#if ENABLE_FLASHLIGHT_PROJECTION_VISIBILITY_TESTING
    bIsFlashlightProjectionVisible = IsFlashlightProjectionVisible();
    // If IsFlashlightProjectionVisible() returned false, determine if we're
    // past the last successfully visible timeout
    if (!bIsFlashlightProjectionVisible
    && (Level.TimeSeconds - FlashlightProjection_LastSuccessfulTestTime) < kFlashlightProjection_FailureTimeout)
    {
        bIsFlashlightProjectionVisible = true;
    }

    if (FlashlightProjection_IsInitializing)
    {
        // Snap directly to 0 or 1 if FlashlightProjection_IsInitializing is true.
        if (bIsFlashlightProjectionVisible)
            FlashlightProjection_CurrentBrightnessAlpha = 1.0;
        else
            FlashlightProjection_CurrentBrightnessAlpha = 0.0;
    }
    else
    {
        // Lerp the current alpha brightness toward 0 or 1, depending on
        // bIsFlashlightProjectionVisible.
        if (bIsFlashlightProjectionVisible)
            FlashlightProjection_CurrentBrightnessAlpha += dTime / kFlashlightProjection_BrightnessAlphaLerpTime;
        else
            FlashlightProjection_CurrentBrightnessAlpha -= dTime / kFlashlightProjection_BrightnessAlphaLerpTime;
        FlashlightProjection_CurrentBrightnessAlpha = FClamp(FlashlightProjection_CurrentBrightnessAlpha, 0.0, 1.0);
    }
#endif

	// The stuff below is only done for the pointlight-to-spotlight modeling
	if (FlashlightUseFancyLights == 1)
    {
#if ENABLE_FLASHLIGHT_PROJECTION_VISIBILITY_TESTING
        FlashlightDynamicLight.LightBrightness = BaseFlashlightBrightness * FlashlightProjection_CurrentBrightnessAlpha;
#endif
		return;
	}

    // Set up flashlight for first person model if it is weapon is held by the player's pawn.
    if (InFirstPersonView())
    {
        if (FirstPersonModel == None)
        {
            assertWithDescription(false, "[henry] Can't update flashlight for "$self$", FirstPersonModel is None");
        }
		WeaponModel    = FirstPersonModel;
		PositionOffset = FlashlightPosition_1stPerson;
		RotationOffset = FlashlightRotation_1stPerson;
    }
    else // todo: handle 3rd person flashlight, including when controller changes
    {
        if (ThirdPersonModel == None)
        {
		    assertWithDescription(false, "[henry] Can't update flashlight for "$self$", ThirdPersonModel is None");
        }
        WeaponModel    = ThirdPersonModel;
		PositionOffset = FlashlightPosition_3rdPerson;
		RotationOffset = FlashlightRotation_3rdPerson;
    }

	traceStart   = FlashlightReferenceActor.Location;
	rayDirection = FlashlightReferenceActor.Rotation;
	// the first person uses a much smaller max distance to avoid popping when
	// the light aims from a distant wall to a nearby object.
    if (InFirstPersonView())
		traceEnd = traceStart + Vector(rayDirection) * FlashlightFirstPersonDistance;
	else
		traceEnd = traceStart + Vector(rayDirection) * MaxFlashlightDistance;

	hitActor = Trace(hitLocation, hitNormal, traceEnd, traceStart, true, , , , True);

	if (hitActor == None)
	{
		hitLocation = traceEnd;
	}

	if (DebugDrawFlashlightDir)
	{
		Level.GetLocalPlayerController().myHUD.AddDebugLine((traceStart + Vect(0.0,0.0,1.0)), (hitLocation +  Vect(0.0,0.0,1.0)),
															class'Engine.Canvas'.Static.MakeColor(255,120,0), 0.02);
		Level.GetLocalPlayerController().myHUD.AddDebugLine(traceStart, traceEnd,
															class'Engine.Canvas'.Static.MakeColor(255,120,200), 0.02);
	}

	delta = hitLocation - traceStart;
	oldDistance = VSize(traceStart - FlashlightDynamicLight.Location);
	newDistance = VSize(delta) * PointLightDistanceFraction;
	newDistance = oldDistance + (newDistance - oldDistance) * PointLightDistanceFadeRate;

	PointLightPos = traceStart + newDistance * Vector(FlashlightReferenceActor.Rotation);
	FlashlightDynamicLight.SetLocation(PointLightPos);

    if (InFirstPersonView())
	{
		// attenuate the radius if the light is approaching something very close
		FlashlightDynamicLight.LightRadius = MinFlashlightRadius +
			(BaseFlashlightRadius - MinFlashlightRadius) * (newDistance/FlashlightFirstPersonDistance);
	}
	else
	{
		FlashlightDynamicLight.LightRadius = MinFlashlightRadius + newDistance *	PointLightRadiusScale;
	}

	FlashlightDynamicLight.LightBrightness = BaseFlashlightBrightness +
		FMin(newDistance/MaxFlashlightDistance, 1.0) * (MinFlashlightBrightness - BaseFlashlightBrightness);
#if ENABLE_FLASHLIGHT_PROJECTION_VISIBILITY_TESTING
    FlashlightDynamicLight.LightBrightness *= FlashlightProjection_CurrentBrightnessAlpha;
#endif
	FlashlightDynamicLight.bLightChanged = true;
}

	
*/

defaultproperties
{
	HasShield=true
	AimAnimation=WeaponAnimAim_Shield
	LowReadyAnimation=WeaponAnimLowReady_Shield
	IdleWeaponCategory=IdleWithShield

	ComplianceAnimation=Compliance_Shield
	ShowCrosshairInIronsights=true
}