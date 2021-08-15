class Procedure_NoUnauthorizedUseOfDeadlyForce extends SwatGame.Procedure
    implements  IInterested_GameEvent_PawnDied;

var config int PenaltyPerEnemy;

var array<SwatEnemy> KilledEnemies;

function PostInitHook()
{
    Super.PostInitHook();

    //register for notifications that interest me
    GetGame().GameEvents.PawnDied.Register(self);
}

//interface IInterested_GameEvent_PawnDied implementation
function OnPawnDied(Pawn Pawn, Actor Killer, bool WasAThreat)
{	
    if (!Pawn.IsA('SwatEnemy')) return;

//    if (WasAThreat)
//    {
//        if (GetGame().DebugLeadership)
//            log("[LEADERSHIP] "$class.name
//                $"::OnPawnDied() did *not* add "$Pawn.name
//                $" to its list of KilledEnemies because the SwatEnemy was a threat (so the deadly force was authorized).");
//
//        return; //the deadly force was authorized
//    }

	
	//debug 
	//if (CheckEnemyHitBack(Pawn,Killer) || true)
	//{
	//	if ( ISwatEnemy(Pawn).GetCurrentState() == EnemyState_Flee  )
	//		GetGame().PenaltyTriggeredMessage(Pawn(Killer) , "Enemy flee");
	//}

    //if (Pawn.IsA('SwatEnemy') && ISwatEnemy(Pawn).IAmThreat())
	if (Pawn.IsA('SwatEnemy') && ISwatEnemy(Pawn).IAmThreat() && !ISwatAI(Pawn).IsCompliant() && !ISwatAI(Pawn).IsArrested() )	
    {
        if (GetGame().DebugLeadership)
            log("[LEADERSHIP] "$class.name
                $"::OnPawnDied() did *not* add "$Pawn.name
                $" to its list of KilledEnemies because the SwatEnemy was a threat (so the deadly force was authorized).");
				
			return; //the deadly force was authorized
    }

    if( !Killer.IsA('SwatPlayer') && Pawn(Killer).GetActiveItem().GetSlot() != Slot_Detonator && !Killer.IsA('SniperPawn'))
    {
        if (GetGame().DebugLeadership)
            log("[LEADERSHIP] "$class.name
                $"::OnPawnDied() did *not* add "$Pawn.name
                $" to its list of KilledEnemies because Killer ("$Killer$") was not the local player.");

        return; //we only penalize the player if they did the Killing
    }
	
	//running close in front of an officer with a gun is considered a threat
	if ( ISwatEnemy(Pawn).GetCurrentState() == EnemyState_Flee  )
    {    
		//GetGame().PenaltyTriggeredMessage(Pawn(Killer) , "Enemy flee " $!ISwatEnemy(Pawn).GetEnemyCommanderAction().HasFledWithoutUsableWeapon()$  " " );
		if ( VSize(Pawn.Location - Killer.Location) < 1000 && !ISwatEnemy(Pawn).GetEnemyCommanderAction().HasFledWithoutUsableWeapon() ) 
		{
			//GetGame().PenaltyTriggeredMessage(Pawn(Killer) , "Enemy flee: no penalty");
			return; 
		}
	}
	

    AssertNotInArray( Pawn, KilledEnemies, 'KilledEnemies' );
    Add( Pawn, KilledEnemies );
	TriggerPenaltyMessage(Pawn(Killer));
    GetGame().CampaignStats_TrackPenaltyIssued();

    if (GetGame().DebugLeadership)
        log("[LEADERSHIP] "$class.name
            $" added "$Pawn.name
            $" to its list of KilledEnemies because PawnDied, Killer="$Killer
            $". KilledEnemies.length="$KilledEnemies.length);
}

function string Status()
{
    return string(KilledEnemies.length);
}

//this function is not used , as result were not as expected. anyway this left over can be good for future generations.
function bool CheckEnemyHitBack(Pawn DeadPawn, Actor Killer) 
{
	local vector EnemyDirectionNoZ, ViewDirectionNoZ;
    local float fDot, fDistanceToEnemy;
	
	fDistanceToEnemy = VSize(DeadPawn.Location - Killer.Location);

	EnemyDirectionNoZ   = Normal(DeadPawn.Location - Killer.Location); 
	EnemyDirectionNoZ.Z = 0.0;
	ViewDirectionNoZ    = vector(ISwatAI(DeadPawn).GetAimOrientation());
	ViewDirectionNoZ.Z  = 0.0;

	// this is a 2d calculation
	fDot = EnemyDirectionNoZ Dot ViewDirectionNoZ;


	// check to see if pawn has been shot in the back
	// DotProduct > 0.0f Same direction
	// DotProduct == 0.0f Perpendicular direction
	// DotProduct < 0.0f Opposite direction
	
	if (fDot < 0.5 ) //dot 0.5 is 45 degrees in front
	{
		GetGame().PenaltyTriggeredMessage(Pawn(Killer) , " dist:" $fDistanceToEnemy$  " dot:" $fDot$ " - hit back penalty!");
		return true; //penalty!
	}
	else
	{
		if (fDistanceToEnemy > 1000) //if shot in front but in more than 15 meters it's a penalty!!!!
		{
			GetGame().PenaltyTriggeredMessage(Pawn(Killer) ," dist:" $fDistanceToEnemy$  " dot:" $fDot$ " - distance penalty!");
			log("Shot in the back: " $fDistanceToEnemy$  " dot: " $fDot$ "   --------- penalty!");
			
			return true; //penalty!
		}
				
	}
	
	GetGame().PenaltyTriggeredMessage(Pawn(Killer) ," dist:" $fDistanceToEnemy$  " dot:" $fDot$ " - No penalty!");
	log("Shot in the back: " $fDistanceToEnemy$  " dot: " $fDot$ "   --------- No penalty!");
	
	return false; //NOT a penalty!
}

//interface IProcedure implementation
function int GetCurrentValue()
{
    if (GetGame().DebugLeadershipStatus)
        log("[LEADERSHIP] "$class.name
            $" is returning CurrentValue = PenaltyPerEnemy * KilledEnemies.length\n"
            $"                           = "$PenaltyPerEnemy$" * "$KilledEnemies.length$"\n"
            $"                           = "$PenaltyPerEnemy * KilledEnemies.length);

    return PenaltyPerEnemy * KilledEnemies.length;
}
