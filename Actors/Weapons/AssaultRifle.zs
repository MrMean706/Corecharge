const ar_base_spread = 2.3; 
const ar_max_spread = 5.2; 
const ar_vertical_spread_factor = 0.8; //Vertical:horizontal ratio for spread

Class AssaultRifleAmmo : Ammo
{
    Default
    {
        Inventory.Amount 30;
        Inventory.MaxAmount 30;
        Ammo.BackpackAmount 0;
        Ammo.BackpackMaxAmount 30;
        +Inventory.IGNORESKILL
    }
	
}

Class TangoAssaultRifle : ReloadableWeapon replaces Chaingun
{
    const MAX_TOKENS = double(20);
    int spreadTokens;
    void IncrementToken() {if (SpreadTokens < MAX_TOKENS) spreadTokens++;}
    void DecrementToken() {if (SpreadTokens > 0) spreadTokens--;}

    double GetSpreadHorz()
    {
        return ar_base_spread + ((SpreadTokens / MAX_TOKENS) * (ar_max_spread - ar_base_spread));
    }
    
    Default
    {
        Tag "Assault Rifle";
        +WEAPON.AMMO_OPTIONAL;
        +WEAPON.NOALERT;
        decal "bulletchip";
        Weapon.SlotNumber 4;
        Weapon.AmmoUse1 1;
        Weapon.AmmoUse2 0;
        Weapon.AmmoType2 "TangoBulletClip";
        Weapon.AmmoType1 "AssaultRifleAmmo";
        Inventory.PickupSound "items/assaultrifle";
        Obituary "%o was gunned down by %k's Assault Rifle";
        Inventory.PickupMessage "$TANGO_ASSAULT_RIFLE";
        Weapon.Kickback 50;
        Weapon.AmmoGive2 20;
    }
	
	States
	{
	Spawn:
		TARP A -1;
		Stop;
	Ready:
		TNT1 A 0 {invoker.DecrementToken();}
		TARG A 4 A_WeaponReady(WRF_ALLOWRELOAD);
		Loop;
	Fire:
		TARG B 1 Bright
        {
            if (CountInv("AssaultRifleAmmo") == 0)
                return ResolveState("CheckAutoReload");
            A_AlertMonsters();
            A_PlaySound("weapons/arfire", CHAN_WEAPON);
            A_GunFlash();
            A_Light1();
            double spread_horz = invoker.GetSpreadHorz();
            A_FireBullets(spread_horz, ar_vertical_spread_factor * spread_horz, -1, 20, "BulletPuff", FBF_USEAMMO|FBF_NORANDOM, 8192);
            invoker.IncrementToken();
            if (TangoPlayer(self).shouldScreenShake())
            {
                // Determine shake level in a few tiers based on spread token count
                // Note you'll want to keep the numbers in these JumpIfInventory checks
                // in sync with your max/half capacity values for tokens, or otherwise
                // modify them if you don't want to use max/half capacity as the breakpoints.
                if (invoker.SpreadTokens >= 20) Radius_Quake(4, 2, 0, 1, 0);
                else if (invoker.SpreadTokens >= 10) Radius_Quake(2, 2, 0, 1, 0);
                else Radius_Quake(1, 2, 0, 1, 0);
            }
            if (TangoPlayer(self).shouldRecoil()) A_SetPitch(pitch - 0.4);
            return ResolveState(null);
        }
		TARG C 1 Bright 
        {
            if(TangoPlayer(self).shouldRecoil()) A_SetPitch(pitch + 0.2);
            A_Light0();
        }
		TARG DE 1
        {
            if(TangoPlayer(self).shouldRecoil()) A_SetPitch(pitch + 0.2);
            A_SpawnItemEx("ChaingunCasing", 30 * cos(pitch), 0, 30 - (30 * sin(pitch)), frandom(2, 4) * cos(pitch), frandom(3, 6), frandom(3, 6) * -sin(pitch), 0, SXF_NOCHECKPOSITION | SXF_TRANSFERPITCH);
        }
		TARG FG 1 A_Refire();
		Goto Ready;
	CheckAutoReload:
		TNT1 A 0 A_JumpIf(ACS_NamedExecuteWithResult("tango_cvar_auto_reload") == 1, "ReloadPreBuffer");
		Goto NoAmmo;
	ReloadPreBuffer:
		TARG A 1 A_WeaponReady(WRF_NOFIRE);
		Goto Reload;
	NoAmmo:
		TARG A 2 A_PlaySound("weapons/empty");
		Goto Ready;
	Reload:
		TNT1 A 0 A_JumpIfInventory("TangoBulletClip", 1, 1);
		Goto NoAmmo;
		TNT1 A 0 A_JumpIfInventory("AssaultRifleAmmo", 0, "Ready");
		TNT1 A 0 {invoker.SpreadTokens = 0;}
		
		TARR ABCC 1;
		TARR DF 1;
		TNT1 A 0 A_PlaySound("weapons/arright", CHAN_AUTO);
		TARR GIJ 1;
		TARR KLMPON 1;
		TRR1 ABCDE 1;
		TRR1 F 3;
		TRR1 GH 1;
		TNT1 A 0 A_PlaySound("weapons/aropen", CHAN_AUTO);
		TRR1 IJ 1;
		TNT1 A 0 A_SpawnItemEx("ClipCasing", 22, 0, 38, frandom(0, 1.0), frandom(-6.5, -8.0), frandom(1.0, 3.5)) ;
		TRR1 KLM 1;
		TRR1 N 2;
	ReloadRepeat:
		TNT1 A 0 A_JumpIfInventory("AssaultRifleAmmo", 0, "ReloadFinish");
		TNT1 A 0 A_JumpIfInventory("TangoBulletClip", 1, 1);
		Goto ReloadFinish;
		TNT1 A 0 A_GiveInventory("AssaultRifleAmmo", 1);
		TNT1 A 0 A_Takeinventory("TangoBulletClip",1);
		Goto ReloadRepeat;
	ReloadFinish:
		TRR2 AB 2;
		TRR2 C 1;
		TNT1 A 0 A_PlaySound("weapons/arin", CHAN_AUTO);
		TRR2 DE 1;
		TRR2 F 3;
		TRR2 G 5;
		TRR2 HIJ 1;
		TARR NK 1;
		TNT1 A 0 A_PlaySound("weapons/arleft", CHAN_AUTO);
		TARR HFDCBA 1;
		Goto Ready;
	Flash:
		TNT1 A 0;
		Goto LightDone;
	Select:
		TNT1 A 0 A_PlaySound("items/assaultrifle", CHAN_WEAPON);
		TARG A 0 A_Raise;
		Loop;
	Deselect:
		TARG A 0 A_Lower;
		Loop;
	}
}