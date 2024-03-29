class Bloodletter : Weapon
{ 
    override void AttachToOwner(Actor other)
    {
        other.TakeInventory("TangoPistol", 1);
        super.AttachToOwner(other);
    }
    
    override bool HandlePickup(Inventory item)
    {
        //Code taken from Weapon::HandlePickup
        if (item is "TangoPistol" ) 
        {
            if (Weapon(item).PickupForAmmo (self))
			{
				item.bPickupGood = true;
			}
			if (MaxAmount > 1) //[SP] If amount<maxamount do another pickup test of the weapon itself!
			{
				return Super.HandlePickup (item);
			}
			return true;
        }
        return super.HandlePickup(item);
    }
    
    void AltAttack()
    {
        FTranslatedLineTarget victim;
        Actor unused;
        int damageDealt;
        double pitch = owner.AimLineAttack(owner.angle, 90);
        [unused, damageDealt] = owner.LineAttack(owner.angle, 90, pitch, 11, 'Melee', "BloodletterMagnumMeleePuffMain", LAF_ISMELEEATTACK);
        if (damageDealt > 0) 
        {
            if (owner.CountInv("PistolAmmo") < Ammo1.MaxAmount) owner.A_StartSound("weapons/bloodletterreloadstage1", CHAN_AUTO);
            owner.GiveInventory("PistolAmmo", 2);
        }
    }
    
    Default
	{
        //Shared with Pistol
        Tag "Bloodletter";
        +WEAPON.AMMO_OPTIONAL;
        +WEAPON.NOALERT;
        Weapon.SelectionOrder 1900;
        decal "bulletchip";
        Weapon.AmmoUse1 1;
        Weapon.AmmoUse2 0;
        Weapon.AmmoType1 "PistolAmmo";
        Weapon.AmmoType2 "TangoBulletClip";
        Weapon.AmmoGive2 0;
        Weapon.SlotNumber 2;
        Inventory.PickupMessage "$TANGO_BLOODLETTER";
        
        //Unique
        Scale 0.5;
        Weapon.BobStyle "Inverse";
		Weapon.BobSpeed 2.3;
		Weapon.BobRangeX 0.5;
		Weapon.BobRangeY 0.3;
        Weapon.UpSound "beplayer/weapswitchbloodletter";
		//Inventory.Icon "WEAP30";
        +WEAPON.ALT_AMMO_OPTIONAL;
	}

	States
	{
		Spawn:
			TBLD A 1;
			Loop;
		Ready:
			_WBD A 1 A_WeaponReady(WRF_ALLOWRELOAD);
			Loop;
		Deselect:
			_WBD A 0 A_Lower;
			Loop;
		Select:
			_WBD A 0 A_Raise;
			Loop;
		Fire:
            _WBD B 3 Bright 
            {
            if (CountInv("PistolAmmo") == 0)
                return ResolveState("CheckAutoReload");
            A_AlertMonsters();
            A_FireBullets(0, 0, 1, 22, "TBulletPuff", FBF_USEAMMO|FBF_NORANDOM, 8192);
            A_StartSound("pistol/fire", CHAN_WEAPON);
            A_GunFlash();
            A_Light1();
            if (TangoPlayer(self).shouldScreenShake()) Radius_Quake(1, 2, 0, 1, 0);
            if (TangoPlayer(self).shouldRecoil()) A_SetPitch(pitch - 0.5);
            return ResolveState(null);
            }
            _WBD C 1
            {
            if (TangoPlayer(self).shouldRecoil()) A_SetPitch(pitch + 0.25);
            A_Light0();
            // Positional calculations for the casing pulled from complex-doom.v27a5.pk3 - thanks Daedalus :D
            A_SpawnItemEx("9mmCasing", 30 * cos(pitch), 0, 30 - (30 * sin(pitch)), frandom(2, 4) * cos(pitch), frandom(3, 6), frandom(3, 6) * -sin(pitch), 0, SXF_NOCHECKPOSITION | SXF_TRANSFERPITCH);
            }
            Goto Ready;
        CheckAutoReload:
		TNT1 A 0 A_JumpIf(ACS_NamedExecuteWithResult("tango_cvar_auto_reload") == 1, "ReloadPreBuffer");
            Goto NoAmmo;
            ReloadPreBuffer:
            _WBD A 1 A_WeaponReady(WRF_NOFIRE);
            Goto Reload;
        NoAmmo:
            _WBD A 2 A_StartSound("weapons/empty");
            Goto Ready;
		AltFire:
            TNT1 A 0 { invoker.AltAttack(); }
			_WBD A 1 Offset( 0, 55);
			_WBD A 1 Offset( 0, 67);
			TNT1 A 1 A_WeaponReady(WRF_NOPRIMARY|WRF_NOSECONDARY|WRF_ALLOWRELOAD|WRF_NOBOB);
			_WBD G 1 A_WeaponOffset(300, 72);
            TNT1 A 0 { invoker.AltAttack(); }
			_WBD G 1 A_WeaponOffset(150, 74);
			_WBD G 1 A_WeaponOffset(30, 77);
			_WBD G 1 
            {
            Radius_Quake(3, 3, 0, 1, 0);
            A_StartSound("weapons/bloodletterslashpool", CHAN_AUTO, 0, 1);
            A_SpawnItemEx("BloodletterSlashFX", 45 * cos(pitch), 0, 35 - (40 * sin(pitch)), vel.x, vel.y, vel.z, 0, SXF_ABSOLUTEVELOCITY|SXF_NOCHECKPOSITION|SXF_TRANSFERPITCH);
            A_SpawnItemEx("BloodletterSlashFXSweetener", 45 * cos(pitch), 0, 35 - (40 * sin(pitch)), vel.x, vel.y, vel.z, 0, SXF_ABSOLUTEVELOCITY|SXF_NOCHECKPOSITION|SXF_TRANSFERPITCH);
            A_SpawnItemEx("BloodletterSlashFXSweetener2", 45 * cos(pitch), 0, 35 - (40 * sin(pitch)), vel.x, vel.y, vel.z, 0, SXF_ABSOLUTEVELOCITY|SXF_NOCHECKPOSITION|SXF_TRANSFERPITCH);
            A_WeaponOffset(0, 82);
            }
			_WBD G 1 A_WeaponOffset(-85, 115);
            TNT1 A 0 { invoker.AltAttack(); }
			_WBD G 1 A_WeaponOffset(-154, 131);
			_WBD G 1 A_WeaponOffset(-215, 141);
			_WBD G 1 A_WeaponOffset(-336, 157);
			TNT1 A 2 A_WeaponReady(WRF_NOSECONDARY|WRF_ALLOWRELOAD);
			_WBD A 1 Offset( 0, 45);
			_WBD A 1 Offset( 0, 38);
			_WBD A 2 Offset( 0, 32);
			Goto Ready;
        Reload:
        //Should total to 29 tics
            TNT1 A 0 A_JumpIfInventory("TangoBulletClip", 1, 1);
            Goto NoAmmo;
            TNT1 A 0 A_JumpIfInventory("PistolAmmo", 0,"Ready");
            TNT1 A 0 A_WeaponReady(WRF_NOBOB | WRF_NOFIRE);
            #### A 1 
            {
            A_WeaponOffset(0, 43);
            A_StartSound("pistol/reload1", CHAN_AUTO);
            }
            #### A 1 A_WeaponOffset(0, 60);
			#### A 1 A_WeaponOffset(0, 80); 
			#### A 1 A_WeaponOffset(6, 83);
            #### A 12 A_WeaponOffset(4, 83);
            #### A 10 A_WeaponOffset(3, 83);
            #### A 1 A_WeaponOffset(2, 84);
            #### A 1 
            {
                A_StartSound("pistol/reload2", CHAN_AUTO);
                A_WeaponOffset(1, 85);
                
                int toLoad = min(invoker.Ammo2.Amount, invoker.Ammo1.MaxAmount - invoker.Ammo1.Amount);
                self.TakeInventory("TangoBulletClip",toLoad);
                self.GiveInventory("PistolAmmo",toLoad);
                A_WeaponReady(WRF_ALLOWRELOAD);
            }
            
            #### A 2 A_WeaponOffset(1, 84);
			Goto Ready;
		Flash:
			TNT1 A 1 Bright A_Light1;
			TNT1 A 1 Bright A_Light0;
			Stop;
	}
}

class BloodletterMagnumMeleePuffMain : Actor
{
	Default
	{
		+BRIGHT
		+NOGRAVITY
		+PUFFGETSOWNER
		+PUFFONACTORS
		+THRUSPECIES
		+ALLOWTHRUFLAGS	
		Scale 1.0;
		DamageType "BloodletterMagnumMelee";
		Species "Player";
	}

	States
	{
		Spawn:
			TNT1 A 2;
			Stop;
		Death:
			TNT1 A 1;
			Stop;
		XDeath:
			TNT1 A 0 A_SetScale(1.5);
			TNT1 A 0 A_StartSound("weapons/bloodlettermeleehit", CHAN_BODY, 0, 1);
			TNT1 A 0 A_SetRoll(random(0,359));
			TNT1 A 0 A_SpawnItemEx("BloodletterMeleeHitSweetener", flags: SXF_NOCHECKPOSITION);
			BLMH ABCD 3;
			Stop;			
	}
}

class BloodletterMeleeHitSweetener : Actor
{
	Default
	{
		+THRUACTORS
		+NOINTERACTION
		+ROLLSPRITE
		+BRIGHT
		Radius 2;
		Height 2;
		RenderStyle "Stencil";
		StencilColor "Dark Red";
		Scale 1.0;
	}	
		
	States
	{
		Spawn:
			BLMH A 0 NoDelay A_SetRoll(random(0,359));
			BLMH ABCD 2;
			Stop;
	}
}

class BloodletterMagnumMeleePuffSwipe : Actor
{
	Default
	{
		+BRIGHT
		+NOGRAVITY
		+PUFFGETSOWNER
		+PUFFONACTORS
		+THRUSPECIES
		+ALLOWTHRUFLAGS	
		Scale 1.0;
		DamageType "BloodletterMagnumMelee";
		Species "Player";
	}

	States
	{
		Spawn:
			TNT1 A 2;
			Stop;
		Death:
			TNT1 A 1;
			Stop;	
	}
}

class BloodletterSlashFX : Actor
{
	Default
	{
		Radius 2;
		Height 2;
		+BRIGHT
		+THRUACTORS
		+NOCLIP
		+NOGRAVITY
		+FLATSPRITE
		+ROLLSPRITE
		+DONTSPLASH
		Scale 1.5;
	}

	States
	{
		Spawn:
			BLSL A 0 NoDelay A_SetPitch(pitch-12);
			BLSL A 0 A_SetRoll(-20);
		SpawnFall:
			BLSL ABC 1
			{
				A_SetRoll(roll+15);
			}
			Goto Death;
		Death:
			BLSL C 1;
			BLSL A 0 A_FadeOut(0.4);
			Stop;	  
	} 
}

class BloodletterSlashFXSweetener : Actor
{
	Default
	{
		Radius 2;
		Height 2;
		RenderStyle "Add";
		StencilColor "Red";
		Alpha 0.2;
		+BRIGHT
		+THRUACTORS
		+NOCLIP
		+NOGRAVITY
		+FLATSPRITE
		+ROLLSPRITE
		+DONTSPLASH
		Scale 1.8;
	}

	States
	{
		Spawn:
			BLSL A 0 NoDelay A_SetPitch(pitch-12);
			BLSL A 0 A_SetRoll(-80);
		SpawnFall:
			BLSL ABC 1
			{
				A_SetRoll(roll+20);
			}
			Goto Death;
		Death:
			BLSL C 1;
			BLSL A 0 A_FadeOut(0.1);
			Stop;	  
	} 
}


class BloodletterSlashFXSweetener2 : Actor
{
	Default
	{
		Radius 2;
		Height 2;
		RenderStyle "Add";
		StencilColor "Red";
		Alpha 0.1;
		+BRIGHT
		+THRUACTORS
		+NOCLIP
		+NOGRAVITY
		+FLATSPRITE
		+ROLLSPRITE
		+DONTSPLASH
		Scale 1.8;
	}

	States
	{
		Spawn:
			BLSL A 0 NoDelay A_SetPitch(pitch-12);
			BLSL A 0 A_SetRoll(-120);
		SpawnFall:
			BLSL ABC 2
			{
				A_SetRoll(roll+20);
			}
			Goto Death;
		Death:
			BLSL C 1;
			BLSL A 0 A_FadeOut(0.1);
			Stop;	  
	} 
}