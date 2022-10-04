class FieldDress extends SwatGame.EquipmentUsedOnOther
    implements ITacticalAid;

var float LastInterruptTime;

simulated function EquippedHook()
{
  Super.EquippedHook();
  UpdateHUD();
}

function UpdateHUD()
{
  local SwatGame.SwatGamePlayerController LPC;
  local int ReserveWedges;

  LPC = SwatGamePlayerController(Level.GetLocalPlayerController());

  if (Pawn(Owner).Controller != LPC) return; //the player doesn't own this ammo

  ReserveWedges = LPC.SwatPlayer.GetTacticalAidAvailableCount(GetSlot());
  ReserveWedges--; // We are holding one
  if(ReserveWedges < 0)
  {
    ReserveWedges = 0;
  }

  LPC.GetHUDPage().AmmoStatus.SetTacticalAidStatus(ReserveWedges, self);
  LPC.GetHUDPage().UpdateWeight();
}

// Every time we use a wedge, switch back to the primary weapon
simulated function EquipmentSlot GetSlotForReequip()
{
  local SwatGame.SwatGamePlayerController LPC;

  LPC = SwatGamePlayerController(Level.GetLocalPlayerController());

  if (Pawn(Owner).Controller != LPC) return Slot_PrimaryWeapon; //the player doesn't own this ammo

  if(LPC.bSecondaryWeaponLast)
    return Slot_SecondaryWeapon;
  return Slot_PrimaryWeapon;
}

simulated function bool CanUseOnOtherNow(Actor Other)
{
    local SwatPawn Pawn;

    Pawn = SwatPawn(Other);

    if (Pawn == None)
        return false;   //can't use on anything other than a SwatPawn

    log( self$"---FieldDress::Pawn.IsLowerBodyInjured() " $ Pawn.IsLowerBodyInjured() $ " .");
    if (Pawn.CanBeHealed() )
        return true;   //Human player or AI is injured

    return false;
}


//called by the PlayerController when the player instigates Use of this HandheldEquipment
simulated function OnPlayerUse()
{
    local Actor DefaultFireFocusActor;
    local SwatGamePlayerController LPC;

    LPC = SwatGamePlayerController(Level.GetLocalPlayerController());

    
    if( LPC != None )
        DefaultFireFocusActor = LPC.GetFocusInterface(Focus_Fire).GetDefaultFocusActor();

    log( self$"---FieldDress::GetDefaultFocusActor() " $ LPC.GetFocusInterface(Focus_Fire).GetDefaultFocusActor().name $ " ." );

    if (DefaultFireFocusActor == None)  
        DefaultFireFocusActor = Owner; //use the item on our own

    // We have to store this in the controller, so when it goes to state
    // QualifyingForUse, it will have the target.
    LPC.OtherForQualifyingUse = DefaultFireFocusActor;

    // In a standalone game we immediately begin qualifying. In a network
    // game, we have to ask the server for permission before we begin
    // qualifying. When the server replies and permits us to begin,
    // the NetPlayer will call NetBeginQualifying below.
    if ( Level.NetMode == NM_Standalone )
    {
        if (!CanUseOnOtherNow(DefaultFireFocusActor))
            return;

        BeginQualifying( DefaultFireFocusActor );
    }
    else
    {
        SwatPlayer(Owner).ServerRequestQualify( DefaultFireFocusActor );
    }
}

simulated function bool AllowedToPassItem()
{
	// we are not allowed to pass Cuffs, Detonator, or the Toolkit
	return false;
}

simulated latent protected function OnUsingBegan()
{
    log( self$"---FieldDress::OnUsingBegan(). Other="$Other$", Owner="$Owner);

    Super.OnUsingBegan();

    //tcohen: there was a bug where if an arrest began and interrupted
    //  on the same frame, then the interrupt would happen before the begin
    //  (because PlayerController::PlayerTick() happens before
    //  ProcessState() on the Cuffs).
    //  So if we were interrupted on the same frame, then we'll ignore the
    //  begin.
   /* if (LastInterruptTime != Level.TimeSeconds)
        ICanBeArrested(Other).OnArrestBegan(Pawn(Owner));
*/
    if (Pawn(Owner).GetHands() != None)
        Pawn(Owner).GetHands().SetNextIdleTweenTime(0.2);
}

simulated function UsedHook()
{
    local SwatPlayer SP;
    local SwatPawn SAI;

    log( self$"---FieldDress::UsedHook(). Other="$Other$", Owner="$ Owner $ " GetAvailableCount() " $GetAvailableCount());

	if ( VSize2D(self.Owner.Location - Other.Location) > 150 )
		return; //dont apply the bandage ... he ran away... 

    //heal other human players or your own
    SP=SwatPlayer(Pawn(Other));

    if (SP != None && SP.isa('SwatPlayer') )
    {
        //log( self$"---FieldDress::UsedHook(). SP.IsLowerBodyInjured() " $ SP.IsLowerBodyInjured() $ " .");
     if ( SP.IsInjured() )//IsLowerBodyInjured())
     {   
        SP.HealLimping();
		if (GetAvailableCount() == 1)
				SetAvailable(false);
	
		UpdateHUD();
     }

      
    }
    else  //heal AI
    {
		SAI=SwatPawn(Pawn(Other));
		
		
        if (SAI != None && SAI.IsLowerBodyInjured())
        {
            SAI.HealIntenseInjury();
			
			if (GetAvailableCount() == 1)
				SetAvailable(false);
			
			UpdateHUD();
        }

        log("Field dress::PawnHealing! GetAvailableCount() " $GetAvailableCount());
    }
    
}

//override from HandheldEquipment:
//Cuffs become unavailable even in Training
/*simulated function UpdateAvailability()
{
    if (UnavailableAfterUsed)
        SetAvailable(false);
}*/

// QualifiedUseEquipment overrides

/*
simulated function OnInterrupted()
{
    mplog( self$"---Cuffs::OnInterrupted. Other="$Other$", Owner="$Owner );

    ICanBeArrested(Other).OnArrestInterrupted(Pawn(Owner));
    LastInterruptTime = Level.TimeSeconds;
}
*/

simulated function bool ShouldUseAlternate()
{
    //use alternate animations in adversarial multiplayer
    return Level.NetMode != NM_Standalone && !Level.IsPlayingCOOP;
}

// IAmAQualifiedUseEquipment implementation

simulated function float GetQualifyDuration()
{
    return 3.0; //seconds of bandage action
}

simulated function float GetQualifyModifier()
{
  return 1.0;
}

// IAmUsedOnOther implementation

simulated protected function AssertOtherIsValid()
{
    assertWithDescription(Other.IsA('SwatPawn'),
        "[tcohen] FieldDress were called to AssertOtherIsValid(), but Other is a "$Other.class.name
        $", which is not a SwatPawn.");
}

//See HandheldEquipment::OnForgotten() for an explanation of the notion of "Forgotten".
//Cuffs become "magically" Available again after they have been Forgotten.
/*simulated function OnForgotten()
{
    SetAvailable(true);
}*/

defaultproperties
{
    Slot=SLOT_Bandage
    UnavailableAfterUsed=true
	bAbleToMelee=true
    StartCount=1
}