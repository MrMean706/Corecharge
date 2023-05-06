Class BearTaser : Weapon replaces Chainsaw
{
    bool isReloading;
    TaserShock currentShock;
    
    void SetCurrentShock(TaserShock newShock)
    {
        currentShock = newShock;
    }
    Default
    {
        Tag "Bear Taser";
        Scale 0.5;
        +WEAPON.NOALERT;
        +WEAPON.AMMO_OPTIONAL
        Weapon.SlotNumber 1;
        Weapon.BobStyle "Inverse";
		Weapon.BobSpeed 2.3;
		Weapon.BobRangeX 0.5;
		Weapon.BobRangeY 0.3;
        Weapon.UpSound "beplayer/weapswitchelectrocutioner";
        //decal "bulletchip";
        Weapon.AmmoUse 1;
        Weapon.AmmoType "TaserAmmo";
        Weapon.AmmoGive 1;
        //Inventory.PickupSound "weapons/shotguncock";
        //Inventory.PickupMessage "$TANGO_SHOTGUN";
    }
    
    States
    {
    Spawn:
		TASE A 1;
		Loop;
	Ready:
		_WEL A 1 A_WeaponReady(WRF_ALLOWRELOAD);
		Loop;
    Select:
		_WEL A 0 A_Raise();
		Loop;
	Deselect:
		_WEL A 0  A_Lower;
		Loop;
    Fire:
		_WEL B 1 Bright
        {
        if (CountInv("TaserAmmo") == 0)
            return ResolveState("NoAmmo");
        A_StartSound("weapons/electrocutionertaserlaunch", 103, 0, 1);
        A_FireProjectile ("TaserDart",0,true,14,0,0,0);
        A_GunFlash();
        return ResolveState(null);
        }
        _WEL C 2 Bright Offset( 0, 39);
        _WEL D 2 Bright Offset( 0, 36);
        _WEL A 2 Offset( 0, 34);
		_WEL A 1 Offset( 0, 32);
		_WEL A 12;
		_WEL A 0  A_ReFire();
		Goto Ready;
    NoAmmo:
        _WEL A 2 offset(0,34) A_PlaySound("weapons/empty");
    Goto Ready;
    Reload:
        _WEL A 1 offset(0,34) A_PlaySound("pistol/reload1", CHAN_AUTO);
		_WEL A 1 offset(5,38);
		_WEL A 1 offset(10,42);
		_WEL A 2 offset(20,46);
        _WEL A 4 offset(30,52)
        {
        A_GiveInventory("TaserAmmo", 1);
        A_PlaySound("pistol/reload2", CHAN_AUTO);
        }
        Goto Ready;
    }
}

Class TaserAmmo : Ammo
{
	Default
    {
        Inventory.Amount 1;
        Inventory.MaxAmount 1;
        Ammo.BackpackAmount 1;
        Ammo.BackpackMaxAmount 1;
        +Inventory.IGNORESKILL
    }
}

Class TaserDart : FastProjectile
{
    Override int SpecialMissileHit(Actor victim)
    {
        int superResult = super.SpecialMissileHit(victim);
        if (superResult != -1 || !victim.bShootable) 
            return superResult;
        if (victim == target)
            return 1;
        TaserShock StatusEffect = TaserShock(victim.GiveInventoryType("TaserShock"));
        if (StatusEffect) 
        {
            StatusEffect.origin = target;
            BearTaser originWeapon = BearTaser(target.FindInventory("BearTaser"));
            if (originWeapon) originWeapon.SetCurrentShock(StatusEffect);
        }
        return -1;
    }
    
    Override void OnDestroy()
    {
        TaserShock.CreateArc(target, self);
        super.OnDestroy();
    }
    
    Default
    {
        Speed 75;
		Radius 8;
		Height 8;
		DamageFunction (12);
		DamageType "Electrocutioner";
		Scale 0.3;
		PROJECTILE;
		+BRIGHT
		+HITTRACER
		+THRUSPECIES
		+ROLLSPRITE
		+DONTFALL
		+FORCERADIUSDMG
		+NODAMAGETHRUST
		Species "Player";
		RenderStyle "Add";
		ReactionTime 180;
    }
    States
	{
	Spawn:
		ECTP A 1;
        ECTP ABCD 1
			{
				if (random (1, 100) <= 25)
				{
					//TODO A_SpawnItemEx("StormMineElectricityDummy");
					A_StartSound("weapons/electrocutionertravel", 103, CHANF_OVERLAP, 1);
				}
			}
    SpawnFall:
			ECTP EF 1
			{
				if (random (1, 100) <= 25)
				{
					//TODO A_SpawnItemEx("StormMineElectricityDummy");
					A_StartSound("weapons/electrocutionertravel", 103, CHANF_OVERLAP, 1);
				}
			}
			Loop;
        Stop;
	Death:
		DTTR A 1 A_SpawnItemEx("ElectrocutionerImpactTaserFX", flags: SXF_NOCHECKPOSITION);
		Stop;
    XDeath:
		ECTP EF 1
        {
        bTHRUACTORS = true;
        A_Stop();
        A_NoGravity();
        A_Warp(AAPTR_TRACER, 0, 0, 32, 0, WARPF_COPYINTERPOLATION | WARPF_NOCHECKPOSITION); //TODO: Don't think this works
        }
		Stop;
	}
}

Class ArcDestination : Actor
{
    Default
    {
        +FRIENDLY;
        +MTHRUSPECIES;
        +ALLOWTHRUFLAGS;
        +THRUSPECIES;
        Species "CorechargePlayer";
    }
    States
    {
    Spawn:
		LAZR ABCDE 4 Bright;
		Stop;
    }
}

Class TaserShock : Inventory
{
    const Stiffness = 1.5;//Scales how hard the taser's wire pulls
    Actor origin;   //Actor who originally fired the taser
    int shockCounter;
    static void CreateArc(Actor source, Actor destination, double driftSpeed = 0.0)
    {
        //Console.printf("Source position: %d, %d, %d",source.x, source.y, source.z);
        ArcDestination dummyDestination = ArcDestination(Spawn("ArcDestination", destination.pos));
        dummyDestination.bFriendly = true;
        dummyDestination.A_Face(source,0,180,0,0,FAF_MIDDLE);
        dummyDestination.A_CustomRailgun(
            0,0,"","Red",
            RGF_SILENT | RGF_FULLBRIGHT | RGF_EXPLICITANGLE ,
            0,3, //aim and jaggedness
            "None", // pufftype
            0, 0, //spread
            source.Distance3D(destination), 3, // range and duration
            1.0, // particle spacing
            driftSpeed
        );
        dummyDestination.Destroy();
    }

    Default
    {
        Inventory.MaxAmount 1;
        DamageType "Electric";
    }
    override void DoEffect()
    {
        super.DoEffect();
        
        if (!owner || (owner.health <= 0))
        {
            Destroy();
            return;
        }
        shockCounter++;
        if (shockCounter >= 4)
        {
            SetOrigin(owner.pos,false);
            A_SpawnItemEx("ElectrocutionerTaserJolt", flags: SXF_NOCHECKPOSITION);
            A_SpawnItemEx("ElectrocutionerTaserJoltSweetener", flags: SXF_NOCHECKPOSITION);
            A_StartSound("weapons/electrocutionertasertrigger", 104, CHANF_OVERLAP, 1);
            owner.DamageMobj(self, origin, 11, self.DamageType, DMG_INFLICTOR_IS_PUFF);
            A_SetRoll(roll + random(0, 359));
            shockCounter = 0;
        }
    }
}

class ElectrocutionerTaserJolt : Actor
{
	Default
	{
		+NOGRAVITY
		+THRUACTORS
		+ROLLSPRITE
		+BRIGHT
		RenderStyle "Add";
		Alpha 0.8;
		Scale 1.2;
	}

	States
	{
		Spawn:
			ECTS A 0 NoDelay A_SetRoll(roll+random(0,359));
			ECTS ABCDEF 2;
			Goto Death;
		Death:
			ECTS F 1 A_FadeOut(0.2);
			Loop;
	}
}

class ElectrocutionerTaserJoltSweetener : Actor
{
	Default
	{
		+NOGRAVITY
		+THRUACTORS
		+ROLLSPRITE
		+BRIGHT
		RenderStyle "AddStencil";
		StencilColor "Yellow";
		Alpha 0.8;
		Scale 1.5;
	}

	States
	{
		Spawn:
			ECTS A 0 NoDelay A_SetRoll(roll+random(0,359));
			ECTS ABCDEF 2;
			Goto Death;
		Death:
			ECTS F 1 A_FadeOut(0.2);
			Loop;
	}
}

class ElectrocutionerImpactTaserFX : Actor
{
	Default
	{
    +NOINTERACTION
    +THRUACTORS
	+BRIGHT
    RenderStyle "Add";
    Scale 0.5;
    Alpha 1.0;
	}	
		
	States
	{
    Spawn:
        DRLG AB 2
		{
			A_FadeOut(0.2);
			A_SetScale(scale.x + 0.5, scale.y - 0.15);
		}
        Loop;
    }
}