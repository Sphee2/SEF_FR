class Procedure_NoForcedArrest extends SwatGame.Procedure
    implements  IInterested_GameEvent_PawnArrested;
	
	
var config int PenaltyPerInfraction;

var int numInfractions;
	
function PostInitHook()
{
    Super.PostInitHook();

    //register for notifications that interest me
    GetGame().GameEvents.PawnArrested.Register(self);
}

//interface IInterested_GameEvent_PawnArrested implementation
function OnPawnArrested( Pawn Pawn, Pawn Arrester )
{
    if (SwatAICharacter(Pawn).HasBeenForcedArrested())
	{
		numInfractions++;
		TriggerPenaltyMessage(Arrester);
		GetGame().CampaignStats_TrackPenaltyIssued();
	}
}

function string Status()
{
    return string(numInfractions);
}

//interface IProcedure implementation
function int GetCurrentValue()
{
    return PenaltyPerInfraction * numInfractions;
}