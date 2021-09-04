class MagliteTorch extends BreachingShotgun config(SwatEquipment); 

var bool evidence_is_highlight;

simulated function OnHolderDesiredFlashlightStateChanged() //we dont shoot here....
{
	Super.OnHolderDesiredFlashlightStateChanged();
	
	evidence();
	
}

simulated function evidence()
{
	local SwatGamePlayerController SGPC; 
    local Controller C;


    for (C = Level.ControllerList; C != none; C = C.nextController)
    {
        SGPC = SwatGamePlayerController(C);
			 if (C.bIsPlayer == true)
			 {
				if (!evidence_is_highlight)
				{
					SGPC.evidencehighlight(true);	
					evidence_is_highlight=true;
				}
				else
				{
					SGPC.evidencehighlight(false);
					evidence_is_highlight=false;
				}
			}
    }
}

simulated latent protected function DoUsingHook()
{
	//it is supposed to do nothing... 
	//here just to avoid fire sound and shit
}


simulated function UnequippedHook() //remove evidence highlight when unequip.
{
local SwatGamePlayerController SGPC; 
local Controller C;

Super.UnequippedHook();

 for (C = Level.ControllerList; C != none; C = C.nextController)
 {
    SGPC = SwatGamePlayerController(C);
    if (C.bIsPlayer == true)
    {
			SGPC.ConsoleCommand("evidencehighlight 0");
			evidence_is_highlight = false;
	}
 } 

}


defaultproperties
{
	bAbletoMelee=false
    Slot=Slot_Maglite
}
