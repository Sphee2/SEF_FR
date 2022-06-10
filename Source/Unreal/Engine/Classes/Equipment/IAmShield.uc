interface IamShield;

simulated function int GetProtectionType();
simulated function int GetProtectionLevel();
simulated function float GetMtP();
simulated function ShieldTakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType);
simulated function ClientShieldTakeDamage( int DamageS );