Class ShotgunAmmo : Ammo
{
	Default
    {
        Inventory.Amount 6;
        Inventory.MaxAmount 6;
        Ammo.BackpackAmount 0;
        Ammo.BackpackMaxAmount 6;
        +Inventory.IGNORESKILL
    }
}

Class TangoShotgun : ReloadableWeapon
{    
    Default
    {
        Tag "Shotgun";
        +WEAPON.AMMO_OPTIONAL
        +WEAPON.NOALERT
        Weapon.KickBack 100;
        Weapon.SlotNumber 3;
        decal "bulletchip";
        Weapon.AmmoUse1 1;
        Weapon.AmmoUse2 0;
        Weapon.AmmoType1 "ShotgunAmmo";
        Weapon.AmmoType2 "TangoShell";
        Weapon.AmmoGive1 0;
        Weapon.AmmoGive2 8;
        Inventory.PickupSound "weapons/shotguncock";
        Inventory.PickupMessage "$TANGO_SHOTGUN";
    }
	
	States
	{
	Spawn:
		SHOT A 5;
		Loop;
	Ready:
		SHTG A 1 A_WeaponReady(WRF_ALLOWRELOAD);
		Loop;
	Fire:
		SHTF A 2 Bright 
        {
        if (CountInv("Reloading") == 1)
            return ResolveState("ReloadFinish");
        if (CountInv("ShotgunAmmo") == 0)
            return ResolveState("CheckAutoReload");
        A_AlertMonsters();
        A_PlaySound("weapons/shotgunfire", CHAN_WEAPON);
        A_FireBullets(3.6, 1.5, 10, 9, "ShotgunPuff", FBF_USEAMMO|FBF_NORANDOM, 8192);
        if (TangoPlayer(self).shouldScreenShake()) Radius_Quake(5, 3, 0, 1, 0);
        A_GunFlash();
        A_Light1();
        if (TangoPlayer(self).shouldRecoil()) A_SetPitch(pitch - 1.0);
        return ResolveState(null);
        }
		SHTF B 1 Bright
        {
        if (TangoPlayer(self).shouldRecoil()) A_SetPitch(pitch + 0.5);
        A_Light2();
        }
		SHTF C 1
        {
        if (TangoPlayer(self).shouldRecoil()) A_SetPitch(pitch + 0.5);
        A_Light0();
        }
		SHTF DEF 1;
		SHTG BCDEFG 1;
		SHTG G 1 A_PlaySound("weapons/shotguncock");
		SHTG H 2;
		SHTG I 1;
		TNT1 A 0 A_SpawnItemEx("ShotgunCasing",random(-7,-9),cos(pitch)*-25,sin(-pitch)*25+random(26,28), random(3,5),0,random(4,6), random(-80,-90));
		SHTG J 1;
		SHTG IH 1;
        SHTG GF 1;
		Goto FireFinish;
	FireFinish:
		SHTG EDCB 1;
		TNT1 A 0 A_JumpIfNoAmmo("CheckAutoReload");
		Goto Ready;
	CheckAutoReload:
		TNT1 A 0 A_JumpIf(ACS_NamedExecuteWithResult("tango_cvar_auto_reload") == 1, "ReloadPreBuffer");
		Goto NoAmmo;
	ReloadPreBuffer:
		SHTG A 1 A_WeaponReady(WRF_NOFIRE);
		Goto Reload;
	NoAmmo:
		SHTG A 2 A_PlaySound("weapons/empty");
		Goto Ready;
	Reload:
		TNT1 A 0 A_JumpIf(ACS_NamedExecuteWithResult("tango_cvar_shotgun_skin") == 1, "ReloadGothic");
		// if we have at least 1 shell to load, jump to continue
		TNT1 A 0 A_JumpIfInventory("TangoShell", 1, 1);
		Goto NoAmmo;
		// if we're full on shotgunammo, just go back to ready
		TNT1 A 0 A_JumpIfInventory("ShotgunAmmo", 0, "Ready");
		SHTG BCD 1;
		SHTG EFG 1; // 2
		TNT1 A 0 A_GiveInventory("Reloading", 1);
		Goto ReloadRepeat;
	ReloadRepeat:
		// if we have max shotgunammo, finish reload
		TNT1 A 0 A_JumpIfInventory("ShotgunAmmo", 0, "ReloadFinish");
		// if we have at least 1 shell, go to LoadShell
		TNT1 A 0 A_JumpIfInventory("TangoShell", 1, "LoadShell");
		Goto ReloadFinish;
	LoadShell:
		SHTR BC 1;
		TNT1 A 0 A_GiveInventory("ShotgunAmmo", 1);
		TNT1 A 0 A_TakeInventory("TangoShell", 1);
		SHTR D 1 A_PlaySound("weapons/shellin", CHAN_AUTO);
		SHTR E 1;
		SHTR FHI 1 A_WeaponReady(WRF_NOBOB);
		Goto ReloadRepeat;
	ReloadFinish:
		SHTG GFEDCB 1;
		TNT1 A 0 A_TakeInventory("Reloading", 1);
		Goto Ready;
	Select:
		TNT1 A 0 A_PlaySound("weapons/shotguncock", CHAN_WEAPON);
		SHTG A 0 A_Raise;
		Loop;
	Deselect:
		TNT1 A 0 A_JumpIfInventory("Reloading", 1, "Deselect2");
	DeselectLoop:
		SHTG A 0 A_Lower;
		Goto DeselectLoop;
	Deselect2:
		TNT1 A 0 A_JumpIf(ACS_NamedExecuteWithResult("tango_cvar_shotgun_skin") == 1, "Deselect2Gothic");
		TNT1 A 0 A_TakeInventory("Reloading", 1);
		SHTG GFEDCB 1;
	Deselect2Loop:
		SHTG A 0 A_Lower;
		Goto Deselect2Loop;
	}
}