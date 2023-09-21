Class PlasmaRifleAmmo : Ammo
{
    Default
    {
        Inventory.Amount 40;
        Inventory.MaxAmount 40;
        Ammo.BackpackAmount 0;
        Ammo.BackpackMaxAmount 40;
        +Inventory.IGNORESKILL
    }
}

Class TangoPlasmaRifle : Weapon
{
    Default
    {
        Tag "Plasma Rifle";
        +WEAPON.NOALERT;
        +WEAPON.AMMO_OPTIONAL;
        Weapon.SlotNumber 6;
        Weapon.AmmoUse1 1;
        Weapon.AmmoUse2 0;
        Weapon.AmmoGive2 40;
        Weapon.AmmoType1 "PlasmaRifleAmmo";
        Weapon.AmmoType2 "TangoCell";
        Inventory.PickupMessage "$TANGO_PLASMA_RIFLE";
        Inventory.PickupSound "items/plasmarifle";
    }
	
	
   	States
   	{
	Spawn:
		TPRP A -1;
		Stop;
	Select:
		TNT1 A 0 A_StartSound("plasmarifle/select", CHAN_WEAPON);
		PKPL A 0 A_Raise;
		Loop;
	Deselect:
		PKPL A 0 A_Lower;
		Loop;
	Ready:
		PKPL A 1 A_WeaponReady(WRF_ALLOWRELOAD);
		Loop;
	NoAmmo:
		PKPL A 2 A_StartSound("weapons/empty");
		Goto Ready;
	Fire:
		PLSF A 1 Bright
        {
            if (CountInv("PlasmaRifleAmmo") == 0)
                return ResolveState("CheckAutoReload");
            A_AlertMonsters();
            A_FireProjectile("WeaponPlasmaBall");
            // We want a chance to skip the screen shake effect because it can
		// be grating if it happens on every single shot
            if (TangoPlayer(self).shouldScreenShake() && (Random(1,256) >= 96)) Radius_Quake(2, 2, 0, 1, 0);
            A_Light1();
            A_StartSound("weapons/plasmafire", CHAN_WEAPON);
            return ResolveState(null);
        }
		PLSF B 1 Bright A_Light0;
		PLSF A 1 Bright;
		PLSF B 1 Bright A_Refire;
		PKPL BCDE 1;
		PKPL F 6 A_StartSound("BEPBEP");
		PKPL EDCB 1;
		TNT1 A 0 A_JumpIfNoAmmo("CheckAutoReload");
		Goto Ready;
	CheckAutoReload:
		TNT1 A 0 A_JumpIf(ACS_NamedExecuteWithResult("tango_cvar_auto_reload") == 1, "ReloadPreBuffer");
		Goto Ready;
	ReloadPreBuffer:
		PKPL A 1 A_WeaponReady(WRF_NOFIRE);
		Goto Reload;
	Reload:
		TNT1 A 0 A_JumpIfInventory("TangoCell",1,1);
		Goto NoAmmo;
		TNT1 A 0 A_JumpIfInventory("PlasmaRifleAmmo", 0,"Ready");
		PLZR B 1; // A_FireCustomMissile("PlasmaCellCasing")
		PLZR CD 2;
		PLZR E 4 A_StartSound("PLREB", CHAN_AUTO);
		PLZR FGH 1;
		PLZR I 1 ;
	ReloadRepeat:
		TNT1 A 0 A_JumpIfInventory("PlasmaRifleAmmo", 0, "ReloadFinish");
		TNT1 A 0 A_JumpIfInventory("TangoCell", 1, 1);
		Goto ReloadFinish;
		TNT1 A 0 A_GiveInventory("PlasmaRifleAmmo", 1);
		TNT1 A 0 A_Takeinventory("TangoCell",1)	;
		Goto ReloadRepeat;
	ReloadFinish:
		PLZR K 8
        {
            A_RadiusThrust(5000, 600, RTF_NOIMPACTDAMAGE | RTF_NOTMISSILE, 3000);
			ShockwaveRing.Spawn(self); 
            Reloader reloader = Reloader(self.FindInventory("Reloader", true));
            if (reloader) reloader.TryReloadEverything();
        }
		PLZR J 4;
		PLZR I 1;
		PLZR L 1;
		PLZR MN 1;
		Goto Ready;
   	Flash:
		TNT1 A 1 A_Light1;
		Goto LightDone;
   	}
}

Class WeaponPlasmaBall : PlasmaBall
{
    Default
    {
        DamageFunction 23;
        Height 6;
        Speed 54;
        Radius 3;
        Scale 0.5;
        // eventually this should be its own damage type, but for now it's close
        // enough to rocket that this is fine
        DamageType "Rocket";
        SeeSound "";
        DeathSound "weapons/hrballexplode";
    }

    States
    {
    Spawn:
		BLPL A 2 Bright A_Weave(frandom(-3, 3), frandom(-3, 3), frandom(-3, 3), frandom(-3, 3));
		TNT1 A 0 A_SpawnItemEx("PlasmaBallTrail");
		BLPL B 2 Bright A_Weave(frandom(-3, 3), frandom(-3, 3), frandom(-3, 3), frandom(-3, 3));
		TNT1 A 0 A_SpawnItemEx("PlasmaBallTrail");
		BLPL C 2 Bright A_Weave(frandom(-3, 3), frandom(-3, 3), frandom(-3, 3), frandom(-3, 3));
		TNT1 A 0 A_SpawnItemEx("PlasmaBallTrail");
		BLPL D 2 Bright A_Weave(frandom(-3, 3), frandom(-3, 3), frandom(-3, 3), frandom(-3, 3));
		TNT1 A 0 A_SpawnItemEx("PlasmaBallTrail");
        Loop;
	Death:
		TNT1 AAAAAAAAAAAAAAA 0 A_SpawnItemEx("PlasmaBallSpark", 0, 0, 0, frandom(0.1, 1.0), frandom(-1.0, 1.0), frandom(-0.5, 4.0), 0, SXF_NOCHECKPOSITION);
		SPLS ABCDEFGHIJKL 2 Bright;
		Stop;
    }
}

Class PlasmaBallTrail: Actor
{
    Default
    {
        Radius 1;
        Height 1;
        Speed 0;
        Alpha 0.6;
        Scale 0.2;
        +NOINTERACTION;
        +CLIENTSIDEONLY;
    }
	
    States
    {
    Spawn:
		TNT1 A 3;
	Death:
		SPLS IJKL 1 Bright;
		Stop;
    }
}

Class PlasmaBallSpark: Actor
{
    Default
    {
    	Scale 0.2;
        Radius 2;
        Height 2;
        Speed 1;
        Projectile;
        Gravity 0.2;
        RenderStyle "Add";
        Alpha 1.0;
        -NOGRAVITY;
        -SOLID;
        +DOOMBOUNCE;
        +EXPLODEONWATER;
        -CANBOUNCEWATER;
        +DONTSPLASH;
        +NOTELEPORT;
        +CLIENTSIDEONLY;
    }

	States
	{
	Spawn:
		SPLS IJKLIJKL 1 Bright;
	FadeOut:
		SPLS IJKL 2 Bright A_FadeOut(0.15);
		Loop;
	}
}