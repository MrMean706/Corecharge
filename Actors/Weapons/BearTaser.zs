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
        +WEAPON.NOALERT;
        +WEAPON.AMMO_OPTIONAL
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
        if (CountInv("TaserAmmo") == 0)
            return ResolveState("NoAmmo");
        A_FireProjectile ("TaserDart",0,true,14,0,0,0);
        A_GunFlash();
        return ResolveState(null);
        }
        DUAL AB 2 A_PlaySound ("weapons/BearTaser/FIRELASERS", CHAN_WEAPON);
        DUAL CD 1;
		DUAL DC 1;
		DUAL BA 5;
		DUAL A 10  A_ReFire();
		DUAL A 5;
		Goto Ready;
    NoAmmo:
    DUAL A 2 offset(0,34) A_PlaySound("weapons/empty");
    Goto Ready;
    Flash:
		DUAL EF 1 Bright A_Light1;
		Goto Lightdone;
    Reload:
        DUAL A 1 offset(0,34);
		DUAL A 1 offset(5,38);
		DUAL A 1 offset(10,42);
		DUAL A 2 offset(20,46);
        DUAL B 4 offset(30,52)
        {
        A_GiveInventory("TaserAmmo", 1);
        if (invoker.currentShock) invoker.currentShock.BreakLine();
        } //TODO: Sound
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
    void BreakLine()
    {
        if(owner && origin)
        {
            //TODO:
            //Snapping sound effect
            //Girthier, messier arc
            CreateArc(origin,owner,1.0);
            //Pull owner towards origin
            //Movement.DoKnockback(owner,(origin.pos - owner.pos).Unit() * ,origin.mass);
        }
        Destroy();
    }
    Default
    {
        Inventory.MaxAmount 1;
        DamageType "Electric";
    }
    override void DoEffect()
    {
        super.DoEffect();
        double lineDistance = owner.Distance3D(origin);
        if (!owner || (owner.health <= 0) || lineDistance > 250 || owner.CountInv("TaserAmmo") > 0)
        {
            BreakLine();
            return;
        }
        if (lineDistance > 200)
        {
            Vector3 ToOrigin = (origin.pos - owner.pos).Unit();
            double WireForce = Stiffness * (lineDistance - 200);
            origin.vel -= ToOrigin * (WireForce / origin.mass);
            owner.vel += ToOrigin * (WireForce / owner.mass);
            //TODO: 
            //Play higher pitch sound to warn player 
            //Pull origin and target together
            
        }
        shockCounter++;
        if (shockCounter >= 4)
        {
            shockCounter = 0;
            CreateArc(origin,owner);
            owner.DamageMobj(self, origin, 11, self.DamageType, DMG_INFLICTOR_IS_PUFF);
        }
    }
    
}
