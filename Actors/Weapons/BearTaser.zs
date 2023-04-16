Class BearTaser : Weapon replaces Chainsaw
{
    bool isReloading;
    Default
    {
        Tag "Bear Taser";
        +WEAPON.AMMO_OPTIONAL;
        +WEAPON.NOALERT;
        Weapon.SlotNumber 1;
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
		DUSP A -1;
		Stop;
	Ready:
		DUAL A 1 A_WeaponReady(WRF_ALLOWRELOAD);
		Loop;
    Select:
		DUAL A 0 
        {
        //A_PlaySound("weapons/shotguncock", CHAN_WEAPON);
        A_Raise();
        }
		Loop;
	Deselect:
		DUAL A 0  A_Lower;
		Loop;
    Fire:
		DUAL A 1 
        {
        A_FireProjectile ("TaserDart",0,true,14,0,0,0);
        A_GunFlash();
        }
        DUAL AB 2 A_PlaySound ("weapons/FIRELASERS", CHAN_WEAPON);
        DUAL CD 1;
		DUAL DC 1;
		DUAL BA 5;
		DUAL A 10  A_ReFire();
		DUAL A 5;
		Goto Ready;
    Flash:
		DUAL EF 1 Bright A_Light1;
		Goto Lightdone;
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
        if (StatusEffect) StatusEffect.origin = target;
        return -1;
    }
    
    Override void OnDestroy()
    {
        TaserShock.CreateArc(target, self);
        super.OnDestroy();
    }
    
    Default
    {
        Radius 3;
        Height 8;
        Speed 200;
        Damage 0;
        Projectile;
        RenderStyle "Add";
        Alpha 0.75;
        DeathSound "weapons/plasmax";
        Obituary "$OB_MPPLASMARIFLE";
        Decal "GatDecal";
    }
    States
	{
	Spawn:
		LSER A 1 Bright;
        Stop;
	Death:
		LAZR ABCDE 4 Bright;
		Stop;
	}
}

Class ArcDestination : Actor
{
    Default
    {
        +FRIENDLY;
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
    Actor origin;   //Actor who originally fired the taser
    //TODO
    int shockCounter;
    static void CreateArc(Actor source, Actor destination)
    {
        Console.printf("Source position: %d, %d, %d",source.x, source.y, source.z);
        ArcDestination dummyDestination = ArcDestination(Spawn("ArcDestination", destination.pos));
        dummyDestination.bFriendly = true;
        dummyDestination.A_Face(source,0,180,0,0,FAF_MIDDLE);
        dummyDestination.A_CustomRailgun(
            0,0,"","FF0000",
            RGF_SILENT | RGF_FULLBRIGHT | RGF_EXPLICITANGLE ,
            0,3, //aim and jaggedness
            "None", // pufftype
            0, 0, //spread
            source.Distance3D(destination), 3, // range and duration
            1.0, // particle spacing
            0 // drift speed
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
            shockCounter = 0;
            //Warp(owner,0,0,0,0,WARPF_NOCHECKPOSITION);
            //spawned = TaserDOT(SpawnMissile(owner,"TaserDOT"));
            //if (!origin) Console.printf("Taser shock has no origin!");
            //f (spawned && origin) spawned.target = origin;
            CreateArc(origin,owner);
            owner.DamageMobj(self, origin, 11, self.DamageType, DMG_INFLICTOR_IS_PUFF);
        }
    }
    
}
