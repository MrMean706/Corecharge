/*
Using spawners instead of replacing monsters directly so that I can just remove this file to use the individual actors in a non-Corecharge project.
NOTE:
If trying to use individual actors within a non-corecharge mapset, remove the following:
    this file
    BloodSplatters.dec
    HealthArmorPowerups.dec
    Keys.dec
*/
// MONSTERS
Class BaronSpawner:             RandomSpawner replaces BaronOfHell      { Default { DropItem "TangoBaronOfHell";}}
Class BehemothSpawner:          RandomSpawner replaces Fatso            { Default { DropItem "TangoBehemoth";}}
Class CacodemonSpawner:         RandomSpawner replaces Cacodemon        { Default { DropItem "TangoCacodemon";}}
Class ChaingunguySpawner:       RandomSpawner replaces Chaingunguy      { Default { DropItem "TangoChaingunguy";}}
Class CyberdemonSpawner:        RandomSpawner replaces Cyberdemon       { Default { DropItem "TangoCyberdemon";}}
Class DraugrSpawner:            RandomSpawner replaces Revenant         { Default { DropItem "TangoDraugr";}}
Class ExileSpawner:             RandomSpawner replaces Archvile         { Default { DropItem "TangoExile";}}
Class FusioniteSpawner:         RandomSpawner replaces Arachnotron      { Default { DropItem "TangoFusionite";}}
Class HellKnightSpawner:        RandomSpawner replaces HellKnight       { Default { DropItem "TangoHellKnight";}}
Class ImpSpawner:               RandomSpawner replaces DoomImp          { Default { DropItem "TangoImp";}}
Class LostSoulSpawner:          RandomSpawner replaces LostSoul         { Default { DropItem "TangoLostSoul";}}
Class MechaDemonSpawner:        RandomSpawner replaces Demon            { Default { DropItem "MechaDemon";}}
Class PainElementalSpawner:     RandomSpawner replaces PainElemental    { Default { DropItem "TangoPainElemental";}}
Class ZombieManSpawner:         RandomSpawner replaces ZombieMan        { Default { DropItem "TangoZombieMan";}}
Class ShotgunGuySpawner:        RandomSpawner replaces ShotgunGuy       { Default { DropItem "TangoShotgunGuy";}}
Class SpiderMastermindSpawner:  RandomSpawner replaces SpiderMastermind { Default { DropItem "TangoSpiderMastermind";}}
// WEAPONS
Class AssaultRifleSpawner:      RandomSpawner replaces Chaingun         { Default { DropItem "TangoAssaultRifle";}}
Class AxeSpawner:               RandomSpawner replaces Berserk          { Default { DropItem "Axe";}}
Class BFG9000Spawner:           RandomSpawner replaces BFG9000          { Default { DropItem "TangoBFG9000";}}
Class BloodletterSpawner:       RandomSpawner replaces Chainsaw         { Default { DropItem "Bloodletter";}}
Class PistolSpawner:            RandomSpawner replaces Pistol           { Default { DropItem "TangoPistol";}}
Class PlasmaRifleSpawner:       RandomSpawner replaces PlasmaRifle      { Default { DropItem "TangoPlasmaRifle";}}
Class RocketLauncherSpawner:    RandomSpawner replaces RocketLauncher   { Default { DropItem "TangoRocketLauncher";}}
Class ShotgunSpawner:           RandomSpawner replaces Shotgun          { Default { DropItem "TangoShotgun";}}
Class SuperShotgunSpawner:      RandomSpawner replaces SuperShotgun     { Default { DropItem "TangoSuperShotgun";}}
// AMMO
Class BulletClipSpawner:        RandomSpawner replaces  Clip  { Default { DropItem "TangoBulletClip";}}
Class BulletBoxSpawner:         RandomSpawner replaces ClipBox   { Default { DropItem "TangoBulletBox";}}
Class ShellSpawner:             RandomSpawner replaces Shell   { Default { DropItem "TangoShell";}}
Class ShellBoxSpawner:          RandomSpawner replaces ShellBox   { Default { DropItem "TangoShellBox";}}
Class RocketAmmoSpawner:        RandomSpawner replaces RocketAmmo   { Default { DropItem "TangoRocketAmmo";}}
Class RocketBoxSpawner:         RandomSpawner replaces RocketBox   { Default { DropItem "TangoRocketBox";}}
Class CellSpawner:              RandomSpawner replaces Cell   { Default { DropItem "TangoCell";}}
Class CellPackSpawner:          RandomSpawner replaces CellPack   { Default { DropItem "TangoCellPack";}}
// CORPSES
Class DeadZombieManSpawner:     RandomSpawner replaces DeadZombieMan   { Default { DropItem "TangoDeadZombieMan";}}
Class DeadShotgunGuySpawner:    RandomSpawner replaces DeadShotgunGuy   { Default { DropItem "TangoDeadShotgunGuy";}}
Class DeadImpSpawner:           RandomSpawner replaces DeadDoomImp   { Default { DropItem "TangoDeadImp";}}
Class DeadDemonSpawner:         RandomSpawner replaces DeadDemon   { Default { DropItem "TangoDeadMechaDemon";}}
Class DeadCacodemonSpawner:     RandomSpawner replaces DeadCacodemon   { Default { DropItem "TangoDeadCacodemon";}}
// MISC
Class BarrelSpawner:      RandomSpawner replaces ExplosiveBarrel   { Default { DropItem "TangoBarrel";}}
Class BulletPuffSpawner:      RandomSpawner replaces BulletPuff   { Default { DropItem "TBulletPuff";}}
Class PlayerSpawner:      RandomSpawner replaces DoomPlayer   { Default { DropItem "TangoPlayer";}}
/*Class Spawner:      RandomSpawner replaces    { Default { DropItem "Tango";}}
Class Spawner:      RandomSpawner replaces    { Default { DropItem "Tango";}}
Class Spawner:      RandomSpawner replaces    { Default { DropItem "Tango";}}
Class Spawner:      RandomSpawner replaces    { Default { DropItem "Tango";}}
Class Spawner:      RandomSpawner replaces    { Default { DropItem "Tango";}}
Class Spawner:      RandomSpawner replaces    { Default { DropItem "Tango";}}*/