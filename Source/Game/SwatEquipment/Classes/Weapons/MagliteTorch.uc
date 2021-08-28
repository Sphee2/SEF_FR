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
			if (evidence_is_highlight)
			{
				SGPC.ConsoleCommand("evidencehighlight 0");
				evidence_is_highlight = false;
			}
			else
			{
				SGPC.ConsoleCommand("evidencehighlight 1");
				evidence_is_highlight = true;
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

    for (C = Level.ControllerList; C != none; C = C.nextController)
    {
        SGPC = SwatGamePlayerController(C);

        if (C.bIsPlayer == true)
        {
			if (evidence_is_highlight)
			{
				SGPC.ToggleFlashlight();
			}
        }
    }

}


defaultproperties
{
	bAbletoMelee=false
    Slot=Slot_Maglite
}
