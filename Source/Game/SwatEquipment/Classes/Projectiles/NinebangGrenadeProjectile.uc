class NinebangGrenadeProjectile extends Engine.SwatGrenadeProjectile
    config(SwatEquipment);

//damage - Damage should be applied constantly over DamageRadius
var config float Damage;
var config float DamageRadius;
var protected config float FuseTime;


//karma impulse - Karma impulse should be applied linearly from KarmaImpulse.Max to KarmaImpulse.Min over KarmaImpulseRadius
var config Range KarmaImpulse;
var config float KarmaImpulseRadius;

//stun
var config float StunRadius;
var config float PlayerStunDuration;
var config float AIStunDuration;
var config float MoraleModifier;
var config float FlashBang; 
var float i;

simulated function Detonated()
{
    local IReactToFlashbangGrenade Current;
    local ICareAboutGrenadesGoingOff CurrentExtra;
    local float OuterRadius;
	local vector vCeilingChkr;

    OuterRadius = FMax(FMax(DamageRadius, KarmaImpulseRadius), StunRadius);
	vCeilingChkr = Location;
	vCeilingChkr.Z = Location.Z + 600;

#if !IG_SWAT_DISABLE_VISUAL_DEBUGGING // ckline: prevent cheating in network games
    if (bRenderDebugInfo)
    {
        // Render a box approximating the radius of affect
        Level.GetLocalPlayerController().myHUD.AddDebugBox(
            Location,
            StunRadius*2,
            class'Engine.Canvas'.Static.MakeColor(0,255,0),
            5);
    }
#endif

    foreach AllActors(class'ICareAboutGrenadesGoingOff', CurrentExtra) 
	{
      CurrentExtra.OnFlashbangWentOff(Pawn(Owner));
    }
	
  if(FastTrace(Location, vCeilingChkr))	
  {	  
		foreach VisibleCollidingActors(class'IReactToFlashbangGrenade', Current, OuterRadius)
		{

					if  (                                                   // (it's within range, and
							Actor(Current).Region.Zone == Region.Zone       //  AND it's in the same zone),
						||  FastTrace(Location, Actor(Current).Location)    // OR it's unblocked
						)
					{

			Current.ReactToFlashbangGrenade(
				Self,
				Pawn(Owner),
				Damage,
				DamageRadius,
				KarmaImpulse,
				KarmaImpulseRadius,
				StunRadius,
				PlayerStunDuration,
				AIStunDuration,
				MoraleModifier);

#if !IG_SWAT_DISABLE_VISUAL_DEBUGGING // ckline: prevent cheating in network games
			if (bRenderDebugInfo)
			{
				// Render line to actors that are affected
				Level.GetLocalPlayerController().myHUD.AddDebugLine(
					Location, Actor(Current).Location,
					class'Engine.Canvas'.Static.MakeColor(0,0,255),
					5);
			}
	#endif
		}
    }
}

	else
	{	  
		foreach RadiusActors(class'IReactToFlashbangGrenade', Current, OuterRadius)
		{

					if  (                                                   // (it's within range, and
							Actor(Current).Region.Zone == Region.Zone       //  AND it's in the same zone),
						||  FastTrace(Location, Actor(Current).Location)    // OR it's unblocked
						)
					{

			Current.ReactToFlashbangGrenade(
				Self,
				Pawn(Owner),
				Damage,
				DamageRadius,
				KarmaImpulse,
				KarmaImpulseRadius,
				StunRadius,
				PlayerStunDuration,
				AIStunDuration,
				MoraleModifier);

#if !IG_SWAT_DISABLE_VISUAL_DEBUGGING // ckline: prevent cheating in network games
			if (bRenderDebugInfo)
			{
				// Render line to actors that are affected
				Level.GetLocalPlayerController().myHUD.AddDebugLine(
					Location, Actor(Current).Location,
					class'Engine.Canvas'.Static.MakeColor(0,0,255),
					5);
			}
	#endif
		}
    }
}	

    if ( Level.NetMode != NM_Client )
        SwatGameInfo(Level.Game).GameEvents.GrenadeDetonated.Triggered( Pawn(Owner), Self );
    dispatchMessage(new class'MessageFlashbangGrenadeDetonated');

    bStasis = true; // optimization

    if (Level.DetailMode == DM_Low)
        LifeSpan = 30; // destroy self after 30 seconds, for optimization
    else
        LifeSpan = 180; // destroy self after 3 minutes, for optimization
}

simulated latent function DoPostDetonation()
{
    //log("disabling tick for "$self);
    Disable('Tick');
}

//added Nine bangs
auto simulated state Live
{
Begin:
    Sleep(FuseTime);

	for(FlashBang= 1; FlashBang<=9; FlashBang+=1)
	{
		
		switch(FlashBang) //to manage 9 different sounds effects
		{
          case 1:  		
		  
		TriggerEffectEvent(
			'Detonated1',
			,					// use default Other
			,					// use default TargetMaterial
			self.Location,		// location of projectile
			Rotator(vect(0,0,1)) // scorch should always orient downward to avoid weird clipping with the floor
		);
		  break;
		  
		  case 2:
		  
		TriggerEffectEvent(
			'Detonated2',
			,					// use default Other
			,					// use default TargetMaterial
			self.Location,		// location of projectile
			Rotator(vect(0,0,1)) // scorch should always orient downward to avoid weird clipping with the floor
		);
		  break;
		  
		  case 3:
		  
		TriggerEffectEvent(
			'Detonated3',
			,					// use default Other
			,					// use default TargetMaterial
			self.Location,		// location of projectile
			Rotator(vect(0,0,1)) // scorch should always orient downward to avoid weird clipping with the floor
		);
		  break;
		  
		  case 4:
		  
		TriggerEffectEvent(
			'Detonated4',
			,					// use default Other
			,					// use default TargetMaterial
			self.Location,		// location of projectile
			Rotator(vect(0,0,1)) // scorch should always orient downward to avoid weird clipping with the floor
		);
		  break;
		  
		  case 5:
		  
		TriggerEffectEvent(
			'Detonated5',
			,					// use default Other
			,					// use default TargetMaterial
			self.Location,		// location of projectile
			Rotator(vect(0,0,1)) // scorch should always orient downward to avoid weird clipping with the floor
		);
		  break;
		  
		  case 6:
		  
		TriggerEffectEvent(
			'Detonated6',
			,					// use default Other
			,					// use default TargetMaterial
			self.Location,		// location of projectile
			Rotator(vect(0,0,1)) // scorch should always orient downward to avoid weird clipping with the floor
		);
		  break;
		  
		  case 7:
		  
		TriggerEffectEvent(
			'Detonated7',
			,					// use default Other
			,					// use default TargetMaterial
			self.Location,		// location of projectile
			Rotator(vect(0,0,1)) // scorch should always orient downward to avoid weird clipping with the floor
		);
		  break;
		  
		  case 8:
		  
		TriggerEffectEvent(
			'Detonated8',
			,					// use default Other
			,					// use default TargetMaterial
			self.Location,		// location of projectile
			Rotator(vect(0,0,1)) // scorch should always orient downward to avoid weird clipping with the floor
		);
		  break;
		  
		  case 9:
		  
		TriggerEffectEvent(
			'Detonated9',
			,					// use default Other
			,					// use default TargetMaterial
			self.Location,		// location of projectile
			Rotator(vect(0,0,1)) // scorch should always orient downward to avoid weird clipping with the floor
		);
		  break;
		  
		 default:
		 
		 break;
		  
		}
		
		NotifyRegistrantsGrenadeDetonated();

		Detonated();
		DestroyNotifyAIsTimer();
		Sleep(0.3);
	}
    DoPostDetonation();
}
//added Nine bangs

defaultproperties
{
    StaticMesh=StaticMesh'SwatGear_sm.NinebangThrown'
}
