class SwatEnemyConfig extends Core.Object
    config(AI);

var config float						LowSkillAdditionalBaseAimError;
var config float						MediumSkillAdditionalBaseAimError;
var config float						HighSkillAdditionalBaseAimError;

var config float						LowSkillMinTimeToFireFullAuto;
var config float						LowSkillMaxTimeToFireFullAuto;
var config float						MediumSkillMinTimeToFireFullAuto;
var config float						MediumSkillMaxTimeToFireFullAuto;
var config float						HighSkillMinTimeToFireFullAuto;
var config float						HighSkillMaxTimeToFireFullAuto;

var config float						MinDistanceToAffectMoraleOfOtherEnemiesUponDeath;

var config array<name>					ThrowWeaponDownAnimationsHG;
var config array<name>					ThrowWeaponDownAnimationsMG;
var config array<name>					ThrowWeaponDownAnimationsSMG;
var config array<name>					ThrowWeaponDownAnimationsSG;

var config float						LowSkillFullBodyHitChance;
var config float						MediumSkillFullBodyHitChance;
var config float						HighSkillFullBodyHitChance;

var config float            LowSkillMinTimeBeforeShooting;
var config float            LowSkillMaxTimeBeforeShooting;
var config float            MediumSkillMinTimeBeforeShooting;
var config float            MediumSkillMaxTimeBeforeShooting;
var config float            HighSkillMinTimeBeforeShooting;
var config float            HighSkillMaxTimeBeforeShooting;

//chance enemy doesnt drop all weapons
var config float 			LowSkillNoDropChance;
var config float			MediumSkillNoDropChance;
var config float 			HighSkillNoDropChance;

defaultproperties
{
	/* OLD SEF VALUES
    LowSkillMinTimeBeforeShooting = 1.0
    LowSkillMaxTimeBeforeShooting = 1.7
    MediumSkillMinTimeBeforeShooting = 0.9
    MediumSkillMaxTimeBeforeShooting = 1.3
    HighSkillMinTimeBeforeShooting = 0.6
    HighSkillMaxTimeBeforeShooting = 1.0
	*/
	LowSkillMinTimeBeforeShooting = 0.0
    LowSkillMaxTimeBeforeShooting = 0.0
    MediumSkillMinTimeBeforeShooting = 0.0
    MediumSkillMaxTimeBeforeShooting = 0.0
    HighSkillMinTimeBeforeShooting = 0.0
    HighSkillMaxTimeBeforeShooting = 0.0
	
	LowSkillNoDropChance=0.1
	MediumSkillNoDropChance=0.3
	HighSkillNoDropChance=0.5
}
