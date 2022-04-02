class ShieldEquip extends SimpleEquipment;

var() name UnequipSocket;


function Equip()
{
	local Pawn PawnOwner;
    
	if ( Owner.isa('Hands') )//first person
	{
		log("Shield Hands equip");
	   Owner.AttachToBone(self, AttachmentBone);	
	   return;
	}
	
	PawnOwner = Pawn(Owner);
	if ( PawnOwner != None ) //third person
	{
		log("Shield TP equip");
		Pawn(Owner).AttachToBone(self, AttachmentBone);
	}
		
}

function UnEquip()
{
	local Pawn PawnOwner;
	
	
	
	if ( Owner.isa('Hands') )//first person
	{
	  log("Shield Hands Unequip");
      Owner.DetachFromBone(self);
	  return;
	}
	
	PawnOwner = Pawn(Owner);
	if ( PawnOwner != None ) //third person
	{	
		log("Shield TP Unequip");
		Pawn(Owner).DetachFromBone(self);
		Pawn(Owner).AttachToBone(self, UnequipSocket);
	}
	
}



defaultproperties
{
	StaticMesh=StaticMesh'Shield_static.Shield_static'
	AttachmentBone=Shield
	UnequipSocket=ShieldUnequip
	bCollideActors=true
}