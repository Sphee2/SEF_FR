class EnemyCommanderActionConfig extends Core.Object config(AI);

		
// Initial Reaction variables

var config float								LowSkillInitialReactionChance;
var config float                                MediumSkillInitialReactionChance;
var config float                                HighSkillInitialReactionChance;

var config float								MinDistanceToOfficersToDoInitialReaction;

var config float								LowSkillScreamChance;
var config float                                MediumSkillScreamChance;
var config float                                HighSkillScreamChance;

// Morale variables

var config float                                SurprisedComplianceAngle;

var config float                                MaxSurprisedComplianceDistance;
var config float                                LowSkillSurprisedComplianceMoraleModification;
var config float                                MediumSkillSurprisedComplianceMoraleModification;
var config float                                HighSkillSurprisedComplianceMoraleModification;

var config float								LowSkillWeaponDroppedMoraleModification;
var config float								MediumSkillWeaponDroppedMoraleModification;
var config float								HighSkillWeaponDroppedMoraleModification;

var config float								LowSkillFlashbangedMoraleModification;
var config float								MediumSkillFlashbangedMoraleModification;
var config float								HighSkillFlashbangedMoraleModification;

var config float								LowSkillGassedMoraleModification;
var config float								MediumSkillGassedMoraleModification;
var config float								HighSkillGassedMoraleModification;

var config float								LowSkillPepperSprayedMoraleModification;
var config float								MediumSkillPepperSprayedMoraleModification;
var config float								HighSkillPepperSprayedMoraleModification;

var config float								LowSkillStungMoraleModification;
var config float								MediumSkillStungMoraleModification;
var config float								HighSkillStungMoraleModification;

var config float								LowSkillTasedMoraleModification;
var config float								MediumSkillTasedMoraleModification;
var config float								HighSkillTasedMoraleModification;

var config float								LowSkillStunnedByC2MoraleModification;
var config float								MediumSkillStunnedByC2MoraleModification;
var config float								HighSkillStunnedByC2MoraleModification;

var config float								LowSkillShotMoraleModification;
var config float								MediumSkillShotMoraleModification;
var config float								HighSkillShotMoraleModification;

var config float								LowSkillKilledOfficerMoraleModification;
var config float								MediumSkillKilledOfficerMoraleModification;
var config float								HighSkillKilledOfficerMoraleModification;

var config float								LowSkillNearbyEnemyKilledMoraleModification;
var config float								MediumSkillNearbyEnemyKilledMoraleModification;
var config float								HighSkillNearbyEnemyKilledMoraleModification;

var config float								LowSkillOutOfUsableWeaponsMoraleModification;
var config float								MediumSkillOutOfUsableWeaponsMoraleModification;
var config float								HighSkillOutOfUsableWeaponsMoraleModification;

var config float								UnobservedComplianceMoraleModification;
var config float								LeaveCompliantStateMoraleThreshold;

// Engaging
var config float								DeltaDistanceToSwitchEnemies;

var config float								LowSkillReactToThrownGrenadeChance;
var config float								MediumSkillReactToThrownGrenadeChance;
var config float								HighSkillReactToThrownGrenadeChance;

var config float								MinLostPawnDeltaTime;
var config float								MaxLostPawnDeltaTime;

//FR AI
var config float								LowSkillInvestigateSoundChance;
var config float                                MediumSkillInvestigateSoundChance;
var config float                                HighSkillInvestigateSoundChance;

var config float						MinAimAtNoiseWhileMovingTime;
var config float						MaxAimAtNoiseWhileMovingTime;