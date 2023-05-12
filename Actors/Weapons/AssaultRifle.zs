// There are several components that make up the spread-over-time for the AR:
// 1) base spread
//		This is the starting spread for the weapon, on a fresh clip.
//		This is defined by the ar_base_spread constant below.
// 2) max spread
//		This is the maximum spread after "max spread tokens" number of bullets
//		have been fired.
//		This is defined by the ar_max_spread constant below.
// 3) max spread tokens
//		This is the max number of "spread tokens" the player can have. One
//		spread token is given to the player upon each bullet fired. This number
//		effectively means "how many successive bullets it takes before maximum
//		spread is reached." This number should always be lower or equal to the
//		maximum ammo in a clip, otherwise the max spread will never be reached.
//		This is defined by the Inventory.MaxAmount
// 4) max spread tokens factor
//		Decimal value representing (1 / max spread tokens). Having this stored
//		as a constant allows us to perform multiplication properly in the spread
//		formula without having to deal with oddities in how the engine handles
//		floating point division. THIS NUMBER MUST ALWAYS BE KEPT IN SYNC WITH
//		MAX SPREAD TOKENS. See notes below for more info on this.
//		This is defined by the ar_max_token_factor constant below.
// 5) token decrement rate
//		This is how many tics it takes to take one spread token from the player.
//		This is determined by the frame count of the single weapon ready state
//		defined below in the weapon. Higher frame count = slower reset back to
//		base spread.
// 6) vertical spread factor
//		This determines how closely the vertical spread matches the horizontal
//		spread calculation. If this is set to 1.0, vertical spread will be
//		the same as horizontal spread. If this is set to 0.5, vertical spread
//		will equal half that of horizontal spread.
//		This is defined by the ar_vertical_spread_factor constant below.


// COMPONENT #1
const ar_base_spread = 2.3;
// COMPONENT #2
const ar_max_spread = 5.2;
// COMPONENT #6
const ar_vertical_spread_factor = 0.8;

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

Class AssaultRifleSpreadToken : Inventory
{
    Default
    {
        // COMPONENT #3
        Inventory.MaxAmount 20;
    }
	
}

// COMPONENT #4
// This constant should be kept in sync with component #3 so that it is always
// equal to (1 / max spread tokens)
const ar_max_token_factor = 0.05;

Class TangoAssaultRifle : ReloadableWeapon replaces Chaingun
{
    // Formula for spread calculation:
    // base spread + (spread token capacity rate * (max spread - base spread))
    // ... where "spread token capacity rate" is:
    // current spread token count / max spread token count
    // This formula is basically saying, set spread to be some number in
    // between the base and max spread, based on how many spread tokens the
    // player has in their inventory. Note that for the vertical spread,
    // we multiply the result of this calculation by half.
    
    // !! NOTE !!, decorate/the engine doesn't seem to handle doing a calculation
    // like "5.0 / 20.0" well, and seems to treat the result as an integer
    // no matter what (ie it cuts off everything after the decimal). From the
    // wiki, it looks like the way floats are handled is hacky, so instead
    // of trying to figure out why this is happening, I am just including this
    // extra ar_max_token_factor variable that allows me to use multiplication
    // to calculate the "spread token capacity rate" without issue. This is why
    // ar_max_token_factor should always be (1 / max_spread_tokens).
    // See: https://zdoom.org/wiki/Data_types#Fixed_point
    double GetSpreadHorz()
    {
        return ar_base_spread + ((ACS_NamedExecuteWithResult("tango_get_ar_spread_tokens") * ar_max_token_factor) * (ar_max_spread - ar_base_spread));
    }
    
    double GetSpreadVert()
    {
        return ar_vertical_spread_factor * (ar_base_spread + ((ACS_NamedExecuteWithResult("tango_get_ar_spread_tokens") * ar_max_token_factor) * (ar_max_spread - ar_base_spread)));
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
		TNT1 A 0 A_TakeInventory("AssaultRifleSpreadToken", 1);
		// COMPONENT #5 is the tic duration for the frame below
		// After that many tics, one spread token is subtracted from the player's
		// inventory. Lower frame duration means spread resets to base faster,
		// and higher means it resets to base slower.
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
            A_FireBullets(invoker.GetSpreadHorz(), invoker.GetSpreadVert(), -1, 20, "BulletPuff", FBF_USEAMMO|FBF_NORANDOM, 8192);
            A_GiveInventory("AssaultRifleSpreadToken", 1);
            if (TangoPlayer(self).shouldScreenShake())
            {
                // Determine shake level in a few tiers based on spread token count
                // Note you'll want to keep the numbers in these JumpIfInventory checks
                // in sync with your max/half capacity values for tokens, or otherwise
                // modify them if you don't want to use max/half capacity as the breakpoints.
                if (CountInv("AssaultRifleSpreadToken") >= 20) Radius_Quake(4, 2, 0, 1, 0);
                else if (CountInv("AssaultRifleSpreadToken") >= 10) Radius_Quake(2, 2, 0, 1, 0);
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
		TNT1 A 0 A_TakeInventory("AssaultRifleSpreadToken");
		
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